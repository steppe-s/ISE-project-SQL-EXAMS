use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_remove_student_from_exam
go

create or alter proc test_pr_remove_student_from_exam.[test if remove_student_from_exam throws student_no cannot be null] 
as
begin
	
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_remove_student_from_exam @student_no = NULL, @exam_id = 'exam_id'
end
go

create or alter proc test_pr_remove_student_from_exam.[test if remove_student_from_exam throws exam_id cannot be null] 
as
begin
	
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_remove_student_from_exam @student_no = 1, @exam_id = NULL
end
go

create or alter proc test_pr_remove_student_from_exam.[test if remove_student_from_exam throws you cannot remove a student from an exam that has taken place already] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM'
	INSERT INTO EXAM VALUES('exam_id', NULL, NULL, GETDATE()-120, NULL)

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%you cannot remove a student from an exam that has taken place already%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_remove_student_from_exam @student_no = 1, @exam_id = 'exam_id'
end
go


create or alter proc test_pr_remove_student_from_exam.[test if remove_student_from_exam removes student from exam] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM'
	EXEC tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'
	INSERT INTO EXAM VALUES('exam_id', NULL, NULL, GETDATE()+120, NULL)
	INSERT INTO EXAM_FOR_STUDENT VALUES('exam_id', 1, NULL, NULL, NULL, NULL)

	EXEC tSQLt.ExpectNoException
	EXEC pr_remove_student_from_exam @student_no = 1, @exam_id = 'exam_id'

	EXEC tSQLt.AssertEmptyTable @TableName = 'EXAM_FOR_STUDENT'
end
go