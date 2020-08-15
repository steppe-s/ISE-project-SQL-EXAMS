-- Fill every XXX
use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_update_exam_for_student 
go


create or alter proc test_pr_update_exam_for_student.[test if update_exam_for_student throws exam_id cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_for_student @exam_id = NULL, @student_no = 1, @class = 'class', @exam_group_type = 'exam_group_type', @result = 1
end
go

create or alter proc test_pr_update_exam_for_student.[test if update_exam_for_student throws student_no cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_for_student @exam_id = 1, @student_no = NULL, @class = 'class', @exam_group_type = 'exam_group_type', @result = 1
end
go

create or alter proc test_pr_update_exam_for_student.[test if update_exam_for_student throws class cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%class cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_for_student @exam_id = 1, @student_no = 1, @class = NULL, @exam_group_type = 'exam_group_type', @result = 1
end
go

create or alter proc test_pr_update_exam_for_student.[test if update_exam_for_student throws exam_group_type cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_group_type cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_for_student @exam_id = 1, @student_no = 1, @class = 'class', @exam_group_type = NULL, @result = 1
end
go

create or alter proc test_pr_update_exam_for_student.[test if update_exam_for_student throws Student is not signed up for exam] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%Student is not signed up for exam%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_for_student @exam_id = 1, @student_no = 1, @class = 'class', @exam_group_type = 'exam_group_type', @result = NULL
end
go


create or alter proc test_pr_update_exam_for_student.[test if update_exam_for_student throws result cannot be null] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'
	INSERT INTO EXAM_FOR_STUDENT VALUES(1, 1,'class', 'exam_group_type', GETDATE(), 1)

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%result cannot be NULL after an exam has been checked%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_update_exam_for_student @exam_id = 1, @student_no = 1, @class = 'class', @exam_group_type = 'exam_group_type', @result = NULL
end
go


create or alter proc test_pr_update_exam_for_student.[test if update_exam_for_student updates exam_for_student] 
as
begin
	DECLARE @hand_in_date DATETIME = GETDATE()
	EXEC tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'
	INSERT INTO EXAM_FOR_STUDENT VALUES(1, 1,'class1', 'exam_group_type1', @hand_in_date, 1)

	CREATE TABLE EXPECTED(exam_id VARCHAR(20), student_no INT, class VARCHAR(20), exam_group_type VARCHAR(20), hand_in_date DATETIME, result NUMERIC(4,2))
	INSERT INTO EXPECTED VALUES(1, 1, 'class2', 'exam_group_type2', @hand_in_date, 2)

	EXEC tSQLt.ExpectNoException
	EXEC pr_update_exam_for_student @exam_id = 1, @student_no = 1, @class = 'class2', @exam_group_type = 'exam_group_type2', @result = 2

	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = 'EXAM_FOR_STUDENT'
end
go
