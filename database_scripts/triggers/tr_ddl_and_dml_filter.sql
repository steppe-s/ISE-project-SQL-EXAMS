use HAN_SQL_EXAM_DATABASE
go

CREATE OR ALTER TRIGGER tr_ddl_and_dml_filter
    ON dbo.EXAM_DATABASE
    instead of UPDATE, INSERT
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
		declare @totalInserts int = (
			select count(*)
			from inserted
		)
		declare @i int = 1
		while @i < @totalInserts + 1
		begin
			declare @dbName varchar(40) = (
				select exam_db_name
				from (
					select *, ROW_NUMBER() over (order by exam_db_name) as rn
					from inserted i
				) as t
				where t.rn = @i
			)
			declare @filteredDDL varchar(max) = (
				select exam_ddl_script
				from (
					select *, ROW_NUMBER() over (order by exam_db_name) as rn
					from inserted i
				) as t
				where t.rn = @i
			)
			declare @filteredDML varchar(max) = (
				select exam_dml_script
				from (
					select *, ROW_NUMBER() over (order by exam_db_name) as rn
					from inserted i
				) as t
				where t.rn = @i
			)
			SET @filteredDDL = REPLACE(@filteredDDL, '''', '''''')
			SET @filteredDDL = LTRIM(@filteredDDL)
			SET @filteredDDL = RTRIM(@filteredDDL)

			while charindex('/*', @filteredDDL) <> 0
				set @filteredDDL = stuff(@filteredDDL, charindex('/*', @filteredDDL), charindex('*/', @filteredDDL) - charindex('/*', @filteredDDL)+2, '')

			IF(@filteredDDL IS NULL OR @filteredDDL = '')
			THROW 60026, 'Query_statement cannot be null', 1;

			IF(CHARINDEX('drop database', @filteredDDL) > 0)
			THROW 60105, 'Statement contains illicit drop statement', 1;

			IF(CHARINDEX('delete', @filteredDDL) > 0)
			THROW 60106, 'Statement contains illicit delete statement', 1;

			IF(CHARINDEX('--', @filteredDDL) > 0 OR CHARINDEX('/*', @filteredDDL) > 0)
			THROW 60107, 'Statement contains illicit comment characters', 1;

			IF(CHARINDEX('create database', @filteredDDL) > 0)
			THROW 60108, 'Statement contains illicit create statement', 1;

			IF(CHARINDEX('update', @filteredDDL) > 0)
			THROW 60109, 'Statement contains illicit update statement', 1;

			SET @filteredDML = REPLACE(@filteredDML, '''', '''''')
			SET @filteredDML = LTRIM(@filteredDML)
			SET @filteredDML = RTRIM(@filteredDML)

			while charindex('/*', @filteredDML) <> 0
				set @filteredDML = stuff(@filteredDML, charindex('/*', @filteredDML), charindex('*/', @filteredDML) - charindex('/*', @filteredDML)+2, '')

			IF(@filteredDML IS NULL OR @filteredDML = '')
			THROW 60026, 'Query_statement cannot be null', 1;

			IF(CHARINDEX('drop database', @filteredDML) > 0)
			THROW 60105, 'Statement contains illicit drop statement', 1;

			IF(CHARINDEX('delete', @filteredDML) > 0)
			THROW 60106, 'Statement contains illicit delete statement', 1;

			IF(CHARINDEX('--', @filteredDML) > 0 OR CHARINDEX('/*', @filteredDML) > 0)
			THROW 60107, 'Statement contains illicit comment characters', 1;

			IF(CHARINDEX('create database', @filteredDML) > 0)
			THROW 60108, 'Statement contains illicit create statement', 1;

			IF(CHARINDEX('update', @filteredDML) > 0)
			THROW 60109, 'Statement contains illicit update statement', 1;

			insert into dbo.EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
			values (@dbName, @filteredDDL, @filteredDML)

			set @i = @i + 1
		end
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO