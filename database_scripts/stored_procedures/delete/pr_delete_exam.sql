USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_delete_exam
    @exam_id VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            IF (@exam_id is null)
                THROW 60001, 'Exam_id cannot be null', 1;
			
			IF(EXISTS(SELECT 1 FROM EXAM WHERE exam_id = @exam_id AND starting_date <= GETDATE()))
				THROW 60152, 'An exam may not be modified when it is taking place or has taken place already', 1;

                DELETE FROM EXAM WHERE exam_id = @exam_id
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