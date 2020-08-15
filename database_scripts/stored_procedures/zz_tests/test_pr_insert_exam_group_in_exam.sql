USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'test_pr_insert_exam_group_in_exam'
GO

CREATE OR ALTER PROCEDURE test_pr_insert_exam_group_in_exam.test_if_pr_inserts_correct_record
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = 'exam_id',
    @exam_group_type VARCHAR(20) = 'exam_group_type',
    @end_date DATE = '2021-04-13 14:00:00.000'

    EXEC tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
    EXEC tSQLt.ExpectNoException

    CREATE TABLE expected
    (
        exam_id VARCHAR(20) NOT NULL,
        exam_group_type VARCHAR(20) NOT NULL,
        end_date DATE NOT NULL
    )

    INSERT INTO expected(exam_id, exam_group_type, end_date)
    VALUES(@exam_id, @exam_group_type, @end_date)

    --Act
    EXEC pr_insert_exam_group_in_exam @exam_id, @exam_group_type, @end_date

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'EXAM_GROUP_IN_EXAM'
END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_exam_group_in_exam.test_if_pr_throws_when_exam_id_is_null
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = NULL,
    @exam_group_type VARCHAR(20) = 'exam_group_type',
    @end_date DATE = '2019-04-13 14:00:00.000'

    EXEC tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be NULL%'

    --Act
   EXEC pr_insert_exam_group_in_exam @exam_id, @exam_group_type, @end_date
   END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_exam_group_in_exam.test_if_pr_throws_when_exam_group_type_is_null
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = 'exam_id',
    @exam_group_type VARCHAR(20) = NULL,
    @end_date DATE = '2019-04-13 14:00:00.000'

    EXEC tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_group_type cannot be NULL%'

    --Act
   EXEC pr_insert_exam_group_in_exam @exam_id, @exam_group_type, @end_date
   END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_exam_group_in_exam.test_if_pr_throws_when_end_date_is_null
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = 'exam_id',
    @exam_group_type VARCHAR(20) = 'exam_group_type',
    @end_date DATE = NULL

    EXEC tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%end_date cannot be NULL%'

    --Act
   EXEC pr_insert_exam_group_in_exam @exam_id, @exam_group_type, @end_date
   END
GO

CREATE OR ALTER PROC test_pr_insert_exam_group_in_exam.test_if_pr_throws_when_trying_to_insert_after_end_date
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = 'exam_id',
    @exam_group_type VARCHAR(20) = 'exam_group_type',
    @end_date DATE = GETDATE()-100

    EXEC tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%An exam_group cannot be submitted after the end_date of an exam%'

    --Act
   EXEC pr_insert_exam_group_in_exam @exam_id, @exam_group_type, @end_date

   END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_exam_group_in_exam.test_if_pr_throws_error_start_date_passed
AS
BEGIN
    --Arrange
    DECLARE @exam_id VARCHAR(20) = 'exam_id',
    @exam_group_type VARCHAR(20) = 'exam_group_type',
    @end_date DATE = GETDATE() + 300,
	@starting_date DATE = GETDATE()-100

    EXEC tSQLt.FakeTable 'EXAM_GROUP_IN_EXAM'
	EXEC tSQLt.FakeTable 'EXAM'
	INSERT INTO EXAM values (@exam_id, 'sut', 'sut', @starting_date, 'sut') 

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%starting_date cannot be NULL or before the current date%'

    --Act
   EXEC pr_insert_exam_group_in_exam @exam_id, @exam_group_type, @end_date

END
GO

EXECUTE tSQLt.Run 'test_pr_insert_exam_group_in_exam'