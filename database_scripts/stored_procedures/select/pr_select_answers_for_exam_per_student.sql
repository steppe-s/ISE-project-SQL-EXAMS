USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER PROCEDURE pr_select_answers_for_exam_per_student
	@exam_id varchar(20),
	@student_no int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		IF @exam_id IS NULL THROW 60001, 'exam_id cannot be null', 16
		IF @student_no IS NULL THROW 60012, 'student_no cannot be NULL', 16

		IF((SELECT 1 FROM EXAM_FOR_STUDENT WHERE student_no = @student_no AND exam_id = @exam_id) IS NULL)
		THROW 60053, 'Student is not signed up for exam', 1;

		SELECT QUESTION.question_assignment, ANSWER.answer ,REASON.reason_description
		FROM ANSWER
			INNER JOIN STUDENT
				ON ANSWER.student_no = STUDENT.student_no
			LEFT JOIN REASON
				ON ANSWER.reason_no = REASON.reason_no
			LEFT JOIN QUESTION
				ON ANSWER.question_no = QUESTION.question_no
		WHERE exam_id = @exam_id AND STUDENT.student_no = @student_no
    END TRY
    BEGIN CATCH
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END