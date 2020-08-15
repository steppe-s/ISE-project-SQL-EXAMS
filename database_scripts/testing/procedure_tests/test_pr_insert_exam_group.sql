USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'test_pr_insert_exam_group'
GO

CREATE OR ALTER PROCEDURE test_pr_insert_exam_group.test_if_pr_inserts_correct_record
AS
BEGIN
    --Arrange
    DECLARE @exam_group_type VARCHAR(20) = 'exam_group_type'

    EXEC tSQLt.FakeTable 'EXAM_GROUP'
    EXEC tSQLt.ExpectNoException

    CREATE TABLE expected
    (
        exam_group_type VARCHAR(20) NOT NULL
    )

    INSERT INTO expected(exam_group_type)
    VALUES(@exam_group_type)

    --Act
    EXEC pr_insert_exam_group @exam_group_type

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'EXAM_GROUP'
END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_exam_group.test_if_pr_throws_when_group_id_is_null
AS
BEGIN
    --Arrange
        DECLARE @exam_group_type VARCHAR(20) = NULL


    EXEC tSQLt.FakeTable 'EXAM_GROUP'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_group_type cannot be NULL%'

    --Act
    EXEC pr_insert_exam_group @exam_group_type
END
GO