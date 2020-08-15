USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_select_students_from_class
	@class varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		if @class is null
			throw 60011, 'class cannot be NULL', 1

		select distinct s.*
		from EXAM_FOR_STUDENT e
			inner join STUDENT s on e.student_no = s.student_no
		where e.class = @class
    END TRY
    BEGIN CATCH
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
end