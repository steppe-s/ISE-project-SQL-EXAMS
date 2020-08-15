USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_select_all_question_assignments_from_exam
	@exam_id varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		if @exam_id is null
			throw 60001, 'exam_id cannot be null', 1

		select q.question_assignment, qe.question_points
		from QUESTION q
			inner join QUESTION_IN_EXAM qe on q.question_no = qe.question_no
		where exam_id = @exam_id
    END TRY
    BEGIN CATCH
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END
go