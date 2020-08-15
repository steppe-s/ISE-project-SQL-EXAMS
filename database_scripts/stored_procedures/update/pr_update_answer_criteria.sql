USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_update_answer_criteria
	@question_no int,
	@keyword_old varchar(30),
	@keyword_new varchar(30),
	@criteria_type varchar(30)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			if @question_no is null
				throw 60002, 'question_no cannot be null', 1
			if @keyword_old is null
				throw 60022, 'keyword_old cannot be null', 1
			if @keyword_new is null
				throw 60023, 'keyword_new cannot be null', 1
			if @criteria_type is null
				throw 60017, 'criteria_type cannot be null', 1

			if exists (
				select *
				from QUESTION_IN_EXAM qe
						inner join EXAM on EXAM.exam_id = qe.exam_id
				where question_no = @question_no and starting_date < GETDATE()
			)
				throw 60154, 'A keyword for a question may not be changed once the question has been used in an exam that has been taken', 1

			update ANSWER_CRITERIA
			set keyword = @keyword_new, criteria_type = @criteria_type
			where question_no = @question_no and keyword = @keyword_old
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