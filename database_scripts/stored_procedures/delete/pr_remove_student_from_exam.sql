USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_remove_student_from_exam
@student_no	INT,
@exam_id	VARCHAR(20)
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

			IF((SELECT starting_date FROM EXAM WHERE exam_id = @exam_id) < GETDATE())
			THROW 60162, 'you cannot remove a student from an exam that has taken place already', 1;

			DELETE FROM EXAM_FOR_STUDENT WHERE exam_id = @exam_id AND student_no = @student_no AND hand_in_date IS NULL AND result IS NULL

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