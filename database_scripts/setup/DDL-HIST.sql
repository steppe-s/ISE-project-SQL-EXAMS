use HAN_SQL_EXAM_DATABASE
go

create or alter proc pr_create_hist_table
    @tableName varchar(40) = null
as
begin
    begin try
		-- Check if @tableName is NULL
        if @tableName is null
            throw 53249, 'Given table name is not filled. This is not allowed', 1

		-- Check if given table exists in the database
		if not exists (
			select 1
			from [INFORMATION_SCHEMA].[TABLES]
			where TABLE_NAME = @tableName
		)
			throw 674823, 'Given table name does not exist in the current database', 1

        declare @histTableName varchar(30) = 'hist_' + @tableName

		-- Check if there is already a hsitory table in de datbase
        IF OBJECT_ID(@histTableName) IS NOT NULL
            throw 73254, 'There is already a history table for the given table', 1

		if not exists (
			select *
			from [INFORMATION_SCHEMA].[SCHEMATA]
			where SCHEMA_NAME = 'hist'
		)
			exec('create schema hist')

        declare @createTableQuery varchar(max)

        set @createTableQuery = 'create table hist.' + @histTableName + ' (
            timestamp timestamp not null'
        
		-- Check if there are any columns in the table
		if exists (
			select 1
			from [INFORMATION_SCHEMA].[COLUMNS]
			where TABLE_NAME = @tableName
		)
		begin 
			declare @i int = 1
			declare @totalColumns int = (
				select count(*) 
				from [INFORMATION_SCHEMA].[COLUMNS]
				where TABLE_NAME = @tableName
			)
			while @i < @totalColumns + 1
			begin
				set @createTableQuery = @createTableQuery + '
				, ' + (
					select COLUMN_NAME
					from [INFORMATION_SCHEMA].[COLUMNS]
					where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
				) + ' ' + (
					select DATA_TYPE
					from [INFORMATION_SCHEMA].[COLUMNS]
					where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
				)

				-- SPECIAL DATA TYPE VARCHAR
				if (
					select DATA_TYPE
					from [INFORMATION_SCHEMA].[COLUMNS]
					where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
				) = 'varchar'
				begin
					set @createTableQuery = @createTableQuery + '(' 
					declare @varcharLength int = (
						select CHARACTER_MAXIMUM_LENGTH
						from [INFORMATION_SCHEMA].[COLUMNS]
						where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
					)
					if (@varcharLength = -1 )
						set @createTableQuery = @createTableQuery + 'max)'
					else 
						set @createTableQuery = @createTableQuery + str(@varcharLength) + ')'
				end

				-- SPECIAL DATA TYPE NUMERIC
				if (
					select DATA_TYPE
					from [INFORMATION_SCHEMA].[COLUMNS]
					where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
				) = 'numeric'
					set @createTableQuery = @createTableQuery + '(' + (
						select str(NUMERIC_PRECISION)
						from [INFORMATION_SCHEMA].[COLUMNS]
						where TABLE_NAME = @tableName and ORDINAL_POSITION = @i 
					) + ', ' + (
						select str(NUMERIC_SCALE)
						from [INFORMATION_SCHEMA].[COLUMNS]
						where TABLE_NAME = @tableName and ORDINAL_POSITION = @i 
					) + ')'
					
				set @i = @i + 1
			end
			set @createTableQuery = @createTableQuery + '
				)'
		end
		exec(@createTableQuery)
    end try
    begin catch
        throw
    end catch
end

go
create or alter proc pr_create_hist_trigger 
	@tableName varchar(20) = null
as
begin
	begin try
		-- Check if @tableName is NULL
        if @tableName is null
            throw 53249, 'Given table name is not filled. This is not allowed', 1

		-- Check if given table exists in the database
		if not exists (
			select 1 
			from [INFORMATION_SCHEMA].[TABLES]
			where TABLE_NAME = @tableName
		)
			throw 674823, 'Given table name does not exists in the current database', 1

        declare @histTableName varchar(30) = 'hist_' + @tableName	

		declare @createTriggerQuery varchar(max) = '
			create or alter trigger tg_insert_changes_in_' + @histTableName + ' 
				on ' + @tableName + ' 
				after update
			as 
			begin 
				if @@ROWCOUNT = 0
					return
				set nocount on
				begin try
					insert into hist.' + @histTableName + '(' 
					
		declare @i int = 1
		declare @totalColumns int = (
			select count(*) 
			from [INFORMATION_SCHEMA].[COLUMNS]
			where TABLE_NAME = @tableName
		) 

		while @i < @totalColumns + 1
		begin 
			set @createTriggerQuery = @createTriggerQuery + (
				select COLUMN_NAME 
				from [INFORMATION_SCHEMA].[COLUMNS]
				where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
			)
			if @i = @totalColumns
				set @createTriggerQuery = @createTriggerQuery + ')'
			else 
				set @createTriggerQuery = @createTriggerQuery + ','
			set @i = @i + 1
		end

		set @createTriggerQuery = @createTriggerQuery + ' 
					select ' 
		
		set @i = 1
		while @i < @totalColumns + 1
		begin 
			set @createTriggerQuery = @createTriggerQuery + 'i.' + (
				select COLUMN_NAME
				from [INFORMATION_SCHEMA].[COLUMNS]
				where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
			)
			if @i <> @totalColumns
				set @createTriggerQuery = @createTriggerQuery + ','
			set @i = @i + 1
		end
					
		set @createTriggerQuery = @createTriggerQuery + ' 			
					from inserted i
						inner join ' + @tableName + ' ' + @tableName + ' on '
						
		declare @totalPKs tinyint = (
			select count(COLUMN_NAME)
			from [INFORMATION_SCHEMA].[KEY_COLUMN_USAGE]
			where OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA+'.'+CONSTRAINT_NAME), 'IsPrimaryKey') = 1 and TABLE_NAME = @tableName
		)
		set @i = 1
		while @i < @totalPKs + 1
		begin
			declare @currentPK varchar(30) = (
				select COLUMN_NAME
				from (
					select COLUMN_NAME, ROW_NUMBER() over (order by TABLE_NAME) as rn
					from [INFORMATION_SCHEMA].[KEY_COLUMN_USAGE]
					where OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA+'.'+CONSTRAINT_NAME), 'IsPrimaryKey') = 1 
						and TABLE_NAME = @tableName
				) p
				where p.rn = @i
			)
			if @i <> 1
				set @createTriggerQuery = @createTriggerQuery + ' and '

			set @createTriggerQuery = @createTriggerQuery + 'i.' + @currentPK + ' = ' + @tableName + '.' + @currentPK

			set @i = @i + 1
		end
		set @createTriggerQuery = @createTriggerQuery + '			
				end try
				begin catch
					throw
				end catch
			end' 
		exec(@createTriggerQuery)
	end try
	begin catch
		throw
	end catch
end

go
create or alter proc pr_create_all_hist_tables_and_triggers
as
begin
	begin try
		declare @i tinyint = 1
		declare @totalTables tinyint = (
			select count(*)
			from [INFORMATION_SCHEMA].[TABLES]
			where TABLE_SCHEMA <> 'hist'
		)
		while @i < @totalTables + 1
		begin
			declare @currentTable varchar(20) = (
				select TABLE_NAME
				from (
					select *, ROW_NUMBER() over (order by TABLE_NAME) as rn
					from [INFORMATION_SCHEMA].[TABLES]
					where TABLE_SCHEMA <> 'hist'
				) t
				where t.rn = @i
			)

			if substring(@currentTable, 0, 6) = 'hist_'
				continue

			exec pr_create_hist_table @currentTable
			exec pr_create_hist_trigger @currentTable

			set @i = @i + 1
		end
	end try
	begin catch
		;throw
	end catch
end

go
create or alter proc pr_drop_all_hist_tables
as
begin
	begin try
		declare @i tinyint = 1
		declare @totalTables tinyint = (
			select count(*)
			from [INFORMATION_SCHEMA].[TABLES]
		)
		declare @dropTableQuery varchar(1000) = ''

		while @i < @totalTables + 1
		begin
			declare @currentTable varchar(40) = (
				select TABLE_NAME
				from (
					select *, ROW_NUMBER() over (order by TABLE_NAME) as rn
					from [INFORMATION_SCHEMA].[TABLES]
				) t
				where t.rn = @i
			)

			if (substring(@currentTable, 0, 6) = 'hist_')
				set @dropTableQuery = @dropTableQuery + 'drop table hist.' + @currentTable + '; '
			set @i = @i + 1
		end
		exec(@dropTableQuery)
	end try
	begin catch
		throw
	end catch
end
go

exec pr_drop_all_hist_tables

exec pr_create_all_hist_tables_and_triggers
