USE HAN_SQL_EXAM_DATABASE
GO 

CREATE OR ALTER PROCEDURE pr_select_correct_answers_from_question
	@question_no int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		IF @question_no IS NULL THROW 60002, 'question_no cannot be null', 16

		SELECT CORRECT_ANSWER.correct_answer_statement
		FROM CORRECT_ANSWER 
		WHERE CORRECT_ANSWER.question_no = @question_no
    END TRY
    BEGIN CATCH
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END