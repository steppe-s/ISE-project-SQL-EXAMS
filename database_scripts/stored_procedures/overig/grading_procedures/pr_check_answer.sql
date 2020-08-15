USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_check_answer 
@question_no INT, 
@exam_id VARCHAR(20), 
@student_no INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
            DECLARE @exam_db_name VARCHAR(40)
            SELECT @exam_db_name = exam_db_name FROM QUESTION WHERE question_no = @question_no 
            --database check (Maybe automatically run ddl and dml when database is missing or incorrect?)
            IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @exam_db_name)
                THROW 60101, 'Database required for question is not available', 1;
            BEGIN TRY
                DECLARE @answer VARCHAR(MAX), @correct VARCHAR(MAX)
                SELECT @answer = answer FROM ANSWER WHERE student_no = @student_no AND exam_id = @exam_id AND question_no = @question_no
				IF(@answer IS NULL)
				THROW 60110, 'No answer was provided by the student', 1;
                IF NOT EXISTS (SELECT * FROM CORRECT_ANSWER WHERE question_no = @question_no AND dbo.ft_compare_sql_statements(correct_answer_statement, @answer) = 1)
                BEGIN
                    --Keyword check
					BEGIN TRY
						DECLARE @keyword VARCHAR(30)
						DECLARE @criteriatype VARCHAR(30)

						SET ROWCOUNT 0
			
						SELECT keyword, criteria_type INTO #temp_table FROM ANSWER_CRITERIA
							WHERE question_no = @question_no
						
						SET ROWCOUNT 1

						SELECT @keyword = keyword FROM #temp_table
						SELECT @criteriatype = criteria_type FROM #temp_table

						WHILE @@ROWCOUNT <> 0
							BEGIN
							SET ROWCOUNT 0
							DELETE FROM #temp_table WHERE keyword = @keyword

							IF(@criteriatype = 'Banned')
								BEGIN
								IF(CHARINDEX(@keyword, @answer) > 0)
								THROW 60111, 'Answer uses an illicit word', 1;
								END
					
							IF(@criteriatype = 'Required')
								BEGIN
								IF(CHARINDEX(@keyword, @answer) = 0)
								THROW 60112, 'Answer does not include the required statements', 1;
								END
					

						SET ROWCOUNT 1
						SELECT @keyword = keyword FROM #temp_table

						END
					END TRY
					BEGIN CATCH
					THROW;
					END CATCH
					
					--Syntax check
                    BEGIN TRY
                        DECLARE @statement NVARCHAR(MAX) = @exam_db_name + '.dbo.sp_executesql N''' + REPLACE(@answer, '''', '''''') + ''''
                        SELECT @statement
                        EXEC (@statement)
                    END TRY
                    BEGIN CATCH
                        THROW 60102, 'Statement not executable', 1;
                    END CATCH
                    --Result check (This will not check if the answer is correctly sorted. Need to implement an extra check for this.)
                    DECLARE @correct_statement VARCHAR(MAX)
                    SELECT TOP 1 @correct_statement = correct_answer_statement FROM CORRECT_ANSWER WHERE question_no = @question_no
                    BEGIN TRY
                        DECLARE @json_correct varchar(MAX)
                        EXEC @json_correct = ft_execute_statement_into_json @correct_statement, @exam_db_name
                        DECLARE @json_attempt varchar(MAX)
                        EXEC @json_attempt = ft_execute_statement_into_json @answer, @exam_db_name
                        -- Oude versie comparison. Laten staan voor eventuele terugdraai
                        -- DECLARE @comparison_query NVARCHAR(MAX) = '((' + REPLACE(@answer, '''', '''''') + ') Except (' + @correct_statement + ')) union ((' + @correct_statement + ') Except (' + REPLACE(@answer, '''', '''''') + '))'
                        -- SET @statement = @exam_db_name + '.dbo.sp_executesql N''' + @comparison_query + ''''
                        -- SELECT @statement
                        -- EXEC (@statement)                        
                        -- if(@@rowcount > 0)
                        IF @json_correct != @json_attempt
                            THROW 60103, 'Queries do not return same rows', 1;
                    END TRY
                    BEGIN CATCH 
                        IF(ERROR_NUMBER() = 60103)
                            THROW;
                        ELSE IF (ERROR_NUMBER() = 205)
                            THROW 60104, 'Queries do not return same columns', 1;
                        ;THROW;
                    END CATCH
                END
                --if all checks have passed answer rating is set to 1 indictating that the answer is CORRECT.
                UPDATE ANSWER SET answer_status = 'PENDING' WHERE student_no = @student_no AND exam_id = @exam_id AND question_no = @question_no
            END TRY
            BEGIN CATCH
                IF NOT EXISTS (SELECT * FROM REASON WHERE reason_no = ERROR_NUMBER())
                    INSERT INTO REASON (reason_no, reason_description) VALUES (ERROR_NUMBER(), ERROR_MESSAGE())
                --if a checks fails answer rating is set to 0 indictating that the answer is INCORRECT.
                UPDATE ANSWER SET answer_status = 'INCORRECT', reason_no = ERROR_NUMBER() WHERE student_no = @student_no AND exam_id = @exam_id AND question_no = @question_no
            END CATCH
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




