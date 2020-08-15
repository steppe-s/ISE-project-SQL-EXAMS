use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_select_results_for_student_answer 
go

create or alter proc test_pr_select_results_for_student_answer.[test if select_results_for_student_answer throws question_no cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be NULL%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_select_results_for_student_answer @question_no = NULL, @exam_id = 'exam_id', @student_no = 1
end
go

create or alter proc test_pr_select_results_for_student_answer.[test if select_results_for_student_answer throws exam_id cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be NULL%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_select_results_for_student_answer @question_no = 1, @exam_id = NULL, @student_no = 1
end
go

create or alter proc test_pr_select_results_for_student_answer.[test if select_results_for_student_answer throws student_no cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be NULL%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_select_results_for_student_answer @question_no = 1, @exam_id = 'exam_id', @student_no = NULL
end
go

create or alter proc test_pr_select_results_for_student_answer.[test if select_results_for_student_answer throws database required for question is not available] 
as
begin
	exec tSQLt.FakeTable 'QUESTION'
	exec tSQLt.FakeTable 'ANSWER'

	INSERT INTO QUESTION(difficulty, exam_db_name, question_assignment, comment, status) VALUES(NULL, 'HAN_SQL_EXAM_DATABASE', NULL, NULL, NULL)
	INSERT INTO ANSWER VALUES(1, 'exam_id', 1, NULL, 'A non-executable statement', NULL, NULL)
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Database required for question is not available%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_select_results_for_student_answer @question_no = 1, @exam_id = 'exam_id', @student_no = 1
end
go

create or alter proc test_pr_select_results_for_student_answer.[test if select_results_for_student_answer throws statement not executable] 
as
begin
	exec tSQLt.FakeTable 'QUESTION'
	exec tSQLt.FakeTable 'ANSWER'

	INSERT INTO QUESTION(question_no, difficulty, exam_db_name, question_assignment, comment, status) VALUES(1, NULL, 'HAN_SQL_EXAM_DATABASE', NULL, NULL, NULL)
	INSERT INTO ANSWER VALUES(1, 'exam_id', 1, NULL, 'A non-executable statement', NULL, NULL)
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement not executable%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_select_results_for_student_answer @question_no = 1, @exam_id = 'exam_id', @student_no = 1
end
go
