USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER PROCEDURE pr_update_exam_group
    @old_exam_group_type VARCHAR(20),
    @new_exam_group_type VARCHAR(20)

AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			    IF @new_exam_group_type IS NULL THROW 60020, 'new_exam_group_type cannot be NULL', 1;
                IF @old_exam_group_type IS NULL THROW 60021, 'old_exam_group_type cannot be NULL', 1;

			UPDATE EXAM_GROUP 
            SET exam_group_type = @new_exam_group_type
            WHERE exam_group_type = @old_exam_group_type

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

