USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER PROCEDURE pr_update_question
@question_no INT,
@difficulty VARCHAR(10),
@exam_db_name VARCHAR(20),
@question_assignment VARCHAR(MAX),
@comment VARCHAR(MAX),
@remove_comment BIT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			  IF @question_no IS NULL THROW 60002, 'question_no cannot be null', 1;
			  IF @exam_db_name IS NULL THROW 60004, 'exam_db_name cannot be null', 1;
			  IF @question_assignment IS NULL THROW 60005, 'question_assignment cannot be null', 1;
			  IF @difficulty IS NULL THROW 60024, 'difficulty cannot be null', 1;

			  IF(EXISTS(SELECT 1 FROM QUESTION_IN_EXAM WHERE question_no = @question_no AND exam_id IN(SELECT E.exam_id FROM EXAM E WHERE E.exam_id = exam_id AND starting_date < GETDATE())))
			  THROW 60151, 'questions may not be changed once they are used in an exam that has been taken', 1;

			  IF(@remove_comment = 0 AND @comment IS NULL)
			  SET @comment = (SELECT comment FROM QUESTION WHERE question_no = @question_no);

			UPDATE QUESTION SET difficulty = @difficulty, exam_db_name = @exam_db_name, question_assignment = REPLACE(@question_assignment,'''', ''''''), comment = @comment WHERE question_no = @question_no

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

