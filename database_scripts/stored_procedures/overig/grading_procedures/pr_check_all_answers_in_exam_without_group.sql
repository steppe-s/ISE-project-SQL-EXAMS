USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_check_all_answers_in_exam_without_group
@exam_id varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			
			IF (@exam_id IS NULL) THROW 60001, 'exam_id cannot be null', 1
			
			DECLARE @exam_group_type varchar(20);
			
			DECLARE cursor_answer CURSOR 
				FOR SELECT exam_group_type
					FROM EXAM_GROUP_IN_EXAM
					WHERE @exam_id = exam_id

			OPEN cursor_answer 
			FETCH NEXT FROM cursor_answer INTO @exam_group_type

			WHILE @@FETCH_STATUS = 0
                BEGIN
                    EXEC pr_check_all_answers_for_exam
							@exam_group_type = @exam_group_type,
							@exam_id = @exam_id

                    FETCH NEXT FROM cursor_answer INTO @exam_group_type;
                END
			CLOSE cursor_answer;
			DEALLOCATE cursor_answer;
			
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