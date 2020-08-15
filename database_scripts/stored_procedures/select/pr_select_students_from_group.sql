USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_select_students_from_group
	@exam_group_type varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		if @exam_group_type is null
			throw 60015, 'exam_group_type cannot be null', 1

		select distinct s.*
		from EXAM_FOR_STUDENT e
			inner join STUDENT s on e.student_no = s.student_no
		where exam_group_type = @exam_group_type
    END TRY
    BEGIN CATCH
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
end