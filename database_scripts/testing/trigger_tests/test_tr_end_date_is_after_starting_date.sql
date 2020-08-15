use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_tr_end_date_is_after_starting_date
go

create or alter proc test_tr_end_date_is_after_starting_date.[test if tr throws when trying to insert an end date which is before starting date]
as
begin
	exec tSQLt.FakeTable EXAM_GROUP_IN_EXAM
	exec tSQLt.FakeTable EXAM

	exec tSQLt.ApplyTrigger EXAM_GROUP_IN_EXAM, 'tr_end_date_is_after_starting_date'

	insert into EXAM(exam_id, starting_date)
	values  ('eId', GETDATE()+10),
			('eId2', GETDATE()+15)

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%end_date must be after starting_time%'

	insert into EXAM_GROUP_IN_EXAM (exam_id, end_date)
	values  ('eId', GETDATE()-10),
			('eId2', GETDATE()+25)
end
go

create or alter proc test_tr_end_date_is_after_starting_date.[test if you can correctly insert multiple rows if end date is after starting time]
as
begin
	exec tSQLt.FakeTable EXAM_GROUP_IN_EXAM
	exec tSQLt.FakeTable EXAM

	exec tSQLt.ApplyTrigger EXAM_GROUP_IN_EXAM, 'tr_end_date_is_after_starting_date'

	insert into EXAM(exam_id, starting_date)
	values  ('eId', GETDATE()+10),
			('eId2', GETDATE()+15)

	exec tSQLt.ExpectNoException

	insert into EXAM_GROUP_IN_EXAM (exam_id, end_date)
	values  ('eId', GETDATE()+20),
			('eId2', GETDATE()+25)
end
go
