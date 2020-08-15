USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER PROCEDURE pr_set_pending_correct_answer_to_true
	@student_no int,
	@exam_id varchar(20),
	@question_no int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			
			IF @student_no IS NULL THROW 60012, 'student_no cannot be NULL', 16
				IF @exam_id IS NULL THROW 60001, 'exam_id cannot be null', 16
					IF @question_no IS NULL THROW 60002, 'question_no cannot be null', 16;

			DECLARE @correct_answer varchar(max) = (SELECT ANSWER.answer FROM ANSWER WHERE student_no = @student_no 
																						AND exam_id = @exam_id
																						AND question_no = @question_no)

			EXEC pr_insert_correct_answer
				@question_no = @question_no, @correct_answer_statement = @correct_answer

			UPDATE ANSWER
			SET answer_status = 'MOVED_TO_CORRECT_ANSWER'
            WHERE student_no = @student_no 
			AND exam_id = @exam_id
			AND question_no = @question_no

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