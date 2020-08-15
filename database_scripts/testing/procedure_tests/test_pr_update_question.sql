use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_update_question 
go

create or alter proc test_pr_update_question.[test if update_question throws question_no cannot be null] 
as
begin

		exec tSQLt.ExpectException @ExpectedMessagePattern = '%Question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;


	exec pr_update_question @question_no = null, @difficulty = 'difficult', @exam_db_name = 'db_name', @question_assignment = 'question_assignment', @comment = null, @remove_comment = 0
end
go

create or alter proc test_pr_update_question.[test if update_question throws difficulty_id cannot be null] 
as
begin

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Difficulty cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;

	exec pr_update_question @question_no = 1, @difficulty = null, @exam_db_name = 'db_name', @question_assignment = 'question_assignment', @comment = null, @remove_comment = 0
end
go

create or alter proc test_pr_update_question.[test if update_question throws db_name cannot be null] 
as
begin

			exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_db_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;


	exec pr_update_question @question_no = 1, @difficulty = 'difficult', @exam_db_name = null, @question_assignment = 'question_assignment', @comment = null, @remove_comment = 0
end
go

create or alter proc test_pr_update_question.[test if update_question throws question_assignment cannot be null] 
as
begin

		exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_assignment cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;

	exec pr_update_question @question_no = 1, @difficulty = 'difficult', @exam_db_name = 'db_name', @question_assignment = null, @comment = null, @remove_comment = 0
end
go

create or alter proc test_pr_update_question.[test if update_question throws questions may not be changed after useage] 
as
begin
		exec tSQLt.FakeTable @TableName = QUESTION
		exec tSQLt.FakeTable @TableName = QUESTION_IN_EXAM
		exec tSQLt.FakeTable @TableName = EXAM

		INSERT INTO QUESTION(question_no, difficulty, exam_db_name, question_assignment, comment) VALUES(1, 'difficulty', 'exam_db_name', 'question_assignment', null)
		INSERT INTO QUESTION_IN_EXAM VALUES(1, 1, 1)
		INSERT INTO EXAM VALUES(1, NULL, NULL, GETDATE()-120, NULL)

		exec tSQLt.ExpectException @ExpectedMessagePattern = '%questions may not be changed once they are used in an exam that has been taken%', @ExpectedSeverity = 16, @ExpectedState = NULL;

	exec pr_update_question @question_no = 1, @difficulty = 'difficult', @exam_db_name = 'db_name', @question_assignment = 'question_assignment', @comment = null, @remove_comment = 0
end
go



create or alter proc test_pr_update_question.[test if update_question updates question and removes comment] 
as
begin
	exec tSQLt.FakeTable @TableName = QUESTION
	INSERT INTO QUESTION(question_no, difficulty, exam_db_name, question_assignment, comment) VALUES(1, 'difficult', 'db_name1', 'question_assignment', 'comment')
	
	exec pr_update_question @question_no = 1, @difficulty = 'difficult2', @exam_db_name = 'db_name2', @question_assignment = 'question_assignment2', @comment = null, @remove_comment = 1

	CREATE TABLE EXPECTED(
	question_no SMALLINT,
	difficulty VARCHAR(10),
	exam_db_name VARCHAR(20),
	question_assignment VARCHAR(MAX),
	comment VARCHAR(MAX)
	)

	INSERT INTO EXPECTED VALUES(1, 'difficult2', 'db_name2', 'question_assignment2', null)

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = QUESTION
end
go

create or alter proc test_pr_update_question.[test if update_question updates question and keeps comment] 
as
begin
	exec tSQLt.FakeTable @TableName = QUESTION
	INSERT INTO QUESTION(question_no, difficulty, exam_db_name, question_assignment, comment) VALUES(1, 'difficult', 'db_name1', 'question_assignment', 'comment')
	
	exec pr_update_question @question_no = 1, @difficulty = 'difficult2', @exam_db_name = 'db_name2', @question_assignment = 'question_assignment2', @comment = null, @remove_comment = 0

	CREATE TABLE EXPECTED(
	question_no SMALLINT,
	difficulty VARCHAR(10),
	exam_db_name VARCHAR(20),
	question_assignment VARCHAR(MAX),
	comment VARCHAR(MAX)
	)

	INSERT INTO EXPECTED VALUES(1, 'difficult2', 'db_name2', 'question_assignment2', 'comment')

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = QUESTION
end
go


create or alter proc test_pr_update_question.[test if update_question updates question] 
as
begin
	exec tSQLt.FakeTable @TableName = QUESTION
	INSERT INTO QUESTION(question_no, difficulty, exam_db_name, question_assignment, comment) VALUES(1, 'difficult', 'db_name1', 'question_assignment', null)
	
	exec pr_update_question @question_no = 1, @difficulty = 'difficult2', @exam_db_name = 'db_name2', @question_assignment = 'question_assignment2', @comment = null, @remove_comment = 0

	CREATE TABLE EXPECTED(
	question_no SMALLINT,
	difficulty VARCHAR(10),
	exam_db_name VARCHAR(20),
	question_assignment VARCHAR(MAX),
	comment VARCHAR(MAX)
	)

	INSERT INTO EXPECTED VALUES(1, 'difficult2', 'db_name2', 'question_assignment2', null)

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = QUESTION
end
go