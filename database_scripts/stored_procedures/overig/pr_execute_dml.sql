USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_execute_dml
	@exam_db_name NVARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));

    BEGIN TRY
        BEGIN TRANSACTION
			SAVE TRANSACTION @savepoint;

            IF @exam_db_name is NULL
                THROW 60004, 'exam_db_name cannot be null', 1;
            IF NOT EXISTS (SELECT * FROM EXAM_DATABASE WHERE exam_db_name = @exam_db_name)
                THROW 60202, 'Database associated with name not found', 1;
            IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @exam_db_name)
                THROW 60201, 'Database required for script is not available', 1;
            
			exec pr_drop_exam_database_population @exam_db_name
			 
            DECLARE @exam_dml_script VARCHAR(MAX)
            SELECT @exam_dml_script = exam_dml_script FROM EXAM_DATABASE WHERE exam_db_name = @exam_db_name

			create table #Temp (
				id		  int				identity(1, 1),
				statement nvarchar(max)
			)

			insert into #Temp (statement)
			SELECT value  
			FROM STRING_SPLIT(@exam_dml_script, ';')  
            
			declare @totalRows int = (
				select count(*)
				from #Temp
			)
			declare @i int = 1
			while @i < @totalRows + 1
			begin
				declare @currentStatement nvarchar(max) = (
					select statement
					from (
						select *, ROW_NUMBER() over (order by id) as rn
						from #Temp
					) t
					where rn = @i
				)

				DECLARE @statement NVARCHAR(MAX) = @exam_db_name + '.dbo.sp_executesql N''' + REPLACE(@currentStatement, '''', '''''') + ''''
                
				EXEC sp_executesql @statement
				
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