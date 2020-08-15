USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_connect_question_to_exam
@question_no INT,
@exam_id VARCHAR(20),
@question_points SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			IF(@question_no IS NULL)THROW 60002, 'question_no cannot be null', 1;
			IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be null', 1;
			IF(@question_points IS NULL OR @question_points < 1)THROW 60006, 'question_points cannot be null or 0', 1;

			IF(EXISTS(SELECT 1 FROM EXAM WHERE exam_id = @exam_id AND starting_date < GETDATE()))
			THROW 60155, 'questions may not be added to an exam that has taken place', 1;

			INSERT INTO QUESTION_IN_EXAM VALUES(@exam_id, @question_no, @question_points)

			update dbo.QUESTION
			set status = 'active'
			where question_no = @question_no

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
