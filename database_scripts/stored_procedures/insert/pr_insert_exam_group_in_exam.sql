USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_insert_exam_group_in_exam
    @exam_id VARCHAR(20),
    @exam_group_type VARCHAR(20),
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be null', 1;
            IF(@exam_group_type IS NULL)THROW 60015, 'exam_group_type cannot be null', 1;
			IF(@end_date IS NULL)THROW 60035, 'end_date cannot be null', 1;
            IF(@end_date < GETDATE())THROW 60035,'An exam_group cannot be submitted after the end_date of an exam', 1;
			IF(GETDATE() > 
				(SELECT starting_date 
				FROM EXAM
				WHERE exam_id = @exam_id
				))THROW 60010, 'starting_date cannot be NULL or before the current date', 1;


			INSERT INTO EXAM_GROUP_IN_EXAM
            VALUES(@exam_id, @exam_group_type, @end_date)

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