USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_update_exam_for_student
@exam_id VARCHAR(20),
@student_no INT,
@class VARCHAR(20),
@exam_group_type VARCHAR(20),
@result NUMERIC(4,2)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be NULL', 1;
			IF(@student_no IS NULL)THROW 60012, 'student_no cannot be NULL', 1;
			IF(@class IS NULL)THROW 60011, 'class cannot be NULL', 1;
			IF(@exam_group_type IS NULL)THROW 60015, 'exam_group_type cannot be NULL', 1;
			
			IF(NOT EXISTS(SELECT 1 FROM EXAM_FOR_STUDENT WHERE exam_id = @exam_id AND student_no = @student_no))
			THROW 60053, 'Student is not signed up for exam', 1;

			IF((SELECT result FROM EXAM_FOR_STUDENT WHERE exam_id = @exam_id AND student_no = @student_no) IS NOT NULL AND @result IS NULL)
			THROW 60036, 'result cannot be NULL after an exam has been checked', 1;

			UPDATE EXAM_FOR_STUDENT SET class = @class, exam_group_type = @exam_group_type, result = @result WHERE student_no = @student_no AND exam_id = @exam_id

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