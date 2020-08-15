USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_select_results_for_student_answer
@question_no INT,
@exam_id VARCHAR(20),
@student_no INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		IF(@question_no IS NULL)THROW 60002, 'question_no cannot be NULL', 1;
		IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be NULL', 1;
		IF(@student_no IS NULL)THROW 60012, 'student_no cannot be NULL', 1;


		DECLARE @answer VARCHAR(MAX)
		SET @answer = (SELECT answer FROM ANSWER WHERE student_no = @student_no AND exam_id = @exam_id AND question_no = @question_no)
		print(@answer)
		DECLARE @exam_db_name VARCHAR(40)
		SET @exam_db_name = (SELECT exam_db_name FROM QUESTION WHERE question_no = @question_no)
		
		IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @exam_db_name)
        THROW 60101, 'Database required for question is not available', 1;

		BEGIN TRY
			DECLARE @statement NVARCHAR(MAX) = @exam_db_name + '.dbo.sp_executesql N''' + REPLACE(@answer, '''', '''''') + ''''
			SELECT @statement
			EXEC (@statement)
		END TRY
		BEGIN CATCH
			THROW 60102, 'Statement not executable', 1;
		END CATCH

    END TRY
    BEGIN CATCH
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END