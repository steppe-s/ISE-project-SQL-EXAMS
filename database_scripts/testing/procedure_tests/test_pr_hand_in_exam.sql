use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_hand_in_exam 
go

create or alter proc test_pr_hand_in_exam.[test if hand_in_exam throws student_no cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_hand_in_exam @student_no = null, @exam_id = 'exam_id'

end
go

create or alter proc test_pr_hand_in_exam.[test if hand_in_exam throws exam_id cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_hand_in_exam @student_no = 1, @exam_id = null

end
go

create or alter proc test_pr_hand_in_exam.[test if hand_in_exam throws student not signed up for exam] 
as
begin
	exec tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Student is not signed up for exam%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_hand_in_exam @student_no = 1, @exam_id = 'exam_id'

end
go

create or alter proc test_pr_hand_in_exam.[test if hand_in_exam creates empty answers for student] 
as
begin
	exec tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'
	exec tSQLt.FakeTable @TableName = 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable @TableName = 'ANSWER'
	INSERT INTO EXAM_FOR_STUDENT VALUES('exam_id', 1, 'class_id', 'group_id', null, null)
	INSERT INTO QUESTION_IN_EXAM VALUES('exam_id', 1, 5)
	INSERT INTO QUESTION_IN_EXAM VALUES('exam_id', 2, 5)
	INSERT INTO ANSWER VALUES(1, 'exam_id', 1, null, 'answer', 'PENDING', null)


	exec tSQLt.ExpectNoException
	exec pr_hand_in_exam @student_no = 1, @exam_id = 'exam_id'

	
	CREATE TABLE EXPECTED(student_no INT, exam_id VARCHAR(20), question_no INT, reason_no INT, answer VARCHAR(MAX), answer_status VARCHAR(20), answer_fill_in_date DATETIME)
	INSERT INTO EXPECTED VALUES(1, 'exam_id', 1, null, 'answer', 'PENDING', null), (1, 'exam_id', 2, 60110, null, 'INCORRECT', (SELECT answer_fill_in_date FROM ANSWER WHERE question_no = 2))

	exec tSQLt.AssertEqualsTable 'EXPECTED', 'ANSWER'
end
go

create or alter proc test_pr_hand_in_exam.[test if hand_in_exam updates hand_in_date in exam_for_student] 
as
begin
	exec tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'
	exec tSQLt.FakeTable @TableName = 'QUESTION_IN_EXAM'
	exec tSQLt.FakeTable @TableName = 'ANSWER'
	INSERT INTO EXAM_FOR_STUDENT VALUES('exam_id', 1, 'class', 'group', null, null), ('exam_id2', 1, 'class', 'group', NULL, NULL)
	INSERT INTO QUESTION_IN_EXAM VALUES('exam_id', 1, 5)
	INSERT INTO QUESTION_IN_EXAM VALUES('exam_id', 2, 5)
	INSERT INTO ANSWER VALUES(1, 'exam_id', 1, null, 'answer', 'PENDING', null)


	exec tSQLt.ExpectNoException
	exec pr_hand_in_exam @student_no = 1, @exam_id = 'exam_id'

	IF((SELECT hand_in_date FROM EXAM_FOR_STUDENT WHERE exam_id = 'exam_id' AND student_no = 1) IS NULL)
	exec tSQLt.Fail @Message0 = 'The hand_in_date column was not changed'

	CREATE TABLE EXPECTED(exam_id VARCHAR(20), student_no INT, class VARCHAR(20), exam_group_type VARCHAR(20), hand_in_date DATETIME, result NUMERIC(4, 2))
	INSERT INTO EXPECTED VALUES('exam_id', 1, 'class', 'group', (SELECT hand_in_date FROM EXAM_FOR_STUDENT WHERE exam_id = 'exam_id' AND student_no = 1), NULL), ('exam_id2', 1, 'class', 'group', NULL, NULL)

	exec tSQLt.AssertEqualsTable 'EXPECTED', 'EXAM_FOR_STUDENT'
end
go