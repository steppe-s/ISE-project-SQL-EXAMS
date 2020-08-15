use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_select_questions_in_exam 
go

create or alter proc test_pr_select_questions_in_exam.[test if select_questions_in_exam throws exam_id cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_select_questions_in_exam @exam_id = null

end
go

create or alter proc test_pr_select_questions_in_exam.[test if select_questions_in_exam selects right questions] 
as
begin
	exec tSQLt.FakeTable @TableName = EXAM
	exec tSQLt.FakeTable @TableName = QUESTION_IN_EXAM
	exec tSQLt.FakeTable @TableName = QUESTION

	INSERT INTO EXAM (exam_id, course, exam_name, starting_date, comment)
	VALUES('exam_id', 'course_id', 'exam_name', GetDate(), null),
		  ('exam_id2', 'course_id', 'exam_name', GetDate(), null)


	INSERT INTO QUESTION(difficulty, exam_db_name, question_assignment, comment, status) VALUES('dif', 'exam_db_name', 'question_assignment', null, 'active')
	INSERT INTO QUESTION(difficulty, exam_db_name, question_assignment, comment, status) VALUES('dif', 'exam_db_name2', 'question_assignment2', null, 'active')
	INSERT INTO QUESTION(difficulty, exam_db_name, question_assignment, comment, status) VALUES('dif', 'exam_db_name3', 'question_assignment3', null, 'active')

	INSERT INTO QUESTION_IN_EXAM VALUES('exam_id', 1, 1)
	INSERT INTO QUESTION_IN_EXAM VALUES('exam_id2', 2, 1)
	INSERT INTO QUESTION_IN_EXAM VALUES('exam_id2', 3, 1)


	exec tSQLt.ExpectNoException
	exec tSQLt.AssertResultSetsHaveSameMetaData @expectedCommand = 'SELECT difficulty, exam_db_name, question_assignment, comment FROM QUESTION WHERE question_no = 1', @actualCommand = 'exec pr_select_questions_in_exam @exam_id = exam_id'

end
go
