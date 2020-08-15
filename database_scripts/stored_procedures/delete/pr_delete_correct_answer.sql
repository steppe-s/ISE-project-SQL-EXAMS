USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_delete_correct_answer
	@question_no INT,
	@correct_answer_id SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
           IF(@question_no IS NULL) THROW 60002, 'question_no cannot be null', 1;
		   IF(@correct_answer_id IS NULL) THROW 60025, 'correct_answer_id cannot be null', 1;
	
			IF((SELECT COUNT(*) FROM CORRECT_ANSWER WHERE question_no = @question_no) = 1)
			THROW 60152, 'At least one correct answer must be provided for a question', 1;

			DELETE FROM CORRECT_ANSWER WHERE question_no = @question_no AND correct_answer_id = @correct_answer_id

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