USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_manipulate_population_of_other_database
	@exam_db_name varchar(40)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			
			if not exists (
				select 1
				from EXAM_DATABASE
				where exam_db_name = @exam_db_name
			)
				throw 60052, 'Given database is unknown, please add an exam database first', 1

			-- Aanmaken van de procedure op de exterene database
			DECLARE @createProcedureStatement varchar(max) 
			SELECT @createProcedureStatement = Definition 
			FROM HAN_SQL_EXAM_DATABASE.[sys].[procedures] p
				INNER JOIN HAN_SQL_EXAM_DATABASE.sys.sql_modules m ON p.object_id = m.object_id
			where p.name = 'pr_manipulate_population_of_current_database'
			SET @createProcedureStatement = REPLACE(@createProcedureStatement,'''','''''')
			set @createProcedureStatement = replace(@createProcedureStatement, 'CREATE', 'CREATE OR ALTER ')
			SET @createProcedureStatement = 'USE [' + @exam_db_name + ']; EXEC(''' + @createProcedureStatement + ''')'

			EXEC(@createProcedureStatement)

			-- Uitvoeren van de procedure op de exterene database
			declare @exec varchar(100)
			set @exec = 'exec ' + @exam_db_name + '.dbo.pr_manipulate_population_of_current_database'
			exec(@exec)
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
