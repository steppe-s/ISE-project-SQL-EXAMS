USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_add_student_to_exam
@student_no INT,
@exam_id VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            
			IF(@student_no IS NULL) THROW 60012, 'student_no cannot be NULL', 1;
			IF(@exam_id IS NULL) THROW 60001, 'exam_id cannot be NULL', 1;
			
			declare @exam_group_type varchar(20) = (
				select case
					when is_dyslexic = 0 then 'Standaard'
					when is_dyslexic = 1 then 'Dyslexie'
				end as exam_group_type
				from dbo.STUDENT where student_no = @student_no
			)

			IF(@exam_group_type IS NULL) THROW 60015, 'exam_group_type cannot be NULL', 1;

			IF(NOT EXISTS(SELECT 1 FROM EXAM_GROUP_IN_EXAM WHERE exam_id = @exam_id AND exam_group_type = @exam_group_type))
			THROW 60054, 'exam group has not been created yet for this exam', 1;

			IF((SELECT starting_date FROM EXAM WHERE exam_id = @exam_id) < GETDATE())
			THROW 60161, 'you cannot assign a student to an exam that has taken place already', 1;

			INSERT INTO EXAM_FOR_STUDENT VALUES(@exam_id, @student_no, (SELECT class FROM STUDENT WHERE student_no = @student_no), @exam_group_type, NULL, NULL)

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