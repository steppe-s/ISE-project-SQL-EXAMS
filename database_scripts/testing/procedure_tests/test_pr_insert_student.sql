USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'test_pr_insert_student'
GO

CREATE OR ALTER PROCEDURE test_pr_insert_student.test_if_pr_inserts_correct_record
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1
	DECLARE @class VARCHAR(20) = 'class'
	DECLARE @first_name VARCHAR(30) = 'first name'
	DECLARE @last_name VARCHAR(50) = 'last name'
	DECLARE @is_dyslexic bit = 1

    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectNoException

    CREATE TABLE expected (
		student_no  INT		    	NOT NULL,
		class		VARCHAR(20)		NOT NULL,
		first_name	VARCHAR(30)		NOT NULL,
		last_name   VARCHAR(50)		NOT NULL,
		is_dyslexic bit				not null
	)
    
	INSERT INTO expected (student_no, class, first_name, last_name, is_dyslexic)
	VALUES  (@student_no, @class, @first_name, @last_name, @is_dyslexic)
    
    --Act
    EXEC pr_insert_student @student_no, @class, @first_name, @last_name, @is_dyslexic

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'STUDENT'
END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_student.test_if_pr_throws_when_student_no_is_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = NULL
	DECLARE @class VARCHAR(20) = 'class'
	DECLARE @first_name VARCHAR(30) = 'first name'
	DECLARE @last_name VARCHAR(50) = 'last name'
		DECLARE @is_dyslexic bit = 1


    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be NULL%'
    
    --Act
    EXEC pr_insert_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_student.test_if_pr_throws_when_class_is_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1
	DECLARE @class VARCHAR(20) = NULL
	DECLARE @first_name VARCHAR(30) = 'first name'
	DECLARE @last_name VARCHAR(50) = 'last name'
		DECLARE @is_dyslexic bit = 1


    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%class cannot be NULL%'
    
    --Act
    EXEC pr_insert_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_student.test_if_pr_throws_when_first_name_is_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1
	DECLARE @class VARCHAR(20) = 'class'
	DECLARE @first_name VARCHAR(30) = NULL
	DECLARE @last_name VARCHAR(50) = 'last name'
	DECLARE @is_dyslexic bit = 1


    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%first_name cannot be NULL%'
    
    --Act
    EXEC pr_insert_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_student.test_if_pr_throws_when_first_name_is_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1
	DECLARE @class VARCHAR(20) = 'class'
	DECLARE @first_name VARCHAR(30) = 'first name'
	DECLARE @last_name VARCHAR(50) = NULL
	DECLARE @is_dyslexic bit = 1


    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%last_name cannot be NULL%'
    
    --Act
    EXEC pr_insert_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO

CREATE OR ALTER PROCEDURE test_pr_insert_student.test_if_pr_throws_when_is_dyslexic_is_null
AS
BEGIN
    --Arrange
    DECLARE @student_no INT = 1
	DECLARE @class VARCHAR(20) = 'class'
	DECLARE @first_name VARCHAR(30) = 'first name'
	DECLARE @last_name VARCHAR(50) = 'last_name'
	DECLARE @is_dyslexic bit = null

    EXEC tSQLt.FakeTable 'STUDENT'
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%is_dyslexic cannot be null%'
    
    --Act
    EXEC pr_insert_student @student_no, @class, @first_name, @last_name, @is_dyslexic
END
GO
