USE HAN_SQL_EXAM_DATABASE
GO
tSQLt.NewTestClass 'test_pr_update_correct_answer'
GO

CREATE OR ALTER PROC test_pr_update_correct_answer.[test if update_correct_answer throws question_no cannot be null]
AS
BEGIN

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_update_correct_answer @question_no = null, @correct_answer_id = 1, @correct_answer_statement = 'correct_answer_statement'

END
GO

CREATE OR ALTER PROC test_pr_update_correct_answer.[test if update_correct_answer throws question_no cannot be null]
AS
BEGIN

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%correct_answer_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_update_correct_answer @question_no = 1, @correct_answer_id = null, @correct_answer_statement = 'correct_answer_statement'

END
GO

CREATE OR ALTER PROC test_pr_update_correct_answer.[test if update_correct_answer throws question_no cannot be null]
AS
BEGIN

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%correct_answer_statement cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_update_correct_answer @question_no = 1, @correct_answer_id = 1, @correct_answer_statement = null

END
GO

CREATE OR ALTER PROC test_pr_update_correct_answer.[test if update_correct_answer updates correct answer]
AS
BEGIN

	exec tSQLt.FakeTable @TableName = 'CORRECT_ANSWER'
	INSERT INTO CORRECT_ANSWER VALUES(1, 1, 'correct_answer_statement1')

	CREATE TABLE EXPECTED(question_no INT, correct_answer_id SMALLINT, correct_answer_statement VARCHAR(MAX))
	INSERT INTO EXPECTED VALUES(1, 1, 'correct_answer_statement2')

	exec tSQLt.ExpectNoException
	exec pr_update_correct_answer @question_no = 1, @correct_answer_id = 1, @correct_answer_statement = 'correct_answer_statement2'

END
GO