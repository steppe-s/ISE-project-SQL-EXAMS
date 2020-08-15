USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_update_exam_group_in_exam
@exam_id VARCHAR(20),
@exam_group_type VARCHAR(20),
@end_date DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be NULL', 1;
			IF(@exam_group_type IS NULL)THROW 60015, 'exam_group_type cannot be NULL', 1;
			IF(@end_date IS NULL)THROW 60035, 'end_date cannot be NULL', 1;

			IF(NOT EXISTS(SELECT 1 FROM EXAM_GROUP_IN_EXAM WHERE exam_id = @exam_id AND exam_group_type = @exam_group_type))
			THROW 60054, 'exam group has not been created yet for this exam', 1;

			IF((SELECT starting_date FROM EXAM WHERE exam_id = @exam_id) < GETDATE())
			THROW 60156, 'The end date is not allowed to be modified after the exam has been taken', 1;

			UPDATE EXAM_GROUP_IN_EXAM SET end_date = @end_date WHERE exam_id = @exam_id AND exam_group_type = @exam_group_type

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