use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_select_correct_answers_from_question 
go

create or alter proc test_pr_select_correct_answers_from_question.[test if select_correct_answers_from_question throws question_no cannot be null] 
as
begin
	
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_select_correct_answers_from_question @question_no = NULL

end
go

create or alter proc test_pr_select_correct_answers_from_question.[test if select_correct_answers_from_question selects correct answers] 
as
begin
	EXEC tSQLt.FakeTable @TableName = 'CORRECT_ANSWER'
	INSERT INTO CORRECT_ANSWER VALUES(1, 1, 'correct_answer1')
	INSERT INTO CORRECT_ANSWER VALUES(1, 2, 'correct_answer2')
	INSERT INTO CORRECT_ANSWER VALUES(2, 1, 'correct_answer3')

	EXEC tSQLt.ExpectNoException
	EXEC tSQLt.AssertResultSetsHaveSameMetaData @expectedCommand = 'SELECT CORRECT_ANSWER.correct_answer_statement
		FROM CORRECT_ANSWER 
		WHERE CORRECT_ANSWER.question_no = 1', @ActualCommand =	'EXEC pr_select_correct_answers_from_question @question_no = 1'

end
go


