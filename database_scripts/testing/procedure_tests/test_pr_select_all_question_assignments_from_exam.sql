use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass 'test_pr_select_all_question_assignments_from_exam'
go

create or alter proc test_pr_select_all_question_assignments_from_exam.test_if_pr_throws_when_exam_id_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be NULL%'
	exec pr_select_all_question_assignments_from_exam @exam_id = null
end
go

create or alter proc test_pr_select_all_question_assignments_from_exam.test_if_pr_returns_correct_data
as
begin
	declare @exam_id varchar(20) = 'eId'
	declare @question_no int = 1

	exec tSQLt.FakeTable 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable 'QUESTION'
	exec tSQLt.ExpectNoException 

	insert into QUESTION_IN_EXAM(exam_id, question_no, question_points)
	values (@exam_id, @question_no, 15)

	insert into QUESTION(question_no, question_assignment)
	values (@question_no, 'assignment')

	exec tSQLt.AssertResultSetsHaveSameMetaData @expectedCommand = 'select q.question_assignment, qe.question_points
		from QUESTION q
			inner join QUESTION_IN_EXAM qe on q.question_no = qe.question_no
		where exam_id = ''eId''', @actualCommand = 'exec pr_select_all_question_assignments_from_exam @exam_id = ''eId'''
	
end
go
