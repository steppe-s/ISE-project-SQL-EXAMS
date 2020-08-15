use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_connect_question_to_exam 
go

create or alter proc test_pr_connect_question_to_exam.[test if connect_question_to_exam throws question_no cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec  pr_connect_question_to_exam @question_no = null, @exam_id = 'exam_id', @question_points = 1

end
go

create or alter proc test_pr_connect_question_to_exam.[test if connect_question_to_exam throws exam_id cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec  pr_connect_question_to_exam @question_no = 1, @exam_id = null, @question_points = 1

end
go

create or alter proc test_pr_connect_question_to_exam.[test if connect_question_to_exam throws question_points cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_points cannot be null or 0%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec  pr_connect_question_to_exam @question_no = 1, @exam_id = 'exam_id', @question_points = null

end
go

create or alter proc test_pr_connect_question_to_exam.[test if connect_question_to_exam throws question cannot be added to exam] 
as
begin
	exec tSQLt.FakeTable @TableName = 'EXAM'
	exec tSQLt.FakeTable @TableName = 'QUESTION'
	exec tSQLt.FakeTable @TableName = 'QUESTION_IN_EXAM'

	INSERT INTO EXAM VALUES('exam_id', 'ITA-1A', 'name', GETDATE(), null)

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%questions may not be added to an exam that has taken place%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec  pr_connect_question_to_exam @question_no = 1, @exam_id = 'exam_id', @question_points = 1

end
go

create or alter proc test_pr_connect_question_to_exam.[test if connect_question_to_exam adds question to exam] 
as
begin
	exec tSQLt.FakeTable @TableName = EXAM_GROUP_IN_EXAM
	exec tSQLt.FakeTable @TableName = QUESTION_IN_EXAM

	CREATE TABLE EXPECTED(exam_id VARCHAR(20), question_no INT, question_points SMALLINT)
	INSERT INTO EXPECTED VALUES('exam_id', 1, 1)

	exec tSQLt.ExpectNoException
	exec  pr_connect_question_to_exam @question_no = 1, @exam_id = 'exam_id', @question_points = 1

end
go

create or alter proc test_pr_connect_question_to_exam.test_if_status_is_updated_in_question_table
as
begin
	exec tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
	exec tSQLt.FakeTable 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable 'QUESTION'

	insert into EXAM_GROUP_IN_EXAM(exam_id, exam_group_type, end_date)
	values ('eId', 'gId', GETDATE()+6)

	insert into QUESTION (question_no, difficulty, exam_db_name, question_assignment, comment, status)
	values (1, null, null, null, null, 'unused')

	create table expected (
		question_no				int,
		difficulty				varchar(10),
		exam_db_name			varchar(40),
		question_assignment		varchar(max),
		comment					varchar(max),
		status					varchar(20)
	)

	insert into expected (question_no, difficulty, exam_db_name, question_assignment, comment, status)
	values (1, null, null, null, null, 'active')

	exec tSQLt.ExpectNoException

	exec pr_connect_question_to_exam @question_no = 1, @exam_id = 'eId', @question_points = 20

	exec tSQLt.AssertEqualsTable 'expected', 'QUESTION'
end
go
