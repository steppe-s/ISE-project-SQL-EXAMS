USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'test_pr_set_pending_correct_answer_to_false'
GO

CREATE OR ALTER PROC test_pr_set_pending_correct_answer_to_false.[test if pr throws student_no cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_set_pending_correct_answer_to_false
		@student_no = null,
		@exam_id = 1,
		@question_no = 1

END
GO

CREATE OR ALTER PROC test_pr_set_pending_correct_answer_to_false.[test if pr throws exam_id cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_set_pending_correct_answer_to_false
		@student_no = 1,
		@exam_id = null,
		@question_no = 1

END
GO

CREATE OR ALTER PROC test_pr_set_pending_correct_answer_to_false.[test if pr throws question_no cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_set_pending_correct_answer_to_false
		@student_no = 1,
		@exam_id = 1,
		@question_no = null

END
GO

CREATE OR ALTER PROCEDURE test_pr_set_pending_correct_answer_to_false.test_if_pr_updates_answer_pending_to_false
AS
BEGIN
   
	EXEC tSQLt.FakeTable 'ANSWER'
    EXEC tSQLt.ExpectNoException

    create table expected (
		student_no			int				not null,
		exam_id				varchar(20)		not null,
		question_no			int				not null,
		reason_no			int				null,
		answer				varchar(max)	null,
		answer_status		varchar(50)		not null,
		answer_fill_in_date	datetime		not null
	)
    
	INSERT INTO expected (student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	VALUES  (1, 1, 2, NULL, 'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'CORRECT', '2019-04-13 11:31:21.873')
    
	INSERT INTO ANSWER(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	VALUES  (1, 1, 2, NULL, 'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'PENDING', '2019-04-13 11:31:21.873')
    --Act
    EXEC pr_set_pending_correct_answer_to_false
		@student_no = 1,
		@exam_id = 1,
		@question_no = 2

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'ANSWER'
END
GO