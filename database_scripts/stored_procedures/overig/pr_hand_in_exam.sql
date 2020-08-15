USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_hand_in_exam
@student_no INT,
@exam_id VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			
			IF(@student_no IS NULL)THROW 60012, 'student_no cannot be null', 1;
			IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be null', 1;
			IF(NOT EXISTS(SELECT 1 FROM EXAM_FOR_STUDENT WHERE exam_id = @exam_id))THROW 60053, 'Student is not signed up for exam', 1;

			  IF NOT EXISTS (SELECT * FROM REASON WHERE reason_no = 60110)
                    INSERT INTO REASON (reason_no, reason_description) VALUES (60110, 'No answer was provided by the student')

			DECLARE @question INT

			SET ROWCOUNT 0
			
			SELECT question_no INTO #temp_table FROM QUESTION_IN_EXAM 
					WHERE exam_id = @exam_id AND question_no NOT IN(
														SELECT question_no FROM ANSWER 
															WHERE exam_id = @exam_id AND student_no = @student_no)

			SET ROWCOUNT 1

			SELECT @question = question_no FROM #temp_table

			WHILE @@ROWCOUNT <> 0
			BEGIN
			SET ROWCOUNT 0
			--SELECT question_no FROM #temp_table WHERE question_no = @question
			DELETE FROM #temp_table WHERE question_no = @question

			INSERT INTO ANSWER VALUES(@student_no, @exam_id, @question, 60110, NULL, 'INCORRECT', GETDATE())

			SET ROWCOUNT 1
			SELECT @question = question_no FROM #temp_table
		END
		SET ROWCOUNT 0

		UPDATE EXAM_FOR_STUDENT SET hand_in_date = GETDATE() WHERE exam_id = @exam_id AND student_no = @student_no

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