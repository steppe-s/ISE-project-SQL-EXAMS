use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_update_exam_group_in_exam 
go

create or alter proc test_pr_update_exam_group_in_exam.[test if update_exam_group_in_exam throws exam_id cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_group_in_exam @exam_id = NULL, @exam_group_type = 'Standaard', @end_date = NULL
end
go

create or alter proc test_pr_update_exam_group_in_exam.[test if update_exam_group_in_exam throws exam_group_type cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_group_type cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_group_in_exam @exam_id = 'exam_id', @exam_group_type = NULL, @end_date = NULL
end
go

create or alter proc test_pr_update_exam_group_in_exam.[test if update_exam_group_in_exam throws end_date cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%end_date cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_group_in_exam @exam_id = 1, @exam_group_type = 'Standaard', @end_date = NULL
end
go

create or alter proc test_pr_update_exam_group_in_exam.[test if update_exam_group_in_exam throws end date may not be modified after exam has been taken] 
as
begin
	DECLARE @DATE DATETIME = GETDATE()

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam group has not been created yet for this exam%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_group_in_exam @exam_id = 1, @exam_group_type = 'Standaard', @end_date = @DATE
end
go

create or alter proc test_pr_update_exam_group_in_exam.[test if update_exam_group_in_exam throws exam group has not been created yet for this exam] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM'
	INSERT INTO EXAM VALUES('exam_id', 'course', 'exam_name', GETDATE(), NULL)
	DECLARE @DATE DATETIME = GETDATE()+120

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam group has not been created yet for this exam%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_group_in_exam @exam_id = 1, @exam_group_type = 'Standaard', @end_date = @DATE
end
go

create or alter proc test_pr_update_exam_group_in_exam.[test if update_exam_group_in_exam updates end_date] 
as
begin
	DECLARE @DATE DATETIME = GETDATE()
	DECLARE @DATE_MODIFIED DATETIME = GETDATE()+120

	EXEC tSQLt.FakeTable @TableName = 'EXAM_GROUP_IN_EXAM'

	EXEC tSQLt.ExpectNoException
	INSERT INTO EXAM_GROUP_IN_EXAM VALUES('exam_id', 'standaard', @DATE)

	CREATE TABLE EXPECTED(exam_id VARCHAR(20), exam_group_type VARCHAR(20), end_date DATETIME)
	INSERT INTO EXPECTED VALUES('exam_id', 'Standaard', @DATE_MODIFIED)

	EXEC pr_update_exam_group_in_exam @exam_id = 'exam_id', @exam_group_type = 'Standaard', @end_date = @DATE_MODIFIED
	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = 'EXAM_GROUP_IN_EXAM'
end
go