USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_calculate_results_for_exam
    @exam_id VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be null', 1;
            UPDATE ES SET ES.result = (SELECT
                                            (SELECT CAST(SUM(question_points) AS numeric(4,0)) FROM QUESTION_IN_EXAM qe JOIN ANSWER a ON qe.question_no = a.question_no WHERE (a.answer_status = 'MOVED TO CORRECT ANSWER' OR a.answer_status = 'PENDING') AND a.student_no = ES.student_no)
                                            /
                                            (SELECT CAST(SUM(question_points) AS numeric(4,0)) FROM QUESTION_IN_EXAM WHERE exam_id = @exam_id)
                                            * 10)
            FROM EXAM_FOR_STUDENT ES WHERE ES.exam_id = @exam_id
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
GO