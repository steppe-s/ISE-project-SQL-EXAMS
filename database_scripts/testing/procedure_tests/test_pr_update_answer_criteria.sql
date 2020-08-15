use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass 'test_pr_update_answer_criteria'
go

create or alter proc test_pr_update_answer_criteria.test_if_pr_updates_keyword_correctly
as
begin
	exec tSQLt.FakeTable 'ANSWER_CRITERIA'
	exec tSQLt.FakeTable 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
	exec tSQLt.FakeTable 'EXAM'

	insert into ANSWER_CRITERIA (question_no, keyword, criteria_type)
	values (1, 'join', 'Banned')

	insert into QUESTION_IN_EXAM(exam_id, question_no, question_points)
	values (1, 1, 20)

	insert into EXAM_GROUP_IN_EXAM(exam_id, exam_group_type, end_date)
	values (1, 'gId', '2030-01-01 01:00:00.000')

	insert into EXAM values(1, NULL, NULL, GETDATE()+120, NULL)

	exec tSQLt.ExpectNoException

	exec pr_update_answer_criteria @question_no = 1, @keyword_old = 'join', @keyword_new = 'where', @criteria_type  = 'Banned'

	create table expected (
		question_no		int				not null,
		keyword			varchar(30)		not null,
		criteria_type	varchar(30)		not null
	)

	insert into expected (question_no, keyword, criteria_type)
	values  (1, 'where', 'Banned')

	exec tSQLt.AssertEqualsTable 'expected', 'ANSWER_CRITERIA'
end
go

create or alter proc test_pr_update_answer_criteria.test_if_pr_updates_criteria_type_correctly
as
begin
	exec tSQLt.FakeTable 'ANSWER_CRITERIA'
	exec tSQLt.FakeTable 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
	exec tSQLt.FakeTable 'EXAM'

	insert into ANSWER_CRITERIA (question_no, keyword, criteria_type)
	values (1, 'join', 'Banned')

	insert into QUESTION_IN_EXAM(exam_id, question_no, question_points)
	values (1, 1, 20)

	insert into EXAM_GROUP_IN_EXAM(exam_id, exam_group_type, end_date)
	values (1, 'gId', '2030-01-01 01:00:00.000')

	insert into EXAM values(1, NULL, NULL, GETDATE()+120, NULL)

	exec tSQLt.ExpectNoException

	exec pr_update_answer_criteria @question_no = 1, @keyword_old = 'join', @keyword_new = 'join', @criteria_type  = 'Required'

	create table expected (
		question_no		int				not null,
		keyword			varchar(30)		not null,
		criteria_type	varchar(30)		not null
	)

	insert into expected (question_no, keyword, criteria_type)
	values  (1, 'join', 'Required')

	exec tSQLt.AssertEqualsTable 'expected', 'ANSWER_CRITERIA'
end
go

create or alter proc test_pr_update_answer_criteria.test_if_pr_throws_when_tyring_to_update_keyword_when_exam_has_already_been_taken_place
as
begin
	exec tSQLt.FakeTable 'ANSWER_CRITERIA'
	exec tSQLt.FakeTable 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
	exec tSQLt.FakeTable 'EXAM'

	insert into EXAM values(1, NULL, NULL, GETDATE(), NULL)

	insert into ANSWER_CRITERIA (question_no, keyword, criteria_type)
	values (1, 'join', 'Banned')

	insert into QUESTION_IN_EXAM(exam_id, question_no, question_points)
	values (1, 1, 20)

	insert into EXAM_GROUP_IN_EXAM(exam_id, exam_group_type, end_date)
	values (1, 'gId', GETDATE()+1)

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%A keyword for a question may not be changed once the question has been used in an exam that has been taken%'

	exec pr_update_answer_criteria @question_no = 1, @keyword_old = 'join', @keyword_new = 'where', @criteria_type  = 'Banned'
end
go

create or alter proc test_pr_update_answer_criteria.test_if_pr_throws_when_question_no_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%'

	exec pr_update_answer_criteria @question_no = null, @keyword_old = 'join', @keyword_new = 'where', @criteria_type  = 'Banned'
end
go

create or alter proc test_pr_update_answer_criteria.test_if_pr_throws_when_keyword_old_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%keyword_old cannot be null%'

	exec pr_update_answer_criteria @question_no = 1, @keyword_old = null, @keyword_new = 'where', @criteria_type  = 'Banned'
end
go

create or alter proc test_pr_update_answer_criteria.test_if_pr_throws_when_keyword_new_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%keyword_new cannot be null%'

	exec pr_update_answer_criteria @question_no = 1, @keyword_old = 'join', @keyword_new = null, @criteria_type  = 'Banned'
end
go

create or alter proc test_pr_update_answer_criteria.test_if_pr_throws_when_criteria_type_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%criteria_type cannot be null%'

	exec pr_update_answer_criteria @question_no = 1, @keyword_old = 'join', @keyword_new = 'where', @criteria_type  = null
end
go