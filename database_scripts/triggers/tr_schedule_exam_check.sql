USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER TRIGGER tr_schedule_exam_check
    ON dbo.EXAM_GROUP_IN_EXAM
    FOR UPDATE, INSERT, DELETE
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
      
      DECLARE @exam_id VARCHAR(20)
      DECLARE @end_date DATETIME
      DECLARE @exams CURSOR
      SET @exams = CURSOR FOR SELECT exam_id FROM inserted
      OPEN @exams
      FETCH NEXT
      FROM @exams INTO @exam_id
      WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC pr_select_highest_end_date_from_exam @exam_id, @highest_hand_in_date = @end_date  OUTPUT
            EXEC pr_schedule_check_job @exam_id, @end_date
        END
        CLOSE @exams
        DEALLOCATE @exams
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END
GO
