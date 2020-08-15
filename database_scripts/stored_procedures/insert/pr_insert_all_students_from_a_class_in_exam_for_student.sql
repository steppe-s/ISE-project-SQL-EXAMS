USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_insert_all_students_from_a_class_in_exam_for_student
	@class VARCHAR(20),
	@exam_id varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			if @class is null
				throw 60011, 'class cannot be NULL', 1;
			if @exam_id is null
				throw 60001, 'exam_id cannot be null', 1

			insert into dbo.EXAM_FOR_STUDENT (exam_id, student_no, class, exam_group_type)
			select @exam_id as exam_id, student_no, @class as class, case
					when is_dyslexic = 0 then 'Standaard'
					when is_dyslexic = 1 then 'Dyslexie'
				end as exam_group_type
			from STUDENT
			where class = @class
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