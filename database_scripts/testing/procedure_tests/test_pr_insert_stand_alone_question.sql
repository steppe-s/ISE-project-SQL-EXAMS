use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_insert_stand_alone_question 
go

create or alter proc test_pr_insert_stand_alone_question.[test if upload_question throws difficulty cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%difficulty cannot be null%'
		exec pr_insert_stand_alone_question @difficulty = null, @exam_db_name = 'exam_db_name', @question_assignment = 'question_assignment', @correct_answer_statement = 'correct_answer_statement', @comment = null
end
go

create or alter proc test_pr_insert_stand_alone_question.[test if upload_question throws db_name cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%db_name cannot be null%'
		exec pr_insert_stand_alone_question @difficulty = 'difficulty', @exam_db_name = null, @question_assignment = 'question_assignment', @correct_answer_statement = 'correct_answer_statement', @comment = null
end
go

create or alter proc test_pr_insert_stand_alone_question.[test if upload_question throws question_assignment cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_assignment cannot be null%'
		exec pr_insert_stand_alone_question @difficulty = 'difficulty', @exam_db_name = 'exam_db_name', @question_assignment = null, @correct_answer_statement = 'correct_answer_statement', @comment = null
end
go

create or alter proc test_pr_insert_stand_alone_question.[test if upload_question throws correct_answer cannot be null] 
as
begin
	
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%correct_answer cannot be null%'
		exec pr_insert_stand_alone_question @difficulty = 'difficulty', @exam_db_name = 'exam_db_name', @question_assignment = 'question_assignment', @correct_answer_statement = null, @comment = null
end
go

create or alter proc test_pr_insert_stand_alone_question.[test if insert_question calls pr_insert_correct_answer with question_no 1] 
as
begin
	exec tSQLt.FakeTable @TableName = QUESTION
	
	exec tSQLt.SpyProcedure @ProcedureName = 'dbo.pr_insert_correct_answer'
	exec pr_insert_stand_alone_question @exam_db_name = 'exam_db_name', @question_assignment = 'question_assignment', @correct_answer_statement = 'correct_answer_statement', @difficulty = 'hard', @comment = null

	SELECT question_no INTO actual FROM dbo.pr_insert_correct_answer_SpyProcedureLog
	SELECT question_no INTO expected FROM (SELECT null) ex(question_no)

	exec tSQLt.AssertEqualsTable 'actual', 'expected';

end
go

create or alter proc test_pr_insert_stand_alone_question.test_if_pr_inserts_correct_record_in_QUESTION
as
begin
	declare @exam_db_name varchar(40) = 'exam_db_name'
	declare @question_assignment varchar(max) = 'question_assignment'
	declare @correct_answer_statement varchar(max) = 'correct_answer_statement'
	declare @difficulty varchar(10) = 'hard'
	declare @comment varchar(max) = null

	exec tSQLt.FakeTable @TableName = QUESTION, @Identity = 1
	exec tSQLt.FakeTable CORRECT_ANSWER

	create table expected (
		question_no				int				not null,
		difficulty				varchar(10)		not null,
		exam_db_name			varchar(40)		not null,
		question_assignment		varchar(max)	not null,
		comment					varchar(max)	null,
		status					varchar(20)		not null
	)

	insert into expected(question_no, difficulty, exam_db_name, question_assignment, comment, status)
	values (1, @difficulty, @exam_db_name, @question_assignment, @comment, 'unused')
	
	exec tSQLt.ExpectNoException

	exec pr_insert_stand_alone_question @exam_db_name = @exam_db_name, @question_assignment = @question_assignment, @correct_answer_statement = @correct_answer_statement, @difficulty = @difficulty, @comment = @comment

	exec tSQLt.AssertEqualsTable 'expected', 'QUESTION'

end
go

create or alter proc test_pr_insert_stand_alone_question.test_if_pr_inserts_correct_record_in_CORRECT_ANSWER
as
begin
	declare @exam_db_name varchar(40) = 'exam_db_name'
	declare @question_assignment varchar(max) = 'question_assignment'
	declare @correct_answer_statement varchar(max) = 'correct_answer_statement'
	declare @difficulty varchar(10) = 'hard'
	declare @comment varchar(max) = null

	exec tSQLt.FakeTable @TableName = QUESTION, @Identity = 1
	exec tSQLt.FakeTable CORRECT_ANSWER

	create table expected (
		question_no					int				not null,
		correct_answer_id			smallint		not null,
		correct_answer_statement	varchar(max)	not null
	)

	insert into expected(question_no, correct_answer_id, correct_answer_statement)
	values (1, 1, @correct_answer_statement)
	
	exec tSQLt.ExpectNoException

	exec pr_insert_stand_alone_question @exam_db_name = @exam_db_name, @question_assignment = @question_assignment, @correct_answer_statement = @correct_answer_statement, @difficulty = @difficulty, @comment = @comment

	exec tSQLt.AssertEqualsTable 'expected', 'CORRECT_ANSWER'

end
go
