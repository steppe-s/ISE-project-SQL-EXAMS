use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_select_answers_for_exam_per_student
go

create or alter proc test_pr_select_answers_for_exam_per_student.[test if select_select_answers_for_exam throws exam_id cannot be null] 
as
begin
	
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_select_answers_for_exam_per_student @exam_id = NULL, @student_no = 1

end
go

create or alter proc test_pr_select_answers_for_exam_per_student.[test if select_select_answers_for_exam throws student_no cannot be null] 
as
begin
	
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_select_answers_for_exam_per_student @exam_id = 'exam_id', @student_no = NULL

end
go

create or alter proc test_pr_select_answers_for_exam_per_student.[test if select_select_answers_for_exam throws student is not signed up for exam] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'

	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%Student is not signed up for exam%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_select_answers_for_exam_per_student @exam_id = 'exam_id', @student_no = 1

end
go

create or alter proc test_pr_select_answers_for_exam_per_student.[test if select_answers_for_exam returns correct data] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'QUESTION'
	EXEC tSQLt.FakeTable @TableName = 'STUDENT'
	EXEC tSQLt.FakeTable @TableName = 'REASON'
	EXEC tSQLt.FakeTable @TableName = 'ANSWER'
	EXEC tSQLt.FakeTable @TableName = 'EXAM_FOR_STUDENT'


	INSERT INTO QUESTION(difficulty, exam_db_name, question_assignment, comment, status) VALUES(NULL, NULL, 'question_assignment', NULL, NULL)
	INSERT INTO STUDENT VALUES(1, NULL, NULL, NULL, 0)
	INSERT INTO REASON VALUES(1, 'reason')
	INSERT INTO ANSWER VALUES(1, 'exam_id', 1, 1, 'answer', null, null)
	INSERT INTO EXAM_FOR_STUDENT VALUES('exam_id', 1, NULL, NULL, NULL, NULL)



	EXEC tSQLt.ExpectNoException
	EXEC tSQLt.AssertResultSetsHaveSameMetaData @expectedCommand = 'SELECT QUESTION.question_assignment, ANSWER.answer ,REASON.reason_description
		FROM ANSWER
			INNER JOIN STUDENT
				ON ANSWER.student_no = STUDENT.student_no
			LEFT JOIN REASON
				ON ANSWER.reason_no = REASON.reason_no
			LEFT JOIN QUESTION
				ON ANSWER.question_no = QUESTION.question_no
		WHERE exam_id = ''exam_id'' AND STUDENT.student_no = 1', @actualCommand = 
'EXEC pr_select_answers_for_exam_per_student @exam_id = ''exam_id'', @student_no = 1'

end
go

