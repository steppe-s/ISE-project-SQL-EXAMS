use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass 'test_tr_set_question_to_pending'
go

create or alter proc test_tr_set_question_to_pending.test_if_trigger_correctly_sets_queue
as
begin
	exec tSQLt.FakeTable 'ANSWER'

	exec tSQLt.ApplyTrigger 'ANSWER', 'tr_set_question_to_pending'

	
	create table dbo.expected (
		student_no			int				not null,
		exam_id				varchar(20)		not null,
		question_no			int				not null,
		reason_no			int				null,
		answer				varchar(max)	null,
		answer_status		varchar(50)		not null,
		answer_fill_in_date	datetime		not null
	)

	insert into expected(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	values (1, 1, 2, null,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'PENDING', '2019-04-13 11:46:42.382')

	exec tSQLt.ExpectNoException

	insert into ANSWER(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	values (1, 1, 2, null,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'CORRECT', '2019-04-13 11:46:42.382')

	exec tSQLt.AssertEqualsTable 'expected', 'ANSWER'
end
go

create or alter proc test_tr_set_question_to_pending.test_if_trigger_correctly_sets_queue_with_multiple_inserts
as
begin
	exec tSQLt.FakeTable 'ANSWER'

	exec tSQLt.ApplyTrigger 'ANSWER', 'tr_set_question_to_pending'

	
	create table dbo.expected (
		student_no			int				not null,
		exam_id				varchar(20)		not null,
		question_no			int				not null,
		reason_no			int				null,
		answer				varchar(max)	null,
		answer_status		varchar(50)		not null,
		answer_fill_in_date	datetime		not null
	)

	insert into expected(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	values (1, 1, 2, null,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'PENDING', '2019-04-13 11:46:42.382'),
	(2, 2, 3, 50002,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'INCORRECT', '2019-04-13 11:46:42.382')

	exec tSQLt.ExpectNoException

	insert into ANSWER(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	values (1, 1, 2, null,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'CORRECT', '2019-04-13 11:46:42.382'),
	(2, 2, 3, 50002,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'INCORRECT', '2019-04-13 11:46:42.382')

	exec tSQLt.AssertEqualsTable 'expected', 'ANSWER'
end
go

create or alter proc test_tr_set_question_to_pending.test_if_trigger_correctly_does_not_set_for_false_questions
as
begin
	exec tSQLt.FakeTable 'ANSWER'

	exec tSQLt.ApplyTrigger 'ANSWER', 'tr_set_question_to_pending'

	
	create table dbo.expected (
		student_no			int				not null,
		exam_id				varchar(20)		not null,
		question_no			int				not null,
		reason_no			int				null,
		answer				varchar(max)	null,
		answer_status		varchar(50)		not null,
		answer_fill_in_date	datetime		not null
	)

	insert into expected(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	values 	(2, 2, 3, 50002,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'INCORRECT', '2019-04-13 11:46:42.382')

	exec tSQLt.ExpectNoException

	insert into ANSWER(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	VALUES (2, 2, 3, 50002,'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'INCORRECT', '2019-04-13 11:46:42.382')

	exec tSQLt.AssertEqualsTable 'expected', 'ANSWER'
end
go
