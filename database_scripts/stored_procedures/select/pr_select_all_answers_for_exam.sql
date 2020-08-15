USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_select_all_answers_for_exam
	@exam_id varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		IF @exam_id IS NULL THROW 60001, 'exam_id cannot be null', 16

		SELECT STUDENT.first_name + ' ' + STUDENT.last_name AS student
			,ANSWER.question_no
			,ANSWER.student_no
			,ANSWER.answer
            ,ANSWER.answer_status
			,REASON.reason_description
		FROM ANSWER
		INNER JOIN STUDENT
			ON ANSWER.student_no = STUDENT.student_no
		LEFT JOIN REASON
			ON ANSWER.reason_no = REASON.reason_no
		WHERE exam_id = @exam_id
    END TRY
    BEGIN CATCH
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END