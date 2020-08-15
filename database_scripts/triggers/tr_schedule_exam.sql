USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER TRIGGER tr_schedule_exam
    ON dbo.EXAM
    FOR UPDATE, INSERT, DELETE
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
      
      DECLARE @exam_id VARCHAR(20)
      DECLARE @starting_date DATETIME
      DECLARE @exams CURSOR
      SET @exams = CURSOR FOR SELECT exam_id, starting_date FROM inserted
      OPEN @exams
      FETCH NEXT
      FROM @exams INTO @exam_id, @starting_date
      WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC pr_schedule_exam_job @exam_id, @starting_date 
        END
        CLOSE @exams
        DEALLOCATE @exams
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END
GO

