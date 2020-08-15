USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_insert_student_for_exam
	@student_no	int,
	@exam_id varchar(20),
	@class varchar(20),
	@group varchar(20),
	@result NUMERIC(4,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			IF @student_no IS NULL THROW  60012, 'student_no cannot be NULL', 1
			IF @exam_id IS NULL THROW 60001, 'exam_id cannot be null', 1
			IF @class IS NULL THROW 60011, 'class cannot be null', 1
			IF @group IS NULL THROW 60015, 'group cannot be null', 1

			IF EXISTS (SELECT 1 FROM EXAM_FOR_STUDENT WHERE exam_id = exam_id AND student_no = student_no)
			BEGIN
				DECLARE @message varchar(max) = CONCAT('Student: ', @student_no, ' is already registered for exam: ', @exam_id);
				THROW 60031, @message, 16;
			END

			IF NOT EXISTS (SELECT 1 FROM CLASS WHERE class = @class)
				THROW 60032, 'class does not exist', 16

			IF NOT EXISTS (SELECT 1 FROM EXAM_GROUP WHERE exam_group_type = @group)
				THROW 60033, 'group does not exist', 16

			INSERT INTO EXAM_FOR_STUDENT(exam_id, student_no, class, exam_group_type, result)
			VALUES (@exam_id, @student_no, @class, @group, @result)

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
