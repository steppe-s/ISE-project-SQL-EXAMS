USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_check_all_answers_for_exam
	@exam_group_type VARCHAR(20),
    @exam_id VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            IF @exam_group_type IS NULL
                THROW 60015, 'exam_group_type cannot be null', 1;
            IF @exam_id IS NULL
                THROW 60001, 'exam_id cannot be null', 1;
            IF EXISTS (SELECT * FROM EXAM_GROUP_IN_EXAM WHERE exam_id = @exam_id AND exam_group_type = @exam_group_type)
            BEGIN
                DECLARE @student_no INT
                DECLARE @question_no INT

                DECLARE @result CURSOR

                SET @result = CURSOR FOR SELECT student_no, question_no FROM ANSWER WHERE exam_id = @exam_id AND student_no IN (SELECT student_no FROM EXAM_FOR_STUDENT WHERE exam_group_type = @exam_group_type AND exam_id = @exam_id)                
                
                --start the cursor
                OPEN @result
                --get first result
                FETCH NEXT
                FROM @result INTO @student_no, @question_no
                --loop over results
                WHILE @@FETCH_STATUS = 0
                BEGIN
                    SELECT CAST(@question_no AS VARCHAR(20)) + ':' + @exam_id + ':' + CAST(@student_no AS VARCHAR(20)) 
                    EXEC pr_check_answer @question_no, @exam_id, @student_no
                    --get next result
                    FETCH NEXT
                    FROM @result INTO @student_no, @question_no
                END
                --end the cursor
                CLOSE @result
                DEALLOCATE @result
            END
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

GO