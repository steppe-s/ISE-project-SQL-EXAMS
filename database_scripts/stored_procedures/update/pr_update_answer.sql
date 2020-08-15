USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_update_answer
	@student_no	int,
	@exam_id varchar(20),
	@question_no int,
	@answer	varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			if @student_no is null
				throw 60012, 'student_no cannot be NULL', 1;
			if @exam_id is null
				throw 60001, 'exam_id cannot be null', 1;
			if @question_no is null
				throw 60002, 'question_no cannot be null', 1;
			if @answer is null
				throw 60009, 'answer cannot be null', 1;

			if exists (
				select * 
				from EXAM_GROUP_IN_EXAM eg
					inner join EXAM_FOR_STUDENT es on eg.exam_id = es.exam_id and eg.exam_group_type = es.exam_group_type
					inner join EXAM on EXAM.exam_id = eg.exam_id
				where eg.exam_id = @exam_id and student_no = @student_no and (GETDATE() > end_date or GETDATE() < EXAM.starting_date)
			)
				throw 60160, 'An answer can only be modified while the exam is taking place', 1;

			update dbo.ANSWER
			set answer = @answer, answer_fill_in_date = GETDATE()
			where student_no = @student_no and exam_id = @exam_id and question_no = @question_no
			
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
