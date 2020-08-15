use HAN_SQL_EXAM_DATABASE
go

delete from EXAM where exam_id = 'DB-1'
delete from ANSWER where student_no = 7

--Examen aanmaken inclusief vragen
declare @date datetime = DATEADD(SECOND,1,GETDATE())
declare @end_date_standaard datetime = DATEADD(minute,90,GETDATE())
declare @end_date_dyslexie datetime = DATEADD(minute,90,GETDATE())

EXEC pr_insert_exam @exam_id = 'DB-1', @course = 'DB', @exam_name = 'Toets 1 demo', @starting_date = @date, @comment = 'Examen voor de demo iteratie 2'
EXEC pr_connect_question_to_exam @exam_id = 'DB-1', @question_no = 1, @question_points = 5
EXEC pr_connect_question_to_exam @exam_id = 'DB-1', @question_no = 2, @question_points = 5
EXEC pr_connect_question_to_exam @exam_id = 'DB-1', @question_no = 3, @question_points = 5
EXEC pr_connect_question_to_exam @exam_id = 'DB-1', @question_no = 4, @question_points = 5
insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date) VALUES ('DB-1', 'Standaard', DATEADD(minute,90,GETDATE()))
insert into EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date) VALUES ('DB-1', 'Dyslexie', DATEADD(minute,120,GETDATE()))

-- Volledige klas koppelen aan een examen
exec pr_insert_all_students_from_a_class_in_exam_for_student @class = 'ISE-A', @exam_id = 'DB-1'
select * from EXAM_FOR_STUDENT where exam_id = 'DB-1'

-- Vragen ophalen
exec pr_select_all_question_assignments_from_exam @exam_id = 'DB-1'

-- Antwoord insturen op vraag 1
exec pr_insert_answer @student_no = 7, @exam_id = 'DB-1', @question_no = 1, @answer = 'SELECT * FROM stuk' -- Foute results

-- Antwoord insturen op vragen 2, 3 en 4
exec pr_insert_answer @student_no = 7, @exam_id = 'DB-1', @question_no = 2, @answer = 'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2' -- Goed antwoord
exec pr_insert_answer @student_no = 7, @exam_id = 'DB-1', @question_no = 3, @answer = 'SELECT n.omschrijving, COUNT(s.stuknr) FROM niveau n JOIN stuk s ON n.niveaucode = s.niveaucode WHERE s.genre = "klassiek" GROUP BY n.niveaucode' -- Foute kollomen
exec pr_insert_answer @student_no = 7, @exam_id = 'DB-1', @question_no = 4, @answer = 'Geen idee...' -- Foute syntax
exec pr_select_all_answers_for_exam @exam_id = 'DB-1'

-- Examen inleveren
exec pr_hand_in_exam @student_no = 7, @exam_id = 'DB-1'
select * from EXAM_FOR_STUDENT where student_no = 7

-- Antwoorden nakijken
exec pr_check_all_answers_for_exam @exam_group_type = 'Standaard', @exam_id = 'DB-1'






















-- Antwoorden ophalen
exec pr_select_all_answers_for_exam @exam_id = 'DB-1'

-- Cijfer ophalen
select * from EXAM_FOR_STUDENT where student_no = 7
