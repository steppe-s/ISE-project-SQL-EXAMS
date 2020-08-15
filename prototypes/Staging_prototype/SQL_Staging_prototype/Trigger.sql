use stagingTest
go

create or alter trigger tg_update_warehouse_on_insert
	on ANSWER
	after insert
as
begin
	begin try
		insert into DATA_WAREHOUSE.dbo.STUDENT_RESULTS (student, question_no, set_id, correct)
		select i.student, i.question_no, i.set_id, i.correct
		from inserted i
			inner join stagingTest.dbo.ANSWER a on i.student = a.student and i.question_no = a.question_no and i.set_id = a.set_id
	end try
	begin catch
		throw
	end catch
end
go