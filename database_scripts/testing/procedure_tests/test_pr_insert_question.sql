use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_insert_question 
go

create or alter proc test_pr_insert_question.[test if upload_question throws difficulty cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%difficulty cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
		exec pr_insert_question @exam_id = 1, @question_points = 1, @difficulty = null, @exam_db_name = 'exam_db_name', @question_assignment = 'question_assignment', @correct_answer_statement = 'correct_answer_statement', @comment = null
end
go

create or alter proc test_pr_insert_question.[test if upload_question throws db_name cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%db_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
		exec pr_insert_question @exam_id = 1, @question_points = 1, @difficulty = 'difficulty', @exam_db_name = null, @question_assignment = 'question_assignment', @correct_answer_statement = 'correct_answer_statement', @comment = null
end
go

create or alter proc test_pr_insert_question.[test if upload_question throws question_assignment cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_assignment cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
		exec pr_insert_question @exam_id = 1, @question_points = 1, @difficulty = 'difficulty', @exam_db_name = 'exam_db_name', @question_assignment = null, @correct_answer_statement = 'correct_answer_statement', @comment = null
end
go

create or alter proc test_pr_insert_question.[test if upload_question throws correct_answer cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%correct_answer cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
		exec pr_insert_question @exam_id = 1, @question_points = 1, @difficulty = 'difficulty', @exam_db_name = 'exam_db_name', @question_assignment = 'question_assignment', @correct_answer_statement = null, @comment = null
end
go


create or alter proc test_pr_insert_question.[test if upload_question throws exam_id cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
		exec pr_insert_question @exam_id = null, @question_points = 1, @difficulty = 'difficulty', @exam_db_name = 'exam_db_name', @question_assignment = 'question_assignment', @correct_answer_statement = null, @comment = null
end
go


create or alter proc test_pr_insert_question.[test if upload_question throws question_points cannot cannot be null or 0] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_points cannot be null or 0%', @ExpectedSeverity = 16, @ExpectedState = NULL;
		exec pr_insert_question @exam_id = 1, @question_points = 0, @difficulty = 'difficulty', @exam_db_name = 'exam_db_name', @question_assignment = 'question_assignment', @correct_answer_statement = 'correct_answer_statement', @comment = null
end
go

create or alter proc test_pr_insert_question.[test if insert_question calls pr_insert_correct_answer with question_no 1] 
as
begin
	exec tSQLt.FakeTable @TableName = QUESTION
	exec tSQLt.FakeTable @TableName = QUESTION_IN_EXAM
	
	exec tSQLt.FakeTable @TableName = EXAM
	INSERT INTO EXAM VALUES('test_id', null, null, null, null)

	exec tSQLt.SpyProcedure @ProcedureName = 'dbo.pr_insert_correct_answer'
	exec pr_insert_question @exam_id = 'test_id', @exam_db_name = 'exam_db_name', @question_assignment = 'question_assignment', @question_points = 1, @correct_answer_statement = 'correct_answer_statement', @difficulty = 'hard', @comment = null

	SELECT question_no INTO actual FROM dbo.pr_insert_correct_answer_SpyProcedureLog
	SELECT question_no INTO expected FROM (SELECT null) ex(question_no)

	exec tSQLt.AssertEqualsTable 'actual', 'expected';

end
go
