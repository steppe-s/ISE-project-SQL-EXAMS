USE HAN_SQL_EXAM_DATABASE
GO
tSQLt.NewTestClass 'test_pr_delete_exam'
GO

CREATE OR ALTER PROC test_pr_delete_exam.[test if delete_exam throws exam_id cannot be null]
AS
BEGIN

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_delete_exam @exam_id = null

END
GO

CREATE OR ALTER PROC test_pr_delete_exam.[test if delete_exam throws exam may not be modified]
AS
BEGIN

	exec tSQLt.FakeTable @TableName = EXAM
	INSERT INTO EXAM VALUES('exam_id', 'course', 'exam_name', GETDATE(), NULL)
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%An exam may not be modified when it is taking place or has taken place already%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_delete_exam @exam_id = 'exam_id'

END
GO


CREATE OR ALTER PROC test_pr_delete_exam.[test if correct exam is deleted]
AS
BEGIN

DECLARE @starting_date DATETIME = DATEADD(year, 1, GetDate())

exec tSQLt.FakeTable @TableName = EXAM
INSERT INTO EXAM VALUES('exam_id1', 'course_id', 'exam_name', @starting_date, null)
INSERT INTO EXAM VALUES('exam_id2', 'course_id', 'exam_name', @starting_date, null)

CREATE TABLE EXPECTED(exam_id VARCHAR(20), course VARCHAR(20), exam_name VARCHAR(50), starting_date DATETIME, comment VARCHAR(MAX))
INSERT INTO EXPECTED VALUES('exam_id2', 'course_id', 'exam_name', @starting_date, null)

exec tSQLt.ExpectNoException
exec pr_delete_exam @exam_id = 'exam_id1'

exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = 'EXAM'

END