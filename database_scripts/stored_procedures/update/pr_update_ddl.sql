USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER PROCEDURE pr_update_ddl
	@exam_db_name varchar(50),
	@ddl_script varchar(MAX)
AS
BEGIN

	IF @exam_db_name IS NULL THROW 60004, 'exam_db_name cannot be null', 16
		IF @ddl_script IS NULL THROW 60030, 'ddl_script cannot be null', 16

    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY

        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            
			IF NOT EXISTS (
				SELECT exam_db_name
				FROM EXAM_DATABASE
				WHERE exam_db_name = @exam_db_name
			)
			BEGIN
				DECLARE @error_message varchar(2000) = CONCAT('script: ',  @exam_db_name, ' does not exists');
				THROW 50000, @error_message, 16
			END

			UPDATE EXAM_DATABASE SET exam_ddl_script = @ddl_script WHERE exam_db_name = @exam_db_name
			
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
    END CATCH
END