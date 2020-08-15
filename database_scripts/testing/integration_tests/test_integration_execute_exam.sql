----------------------------------------------------------
/*		Integratie test proces: uitvoeren examen        */
----------------------------------------------------------
/*
In deze integratie test worden alle procedures en triggers gezamenlijk
getest om te kijken of er problemen zijn tussen de procedures door. 

N.B.
Tussen elke procedure/trigger wordt gekeken of de juiste waardes in de juiste tabellen staan.

In deze integratie test worden de volgende procedures en triggers gebruikt:
	- pr_insert_answer
	- pr_hand_in_exam
	- pr_update_answer
	- pr_check_answer
	- pr_check_all_answers_for_exam

	- tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam
	- tr_restrict_update_end_time_after_exam_has_been_taken
    - tr_set_question_to_pending

BELANGRIJK:
DEZE INTEGRATIE TEST MAAKT GEBRUIK VAN DE DATABASE ZELF EN NIET VAN
FAKE TABLES, DEZE TEST MOET DAAROM IN EEN TESTDATABASE GEBRUIKT WORDEN EN
NIET IN EEN ECHTE DATABASE! ZORG ER OOK VOOR DAT DE DATABASE LEEG IS, ANDERS
FAALT DE INTEGRATIETEST!
*/
USE HAN_SQL_EXAM_DATABASE
GO

DROP TRIGGER IF EXISTS tr_schedule_exam
GO

DROP TRIGGER IF EXISTS tr_schedule_exam_check
GO

EXEC tSQLt.NewTestClass test_integration_execute_exam 
GO

CREATE OR ALTER PROC test_integration_execute_exam.[test if integration is succesfull] 
AS
BEGIN
	--SETUP
	EXEC tSQLt.ExpectNoException
	INSERT INTO CLASS VALUES('ISE-A'),('ISE-B')
	INSERT INTO STUDENT VALUES(1, 'ISE-A', 'Daan', 'Jelink', 1),(2, 'ISE-A', 'Sanne', 'Brugmans', 0),(3, 'ISE-A', 'Mark', 'Jansen', 0),(4, 'ISE-B', 'Janny', 'Smit', 1)
	INSERT INTO EXAM_GROUP VALUES('Standaard'),('Dyslexie'),('Herkanser')
	INSERT INTO DIFFICULTY VALUES('leerjaar1'),('leerjaar2')
	INSERT INTO COURSE VALUES('DEA', 'leerjaar2'),('OOPD', 'leerjaar1')
	INSERT INTO CRITERIA_TYPE VALUES('Banned'),('Required')

	DECLARE @STARTING_DATE DATETIME = GETDATE();
	DECLARE @END_DATE_STANDARD DATETIME = @STARTING_DATE + 1;
	DECLARE @END_DATE_DYSLEXIC DATETIME = @STARTING_DATE + 2;


	--EXAM
	INSERT INTO EXAM VALUES('DEA1', 'DEA', 'schriftelijke toets 1', @STARTING_DATE, NULL)

	--EXAM_GROUP_IN_EXAM
	INSERT INTO EXAM_GROUP_IN_EXAM VALUES('DEA1', 'standaard', @END_DATE_STANDARD),('DEA1', 'dyslexie', @END_DATE_DYSLEXIC)

	--EXAM_FOR_STUDENT
	INSERT INTO EXAM_FOR_STUDENT VALUES('DEA1', 1, 'ISE-A', 'Dyslexie', NULL, NULL),('DEA1', 2, 'ISE-A', 'Standaard', NULL, NULL)

	--EXAM_DATABASE
	INSERT INTO EXAM_DATABASE VALUES('MuziekDatabase', 'create table Componist (
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
    INSERT INTO Componist VALUES (10, ''Jan van Maanen'', ''08-sep-1965'', 1);');
	
	--QUESTION
	DBCC CHECKIDENT(QUESTION, RESEED, 0)
	INSERT INTO QUESTION 
	VALUES	('leerjaar2', 'MuziekDatabase', 'selecteer alle componisten', 'Controleer of de * wordt gebruikt', 'active'),
			('leerjaar2', 'MuziekDatabase', 'selecteer alles componisten zonder *', 'Controleer of de * niet wordt gebruikt', 'active'),
			('leerjaar2', 'MuziekDatabase', 'selecteer de componist Thomas', NULL, 'active')

	--QUESTION_IN_EXAM
	INSERT INTO QUESTION_IN_EXAM (exam_id, question_no, question_points)
	VALUES	('DEA1', 1, 5),
			('DEA1', 2, 10),
			('DEA1', 3, 5)

	--CORRECT_ANSWER
	INSERT INTO CORRECT_ANSWER 
	VALUES	(1, 1, 'SELECT * FROM componist'),
			(2, 1, 'SELECT * FROM componist'),
			(3, 1, 'SELECT * FROM componist WHERE name = ''Thomas''')

	--ANSWER_CRITERIA
	INSERT INTO ANSWER_CRITERIA 
	VALUES	(1, '*', 'Required'),
			(2, '*', 'Banned')
			
	--ANSWER
	INSERT INTO ANSWER VALUES(2,'DEA1', 1, NULL, 'SELECT * FROM componist c', 'REQUIRE CHECK', @STARTING_DATE)

----------------------------------------
	--Creation of expected result tables
	--ANSWER
	CREATE TABLE EXPECTED_REASON(reason_no INT, reason_description VARCHAR(1024))
	INSERT INTO EXPECTED_REASON
		VALUES(60110, 'No answer was provided by the student')

	CREATE TABLE EXPECTED_ANSWER(student_no INT, exam_id VARCHAR(20), question_no INT, reason_no INT, answer VARCHAR(MAX), answer_status VARCHAR(50), answer_fill_in_date DATETIME)
	INSERT INTO EXPECTED_ANSWER VALUES(2,'DEA1', 1, NULL, 'SELECT * FROM componist c', 'REQUIRE CHECK', @STARTING_DATE)

				 
	--Execution of procedures
	-- pr_insert_answer
	EXEC pr_insert_answer @student_no = 1, @exam_id = 'DEA1', @question_no = 1, @answer = 'SELECT * FROM componist'
	EXEC pr_insert_answer @student_no= 1, @exam_id = 'DEA1', @question_no = 2, @answer = 'SELECT *'

	--Update EXPECTED_ANSWER
	INSERT INTO EXPECTED_ANSWER
		VALUES	(1, 'DEA1', 1, NULL, 'SELECT * FROM componist', 'REQUIRE CHECK', (SELECT answer_fill_in_date FROM ANSWER WHERE student_no = 1 AND question_no = 1)),
				(1, 'DEA1', 2, NULL, 'SELECT *', 'REQUIRE CHECK', (SELECT answer_fill_in_date FROM ANSWER WHERE student_no = 1 AND question_no = 2))

	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED_ANSWER', @Actual = 'ANSWER'

	--pr_update_answer
	EXEC pr_update_answer @student_no = 1, @exam_id = 'DEA1', @question_no = 2, @answer = 'SELECT * FROM'


	--Update EXPECTED_ANSWER
	UPDATE EXPECTED_ANSWER SET answer = 'SELECT * FROM', answer_fill_in_date = (SELECT answer_fill_in_date FROM ANSWER WHERE student_no = 1 AND question_no = 2) WHERE question_no = 2

	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED_ANSWER', @Actual = 'ANSWER'

	--pr_hand_in_exam
	EXEC pr_hand_in_exam @student_no = 1, @exam_id = 'DEA1'

	--update EXPECTED_ANSWER en EXPECTED_REASON
	INSERT INTO EXPECTED_ANSWER VALUES(1, 'DEA1', 3, 60110, NULL, 'INCORRECT', (SELECT answer_fill_in_date FROM ANSWER WHERE student_no = 1 AND question_no = 3))

	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED_ANSWER', @Actual = 'ANSWER'

	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED_REASON', @Actual = 'REASON'
	

	--pr_check_all_answers_for_exam
	EXEC pr_check_all_answers_for_exam @exam_group_type = 'Dyslexie', @exam_id = 'DEA1'
	select * from ANSWER
	select * from REASON

	--update EXPECTED_ANSWER en EXPECTED_REASON
	UPDATE EXPECTED_ANSWER SET reason_no = 60111, answer_status = 'INCORRECT' WHERE student_no = 1 AND question_no = 2
	UPDATE EXPECTED_ANSWER SET answer_status = 'PENDING' WHERE student_no = 1 AND question_no = 1
	UPDATE EXPECTED_ANSWER SET answer_status = 'REQUIRE CHECK' WHERE student_no = 2 AND question_no = 1

	INSERT INTO EXPECTED_REASON VALUES(60111, 'Answer uses an illicit word')

	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED_ANSWER', @Actual = 'ANSWER'
	EXEC tSQLt.AssertEqualsTable @Expected = 'EXPECTED_REASON', @Actual = 'REASON'
END
GO