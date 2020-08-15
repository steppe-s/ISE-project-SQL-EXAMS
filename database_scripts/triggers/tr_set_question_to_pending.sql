USE HAN_SQL_EXAM_DATABASE
GO


CREATE OR ALTER TRIGGER tr_set_question_to_pending
    ON dbo.answer
    FOR INSERT
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
		IF UPDATE(answer_status)
		BEGIN
			UPDATE ANSWER
				SET answer_status = 'PENDING'
				FROM ANSWER INNER JOIN inserted
					ON ANSWER.student_no = inserted.student_no
					AND ANSWER.exam_id = inserted.exam_id
					AND ANSWER.question_no = inserted.question_no
					AND ANSWER.answer_status = 'CORRECT'
		END
    END TRY
    BEGIN CATCH
        ;THROW 
    END CATCH
END
GO