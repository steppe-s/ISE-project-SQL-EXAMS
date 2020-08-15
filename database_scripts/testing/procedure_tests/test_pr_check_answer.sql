use HAN_SQL_EXAM_DATABASE
go

tSQLt.NewTestClass 'test_pr_check_answer'
go

create or alter proc test_pr_check_answer.test_if_pr_check_answer_no_database
as
begin
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%Database required for question is not available%', @ExpectedSeverity = 16, @ExpectedState = NULL;
    exec pr_check_answer 1, ' ', 1
END
GO

create or alter proc test_pr_check_answer.test_if_pr_check_answer_string_compare
as
begin
    exec tSQLt.FakeTable 'QUESTION'
    exec tSQLt.FakeTable 'ANSWER'
    exec tSQLt.FakeTable 'CORRECT_ANSWER'

    INSERT INTO QUESTION (question_no, exam_db_name) VALUES (1, 'HAN_SQL_EXAM_DATABASE')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (1, 'DB-1', 3, 'SELECT * FROM table')
    INSERT INTO CORRECT_ANSWER (question_no, correct_answer_statement) VALUES (1, 'SELECT * FROM table')
    
    exec tSQLt.ExpectNoException


    exec pr_check_answer 1, 'DB-1', 3

    DECLARE @actual VARCHAR(20) 
    SELECT @actual = answer_status FROM ANSWER WHERE question_no = 1
    exec tSQLt.AssertEquals 'PENDING', @actual
END
GO

create or alter proc test_pr_check_answer.test_if_pr_check_answer_different_solution
as
begin
    exec tSQLt.FakeTable 'QUESTION'
    exec tSQLt.FakeTable 'ANSWER'
    exec tSQLt.FakeTable 'CORRECT_ANSWER'

    INSERT INTO QUESTION (question_no, exam_db_name) VALUES (1, 'HAN_SQL_EXAM_DATABASE')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (1, 'DB-1', 3, 'SELECT student_no, exam_id, question_no, reason_no, answer, answer_rating, answer_fill_in_date FROM answer')
    INSERT INTO CORRECT_ANSWER (question_no, correct_answer_statement) VALUES (1, 'SELECT * FROM answer')
    
    exec tSQLt.ExpectNoException

    exec pr_check_answer 1, 'DB-1', 3

    DECLARE @actual VARCHAR(20) 
    SELECT @actual = answer_status FROM ANSWER WHERE question_no = 1
    exec tSQLt.AssertEquals 'INCORRECT', @actual
END
GO

create or alter proc test_pr_check_answer.test_if_pr_check_answer_syntax_incorrect
as
begin
    exec tSQLt.FakeTable 'QUESTION'
    exec tSQLt.FakeTable 'ANSWER'
    exec tSQLt.FakeTable 'CORRECT_ANSWER'

    INSERT INTO QUESTION (question_no, exam_db_name) VALUES (1, 'HAN_SQL_EXAM_DATABASE')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (1, 'DB-1', 3, 'SELLECT student_no, exam_id, question_no, reason_no, answer, answer_rating, answer_fill_in_date FROM answer')

    INSERT INTO CORRECT_ANSWER (question_no, correct_answer_statement) VALUES (1, 'SELECT * FROM answer WHERE question_no = 1')
    
    exec tSQLt.ExpectNoException


    exec pr_check_answer 1, 'DB-1', 3

    DECLARE @actual VARCHAR(20) 
    SELECT @actual = answer_status FROM ANSWER WHERE question_no = 1
    exec tSQLt.AssertEquals 'INCORRECT', @actual
END
GO

create or alter proc test_pr_check_answer.test_if_pr_check_answer_incorrect_rows
as
begin
    exec tSQLt.FakeTable 'QUESTION'
    exec tSQLt.FakeTable 'ANSWER'
    exec tSQLt.FakeTable 'CORRECT_ANSWER'

    INSERT INTO QUESTION (question_no, exam_db_name) VALUES (1, 'HAN_SQL_EXAM_DATABASE')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (1, 'DB-1', 3, 'SELECT * FROM answer')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (2, 'DB-2', 4, 'SELECT * FROM answer')

    INSERT INTO CORRECT_ANSWER (question_no, correct_answer_statement) VALUES (1, 'SELECT * FROM answer WHERE question_no = 1')
    
    exec tSQLt.ExpectNoException

    exec pr_check_answer 1, 'DB-1', 3

    DECLARE @actual INT
    SELECT @actual = reason_no FROM ANSWER WHERE question_no = 1
    
    exec tSQLt.AssertEquals 60103, @actual
END
GO

create or alter proc test_pr_check_answer.test_if_pr_check_answer_incorrect_columns
as
begin
    exec tSQLt.FakeTable 'QUESTION'
    exec tSQLt.FakeTable 'ANSWER'
    exec tSQLt.FakeTable 'CORRECT_ANSWER'

    INSERT INTO QUESTION (question_no, exam_db_name) VALUES (1, 'HAN_SQL_EXAM_DATABASE')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (1, 'DB-1', 3, 'SELECT question_no FROM answer')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (2, 'DB-2', 4, 'SELECT question_no FROM answer')

    INSERT INTO CORRECT_ANSWER (question_no, correct_answer_statement) VALUES (1, 'SELECT * FROM answer WHERE question_no = 1')

    exec tSQLt.ExpectNoException

    exec pr_check_answer 1, 'DB-1', 3

    DECLARE @actual INT
    SELECT @actual = reason_no FROM ANSWER WHERE question_no = 1

    exec tSQLt.AssertEquals 60103, @actual
END
GO

create or alter proc test_pr_check_answer.test_if_pr_check_answer_throws_answer_uses_an_illicit_word
as
begin
    exec tSQLt.FakeTable 'QUESTION'
    exec tSQLt.FakeTable 'ANSWER'
	exec tSQLt.FakeTable 'ANSWER_CRITERIA'


    INSERT INTO QUESTION (question_no, exam_db_name) VALUES (1, 'HAN_SQL_EXAM_DATABASE')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (1, 'DB-1', 1, 'SELECT question_no FROM answer order by question_no')
    INSERT INTO ANSWER_CRITERIA (question_no, keyword, criteria_type) VALUES (1, 'order by', 'Banned')

	exec tSQLt.ExpectNoException

    exec pr_check_answer 1, 'DB-1', 1

    DECLARE @actual INT
    SELECT @actual = reason_no FROM ANSWER WHERE question_no = 1

    exec tSQLt.AssertEquals 60111, @actual

END
GO

create or alter proc test_pr_check_answer.test_if_pr_check_answer_throws_Answer_does_not_include_the_required_statements
as
begin
    exec tSQLt.FakeTable 'QUESTION'
    exec tSQLt.FakeTable 'ANSWER'
	exec tSQLt.FakeTable 'ANSWER_CRITERIA'


    INSERT INTO QUESTION (question_no, exam_db_name) VALUES (1, 'HAN_SQL_EXAM_DATABASE')
    INSERT INTO ANSWER (question_no, exam_id, student_no, answer) VALUES (1, 'DB-1', 1, 'SELECT question_no FROM answer')
    INSERT INTO ANSWER_CRITERIA (question_no, keyword, criteria_type) VALUES (1, 'order by', 'Required')

	 exec tSQLt.ExpectNoException

    exec pr_check_answer 1, 'DB-1', 1

    DECLARE @actual INT
    SELECT @actual = reason_no FROM ANSWER WHERE question_no = 1

    exec tSQLt.AssertEquals 60112, @actual

END
GO