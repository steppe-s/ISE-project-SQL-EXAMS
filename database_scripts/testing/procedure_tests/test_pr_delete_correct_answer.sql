use HAN_SQL_EXAM_DATABASE
go

tSQLt.NewTestClass 'test_pr_delete_correct_answer'
go

CREATE OR ALTER PROC test_pr_delete_correct_answer.[test if delete_correct_answer throws question_no cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_delete_correct_answer @question_no = null, @correct_answer_id = 1

END
GO

CREATE OR ALTER PROC test_pr_delete_correct_answer.[test if delete_correct_answer throws correct_answer_id cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%correct_answer_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_delete_correct_answer @question_no = 1, @correct_answer_id = null

END
GO


CREATE OR ALTER PROC test_pr_delete_correct_answer.[test if delete_correct_answer throws at least one correct question must be provided]
AS
BEGIN
EXEC tSQLt.FakeTable @TableName = CORRECT_ANSWER
INSERT INTO CORRECT_ANSWER VALUES(1, 1, 'correct_answer_statement')


exec tSQLt.ExpectException @ExpectedMessagePattern = '%At least one correct answer must be provided for a question%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_delete_correct_answer @question_no = 1, @correct_answer_id = 1

END
GO


CREATE OR ALTER PROC test_pr_delete_correct_answer.[test if delete_correct_answer deletes correct record]
AS
BEGIN
EXEC tSQLt.FakeTable @TableName = CORRECT_ANSWER
INSERT INTO CORRECT_ANSWER VALUES(1, 1, 'correct_answer_statement')
INSERT INTO CORRECT_ANSWER VALUES(1, 2, 'correct_answer_statement2')
INSERT INTO CORRECT_ANSWER VALUES(2, 1, 'correct_answer_statement')

CREATE TABLE EXPECTED(question_no INT, correct_answer_id SMALLINT, correct_answer_statement VARCHAR(MAX))
INSERT INTO EXPECTED VALUES(1, 2, 'correct_answer_statement2')
INSERT INTO EXPECTED VALUES(2, 1, 'correct_answer_statement')

EXEC tSQLt.ExpectNoException
EXEC pr_delete_correct_answer @question_no = 1, @correct_answer_id = 1

EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = 'CORRECT_ANSWER'

END
GO