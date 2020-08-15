USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_delete_question
	@question_no	INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            IF(@question_no IS NULL) THROW 60002, 'question_no cannot be null', 1;

			IF(EXISTS(SELECT 1 FROM QUESTION_IN_EXAM WHERE question_no = @question_no))
               UPDATE QUESTION SET status = 'deleted' WHERE question_no = @question_no;
			   ELSE
			   DELETE FROM QUESTION WHERE question_no = @question_no
			   DELETE FROM CORRECT_ANSWER WHERE question_no = @question_no
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
