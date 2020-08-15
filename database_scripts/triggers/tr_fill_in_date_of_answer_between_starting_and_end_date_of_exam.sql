use HAN_SQL_EXAM_DATABASE
go

CREATE OR ALTER TRIGGER tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam
    ON dbo.ANSWER
    FOR UPDATE, INSERT
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
		if exists (
			select 1
			from dbo.ANSWER a
				inner join EXAM_FOR_STUDENT es on a.student_no = es.student_no and a.exam_id = es.exam_id
					inner join EXAM_GROUP_IN_EXAM ge on es.exam_id = ge.exam_id and es.exam_group_type = ge.exam_group_type
						inner join EXAM e on a.exam_id = e.exam_id
			where a.answer_fill_in_date < e.starting_date or a.answer_fill_in_date > ge.end_date
		)
			throw 60029, 'answer_fill_in_date must be between the starting and end date of the corresponding exam', 1
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END
GO