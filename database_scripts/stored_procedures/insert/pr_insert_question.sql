USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER PROCEDURE pr_insert_question
@exam_id VARCHAR(20),
@exam_db_name VARCHAR(40),
@question_assignment VARCHAR(max),
@question_points	smallint,
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
			IF @exam_id IS NULL THROW 60001, 'exam_id cannot be null', 1;
			IF @correct_answer_statement IS NULL THROW 60003, 'correct_answer cannot be null', 1;
			IF @exam_db_name IS NULL THROW 60004, 'exam_db_name cannot be null', 1;
			IF @question_assignment IS NULL THROW 60005, 'question_assignment cannot be null', 1;
			IF @difficulty IS NULL THROW 60024, 'difficulty cannot be null', 1;
			IF (@question_points IS NULL OR @question_points = 0)THROW 60006, 'question_points cannot be null or 0', 1;

			IF((SELECT starting_date FROM EXAM WHERE exam_id = @exam_id) < GETDATE())
			THROW 60155, 'Questions may not be added to an exam that has taken place', 1;

			
			INSERT INTO QUESTION(difficulty, exam_db_name, question_assignment, comment, status) VALUES(@difficulty, @exam_db_name, @question_assignment, @comment, 'Active')

			DECLARE @question_no INT
			SET @question_no = IDENT_CURRENT('QUESTION')
			INSERT INTO QUESTION_IN_EXAM VALUES(@exam_id, @question_no, @question_points)

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