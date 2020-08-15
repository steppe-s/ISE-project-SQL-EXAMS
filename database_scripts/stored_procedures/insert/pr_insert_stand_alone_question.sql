USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER PROCEDURE pr_insert_stand_alone_question
@exam_db_name VARCHAR(40),
@question_assignment VARCHAR(max),
@correct_answer_statement VARCHAR(max),
@difficulty VARCHAR(10),
@comment VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			IF @correct_answer_statement IS NULL THROW 60003, 'correct_answer cannot be null', 1;
			IF @exam_db_name IS NULL THROW 60004, 'exam_db_name cannot be null', 1;
			IF @question_assignment IS NULL THROW 60005, 'question_assignment cannot be null', 1;
			IF @difficulty IS NULL THROW 60024, 'difficulty cannot be null', 1;

			INSERT INTO QUESTION(difficulty, exam_db_name, question_assignment, comment, status) 
			VALUES(@difficulty, @exam_db_name, @question_assignment, @comment, 'unused')

			DECLARE @question_no INT
			SET @question_no = IDENT_CURRENT('QUESTION')

			EXEC pr_insert_correct_answer @question_no, @correct_answer_statement

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