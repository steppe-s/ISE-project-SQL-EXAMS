USE HAN_SQL_EXAM_DATABASE
GO

tSQLt.NewTestClass 'test_pr_set_pending_correct_answer_to_true'
GO

CREATE OR ALTER PROC test_pr_set_pending_correct_answer_to_true.[test if pr throws student_no cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%student_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_set_pending_correct_answer_to_true
		@student_no = null,
		@exam_id = 1,
		@question_no = 1

END
GO

CREATE OR ALTER PROC test_pr_set_pending_correct_answer_to_true.[test if pr throws exam_id cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_set_pending_correct_answer_to_true
		@student_no = 1,
		@exam_id = null,
		@question_no = 1

END
GO

CREATE OR ALTER PROC test_pr_set_pending_correct_answer_to_true.[test if pr throws question_no cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_set_pending_correct_answer_to_true
		@student_no = 1,
		@exam_id = 1,
		@question_no = null

END
GO

CREATE OR ALTER PROCEDURE test_pr_set_pending_correct_answer_to_true.test_if_pr_inserts_to_CORRECT_ANSWER
AS
BEGIN
   
	EXEC tSQLt.FakeTable 'CORRECT_ANSWER'
	EXEC tSQLt.FakeTable 'ANSWER'
    EXEC tSQLt.ExpectNoException

    CREATE TABLE expected (
		question_no					INT		    NOT NULL,
		correct_answer_id			VARCHAR(30)		NOT NULL,
		correct_answer_statement	VARCHAR(50)		NOT NULL
	)
    
	INSERT INTO expected (question_no, correct_answer_id, correct_answer_statement)
	VALUES  (1, 1, 'SELECT * FROM stuk')

	INSERT INTO ANSWER(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	VALUES  (1, 1, 1, 60103, 'SELECT * FROM Stuk', 'PENDING', '2019-04-13 11:31:21.873')
    
    --Act
    EXEC pr_set_pending_correct_answer_to_true
		@student_no = 1,
		@exam_id = 1,
		@question_no = 1

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'CORRECT_ANSWER'
END
GO

CREATE OR ALTER PROCEDURE test_pr_set_pending_correct_answer_to_true.test_if_pr_updates_answer_pending_to_MOVED_TO_CORRECT_ANSWER
AS
BEGIN
   
	EXEC tSQLt.FakeTable 'ANSWER'
	EXEC tSQLt.FakeTable 'QUESTION'
	EXEC tSQLt.FakeTable 'CORRECT_ANSWER'


	INSERT INTO QUESTION(question_no, difficulty, exam_db_name, question_assignment, comment, status) VALUES(1, null, null, null, null, null)
	

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
	VALUES  (1, 1, 1, 60103, 'SELECT * FROM Stuk', 'MOVED_TO_CORRECT_ANSWER', '2019-04-13 11:31:21.873')

	INSERT INTO ANSWER(student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
	VALUES  (1, 1, (SELECT question_no FROM QUESTION), 60103, 'SELECT * FROM Stuk', 'PENDING', '2019-04-13 11:31:21.873')
    
    --Act
    EXEC pr_set_pending_correct_answer_to_true
		@student_no = 1,
		@exam_id = 1,
		@question_no = 1

    --Assert
    EXEC tSQLt.AssertEqualsTable 'expected', 'ANSWER'
END
GO