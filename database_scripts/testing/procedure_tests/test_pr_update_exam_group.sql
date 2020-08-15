USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'test_pr_update_exam_group'
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam_group.test_if_pr_update_correct_record
AS
BEGIN
    --Arrange
    DECLARE @old_exam_group_type VARCHAR(20) = 'old group id',
            @new_exam_group_type VARCHAR(20) = 'new group id'

    EXEC tSQLt.FakeTable 'EXAM_GROUP'

    INSERT INTO EXAM_GROUP
        (exam_group_type)
    VALUES
        (@old_exam_group_type)

    EXEC tSQLt.ExpectNoException

    CREATE TABLE expected
    (
        exam_group_type VARCHAR(20)
    )

    INSERT INTO expected
        (exam_group_type)
    VALUES
        (@new_exam_group_type)

    --Act
    EXEC pr_update_exam_group @old_exam_group_type, @new_exam_group_type

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'EXAM_GROUP'
END
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam_group.test_if_pr_insert_throws_group_id_old_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE	@old_exam_group_type VARCHAR(20) = NULL,
            @new_exam_group_type VARCHAR(20) = 'new group id'

    EXEC tSQLt.FakeTable 'EXAM_GROUP'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%old_exam_group_type cannot be NULL%'

    --Act
    EXEC pr_update_exam_group @old_exam_group_type, @new_exam_group_type

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_exam_group.test_if_pr_insert_throws_group_id_new_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @old_exam_group_type VARCHAR(20) = 'new group id',
            @new_exam_group_type VARCHAR(20) = NULL

    EXEC tSQLt.FakeTable 'EXAM_GROUP'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%new_exam_group_type cannot be NULL%'

    --Act
    EXEC pr_update_exam_group @old_exam_group_type, @new_exam_group_type
    
END
GO