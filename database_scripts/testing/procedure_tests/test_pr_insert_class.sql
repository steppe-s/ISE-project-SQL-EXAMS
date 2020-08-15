USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'pr_insert_class'
GO

CREATE OR ALTER PROCEDURE pr_insert_class.test_if_pr_inserts_correct_record
AS
BEGIN
    --Arrange
    DECLARE @class VARCHAR(20) = 'SUT class'

    EXEC tSQLt.FakeTable 'CLASS'
    EXEC tSQLt.ExpectNoException

    CREATE TABLE expected
    (
        class VARCHAR(20) NOT NULL
    )

    INSERT INTO expected
        (class)
    VALUES(@class)

    --Act
    EXEC pr_insert_class @class

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'CLASS'
END
GO

CREATE OR ALTER PROCEDURE pr_insert_class.test_if_pr_throws_when_group_id_is_null
AS
BEGIN
    --Arrange
    DECLARE @class VARCHAR(20) = NULL

    EXEC tSQLt.FakeTable 'CLASS'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%class cannot be NULL%'

    --Act
    EXEC pr_insert_class @class
END
GO