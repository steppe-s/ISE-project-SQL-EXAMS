USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_update_exam_database
	@exam_db_name varchar(40),
	@exam_ddl_script varchar(max),
	@exam_dml_script varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			if @exam_db_name is null
				throw 60004, 'exam_db_name cannot be null', 1
			if @exam_ddl_script is null
				throw 60027, 'exam_ddl_script cannot be null', 1
			if @exam_dml_script is null
				throw 60028, 'exam_dml_script cannot be null', 1

			update dbo.EXAM_DATABASE
			set exam_ddl_script = @exam_ddl_script, exam_dml_script = @exam_dml_script
			where exam_db_name = @exam_db_name

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