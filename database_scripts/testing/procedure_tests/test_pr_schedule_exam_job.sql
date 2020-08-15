USE HAN_SQL_EXAM_DATABASE
GO

EXECUTE tSQLt.NewTestClass 'test_pr_schedule_exam_job';
GO

CREATE OR ALTER PROC test_pr_schedule_exam_job.test_if_pr_throwsno_error
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = 'DEA1',
			@starting_date DATETIME = GETDATE() + 100;

    EXEC tSQLt.ExpectNoException 
    EXEC pr_schedule_exam_job @exam_id = @exam_id, @starting_date = @starting_date

END
GO

CREATE OR ALTER PROC test_pr_schedule_exam_job.test_if_pr_throws_error_exam_id_null
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = NULL,
			@starting_date DATETIME = GETDATE() + 100;

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
    EXEC pr_schedule_exam_job @exam_id = @exam_id, @starting_date = @starting_date

END
GO

CREATE OR ALTER PROC test_pr_schedule_exam_job.test_if_pr_throws_error_starting_date_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = 'DEA1',
			@starting_date DATETIME = NULL;

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%starting_date cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
    EXEC pr_schedule_exam_job @exam_id = @exam_id, @starting_date = @starting_date

END
GO

CREATE OR ALTER PROC test_pr_schedule_exam_job.test_if_pr_throws_error_schedule_date_cannot_be_in_the_past
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = 'DEA1',
			@starting_date DATETIME = GETDATE() - 100;

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%scheduled date cannot be in the past%', @ExpectedSeverity = 16, @ExpectedState = NULL;
    EXEC pr_schedule_exam_job @exam_id = @exam_id, @starting_date = @starting_date

END
GO
