USE HAN_SQL_EXAM_DATABASE
GO
EXEC tSQLt.NewTestClass test_pr_delete_question
GO

CREATE OR ALTER PROC test_pr_delete_question.[test if delete_question throws question_no cannot be null]
AS
BEGIN

EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_delete_question @question_no = null

END
GO


CREATE OR ALTER PROC test_pr_delete_question.[test if delete_question updates status to deleted]
AS
BEGIN
EXEC tSQLt.FakeTable @TableName = 'QUESTION'
INSERT INTO QUESTION(question_no, difficulty, exam_db_name, question_assignment, comment, status) VALUES(1, 'difficulty', 'exam_db_name', 'question_assignment', null, 'active')

EXEC tSQLt.FakeTable @TableName = 'QUESTION_IN_EXAM'
INSERT INTO QUESTION_IN_EXAM VALUES('exam_id', 1, 1)

CREATE TABLE EXPECTED(question_no INT, difficulty VARCHAR(10), exam_db_name VARCHAR(40), question_assignment VARCHAR(MAX), comment VARCHAR(MAX), status VARCHAR(20))
INSERT INTO EXPECTED VALUES(1, 'difficulty', 'exam_db_name', 'question_assignment', null, 'deleted')

EXEC tSQLt.ExpectNoException
EXEC pr_delete_question @question_no = 1
EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = 'QUESTION'

END
GO

CREATE OR ALTER PROC test_pr_delete_question.[test if delete_question deletes question when not in use]
AS
BEGIN
EXEC tSQLt.FakeTable @TableName = 'QUESTION'
INSERT INTO QUESTION(question_no, difficulty, exam_db_name, question_assignment, comment, status) VALUES(1, 'difficulty', 'exam_db_name', 'question_assignment', null, 'active')

EXEC tSQLt.ExpectNoException
EXEC pr_delete_question @question_no = 1
EXEC tSQLt.AssertEmptyTable @TableName = 'QUESTION'

END
GO