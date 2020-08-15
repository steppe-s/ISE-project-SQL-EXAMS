use HAN_SQL_EXAM_DATABASE
go

CREATE OR ALTER TRIGGER tr_restrict_update_end_time_after_exam_has_been_taken
    ON dbo.EXAM_GROUP_IN_EXAM
    for UPDATE
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
		declare @totalRowsUpdated int = (
			select count(*)
			from inserted
		)
		declare @i int = 1
		while @i < @totalRowsUpdated + 1
		begin
			-- Checking if end-date have been changed. If not, continue
			if exists (
				select *
				from (
					select i.exam_id as new_exam_id, i.exam_group_type as new_exam_group_id, i.end_date as new_end_date, 
						   d.exam_id as deleted_exam_id, d.exam_group_type as deleted_exam_group_id, d.end_date as deleted_end_date, 
						   ROW_NUMBER() over (order by i.exam_id) as rn
					from inserted i 
						inner join deleted d on i.exam_id = d.exam_id and i.exam_group_type = d.exam_group_type
				) t
				where rn = @i and new_end_date = deleted_end_date
			)
			begin
				set @i = @i + 1
				continue;
			end

			-- Checking if the deleted end-date is before today
			if exists (
				select *
				from (
					select *, ROW_NUMBER() over (order by exam_id) as rn
					from deleted d
				) t
				where rn = @i and (end_date < GETDATE())
			)
				throw 60156, 'The end date is not allowed to be modified after the exam has been taken place', 1

			set @i = @i + 1
		end
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END
GO
