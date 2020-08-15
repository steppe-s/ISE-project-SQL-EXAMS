USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_prepare_exam_databases
@exam_id NVARCHAR(40)
AS
BEGIN
    BEGIN TRY
        DECLARE @exam_db_name VARCHAR(40)
        DECLARE @databases CURSOR
        SET @databases = CURSOR FOR SELECT DISTINCT exam_db_name FROM QUESTION_IN_EXAM qe JOIN QUESTION q ON qe.question_no = q.question_no WHERE qe.exam_id = @exam_id
        OPEN @databases
        FETCH NEXT
        FROM @databases INTO @exam_db_name

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC pr_create_database @exam_db_name
            EXEC pr_execute_ddl @exam_db_name
            EXEC pr_execute_dml @exam_db_name
        END
        CLOSE @databases
        DEALLOCATE @databases
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END