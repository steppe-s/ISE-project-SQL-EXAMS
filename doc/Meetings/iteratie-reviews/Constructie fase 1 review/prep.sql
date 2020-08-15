USE HAN_SQL_EXAM_DATABASE
--Examen aanmaken
EXEC pr_insert_exam @exam_id = 'DB-1', @course_id = 'DB', @exam_name = 'Toets 1 demo', @grade_formula = 1, @execution_year = 2020, @comment = 'Examen voor de demo iteratie 1'


--Een nieuw vraag maken en toevoegen aan het examen.
EXEC pr_insert_question @exam_id = 'DB-1',
@exam_db_name = 'MuziekdatabaseUitgebreid',
@question_assignment = 'Geef van alle originele speelstukken van genre klassiek.',
@question_points = 2,
@correct_answer_statement = 'SELECT * FROM stuk WHERE genrenaam = ''Klassiek'' AND stuknrOrigineel is null ',
@difficulty_id = 'Year 1',
@comment = 'demo vraag'


--Extra vragen aan het examen koppelen
EXEC pr_connect_question_to_exam @exam_id = 'DB-1', @question_no = 1, @question_points = 5
EXEC pr_connect_question_to_exam @exam_id = 'DB-1', @question_no = 2, @question_points = 5
EXEC pr_connect_question_to_exam @exam_id = 'DB-1', @question_no = 3, @question_points = 5
EXEC pr_connect_question_to_exam @exam_id = 'DB-1', @question_no = 4, @question_points = 5

--Groep aan examen koppelen
insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_id, begin_date, end_date) VALUES ('DB-1', 'standaard', GETDATE(), DATEADD(hour,2,GETDATE()))

--Student inschrijven voor groep
insert into dbo.EXAM_FOR_STUDENT (exam_id, student_no, class_id, group_id, result)
values  ('DB-1', 1, 'ISE-A', 'Standaard', 0)

--Vraag beantwoorden
insert into dbo.ANSWER (student_no, exam_id, question_no, answer, answer_rating, answer_fill_in_date)
values  (1, 'DB-1', 9, 'SELECT stuknr, componistId, titel, stuknrOrigineel, genrenaam, niveaucode, speelduur, jaartal FROM stuk WHERE genrenaam = ''Klassiek'' AND stuknrOrigineel = null', 0, '2019-04-13 11:31:21.874')


--Extra vragen beantwoorden
insert into dbo.ANSWER (student_no, exam_id, question_no, reason_no, answer, answer_rating, answer_fill_in_date)
values  (1, 'DB-1', 1, null, 'SELECT * FROM stuk', 0, '2019-04-13 11:31:21.874'), -- Foute results
		(1, 'DB-1', 2, null, 'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 0, '2019-04-13 11:46:42.382'), -- Goed antwoord
		(1, 'DB-1', 3, null, 'SELECT n.omschrijving, COUNT(s.stuknr) FROM niveau n JOIN stuk s ON n.niveaucode = s.niveaucode WHERE s.genre = "klassiek" GROUP BY n.niveaucode', 0, '2019-04-13 12:01:56.965'), -- Foute kollomen
		(1, 'DB-1', 4, null, 'Ik weet het niet...', 0, '2019-04-13 12:29:01.824') -- Foute syntax


--antwoorden selecteren
EXEC pr_select_all_answers_for_exam @exam_id = 'DB-1'

--antwoorden nakijken
EXEC pr_check_all_answers_for_exam 'standaard', 'DB-1'


EXEC pr_check_all_answers_for_exam 'standaard', '1'
EXEC pr_check_all_answers_for_exam 'dyslexie', '1'

SELECT * FROM ANSWER WHERE exam_id = '1'

