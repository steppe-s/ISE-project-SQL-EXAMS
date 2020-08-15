USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'test_pr_update_class'
GO

CREATE OR ALTER PROCEDURE test_pr_update_class.test_if_pr_update_correct_record
AS
BEGIN
    --Arrange
    DECLARE @class_name_old VARCHAR(20) = 'old class name',
            @class_name_new VARCHAR(20) = 'new class name'

    EXEC tSQLt.FakeTable 'CLASS'

    INSERT INTO CLASS
        (class)
    VALUES
        (@class_name_old)

    EXEC tSQLt.ExpectNoException

    CREATE TABLE expected
    (
        class VARCHAR(20)
    )

    INSERT INTO expected
        (class)
    VALUES
        (@class_name_new)

    --Act
    EXEC pr_update_class @class_name_new, @class_name_old

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'CLASS'
END
GO

CREATE OR ALTER PROCEDURE test_pr_update_class.test_if_pr_insert_throws_class_id_old_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @class_name_old VARCHAR(20) = NULL,
            @class_name_new VARCHAR(20) = 'new class name'

    EXEC tSQLt.FakeTable 'CLASS'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%class_name_old cannot be NULL%'

    --Act
    EXEC pr_update_class @class_name_new, @class_name_old

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_class.test_if_pr_insert_throws_class_name_new_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @class_name_old VARCHAR(20) = 'new class name',
            @class_name_new VARCHAR(20) = NULL

    EXEC tSQLt.FakeTable 'CLASS'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%class_name_new cannot be NULL%'

    --Act
    EXEC pr_update_class @class_name_new, @class_name_old
    
END
GO