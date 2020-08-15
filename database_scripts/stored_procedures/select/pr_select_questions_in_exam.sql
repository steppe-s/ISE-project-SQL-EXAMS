USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_select_questions_in_exam
@exam_id VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be null', 1;
          
		SELECT Q.difficulty, Q.exam_db_name, Q.question_assignment, Q.comment 
		FROM QUESTION Q 
				WHERE question_no IN(
					SELECT question_no
					FROM QUESTION_IN_EXAM 
						WHERE exam_id IN(	
							SELECT exam_id 
							FROM EXAM 
							WHERE exam_id = @exam_id))
    END TRY
    BEGIN CATCH
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END