use HAN_SQL_EXAM_DATABASE
go

CREATE OR ALTER TRIGGER tr_end_date_is_after_starting_date
    ON dbo.EXAM_GROUP_IN_EXAM
    FOR UPDATE, INSERT
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
		if exists (
			select 1
			from inserted i
				inner join EXAM e on i.exam_id = e.exam_id
			where end_date <= starting_date
		)
			throw 60030, 'end_date must be after starting_time', 1
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END
GO
