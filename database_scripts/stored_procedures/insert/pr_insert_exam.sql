USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_insert_exam
	@exam_id VARCHAR(20),
	@course varchar(20),
	@exam_name VARCHAR(50),
	@starting_date DATETIME,
	@comment VARCHAR(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			if @exam_id is null
				throw 60001, 'exam_id cannot be null', 1
			if @course is null
				throw 60007, 'course cannot be null', 1
			if @exam_name is null
				throw 60008, 'exam_name cannot be null', 1
			if @starting_date is null or @starting_date < GETDATE()
				throw 60010, 'starting_date cannot be null or before the current date', 1

			insert into dbo.EXAM (exam_id, course, exam_name, starting_date, comment)
			values (@exam_id, @course, @exam_name, @starting_date, @comment)

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
end
