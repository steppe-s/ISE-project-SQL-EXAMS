USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_manipulate_population_of_current_database
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
				if DB_NAME() = 'HAN_SQL_EXAM_DATABASE'
					throw 60163, 'procedure pr_manipulate_population_of_current_database cannot be used on database: HAN_SQL_EXAM_DATABASE', 1

				declare @sql varchar(max) = ''
				declare @totalTables int = (
				select count(*)
				from INFORMATION_SCHEMA.TABLES
				where TABLE_SCHEMA = 'dbo'
				)
				declare @i int = 1 

				-- Dropping foreign keys
				declare @totalFKs int = (
				select count(*)
				from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
				)
				declare @k int = 1
				while @k < @totalFKs + 1
				begin
					declare @alter_sql varchar(max) = 'alter table '
					set @alter_sql = @alter_sql + (
						select top 1 TABLE_NAME
						from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS r 
							inner join INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE c on r.CONSTRAINT_NAME = c.CONSTRAINT_NAME

						) + ' drop constraint ' + (
						select top 1 c.CONSTRAINT_NAME
						from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS r 
							inner join INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE c on r.CONSTRAINT_NAME = c.CONSTRAINT_NAME
					)

					exec(@alter_sql)

					set @k = @k + 1
				end
				while @i < @totalTables + 1
				begin
				declare @currentTable varchar(max) = (
					select TABLE_NAME
					from (
						select *, ROW_NUMBER() over (order by TABLE_NAME) as rn
						from INFORMATION_SCHEMA.TABLES
						where TABLE_SCHEMA = 'dbo'
					) t
					where t.rn = @i
				)

				declare @totalColumns int = (
					select count(*)
					from INFORMATION_SCHEMA.COLUMNS
					where TABLE_NAME = @currentTable
				)

				-- Statement building
				declare @j int = 1
				while @j < @totalColumns + 1
				begin
					
					declare @currentColumn varchar(max) = (
						select COLUMN_NAME
						from (
							select *, ROW_NUMBER() over (order by COLUMN_NAME) as rn
							from INFORMATION_SCHEMA.COLUMNS
							where TABLE_NAME = @currentTable
						) t
						where t.rn = @j
					)
					print @currentColumn
					declare @currenDataType varchar(50) = (
						select DATA_TYPE
						from INFORMATION_SCHEMA.COLUMNS
						where TABLE_NAME = @currentTable and COLUMN_NAME = @currentColumn
					)

					if (@currenDataType = 'varchar' or @currenDataType = 'nvarchar' or @currenDataType = 'char')
						set @sql = 'update ' + @currentTable + ' set ' + @currentColumn + ' = substring(' + @currentColumn + ', 1, 3)'
						--set @sql = 'update ' + @currentTable + ' set ' + @currentColumn + ' = ' + @currentColumn + ' + ''a'''
		
					if (@currenDataType = 'int' or @currenDataType = 'numeric' or @currenDataType = 'datetime')
						set @sql = 'update ' + @currentTable + ' set ' + @currentColumn + ' = ' + @currentColumn + ' + 1'
		
					if (@currenDataType = 'date')
						set @sql = 'update ' + @currentTable + ' set ' + @currentColumn + ' = getdate()'

					exec(@sql)

					set @j = @j + 1
				end
				set @i = @i + 1
				end
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1 AND @startTC = 0
            ROLLBACK TRANSACTION;
        ELSE
            IF XACT_STATE() = 1
                BEGIN
                    ROLLBACK TRANSACTION @savepoint;
                    COMMIT TRANSACTION;
                END;
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END
GO
