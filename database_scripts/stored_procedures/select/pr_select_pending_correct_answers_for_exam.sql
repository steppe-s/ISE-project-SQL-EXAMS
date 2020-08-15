USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER PROCEDURE pr_select_pending_correct_answers_for_exam
	@exam_id varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
			IF @exam_id IS NULL THROW 60001, 'exam_id cannot be null', 16
				
				SELECT ANSWER.answer, REASON.reason_description, ANSWER.student_no, ANSWER.exam_id, ANSWER.question_no
				FROM ANSWER INNER JOIN  REASON
					ON ANSWER.reason_no = REASON.reason_no
				WHERE ANSWER.answer_status = 'REQUIRE CHECK'
				AND ANSWER.exam_id = @exam_id

			PRINT N'To set one of these question to correct the stored procedure pr_set_pending_correct_answer_to_true or 
			pr_set_pending_correct_answer_to_false. 
			This stored procedure expects three parameters the student_on, exam_id and question_no. These are the last three columns of the result set of this stored procedure'
END