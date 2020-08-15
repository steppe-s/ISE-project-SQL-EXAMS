use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass 'test_pr_select_pending_correct_answers_for_exam'
go

create or alter proc test_pr_select_pending_correct_answers_for_exam.test_if_pr_throw_when_exam_id_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%'
	exec pr_select_pending_correct_answers_for_exam @exam_id = null
end
go

create or alter proc test_pr_select_pending_correct_answers_for_exam.test_if_pr_does_not_throw_whith_known_exam_id
as
begin

	exec tSQLt.FakeTable 'ANSWER'
	exec tSQLt.ExpectNoException 

	insert into ANSWER(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	values (1, 1, 2, null,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'REQUIRE_CHECK', '2019-04-13 11:46:42.382')

	exec pr_select_pending_correct_answers_for_exam @exam_id = 1
end
go