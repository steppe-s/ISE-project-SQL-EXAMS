use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam
go

create or alter proc test_tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam.[test if tr throws when trying to submit an answer before the starting date]
as
begin
	exec tSQLt.FakeTable EXAM_GROUP_IN_EXAM
	exec tSQLt.FakeTable EXAM
	exec tSQLt.FakeTable EXAM_FOR_STUDENT
	exec tSQLt.FakeTable ANSWER

	exec tSQLt.ApplyTrigger ANSWER, 'tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam'

	insert into EXAM(exam_id, starting_date)
	values  ('eId', GETDATE()+10)

	insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
	values  ('eId', 'Standaard', GETDATE()+20)
	
	insert into EXAM_FOR_STUDENT (exam_id, exam_group_type, student_no)
	values ('eId', 'Standaard', 1)

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%answer_fill_in_date must be between the starting and end date of the corresponding exam%'

	insert into ANSWER (exam_id, student_no, answer_fill_in_date)
	values ('eId', 1, GETDATE())
end
go

create or alter proc test_tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam.[test if tr allows insert if fill in date is between starting and end date]
as
begin
	exec tSQLt.FakeTable EXAM_GROUP_IN_EXAM
	exec tSQLt.FakeTable EXAM
	exec tSQLt.FakeTable EXAM_FOR_STUDENT
	exec tSQLt.FakeTable ANSWER

	exec tSQLt.ApplyTrigger ANSWER, 'tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam'

	insert into EXAM(exam_id, starting_date)
	values  ('eId', GETDATE()-5)

	insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
	values  ('eId', 'Standaard', GETDATE()+5)
	
	insert into EXAM_FOR_STUDENT (exam_id, exam_group_type, student_no)
	values ('eId', 'Standaard', 1)

	exec tSQLt.ExpectNoException

	insert into ANSWER (exam_id, student_no, answer_fill_in_date)
	values ('eId', 1, GETDATE())
end
go

create or alter proc test_tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam.[test if tr can handle multiple records]
as
begin
	exec tSQLt.FakeTable EXAM_GROUP_IN_EXAM
	exec tSQLt.FakeTable EXAM
	exec tSQLt.FakeTable EXAM_FOR_STUDENT
	exec tSQLt.FakeTable ANSWER

	exec tSQLt.ApplyTrigger ANSWER, 'tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam'

	insert into EXAM(exam_id, starting_date)
	values  ('eId', GETDATE()+10)

	insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
	values  ('eId', 'Standaard', GETDATE()+20)
	
	insert into EXAM_FOR_STUDENT (exam_id, exam_group_type, student_no)
	values  ('eId', 'Standaard', 1),
			('eId', 'Standaard', 2)

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%answer_fill_in_date must be between the starting and end date of the corresponding exam%'

	insert into ANSWER (exam_id, student_no, answer_fill_in_date)
	values ('eId', 1, GETDATE()),
		   ('eId', 2, GETDATE()+15)
end
go
