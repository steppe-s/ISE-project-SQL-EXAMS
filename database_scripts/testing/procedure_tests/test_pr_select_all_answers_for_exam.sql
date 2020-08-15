use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_select_all_answers_for_exam 
go

create or alter proc test_pr_select_all_answers_for_exam.[test if select_all_answers_for_exam throws exam_id cannot be null] 
as
begin
		exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
		exec pr_select_all_answers_for_exam @exam_id = NULL
end
go

create or alter proc test_pr_select_all_answers_for_exam.[test if select_all_answers_for_exam selects correct data] 
as
begin
		exec tSQLt.FakeTable @TableName = 'ANSWER'
		exec tSQLt.FakeTable @TableName = 'STUDENT'
		exec tSQLt.FakeTable @TableName = 'REASON'
		INSERT INTO ANSWER VALUES(1, 'exam_id', 1, 1, 'answer', NULL, NULL)
		INSERT INTO STUDENT VALUES(1, NULL, NULL, NULL, 0)
		INSERT INTO REASON VALUES(1, 'reason')

		exec tSQLt.ExpectNoException
		exec tSQLt.AssertResultSetsHaveSameMetaData @expectedCommand ='SELECT first_name + '' '' + last_name AS student
			,question_no
			,STUDENT.student_no
			,answer
            ,answer_status
			,reason_description
		FROM ANSWER
		INNER JOIN STUDENT
			ON ANSWER.student_no = STUDENT.student_no
		LEFT JOIN REASON
			ON ANSWER.reason_no = REASON.reason_no
		WHERE exam_id = ''exam_id''', @actualCommand = 'exec pr_select_all_answers_for_exam @exam_id = ''exam_id'''
end
go