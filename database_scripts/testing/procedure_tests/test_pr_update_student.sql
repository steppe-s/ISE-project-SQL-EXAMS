USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'pr_update_student'
GO

CREATE OR ALTER PROCEDURE pr_update_student.test_if_pr_update_correct_record
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1,
			@class VARCHAR(20) = 'class',
            @first_name VARCHAR(30) = 'first name',
            @last_name  VARCHAR(50) = 'last name',
			@is_dyslexic bit = 1

    EXEC tSQLt.FakeTable 'STUDENT'

    INSERT INTO STUDENT
        (student_no, first_name, last_name, class, is_dyslexic)
    VALUES
        (@student_no, @first_name, @last_name, @class, @is_dyslexic)

    EXEC tSQLt.ExpectNoException

    CREATE TABLE expected
    (
        student_no INT,
		class VARCHAR(20),
        first_name VARCHAR(30),
        last_name VARCHAR(50),
		is_dyslexic bit 
    )

    INSERT INTO expected
        (student_no, class, first_name, last_name, is_dyslexic)
    VALUES
        (@student_no, @class, @first_name, @last_name, @is_dyslexic)

    --Act
    EXEC pr_update_student @student_no, @class, @first_name, @last_name, @is_dyslexic

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'STUDENT'
END
GO

CREATE OR ALTER PROCEDURE pr_update_student.test_if_pr_insert_throws_student_no_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = NULL,
            @class VARCHAR(20) = 'class',
            @first_name VARCHAR(30) = 'first name',
            @last_name  VARCHAR(50) = 'last name',
			@is_dyslexic bit = 1

    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be NULL%'

    --Act
    EXEC pr_update_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO

CREATE OR ALTER PROCEDURE pr_update_student.test_if_pr_insert_throws_class_id_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1,
            @class VARCHAR(20) = NULL,
            @first_name VARCHAR(30) = 'first name',
            @last_name  VARCHAR(50) = 'last name',
			@is_dyslexic bit = 1

    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%class_id cannot be NULL%'

    --Act
    EXEC pr_update_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO

CREATE OR ALTER PROCEDURE pr_update_student.test_if_pr_insert_throws_first_name_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1,
           @class VARCHAR(20) = 'class',
            @first_name VARCHAR(30) = NULL,
            @last_name  VARCHAR(50) = 'last name',
			@is_dyslexic bit = 1

    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%first_name cannot be NULL%'

    --Act
    EXEC pr_update_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO

CREATE OR ALTER PROCEDURE pr_update_student.test_if_pr_insert_throws_last_name_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1,
            @class VARCHAR(20) = 'class',
            @first_name VARCHAR(30) = 'first name',
            @last_name  VARCHAR(50) = NULL,
			@is_dyslexic bit = 1

    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%last_name cannot be NULL%'

    --Act
    EXEC pr_update_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO

CREATE OR ALTER PROCEDURE pr_update_student.test_if_pr_insert_throws_is_dyslexic_cannot_be_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1,
            @class VARCHAR(20) = 'class',
            @first_name VARCHAR(30) = 'first name',
            @last_name  VARCHAR(50) = 'last name',
			@is_dyslexic bit = null

    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%is_dyslexic cannot be NULL%'

    --Act
    EXEC pr_update_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO
