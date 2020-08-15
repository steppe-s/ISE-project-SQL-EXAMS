USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_execute_ddl
@exam_db_name NVARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));

    EXEC pr_create_database @exam_db_name

    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;

            IF @exam_db_name is NULL
                THROW 60004, 'exam_db_name cannot be null', 1;
            IF NOT EXISTS (SELECT * FROM EXAM_DATABASE WHERE exam_db_name = @exam_db_name)
                THROW 60202, 'Database associated with name not found', 1;
            IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @exam_db_name)
                THROW 60201, 'Database required for script is not available', 1;
            ELSE
            BEGIN
                DECLARE @exam_ddl_script NVARCHAR(MAX)
                SELECT @exam_ddl_script = exam_ddl_script FROM EXAM_DATABASE WHERE exam_db_name = @exam_db_name

                DECLARE @statement NVARCHAR(MAX) = @exam_db_name + '.dbo.sp_executesql N''' + @exam_ddl_script + ''''
                
                EXEC sp_executesql @statement
            END
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