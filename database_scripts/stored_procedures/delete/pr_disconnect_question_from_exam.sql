USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_disconnect_question_from_exam
@question_no INT,
@exam_id VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			IF(@question_no IS NULL)THROW 60002, 'question_no cannot be null', 1;
			IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be null', 1;

			IF(EXISTS(SELECT 1 FROM QUESTION_IN_EXAM WHERE question_no = @question_no AND exam_id = @exam_id AND exam_id IN(SELECT exam_id FROM EXAM WHERE exam_id = @exam_id AND starting_date <= GETDATE())))
			THROW 60151, 'questions may not be changed once they are used in an exam that has been taken', 1;

			DELETE FROM QUESTION_IN_EXAM WHERE question_no = @question_no AND exam_id = @exam_id

			IF(NOT EXISTS(SELECT 1 FROM QUESTION_IN_EXAM WHERE question_no = @question_no))
			UPDATE dbo.QUESTION
			SET STATUS = 'unused'
			WHERE question_no = @question_no

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