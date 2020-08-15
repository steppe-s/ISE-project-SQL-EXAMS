USE HAN_SQL_EXAM_DATABASE
GO
tSQLt.NewTestClass 'test_pr_update_exam'
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam.[test if update_exam throws exam_id cannot be null]
AS
BEGIN
DECLARE @DATE DATETIME = GETDATE();
exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_exam @exam_id = null, @course = 'course', @exam_name = 'exam_name', @starting_date = @DATE, @comment = null

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam.[test if update_exam throws course_id cannot be null]
AS
BEGIN
DECLARE @DATE DATETIME = GETDATE();

exec tSQLt.ExpectException @ExpectedMessagePattern = '%course_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_exam @exam_id = 'exam_id', @course = null, @exam_name = 'exam_name', @starting_date = @DATE, @comment = null

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam.[test if update_exam throws exam_name cannot be null]
AS
BEGIN
DECLARE @DATE DATETIME = GETDATE();
exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_exam @exam_id = 'exam_id', @course = 'course', @exam_name = null, @starting_date = @DATE, @comment = null

END
GO


CREATE OR ALTER PROCEDURE test_pr_update_exam.[test if update_exam throws starting_date cannot be null or lower than date]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%starting_date cannot be NULL or before the current date%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_exam @exam_id = 'exam_id', @course = 'course', @exam_name = 'exam_name', @starting_date = null, @comment = NULL;

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam.[test if update_exam throws exam may not be modified]
AS
BEGIN
DECLARE @DATE DATETIME = GETDATE();
DECLARE @NEW_DATE DATETIME = GETDATE()+1;


exec tSQLt.FakeTable @TableName = EXAM_GROUP_IN_EXAM
exec tSQLt.FakeTable @TableName = EXAM
INSERT INTO EXAM VALUES('exam_id', 'course', 'exam_name', @DATE, null)
INSERT INTO EXAM_GROUP_IN_EXAM VALUES('exam_id', 'exam_group_id', GETDATE())

exec tSQLt.ExpectException @ExpectedMessagePattern = '%An exam may not be modified when it is taking place or has taken place already%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_exam @exam_id = 'exam_id', @course = 'course2', @exam_name = 'exam_name2', @starting_date = @NEW_DATE, @comment = null

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam.[test if update_exam updates comment after exam has been taken]
AS
BEGIN
DECLARE @DATE DATETIME = GETDATE()+1;
DECLARE @NEW_DATE DATETIME = GETDATE()+2;


exec tSQLt.FakeTable @TableName = EXAM_GROUP_IN_EXAM
exec tSQLt.FakeTable @TableName = EXAM
INSERT INTO EXAM VALUES('exam_id', 'course_id', 'exam_name', @DATE, null)
INSERT INTO EXAM_GROUP_IN_EXAM VALUES('exam_id', 'exam_group_id', GETDATE())

exec tSQLt.ExpectNoException
exec pr_update_exam @exam_id = 'exam_id', @course = 'course', @exam_name = 'exam_name', @starting_date = @NEW_DATE, @comment = 'comment'

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam.[test if update_exam updates exam]
AS
BEGIN
DECLARE @DATE DATETIME = GETDATE()+1;
DECLARE @NEW_DATE DATETIME = GETDATE()+2;


exec tSQLt.FakeTable @TableName = EXAM
INSERT INTO EXAM VALUES('exam_id', 'course', 'exam_name', @DATE, null)

CREATE TABLE expected (exam_id VARCHAR(20), course VARCHAR(20), exam_name VARCHAR(50), starting_date DATETIME, comment VARCHAR(MAX))
    INSERT INTO expected (exam_id, course, exam_name, starting_date, comment) VALUES ('exam_id', 'course2', 'exam_name2', @NEW_DATE, 'comment') 

exec tSQLt.ExpectNoException
exec pr_update_exam @exam_id = 'exam_id', @course = 'course2', @exam_name = 'exam_name2', @starting_date = @NEW_DATE, @comment = 'comment'

exec tSQLt.AssertEqualsTable @Expected = 'expected', @actual = 'EXAM'

END
GO