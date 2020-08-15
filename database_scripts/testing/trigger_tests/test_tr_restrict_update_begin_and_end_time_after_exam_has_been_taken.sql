use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass 'test_tr_restrict_update_begin_and_end_time_after_exam_has_been_taken'
go

create or alter proc test_tr_restrict_update_begin_and_end_time_after_exam_has_been_taken.test_if_tr_allows_updates_on_exam_id
as
begin
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
	
	exec tSQLt.ApplyTrigger 'EXAM_GROUP_IN_EXAM', 'tr_restrict_update_end_time_after_exam_has_been_taken'

	insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
	values (1, null, null)

	create table expected (
		exam_id			varchar(20),
		exam_group_type	varchar(20),
		end_date		datetime
	)

	insert into expected (exam_id, exam_group_type, end_date)
	values (2, null, null)

	exec tSQLt.ExpectNoException

	update EXAM_GROUP_IN_EXAM 
	set exam_id = 2
	where exam_id = 1

	exec tSQLt.AssertEqualsTable 'expected', 'EXAM_GROUP_IN_EXAM'
end
go

create or alter proc test_tr_restrict_update_begin_and_end_time_after_exam_has_been_taken.test_if_tr_allows_updates_on_exam_group_id
as
begin
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'

	exec tSQLt.ApplyTrigger 'EXAM_GROUP_IN_EXAM', 'tr_restrict_update_end_time_after_exam_has_been_taken'

	insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
	values (null, 'Standaard', null)

	create table expected (
		exam_id			varchar(20),
		exam_group_type	varchar(20),
		end_date		datetime
	)

	insert into expected (exam_id, exam_group_type, end_date)
	values (null, 'Herkanser', null)

	exec tSQLt.ExpectNoException

	update EXAM_GROUP_IN_EXAM 
	set exam_group_type = 'Herkanser'
	where exam_group_type = 'Standaard'

	exec tSQLt.AssertEqualsTable 'expected', 'EXAM_GROUP_IN_EXAM'
end
go

create or alter proc test_tr_restrict_update_begin_and_end_time_after_exam_has_been_taken.test_if_tr_allows_updates_on_end_date_of_future_exams
as
begin
	declare @old_end_date datetime = getdate()+100
	declare @new_end_date datetime = getdate()+120
	
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'

	exec tSQLt.ApplyTrigger 'EXAM_GROUP_IN_EXAM', 'tr_restrict_update_end_time_after_exam_has_been_taken'

	insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
	values (null, null, @old_end_date)

	create table expected (
		exam_id			varchar(20),
		exam_group_type	varchar(20),
		end_date		datetime
	)

	insert into expected (exam_id, exam_group_type, end_date)
	values (null, null, @new_end_date)

	exec tSQLt.ExpectNoException

	update EXAM_GROUP_IN_EXAM 
	set end_date = @new_end_date
	where end_date = @old_end_date

	exec tSQLt.AssertEqualsTable 'expected', 'EXAM_GROUP_IN_EXAM'
end
go

create or alter proc test_tr_restrict_update_begin_and_end_time_after_exam_has_been_taken.test_if_tr_throws_when_trying_to_update_end_date_of_taken_exam
as
begin
	declare @old_end_date datetime = getdate()-100
	declare @new_end_date datetime = getdate()+120
	
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'

	exec tSQLt.ApplyTrigger 'EXAM_GROUP_IN_EXAM', 'tr_restrict_update_end_time_after_exam_has_been_taken'

	insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
	values (null, null, @old_end_date)

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%The end date is not allowed to be modified after the exam has been taken place%'

	update EXAM_GROUP_IN_EXAM 
	set end_date = @new_end_date
	where end_date = @old_end_date
end
go

create or alter proc test_tr_restrict_update_begin_and_end_time_after_exam_has_been_taken.test_if_tr_can_handle_multiple_statements
as
begin
	declare @old_end_date datetime = getdate()-100
	declare @new_end_date datetime = getdate()+120
	
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'

	exec tSQLt.ApplyTrigger 'EXAM_GROUP_IN_EXAM', 'tr_restrict_update_end_time_after_exam_has_been_taken'

	insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
	values (null, null, @old_end_date),
		   (null, null, @old_end_date)

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%The end date is not allowed to be modified after the exam has been taken place%'

	update EXAM_GROUP_IN_EXAM 
	set end_date = @new_end_date
	where end_date = @old_end_date
end
go
