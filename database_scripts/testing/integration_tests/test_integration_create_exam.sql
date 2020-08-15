----------------------------------------------------------
/*			Integratie test proces aanmaken examen		*/
----------------------------------------------------------
/*
In deze integratie test worden alle procedures en triggers gezamenlijk
getest om te kijken of er problemen zijn tussen de procedures door. 
Tussen elke procedure/trigger wordt gekeken of de juiste waardes in de juiste tabellen staan.

In deze integratie test worden de volgende procedures en triggers gebruikt:

-pr_insert_exam
-pr_insert_exam_group_in_exam
-pr_insert_all_students_from_a_class_in_exam_for_student
-pr_add_student_to_exam and pr_remove_student_from_exam
-pr_update_exam
-pr_update_exam_group_in_exam
-pr_update_exam_for_student
-pr_insert_exam_database
-pr_insert_exam_database
-pr_insert_standalone_question
-pr_insert_question
-pr_update_question 
-pr_update_correct_answer
-pr_insert_correct_answer
-pr_insert_answer_criteria
-pr_update_answer_criteria

BELANGRIJK:
DEZE INTEGRATIE TEST MAAKT GEBRUIK VAN DE DATABASE ZELF EN NIET VAN
FAKE TABLES, DEZE TEST MOET DAAROM IN EEN TESTDATABASE GEBRUIKT WORDEN EN
NIET IN EEN ECHTE DATABASE! ZORG ER OOK VOOR DAT DE DATABASE LEEG IS, ANDERS
FAALT DE INTEGRATIETEST
*/
use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_integration_create_exam 
go

DROP TRIGGER IF EXISTS tr_schedule_exam
GO

DROP TRIGGER IF EXISTS tr_schedule_exam_check
GO

create or alter proc test_integration_create_exam.[test if create_exam_proces_works] 
as
begin
	--Setup
	exec tSQLt.ExpectNoException
	INSERT INTO CLASS VALUES('ISE-A'),('ISE-B')
	INSERT INTO STUDENT VALUES(1, 'ISE-A', 'Daan', 'Jelink', 1),(2, 'ISE-A', 'Sanne', 'Brugmans', 0),(3, 'ISE-A', 'Mark', 'Jansen', 0),(4, 'ISE-B', 'Janny', 'Smit', 1)
	INSERT INTO EXAM_GROUP VALUES('Standaard'),('Dyslexie'),('Herkanser')
	INSERT INTO DIFFICULTY VALUES('leerjaar1'),('leerjaar2')
	INSERT INTO COURSE VALUES('DEA', 'leerjaar2'),('OOPD', 'leerjaar1')
	INSERT INTO CRITERIA_TYPE VALUES('Banned')

	DECLARE @STARTING_DATE DATETIME = GETDATE() + 250;
	DECLARE @STARTING_DATE_MODIFIED DATETIME = GETDATE() + 300;
	DECLARE @END_DATE_STANDARD DATETIME = @STARTING_DATE + 400;
	DECLARE @END_DATE_DYSLEXIC DATETIME = @STARTING_DATE + 460;


	--Creation of expected result tables
	--EXAM
	CREATE TABLE EXPECTED_EXAM(exam_id VARCHAR(20), course VARCHAR(20), exam_name VARCHAR(50), starting_date DATETIME, comment VARCHAR(MAX))
	INSERT INTO EXPECTED_EXAM VALUES('DEA1', 'DEA', 'schriftelijke toets 1', @STARTING_DATE, NULL)

	--EXAM_GROUP_IN_EXAM
	CREATE TABLE EXPECTED_EXAM_GROUP_IN_EXAM(exam_id VARCHAR(20), exam_group_type VARCHAR(20), end_date DATETIME)
	INSERT INTO EXPECTED_EXAM_GROUP_IN_EXAM VALUES('DEA1', 'standaard', @END_DATE_STANDARD),('DEA1', 'dyslexie', @END_DATE_DYSLEXIC)

	--EXAM_FOR_STUDENT
	CREATE TABLE EXPECTED_EXAM_FOR_STUDENT(exam_id VARCHAR(20), student_no INT, class VARCHAR(20), exam_group_type VARCHAR(20), hand_in_date DATETIME, result NUMERIC(4,2))
	INSERT INTO EXPECTED_EXAM_FOR_STUDENT VALUES('DEA1', 1, 'ISE-A', 'Dyslexie', NULL, NULL),('DEA1', 2, 'ISE-A', 'Standaard', NULL, NULL),('DEA1', 3, 'ISE-A', 'Standaard', NULL, NULL)

	--EXAM_DATABASE
	CREATE TABLE EXPECTED_EXAM_DATABASE(exam_db_name VARCHAR(40), exam_ddl_script VARCHAR(MAX), exam_dml_script VARCHAR(MAX))
	INSERT INTO EXPECTED_EXAM_DATABASE VALUES('MuziekDatabase', 'create table Componist (
    componistId          numeric(4)           not null,
    naam                 varchar(20)          not null,
    geboortedatum        datetime             null,
    schoolId             numeric(2)           null
    )

    alter table Componist
    add constraint AK_COMPONIST unique (naam)

    alter table Componist
    add constraint PK_COMPONIST primary key (componistId)', 'INSERT INTO Componist VALUES ( 1, ''Charlie Parker'', ''12-dec-1904'', NULL);
    INSERT INTO Componist VALUES ( 2, ''Thom Guidi'',     ''05-jan-1946'', 1);
    INSERT INTO Componist VALUES ( 4, ''Rudolf Escher'',  ''08-jan-1912'', NULL);
    INSERT INTO Componist VALUES ( 5, ''Sofie Bergeijk'', ''12-jul-1960'', 2);
    INSERT INTO Componist VALUES ( 8, ''W.A. Mozart'',    ''27-jan-1756'', NULL);
    INSERT INTO Componist VALUES ( 9, ''Karl Schumann'',  ''10-oct-1935'', 2);
    INSERT INTO Componist VALUES (10, ''Jan van Maanen'', ''08-sep-1965'', 1);')

	--QUESTION
	CREATE TABLE EXPECTED_QUESTION(question_no INT, difficulty VARCHAR(10), exam_db_name VARCHAR(40), question_assignment VARCHAR(MAX), comment VARCHAR(MAX), status VARCHAR(20))
	INSERT INTO EXPECTED_QUESTION VALUES(1, 'leerjaar2', 'MuziekDatabase', 'selecteer alle componisten', 'Controleer of de * wordt gebruikt', 'unused')

	--CORRECT_ANSWER
	CREATE TABLE EXPECTED_CORRECT_ANSWER(question_no INT, correct_answer_id SMALLINT, correct_answer_statement VARCHAR(MAX))
	INSERT INTO EXPECTED_CORRECT_ANSWER VALUES(1, 1, 'SELECT * FROM componist')

	--ANSWER_CRITERIA
	CREATE TABLE EXPECTED_ANSWER_CRITERIA(question_no INT, keyword VARCHAR(30), criteria_type VARCHAR(30))
	INSERT INTO EXPECTED_ANSWER_CRITERIA VALUES(1, '*', 'Banned')

	--Execution of procedures
	--pr_insert_exam
	exec pr_insert_exam @exam_id = 'DEA1', @course = 'DEA', @exam_name = 'schriftelijke toets 1', @starting_date = @STARTING_DATE, @comment = NULL
	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_EXAM', @Actual = 'EXAM'

	--pr_insert_exam_group_in_exam
	exec pr_insert_exam_group_in_exam @exam_id = 'DEA1', @exam_group_type = 'standaard', @end_date = @END_DATE_STANDARD
	exec pr_insert_exam_group_in_exam @exam_id = 'DEA1', @exam_group_type = 'dyslexie', @end_date = @END_DATE_DYSLEXIC
	--exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_EXAM_GROUP_IN_EXAM', @Actual = 'EXAM_GROUP_IN_EXAM'

	--pr_insert_all_students_from_a_class_in_exam_for_student
	exec pr_insert_all_students_from_a_class_in_exam_for_student @class = 'ISE-A', @exam_id = 'DEA1'
	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_EXAM_FOR_STUDENT', @Actual = 'EXAM_FOR_STUDENT'

	--pr_add_student_to_exam and pr_remove_student_from_exam
	exec pr_add_student_to_exam @student_no = 4, @exam_id = 'DEA1'

	exec pr_remove_student_from_exam @student_no = 3, @exam_id = 'DEA1'

	--update EXPECTED_EXAM_FOR_STUDENT table
	DELETE FROM EXPECTED_EXAM_FOR_STUDENT WHERE student_no = 3
	INSERT INTO EXPECTED_EXAM_FOR_STUDENT VALUES('DEA1', 4, 'ISE-B', 'Dyslexie', NULL, NULL)

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_EXAM_FOR_STUDENT', @Actual = 'EXAM_FOR_STUDENT'

	--pr_update_exam
	exec pr_update_exam @exam_id = 'DEA1', @course = 'OOPD', @exam_name = 'DEA schriftelijke toets 2', @starting_date = @STARTING_DATE_MODIFIED, @comment = 'Is nu moeilijker'

	--update EXPECTED_EXAM
	UPDATE EXPECTED_EXAM SET course = 'OOPD', exam_name = 'DEA schriftelijke toets 2', starting_date = @STARTING_DATE_MODIFIED, comment = 'Is nu moeilijker' WHERE exam_id = 'DEA1'
	
	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_EXAM', @Actual = 'EXAM'

	--pr_update_exam_group_in_exam
	exec pr_update_exam_group_in_exam @exam_id = 'DEA1', @exam_group_type = 'Standaard', @end_date = @END_DATE_DYSLEXIC

	--update EXPECTED_EXAM_GROUP_IN_EXAM
	UPDATE EXPECTED_EXAM_GROUP_IN_EXAM SET end_date = @END_DATE_DYSLEXIC WHERE exam_group_type = 'Standaard'

	--exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_EXAM_GROUP_IN_EXAM', @Actual = 'EXAM_GROUP_IN_EXAM'

	--pr_update_exam_for_student
	exec pr_update_exam_for_student @exam_id = 'DEA1', @student_no = 1,@class = 'ISE-B', @exam_group_type = 'Standaard', @result = NULL

	--update EXPECTED_EXAM_FOR_STUDENT
	UPDATE EXPECTED_EXAM_FOR_STUDENT SET class = 'ISE-B', exam_group_type = 'Standaard' WHERE exam_id = 'DEA1' AND student_no = 1;

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_EXAM_FOR_STUDENT', @Actual = 'EXAM_FOR_STUDENT'

	--pr_insert_exam_database
	exec pr_insert_exam_database @exam_db_name = 'MuziekDatabase', @exam_ddl_script = 
	'create table Componist (
    componistId          numeric(4)           not null,
    naam                 varchar(20)          not null,
    geboortedatum        datetime             null,
    schoolId             numeric(2)           null
    )

    alter table Componist
    add constraint AK_COMPONIST unique (naam)

    alter table Componist
    add constraint PK_COMPONIST primary key (componistId)', 
	@exam_dml_script = 
	'INSERT INTO Componist VALUES ( 1, ''Charlie Parker'', ''12-dec-1904'', NULL);
    INSERT INTO Componist VALUES ( 2, ''Thom Guidi'',     ''05-jan-1946'', 1);
    INSERT INTO Componist VALUES ( 4, ''Rudolf Escher'',  ''08-jan-1912'', NULL);
    INSERT INTO Componist VALUES ( 5, ''Sofie Bergeijk'', ''12-jul-1960'', 2);
    INSERT INTO Componist VALUES ( 8, ''W.A. Mozart'',    ''27-jan-1756'', NULL);
    INSERT INTO Componist VALUES ( 9, ''Karl Schumann'',  ''10-oct-1935'', 2);
    INSERT INTO Componist VALUES (10, ''Jan van Maanen'', ''08-sep-1965'', 1);'
	
	--pr_insert_standalone_question
	DBCC CHECKIDENT(QUESTION, RESEED, 0)
	exec pr_insert_stand_alone_question @exam_db_name = 'MuziekDatabase', @question_assignment = 'selecteer alle componisten', @correct_answer_statement = 'SELECT * FROM componist', @difficulty = 'leerjaar2', @comment = 'Controleer of de * wordt gebruikt'

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_QUESTION', @Actual = 'QUESTION'
	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_CORRECT_ANSWER', @Actual = 'CORRECT_ANSWER'

	--pr_insert_question
	exec pr_insert_question @exam_id = 'DEA1', @exam_db_name = 'MuziekDatabase', @question_assignment = 'selecteer de componist met de naam Thom', @question_points = 5, @correct_answer_statement = 'SELECT * FROM componist WHERE naam LIKE %Thom%', @difficulty = 'leerjaar2', @comment = NULL
	
	--update EXPECTED_QUESTION and EXPECTED_CORRECT_ANSWER
	INSERT INTO EXPECTED_QUESTION VALUES(2, 'leerjaar2', 'MuziekDatabase', 'selecteer de componist met de naam Thom', NULL, 'active')
	INSERT INTO EXPECTED_CORRECT_ANSWER VALUES(2, 2, 'SELECT * FROM componist WHERE naam LIKE %Thom%')

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_QUESTION', @Actual = 'QUESTION'
	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_CORRECT_ANSWER', @Actual = 'CORRECT_ANSWER'

	--pr_update_question and pr_update_correct_answer
	exec pr_update_question @question_no = 1, @difficulty = 'leerjaar1', @exam_db_name = 'MuziekDatabase', @question_assignment = 'selecteer alle (*) componisten', @comment = '* toegevoegd aan opgave', @remove_comment = 0
	exec pr_update_correct_answer @question_no = 1, @correct_answer_id = 1, @correct_answer_statement = 'SELECT naam FROM componisten'

	--update EXPECTED_QUESTION and EXPECTED_CORRECT_ANSWER
	UPDATE EXPECTED_QUESTION SET difficulty = 'leerjaar1', question_assignment = 'selecteer alle (*) componisten', comment = '* toegevoegd aan opgave' WHERE question_no = 1
	UPDATE EXPECTED_CORRECT_ANSWER SET correct_answer_statement = 'SELECT naam FROM componisten' WHERE question_no = 1 AND correct_answer_id = 1

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_QUESTION', @Actual = 'QUESTION'
	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_CORRECT_ANSWER', @Actual = 'CORRECT_ANSWER'

	--pr_insert_correct_answer
	exec pr_insert_correct_answer @question_no = 1, @correct_answer_statement = 'SELECT * FROM componist'

	--update EXPECTED_CORRECT_ANSWER
	INSERT INTO EXPECTED_CORRECT_ANSWER VALUES(1, 2, 'SELECT * FROM componist')

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_CORRECT_ANSWER', @Actual = 'CORRECT_ANSWER'

	--pr_insert_answer_criteria
	exec pr_insert_answer_criteria @question_no = 1, @keyword = '*', @criteria_type = 'Banned'

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_ANSWER_CRITERIA', @Actual = 'ANSWER_CRITERIA'

	--pr_update_answer_criteria
	exec pr_update_answer_criteria @question_no = 1, @keyword_old = '*', @keyword_new = 'naam', @criteria_type = 'Banned'

	--update EXPECTED_ANSWER_CRITERIA
	UPDATE EXPECTED_ANSWER_CRITERIA SET keyword = 'naam' WHERE question_no = 1

	exec tSQLt.AssertEqualsTable @Expected = 'EXPECTED_ANSWER_CRITERIA', @Actual = 'ANSWER_CRITERIA'

end
go