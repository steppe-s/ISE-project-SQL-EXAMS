USE HAN_SQL_EXAM_DATABASE
GO
exec tSQLt.NewTestClass test_pr_insert__correct_answer
go

create or alter proc test_pr_insert__correct_answer.[test if insert_correct_answer throws question_no cannot be null]
as
begin

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;

	exec pr_insert_correct_answer @question_no = null, @correct_answer_statement = 'correct_answer_statement'
end
go

create or alter proc test_pr_insert__correct_answer.[test if insert_correct_answer throws correct_answer_statement cannot be null]
as
begin

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%correct_answer_statement cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;


	exec pr_insert_correct_answer @question_no = 1, @correct_answer_statement = null
end
go

create or alter proc test_pr_insert__correct_answer.[test if insert_correct_answer inserts answer]
as
begin
	exec tSQLt.FakeTable @TableName = 'CORRECT_ANSWER'

	CREATE TABLE EXPECTED
	(
		question_no SMALLINT,
		correct_answer_id SMALLINT,
		correct_answer_statement VARCHAR(MAX)
	)

	INSERT INTO EXPECTED
	VALUES(1, 1, 'correct_answer_statement')

	exec tSQLt.ExpectNoException
	exec pr_insert_correct_answer @question_no = 1, @correct_answer_statement = 'correct_answer_statement'

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = 'CORRECT_ANSWER'

end
go

create or alter proc test_pr_insert__correct_answer.[test if insert_correct_answer sets answer_id to 1]
as
begin
	exec tSQLt.FakeTable @TableName = 'CORRECT_ANSWER'

	exec pr_insert_correct_answer @question_no = 1, @correct_answer_statement = 'correct_answer_statement'
	declare @actualResult smallint
	set @actualResult = (SELECT correct_answer_id
	FROM CORRECT_ANSWER)
	exec tSQLt.AssertEquals @expected = 1, @actual = @actualResult
end
go

create or alter proc test_pr_insert__correct_answer.[test if insert_correct_answer sets answer_id to 2]
as
begin
	exec tSQLt.FakeTable @TableName = 'CORRECT_ANSWER'

	INSERT INTO CORRECT_ANSWER
	VALUES(1, 1, 'correct_answer_statement')
	exec pr_insert_correct_answer @question_no = 1, @correct_answer_statement = 'correct_answer_statement'
	declare @actualResult smallint
	set @actualResult = (SELECT TOP(1)
		correct_answer_id
	FROM CORRECT_ANSWER
	ORDER BY correct_answer_id DESC)
	exec tSQLt.AssertEquals @expected = 2, @actual = @actualResult
end
go