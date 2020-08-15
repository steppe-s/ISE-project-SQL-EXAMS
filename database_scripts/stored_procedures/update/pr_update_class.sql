USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_update_class
    @class_name_new VARCHAR(20),
    @class_name_old VARCHAR(20)

AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            IF (@class_name_new IS NULL)
                THROW 60018, 'class_name_new cannot be NULL', 1;
            IF (@class_name_old IS NULL)
                THROW 60019, 'class_name_old cannot be NULL', 1;

            ELSE
                UPDATE CLASS 
                SET class = @class_name_new 
                WHERE class = @class_name_old
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