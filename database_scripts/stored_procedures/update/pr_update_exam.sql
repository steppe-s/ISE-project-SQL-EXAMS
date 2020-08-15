USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_update_exam
@exam_id VARCHAR(20),
@course VARCHAR(20),
@exam_name VARCHAR(50),
@starting_date DATETIME,
@comment VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            IF(@exam_id IS NULL) THROW 60001, 'exam_id cannot be null', 1;
			IF(@course IS NULL) THROW 60007, 'course_id cannot be null', 1;
			IF(@exam_name IS NULL) THROW 60008, 'exam_name cannot be null', 1;
			IF(@starting_date IS NULL OR @starting_date < GetDate()) THROW 60010, 'starting_date cannot be NULL or before the current date', 1;

			IF(EXISTS(SELECT 1 FROM EXAM WHERE exam_id = @exam_id AND starting_date <= GETDATE()))
				IF(NOT EXISTS(SELECT 1 FROM EXAM WHERE exam_id = @exam_id AND @course = @course AND @exam_name = @exam_name AND starting_date = @starting_date))
				THROW 60152, 'An exam may not be modified when it is taking place or has taken place already', 1;
			ELSE
			UPDATE EXAM SET comment = @comment WHERE exam_id = @exam_id;
			ELSE
			UPDATE EXAM SET course = @course, exam_name = @exam_name, starting_date = @starting_date, comment = @comment WHERE exam_id = @exam_id;

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