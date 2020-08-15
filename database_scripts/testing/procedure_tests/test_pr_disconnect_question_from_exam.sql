use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass 'test_pr_disconnect_question_from_exam'
go

create or alter proc test_pr_disconnect_question_from_exam.test_if_pr_deletes_correct_record
as
begin
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
	exec tSQLt.FakeTable 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable 'QUESTION'

	insert into EXAM_GROUP_IN_EXAM(exam_id, exam_group_type, end_date)
	values ('eId', 'gId', GETDATE()+6)

	insert into QUESTION_IN_EXAM (exam_id, question_no, question_points)
	values  ('eId', 1, 20),
			('eId', 2, 30)

	insert into QUESTION (question_no, difficulty, exam_db_name, question_assignment, comment, status)
	values  (1, null, null, null, null, 'active'),
			(2, null, null, null, null, 'active')

	create table expected (
		exam_id					varchar(20),
		question_no				int,
		question_points			smallint
	)

	insert into expected (exam_id, question_no, question_points)
	values  ('eId', 2, 30)

	exec tSQLt.ExpectNoException

	exec pr_disconnect_question_from_exam @question_no = 1, @exam_id = 'eId'

	exec tSQLt.AssertEqualsTable 'expected', 'QUESTION_IN_EXAM'
end
go

create or alter proc test_pr_disconnect_question_from_exam.test_if_pr_throws_when_trying_to_disconnect_from_taken_exam
as
begin
	exec tSQLt.FakeTable 'EXAM'
	exec tSQLt.FakeTable 'QUESTION_IN_EXAM'

	insert into EXAM values('eId', null, null, GETDATE(), null)

	insert into QUESTION_IN_EXAM (exam_id, question_no, question_points)
	values ('eId', 1, 20)

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%questions may not be changed once they are used in an exam that has been taken%'

	exec pr_disconnect_question_from_exam @question_no = 1, @exam_id = 'eId'
end
go

create or alter proc test_pr_disconnect_question_from_exam.test_if_status_is_updated_in_question_table
as
begin
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
	exec tSQLt.FakeTable 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable 'QUESTION'

	insert into EXAM_GROUP_IN_EXAM(exam_id, exam_group_type, end_date)
	values ('eId', 'gId',  GETDATE()+6)

	insert into QUESTION (question_no, difficulty, exam_db_name, question_assignment, comment, status)
	values (1, null, null, null, null, 'active')

	create table expected (
		question_no				int,
		difficulty				varchar(10),
		exam_db_name			varchar(40),
		question_assignment		varchar(max),
		comment					varchar(max),
		status					varchar(20)
	)

	insert into expected (question_no, difficulty, exam_db_name, question_assignment, comment, status)
	values (1, null, null, null, null, 'unused')

	exec tSQLt.ExpectNoException

	exec pr_disconnect_question_from_exam @question_no = 1, @exam_id = 'eId'

	exec tSQLt.AssertEqualsTable 'expected', 'QUESTION'
end
go

create or alter proc test_pr_disconnect_question_from_exam.test_if_pr_throws_when_question_no_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%'

	exec pr_disconnect_question_from_exam @question_no = null, @exam_id = 'eId'
end
go

create or alter proc test_pr_disconnect_question_from_exam.test_if_pr_throws_when_exam_id_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%'

	exec pr_disconnect_question_from_exam @question_no = 1, @exam_id = null
end
go