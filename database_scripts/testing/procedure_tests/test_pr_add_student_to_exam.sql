use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_add_student_to_exam
go

create or alter proc test_pr_add_student_to_exam.[test if add_student_to_exam throws student_no cannot be null] 
as
begin

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_add_student_to_exam @student_no = NULL, @exam_id = 'exam_id'
end
go

create or alter proc test_pr_add_student_to_exam.[test if add_student_to_exam throws exam_id cannot be null] 
as
begin

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_add_student_to_exam @student_no = 1, @exam_id = NULL
end
go

create or alter proc test_pr_add_student_to_exam.[test if add_student_to_exam throws exam_group_type cannot be null] 
as
begin

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_group_type cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_add_student_to_exam @student_no = 1, @exam_id = 'exam_id'
end
go

create or alter proc test_pr_add_student_to_exam.[test if add_student_to_exam throws exam group has not been created yet for this exam] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM_GROUP_IN_EXAM'
	EXEC tSQLt.FakeTable @TableName = 'STUDENT'

	INSERT INTO STUDENT VALUES(1, 'class', 'first name', 'last name', 0)

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam group has not been created yet for this exam%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_add_student_to_exam @student_no = 1, @exam_id = 'exam_id'


end
go

create or alter proc test_pr_add_student_to_exam.[test if add_student_to_exam throws you cannot assign a student to an exam that has taken place already] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM_GROUP_IN_EXAM'
	EXEC tSQLt.FakeTable @TableName = 'EXAM'
	EXEC tSQLt.FakeTable @TableName = 'STUDENT'
	
	INSERT INTO STUDENT VALUES(1, 'class', 'first name', 'last name', 0)
	INSERT INTO EXAM_GROUP_IN_EXAM VALUES('exam_id', 'standaard', GETDATE()+120)
	INSERT INTO EXAM VALUES('exam_id', NULL, NULL, GETDATE()-120, NULL)

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%you cannot assign a student to an exam that has taken place already%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_add_student_to_exam @student_no = 1, @exam_id = 'exam_id'


end
go

create or alter proc test_pr_add_student_to_exam.[test if add_student_to_exam adds student to right exam] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM_GROUP_IN_EXAM'
	EXEC tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'
	EXEC tSQLt.FakeTable @TableName = 'EXAM'
	EXEC tSQLt.FakeTable @TableName = 'STUDENT'

	INSERT INTO EXAM_GROUP_IN_EXAM VALUES('exam_id', 'standaard', GETDATE()+120)
	INSERT INTO EXAM VALUES('exam_id', NULL, NULL, GETDATE()+100, NULL)
	INSERT INTO EXAM VALUES('exam_id2', NULL, NULL, GETDATE()+105, NULL)

	INSERT INTO STUDENT VALUES(1, 'class1', 'first name', 'last name', 0),(2, 'class2', 'first name', 'last name', 0)

	CREATE TABLE EXPECTED(exam_id VARCHAR(20), student_no INT, class VARCHAR(20), exam_group_type VARCHAR(20), hand_in_date DATETIME, result NUMERIC)
	INSERT INTO EXPECTED VALUES('exam_id', 1, 'class1', 'standaard', NULL, NULL)

	EXEC tSQLt.ExpectNoException
	EXEC pr_add_student_to_exam @student_no = 1, @exam_id = 'exam_id'

	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED', @Actual = 'EXAM_FOR_STUDENT'


end
go