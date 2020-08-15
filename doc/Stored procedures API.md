# Stored procedures API

## Inleiding

In deze map staan alle stored procedures die gebruikt worden in het systeem.
Voor elke stored procedure is er een uitleg gegeven over hoe deze gebruikt moet
worden, wat deze uitvoert en welke foutmeldingen deze procedure kan teruggeven.

Per procedure moeten de volgende gegevens zijn opgegeven:

-   Naam van procedure

-   Wat deze procedure doet

-   Hoe deze procedure gebruikt moet worden (gebruik parameters, optionele
    parameters)

-   Op welke tables deze procedure van toepassing is

-   Welke foutmeldingen deze procedure terug kan geven

## Stored procedures

### DELETE 

#### Pr_delete_question

##### Functie

Verwijderd een vraag wanneer deze nog nooit is gebruik voor een examen, en zet de status van een vraag op deleted wanneer deze vraag al wel eens is gebruikt.

#### Use case 

Vragenset met antwoorden beheren

##### Gebruik procedure

        Exec pr_delete_question 
                @question_no = 1

@question_no (int): de vraag nummer die verwijderd moet worden

##### Relaties met tables

QUESTION, QUESTION_IN_EXAM, CORRECT_ANSWER

##### Foutmeldingen

60002: 'question_no cannot be null'

#### Pr_delete_correct_answer

##### Functie

Laat een gebruiker een correct antwoord verwijderen zodat deze niet meer wordt gebruikt bij het nakijken

#### Use case 

Vragenset met antwoorden beheren

##### Gebruik procedure

        exec pr_delete_correct_answer 
                @question_no = 1, 
                @correct_answer_id = 1

@question_no (int): de vraag waar het antwoord bijhoort

@correct_answer_id (smallint): het antwoord dat verwijderd moet worden

##### Relaties met tables

CORRECT_ANSWER, QUESTION

##### Foutmeldingen

60002: ‘question_no cannot be null’

60025: ‘correct_answer_id cannot be null’

60152: ‘At least one correct answer must be provided for a question’

#### pr_delete_answer_criteria

##### Functie

Laat een gebruiker een criterium voor een vraag verwijderen zodat deze niet meer wordt gebruikt bij het nakijken.

##### Use case 

Vragenset met antwoorden beheren

##### Gebruik procedure

        exec pr_delete_answer_criteria 
                @question_no = 1, 
                @keyword = 'Exist'

@question_no (int): de vraag waar het sleutelwoord bijhoort

@keyword (varchar(30)): het sleutelwoord voor de vraag dat verwijderd moet worden

##### Relaties met tables

ANSWER_CRITERIA

##### Foutmeldingen

60002: ‘question_no cannot be null’

60016: ‘keyword cannot be null’

#### pr_delete_exam

##### Fucntie 

Verwijderd een examen

##### Use case 

Examen beheren

##### Gebruik procedure

	pr_delete_exam
		@exam_id = 'id'

@exam_id varchar(20): Het examen dat moet worden verwijderd

##### Relaties met tables 

EXAM 

##### Foutmeldingen

60001: 'exam_id cannot be null'

60152: 'An exam may not be modified when it is taking place or has taken place already'

#### pr_remove_student_from_exam

##### Functie

Ontkoppelt een student van een examen dat nog niet heeft plaatsgevonden

##### Use cases 

Student beheren

##### Gebruik procedure

        exec pr_remove_student_from_exam 
                @student_no = 1,
	        @exam_id = 'eId'

@student_no (int): het studentnummer dat gekoppeld moet worden aan een examen

@exam_id (varchar(20)): het examen waarvan alle studenten aan gekoppeld moeten worden

##### Relaties met tables

EXAM_FOR_STUDENT, EXAM_GROUP_IN_EXAM

##### Foutmeldingen

60001: 'student_no cannot be NULL'

60001: 'exam_id cannot be null'

60161: 'you cannot asign a student to an exam that has taken place already'

#### pr_disconnect_question_from_exam

##### Functie

Laat een gebruiker een vraag verwijderen uit een examen wanneer dit examen nog niet heeft plaatsgevonden.

##### Use case 

Vragenset met antwoorden beheren

##### Gebruik procedure

        exec pr_disconnect_question_from_exam 
                @question_no = 1, 
                @exam_id = 'examId'

@question_no (int): de vraag die verwijderd moet worden van het examen

@exam_id (varchar(20)): het examen waarvan de vraag verwijderd moet worden

##### Relaties met tables

EXAM, QUESTION_IN_EXAM, QUESTION, EXAM_GROUP_IN_EXAM

##### Foutmeldingen

60001: ‘exam_id cannot be null’

60002: ‘question_no cannot be null’

60151: ‘questions may not be changed once they are use in an exam that has been
taken’




### INSERT

#### pr_connect_question_to_exam

##### Functie

Laat een gebruiker een vraag toevoegen aan een bestaand examen

##### Use case 

Vragenset met antwoorden beheren

##### Gebruik procedure

        EXEC pr_connect_question_to_exam 
                @exam_id = 'examId', 
                @question_no = 1, 
                @question_points = 20

@exam_id (varchar(20)): het examen waar de vraag aan toegevoegd moet worden

@question_no (int): de vraag die toegevoegd moet worden aan het examen

@question_points (smallint): het aantal punten dat een goed antwoord kan opleveren

##### Relaties met tables

EXAM, QUESTION, EXAM_GROUP_IN_EXAM, QUESTION_IN_EXAM

##### Foutmeldingen

60002: ‘question_no cannot be null’

60001: ’exam_id cannot be null’

60006, 'question_points cannot be null or 0'

60155: ‘questions may not be added to an exam that has taken place’

#### pr_insert_answer_criteria

##### Functie

Laat een gebruiker een sleutelwoord toevoegen voor een vraag.

##### Use case 

Vragenset met antwoorden beheren

##### Gebruik procedure

        exec pr_insert_answer_criteria 
                @question_no= 1, 
                @keyword = 'join', 
                @criteria_type = 'Banned'

@question_no (int): Het nummer van de vraag waar het sleutelwoord voor bedoeld is

@keyword (varchar(30)): Het sleutelwoord dat toegevoegd moet worden.

@criteria_type (varchar(30)): geeft aan of het sleutelwoord juist wel of niet gebruikt moet worden in de vraag.

##### Relaties met tables

ANSWER_CRITERIA

##### Foutmeldingen

60002: 'question_no cannot be null'

60016: 'keyword cannot be null'

60017: 'criteria_type cannot be null'

#### pr_insert_exam_group

##### Functie

Laat een gebruiker een examengroep toevoegen.

##### Use case 

Examen beheren

##### Gebruik procedure

        exec pr_insert_exam_group
                @exam_group_type = 'nieuwe groep'

@exam_group_type (varchar(20)) : de naam van de nieuwe examengroep.

##### Relaties met tables

EXAM_GROUP_IN_EXAM, EXAM_FOR_STUDENT

##### Foutmeldingen

60015: ‘exam_group_type cannot be null’

#### pr_insert_exam_database

##### Functie

Laat een gebruiker nieuwe voor een nieuwe database de DDL en DML scripts uploaden.

##### Use case 

DDL en DML Scripts beheren

##### Gebruik procedure

        exec pr_insert_exam_database
                @exam_db_name = 'newDbName',
                @exam_ddl_script = 'create table CHAIRS(...)',
                @exam_dml_script = 'insert into CHAIRS (...) values (...)'

@exam_db_name (varchar(40)): De naam van de nieuwe database

@exam_ddl_script (varchar(max)): Het DDL script voor de nieuwe database 

@exam_dml_script (varchar(max)): Het DML script voor de nieuwe database 

##### Relaties met tables

EXAM_DATABASE

##### Foutmeldingen

60004: 'exam_db_name cannot be null'

60027: 'exam_ddl_script cannot be null'

60028: 'exam_dml_script cannot be null'

#### pr_insert_answer

##### Functie

Laat een student zijn antwoord inleveren op een vraag van een examen.

##### Use case 

Vraag beantwoorden

##### Gebruik procedure

        exec pr_insert_answer
                @student_no = 1,
                @exam_id = 'examId',
                @question_no = 2,
                @answer = 'SELECT * FROM CHAIRS'

@student_no (int): Het studentnummer van de student die zijn antwoord inlevert

@exam_id (varchar(20)): Het examen waar zijn antwoord voor gemaakt is

@question_no (int): De vraag waar zijn antwoord voor gemaakt is

@answer (varchar(max)): Het antwoord dat de student wilt inleveren

##### Relaties met tables

ANSWER, EXAM_GROUP_IN_EXAM, EXAM_FOR_STUDENT

##### Foutmeldingen

60012: 'student_no cannot be NULL'

60001: 'exam_id cannot be null'

60002: 'question_no cannot be null'

60009: 'answer cannot be null'

60158: 'An answer cannot be submitted before the begin_date of an exam'

60159: 'An answer cannot be submitted after the end_date of an exam'

#### pr_insert_stand_alone_question

##### Functie

Laat een gebruiker een vraag inclusief antwoord uploaden.

##### Use case 

Vragenset met antwoorden beheren

##### Gebruik procedure

        exec pr_insert_stand_alone_question 
                @exam_db_name = 'dbName', 
                @question_assignment = 'What is the answer on this question?', 
                @correct_answer_statement = 'select * from table', 
                @difficulty = 'year 1', 
                @comment = 'Be smart!'

@exam_db_name (varchar(50)): de naam van een al bestaande examen database in EXAM_DATABASE

@question_assignment (varchar(max)): de vraag die gesteld gaat worden op de toets

@correct_answer_statement (varchar(max)): het antwoord op de gestelde vraag

@difficulty (varchar(10)): de moeilijkheidsgraad van de gestelde vraag

@comment (varchar(max)): een eventuele comment kan erbij geplaatst worden om leraren een
richtlijn te geven bij het nakijken van de vraag

##### Relaties met tables

QUESTION, CORRECT_ANSWER

##### Foutmeldingen

60003: ‘correct_answer_statement cannot be null’

60004: ‘exam_db_name cannot be null’

60005: ‘question_assignment cannot be null’

60024: ‘difficulty cannot be null’

#### pr_insert_student_for_exam

##### Functie 

Voegt een student toe aan een examen

##### Use case 

Student beheren

##### Gebruik procedure

	exec pr_insert_student_for_exam
		@student_no = 1
		@exam_id = 'ISE'
		@class = 'ITA-1A'
		@group = 'STANDARD'
		
of
	
	exec pr_insert_student_for_exam
		@student_no = 1
		@exam_id = 'ISE'
		@class = 'ITA-1A'
		@group = 'STANDARD'
		@result = 1 

@student_no: 'het unieke id van een student
@exam_id: 'Het unieke id van een examen'
@class: 'De klas waar de student zich in bevind'
@group: 'De groep waar de student bij hoort, zoals dyslexie'
@result: 'Het resultaat van de toets' (optional)

##### Foutmeldingen

60012, 'student_no cannot be NULL'
60001, 'exam_id cannot be null'
60011, 'class cannot be null'
60015, 'group cannot be null'
		
#### pr_insert_all_students_from_a_class_in_exam_for_student

##### Functie

Laat een docent alle studenten van een klas koppelen aan een examen

##### Use case 

Student beheren

##### Gebruik procedure

        exec pr_insert_all_students_from_a_class_in_exam_for_student 
                @class = 'ISE-A',
	        @exam_id = 'eId'

@class (varchar(20)): de klas waarvan alle studenten gekoppeld moeten worden aan het gegeven examen

@exam_id (varchar(20)): het examen waarvan alle studenten aan gekoppeld moeten worden

##### Relaties met tables

EXAM_FOR_STUDENT, STUDENT, EXAM_GROUP_IN_EXAM

##### Foutmeldingen

60011: 'class cannot be NULL'

60001: 'exam_id cannot be null'

60054: 'exam group has not been created yet for this exam'

#### pr_add_student_to_exam

##### Functie

Koppelt een student aan een examen via een examengroep

##### Use case 

Student beheren

##### Gebruik procedure

        exec pr_add_student_to_exam 
                @student_no = 1,
	        @exam_id = 'eId'

@student_no (int): het studentnummer dat gekoppeld moet worden aan een examen

@exam_id (varchar(20)): het examen waarvan alle studenten aan gekoppeld moeten worden

##### Relaties met tables

EXAM_FOR_STUDENT, STUDENT, EXAM_GROUP_IN_EXAM

##### Foutmeldingen

60001: 'student_no cannot be NULL'

60001: 'exam_id cannot be null'

60054: 'exam group has not been created yet for this exam'

60161: 'you cannot asign a student to an exam that has taken place already'

#### pr_insert_exam_group_in_exam 

##### Functie 

Voegt een groep toe aan een examen 

##### Use case 

Examen beheren

##### Gebruik procedure 

	pr_insert_exam_group_in_exam
		@exam_id = 'id',
		@exam_group_type = 'STANDAARD',
		@end_date = '09-09-2020'
		
@exam_id varchar(20): Het examen waarvoor de groep moet worden toegevoegd
@exam_group_type varchar(20): De soort groep die meedoet aan dit examen, bijvoorbeeld standaard
@end_date datetime: De tijd waarop de toets eindigd
		
##### Relaties 

EXAM_GROUP_IN_EXAM

##### Foutmeldingen

60001: 'exam_id cannot be null'
60015: 'exam_group_type cannot be null'
60035: 'end_date cannot be null'

#### pr_insert_student_to_exam 

##### Functie 

Zet een examen klaar voor een student

##### Use case 

Examen beheren

##### Gebruik procedure 

	pr_insert_student_for_exam
		@student_no = 1,
		@exam_id = 'id',
		@class = 'ITA-1A',
		@group = 'STANDARD'
		
of 

	pr_insert_student_for_exam
		@student_no = 1,
		@exam_id = 'id',
		@class = 'ITA-1A',
		@group = 'STANDARD',
		@result = 9.0
			
@student_no int: De student die moet worden toegevoegd aan het examen
@exam_id varchar(20): Het examen waar de student aan gaat deelnemen
@class varchar(20): De klas waar de student in zit
@group varchar(20): De soort groep van de student, zoals standaard
@result numeric(4,2) (optional): Het resultaat van de student voor dat examen

##### Relaties

EXAM_FOR_STUDENT, EXAM_GROUP, CLASS

##### Foutmeldingen 

60012: 'student_no cannot be NULL'
60001: 'exam_id cannot be null'
60011: 'class cannot be null'
60015: 'group cannot be null'
60032: 'class does not exist'
60033: 'group does not exist'
60031: 'Student: ', @student_no, ' is already registered for exam: ', @exam_id

#### pr_insert_correct_answer

##### Functie

Laat een gebruiker een antwoord uploaden voor een al bestaande vraag van een test

##### Use case 

Vragenset met antwoorden beheren

##### Gebruik procedure

        exec pr_upload_answer 
                @question_no = 1, 
                @correct_answer_statement = 'select * from table'


@question_no (int): het vraagnummer waarop dit antwoord van toepassing is

@correct_answer_statement (varchar(max)): het correcte antwoord op de vraag

##### Relaties met tables

CORRECT_ANSWER, QUESTION

##### Foutmeldingen

60002: ‘question_no cannot be null’

60003: ‘correct_answer_statement cannot be null’

#### pr_insert_question

##### Functie

Laat een gebruiker een vraag inclusie antwoord uploaden voor een al bestaande
test. Maakt gebruik van de procedure pr_upload_answer.

#### Use case 

Vragenset met antwoorden beheren 

##### Gebruik procedure

        exec pr_insert_question 
                @exam_id = 'exam1', 
                @exam_db_name = 'dbName', 
                @question_assignment = 'What is the answer on this question?', 
                @question_points = 20, 
                @correct_answer_statement = 'select * from table', 
                @difficulty = 'year 1', 
                @comment = 'Be smart!'

@exam_id (varchar(20)): de naam van een al bestaande examen

@exam_db_name (varchar(50)): de naam van een al bestaande examen database in EXAM_DATABASE

@question_assignment (varchar(max)): de vraag die gesteld gaat worden op de toets

@question_points (smallint): het aantal punten dat toegekend wordt aan de vraag, deze
waarde moet 1 of hoger zijn

@correct_answer_statement (varchar(max)): het antwoord op de gestelde vraag

@difficulty (varchar(10)): de moeilijkheidsgraad van de gestelde vraag

@comment (varchar(max)): een eventuele comment kan erbij geplaatst worden om leraren een
richtlijn te geven bij het nakijken van de vraag

##### Relaties met tables

CORRECT_ANSWER, QUESTION_IN_EXAM, EXAM, EXAM_DATABASE, QUESTION

##### Foutmeldingen

60001: ‘exam_id cannot be null’

60003: ‘correct_answer_statement cannot be null’

60004: ‘exam_db_name cannot be null’

60005: ‘question_assignment cannot be null’

60006: ‘question_points cannot be null or 0’

60024: ‘difficulty cannot be null’

#### pr_insert_exam

##### Functie

Laat een gebruiker een nieuw examen uploaden.

##### Use case 

Examen beheren

##### Gebruik procedure

        exec pr_insert_exam 
                @exam_id = 'examId', 
                @course_id = 'courseId', 
                @exam_name = 'examName', 
                @starting_date = '20-05-2020 13:00', 
                @comment = 'Be smart!'

of

        exec pr_insert_exam 
                @exam_id = 'examId', 
                @course_id = 'courseId', 
                @exam_name = 'examName', 
                @starting_date = '20-05-2020 13:00',

@exam_id (varchar(20)): het id van het nieuwe examen.

@course_id (varchar(20)): het id van de bestaande course waar het examen voor is.

@exam_name (varchar(50)): de naam van het examen.

@starting_date (datetime): de datum waarop het examen start.

@comment (varchar(max)): eventuele opmerkingen die voor het examen gelden.

##### Relaties met tables

EXAM, COURSE

##### Foutmeldingen

60001: ‘exam cannot be null’

60007: ‘course_id cannot be null’

60008: ‘exam_name cannot be null’

60010: ‘starting_date cannot be null or before the current date’

#### pr_insert_class

##### Functie

Laat een gebruiker een klas toevoegen.

##### Use case 

Student beheren

##### Gebruik procedure

        exec pr_insert_class 
                @class = 'new class'

@class (varchar(20)): de naam van een al bestaande klas.

##### Relaties met tables

EXAM_FOR_STUDENT

##### Foutmeldingen

60011: ‘class cannot be null’

#### pr_insert_student

##### Functie

Laat een gebruiker een student toevoegen.

##### Gebruik procedure

        exec pr_insert_student
                @student_no = 1,
                @class = 'class name'
                @first_name = 'first name',
                @last_name = 'last name',

@student_no (int) : nieuw studentnummer.

@class (varchar(20)) : klas waarin de student zit.

@first_name (varchar(30)) : voornaam van de nieuwe student.

@last_name (varchar(50)) : achternaam van de nieuwe student.

##### Relaties met tables

STUDENT

##### Foutmeldingen

60012: ‘student_no cannot be NULL’

60011: 'class cannot be NULL'

60013: ‘first_name cannot be NULL’

60014: ‘last_name cannot be NULL’


### GRADING PROCEDURES

#### pr_check_all_answers_in_exam_without_group

##### Fucntie

Kijkt alle antwoorden van het examen. 

##### Use case 

N.v.t.

##### Roept procedure aan 

	pr_check_all_answers_for_exam

##### Gebruik procedure 
	
	pr_check_all_answers_in_exam_without_group
		@exam_id = 1 
		
@exam_id varchar(20): Het examen die moet worden nagekeken

##### Relaties met tables

EXAM_GROUP_IN_EXAM

##### Foutmeldingen

60001: 'exam_id cannot be null'

#### pr_check_all_answers_for_exam

##### Functie 

Loopt over alle antwoorden die nog niet gecontroleerd zijn en controleerd deze.

##### Use case 

N.v.t.

##### Gebruik procedure 

	pr_check_all_answers_for_exam
		@exam_group_type = 'STANDAARD',
		@exam_id = 'ITA-1A'

@exam_group_type varchar(20): De soort groep van de student, zoals standaard
@exam_id varchar(20): Het examen die moet worden nagekeken

##### Roept procedure aan 
pr_check_answer

##### Relaties 

EXAM_GROUP_IN_EXAM, ANSWER, EXAM_FOR_STUDENT

###### Foutmeldingen

60015: 'exam_group_type cannot be null'
60001: 'exam_id cannot be null'

#### pr_check_answer

##### Fucntie

Kijkt de antwoorden na 

##### Use case 

N.v.t. 

##### Gebruik procedure 

	pr_check_answer
		@question_no = 1,
		@exam_id = 'id',
		@student_no = 1
		
@question_no int: the question that has to be checked
@exam_id varchar(20): In what exam was the answer given
@student_no int: Which student gave the answer

##### Relaties

QUESTION, ANSWER, CORRECT_ANSWER, ANSWER_CRITERIA

##### Foutmeldingen

60101: 'Database required for question is not available'
60111: 'Answer uses an illicit word'
60112: 'Answer does not include the required statements'
60102: 'Statement not executable'
60103: 'Queries do not return same rows'
60104: 'Queries do not return same columns'

#### pr_calculate_results_for_exam

##### Fucntie

Berekent de cijfers van studenten voor een examen

##### Use case 

N.v.t. 

##### Gebruik procedure 

	pr_calculate_results_for_exam
		@exam_id = 'id'
		
@exam_id varchar(20): The exam which has to be graded.

##### Relaties

ANSWER, QUESTION_IN_EXAM, EXAM_FOR_STUDENT

##### Foutmeldingen

60001: 'exam_id cannot be null'

### OVERIG 

#### pr_schedule_exam_job

##### Functie

Opent een job die op een bepaald moment kan worden aangeroepen

##### Use case 

N.v.t.

##### Roept procedure aan 

	msdb.dbo.sp_delete_job
	msdb.dbo.sp_add_job
	msdb.dbo.sp_add_jobstep
	msdb.dbo.sp_add_schedule
	msdb.dbo.sp_attach_schedule 
	msdb.dbo.sp_add_jobserver  
	 
##### Gebruik procedure 

	pr_schedule_exam_job
		@exam_id = 1 
		@starting date = '2008-11-11 13:23:44'

##### Relaties

N.v.t.

##### Foutmeldingen

N.v.t.

#### pr_prepare_exam_databases

##### Functie

Maakt de database klaar voor een examen

##### Use case 

N.v.t. 

##### Roept procedure aan 

	 pr_create_database @exam_db_name
     pr_execute_ddl @exam_db_name
     pr_execute_dml @exam_db_name
	 
##### Gebruik procedure

	pr_prepare_exam_databases
		@exam_id = 1
		
@exam_id nvarchar(40): Het examen waarvan de database moet worden voorbereid

##### Relaties

QUESTION_IN_EXAM

##### Foutmeldingen

N.v.t.

#### pr_manipulate_population_of_current_database

##### Functie

Manipuleert de data van de huidige database. Als de procedure aangeroepen wordt in database: A, manipuleerd hij de data van database A.

Het manipuleren van de data gebeurt op de volgende manier:

| Datatype | Verandering                                         | Vb. originele waarde      | Vb. aangepaste waarde     |
|----------|-----------------------------------------------------|---------------------------|---------------------------|
| varchar  | Eerste 3 letters overhouden van de originele waarde | 'Jackson'                 | 'Jac'                     |
| nvarchar | Eerste 3 letters overhouden van de originele waarde | 'Peter'                   | 'Pet'                     |
| char     | Eerste 3 letters overhouden van de originele waarde | 'A79HDO6'                 | 'A79'                     |
| int      | Originele waarde + 1                                | 12                        | 13                        |
| numeric  | Originele waarde + 1                                | 7                         | 8                         |
| datetime | Originele waarde + 1 dag                            | '1998-01-02 00:00:00.000' | '1998-01-03 00:00:00.000' |
| date     | Originele waarde + 1 dag                            | '2020-11-25'              | '2020-11-26'              |

##### Gebruik procedure

        exec pr_manipulate_population_of_current_database 

##### Relaties met tables

**ALLE TABELLEN VAN DE DATABASE**

#### Foutmeldingen

60163: 'procedure pr_manipulate_population_of_current_database cannot be used on database: HAN_SQL_EXAM_DATABASE'

#### pr_manipulate_population_of_other_database

##### Functie

Maakt de procedure [pr_manipulate_population_of_current_database](###pr_manipulate_population_of_current_database) aan op de gegeven database en roept deze vervolgens aan. 

##### Gebruik procedure

        exec pr_manipulate_population_of_other_database 
                @exam_db_name = 'ChairsDB'

@exam_db_name (varchar(40)): De naam van de database waarvan de populatie gemanipuleerd moet worden.

##### Relaties met tables

--

##### Foutmeldingen

60052: 'Given database is unknown, please add an exam database first'

#### pr_create_database

##### Fucntie

Maakt een database aan. 

##### Use case 

DDL en DML script beheren

##### Gebruik procedure

	pr_create_database
		@exam_db_name = 'MuziekdatabaseExtended'

@exam_db_name varchar(40): De unieke naam van een database

##### Relaties

N.v.t.

##### Foutmeldingen

60004: 'exam_db_name cannot be null

#### pr_drop_ddl

##### Functie 

Verwijderd de instantie van de database 

##### Use case 

DDL en DML script beheren

##### Gebruik procedure

	pr_drop_ddl
		@exam_db_name = 'MuziekdatabaseExtended'
		
@exam_db_name varchar(40): De unieke naam van een database

##### Relaties

EXAM_DATABASE

##### Foutmeldingen

60004: 'exam_db_name cannot be null'
60157: 'The provided database name does not exist'

#### pr_drop_exam_database_population

##### Functie

Laat een gebruiker data van een examen database verwijderen zodat deze opnieuw kan
worden toegevoegd.

##### Use case 

DDL en DML script beheren

##### Gebruik procedure

        exec pr_drop_exam_database_population
                @exam_db_name = 'chairsDB',

@exam_db_name (varchar(40)): De naam van de bestaande database

##### Relaties met tables

EXAM_DATABASE

##### Foutmeldingen

60004: 'exam_db_name cannot be null'

60155: 'The provided database name does not exist'

#### pr_execute_dml

##### Functie

Voert het DML uit voor de database met de gegeven naam.

##### Use case 

DDL en DML script beheren

##### Gebruik procedure

        exec pr_execute_dml
                @exam_db_name = 'ChairsDB'

@exam_db_name (nvarchar(40)): De naam van de database waar het DML uitgevoerd van moet worden

##### Relaties met tables

EXAM_DATABASE

##### Foutmeldingen

60004: 'exam_db_name cannot be null'

60202: 'Database associated with name not found'

60201: 'Database required for script is not available'

#### pr_execute_ddl

##### Functie

Voert het DML uit voor de database met de gegeven naam.

##### Use case 

DDL en DML script beheren

##### Gebruik procedure

        exec pr_execute_dml
                @exam_db_name = 'ChairsDB'

@exam_db_name (nvarchar(40)): De naam van de database waar het DDL uitgevoerd van moet worden

##### Relaties met tables

EXAM_DATABASE

##### Foutmeldingen

60004: 'exam_db_name cannot be null'

60202: 'Database associated with name not found'

60201: 'Database required for script is not available'

#### pr_hand_in_exam

##### Functie

Geeft het moment op waarop de student het antwoord heeft ingeleverd, tevens insert het alle onbeantwoorde vragen van een student.

##### Use case 

Vraag beantwoorden

##### Gebruik procedure

        exec pr_hand_in_exam
                @student_no = 1,
                @exam_id = 'exam_id'

@student_no (int): Het studentnummer van de student die het examen inlevert

@exam_id (varchar(20)): Het examen dat ingeleverd moet worden

##### Relaties met tables

EXAM, EXAM_FOR_STUDENT, QUESTION_IN_EXAM, ANSWER

##### Foutmeldingen

60012: 'student_no cannot be null'

60001: 'exam_id cannot be null'

60053: 'Student is not signed up for exam'

#### pr_set_pending_correct_answer_to_false

##### Functie 

Zet de vraag naar naar fout

##### Use case 

N.v.t. 

##### Gebruik procedure 

	pr_set_pending_correct_answer_to_false
		@student_no = 1,
		@exam_id = 'ITA-1A',
		@question_no = 1

@student_no int: De student die de vraag heeft beantwoord
@exam_id varchar(40): Het examen waar de student aan heeft meegedaan
@question_no int: Het nummer van de vraag die de student heeft beantwoord

##### Relaties

ANSWER

##### Foutmeldingen

60012: 'student_no cannot be NULL'
60001: 'exam_id cannot be null'
60002: 'question_no cannot be null'

#### pr_set_pending_correct_answer_to_true

##### Functie 

Zet de vraag naar naar correct en verplaats hem naar de lijst met correcte antwoorden

##### Use case 

N.v.t. 

##### Gebruik procedure 

	pr_set_pending_correct_answer_to_true
		@student_no = 1,
		@exam_id = 'ITA-1A',
		@question_no = 1

@student_no int: De student die de vraag heeft beantwoord
@exam_id varchar(40): Het examen waar de student aan heeft meegedaan
@question_no int: Het nummer van de vraag die de student heeft beantwoord

##### Roept procedure aan 

	pr_insert_correct_answer
		@question_no = @question_no, 
		@correct_answer_statement = @correct_answer

##### Relaties

ANSWER

##### Foutmeldingen

60012: 'student_no cannot be NULL'
60001: 'exam_id cannot be null'
60002: 'question_no cannot be null'

### REPORTING PROCEDURES

#### pr_select_results_into_json

##### Functie

Haalt resultaten op voor de staging database in JSON format

##### Use case 

Overzicht bekijken van behaalde resultaten

##### Gebruik procedure

	pr_select_results_into_json
	
##### Relaties

EXAM, EXAM_FOR_STUDENT, ANSWER

##### Foutmeldingen

N.v.t.

### SELECT 

#### pr_select_highest_end_date_from_exam

##### Functie 

Selecteerd de hoogste eind tijd van een examen. 

##### Use case 

N.v.t.

##### Gebruik procedure

	DECLARE @highest_hand_in_date DATETIME
	pr_select_highest_end_date_from_exam
		@exam_id = 1
		@highest_hand_in_date = @highest_hand_in_date
		
		SELECT @highest_hand_in_date
		
##### Relaties met tables 

EXAM_GROUP_IN_EXAM

##### Foutmeldingen

N.v.t.	

#### pr_select_pending_correct_answers_for_exam

##### Fucntie 

Haalt de vragen op die goed zijn gekeurd door ons systeem, echter nog niet door de leraar

##### Use case 
N.v.t.

##### Gebruik procedure

	pr_select_pending_correct_answers_for_exam
		@exam_id = 'ITA-1A'
		
@exam_id varchar(40): Het examen waar de vragen moeten worden uitgehaald
		
##### Relaties 

ANSWER, REASON

##### Foutmeldingen

60001: 'exam_id cannot be null'

#### pr_select_results_for_student_answer

##### Fucntie 

Haalt de resultaten op van een student per antwoord

##### Use case 

Overzicht bekijken van behaalde resultaten 

##### Gebruik procedure 

	 pr_select_results_for_student_answer
		@question_no = 1,
		@exam_id = 'ITA-1A',
		@student_no = 1 

@student_no int: De student die de vraag heeft beantwoord
@exam_id varchar(40): Het examen waar de student aan heeft meegedaan
@question_no int: Het nummer van de vraag die de student heeft beantwoord

##### Relaties

ANSWER, QUESTION
			
##### Foutmeldingen

60012: 'student_no cannot be NULL'
60001: 'exam_id cannot be null'
60002: 'question_no cannot be null'

#### pr_select_students_from_class

##### Functie

Geeft alle studenten terug die een toets heeft gemaakt terwijl ze in de meegegeven klas zaten.

##### Use case 

Examen beheren

##### Gebruik procedure

        exec pr_select_students_from_class 
                @class = 'class'

@class (varchar(20)): de naam van de klas.

##### Relaties met tables

EXAM_FOR_STUDENT, STUDENT

##### Foutmeldingen

60011: ‘class cannot be null’

#### pr_select_students_from_group

##### Functie

Geeft alle studenten terug die een toets heeft gemaakt terwijl ze in de meegegeven groep zaten.

##### Use case 

Examen beheren

##### Gebruik procedure

        exec pr_select_students_from_group 
                @exam_group_type = 'Standaard'

@exam_group_type (varchar(20)): het soort groep dat een examen gaat maken.

##### Relaties met tables

EXAM_FOR_STUDENT, STUDENT

##### Foutmeldingen

60015: ‘exam_group_type cannot be null’

#### pr_select_questions_in_exam

##### Functie

Laat de gebruiker aan de hand van een aantal gegevens een vragenlijst zijn van een of meerdere examens.

##### Use case 

Vraag beantwoorden

##### Gebruik procedure

        exec pr_select_questions_in_exam 
                @exam_id = 'DI-3'

@exam_id (varchar(20)): toont alle vragen voor een specifiek examen

##### Foutmeldingen

60001: 'exam_id cannot be null'

#### pr_select_all_answers_for_exam

##### Functie
Geeft de leraar de mogelijkheid alle vragen uit een examen te halen. 

##### Use case 
N.v.t.

##### Gebruik procedure
	EXEC pr_select_all_answers_for_exam
		@exam_id = 1
	
@exam_id varchar(20): Het nummer van het examen waarvan de vragen worden opgehaald

##### Relaties met tables 

ANSWER, STUDENT, REASON

##### Foutmeldingen
60001 'exam_id cannot be null'

#### pr_select_answers_for_exam_per_student

##### Functie
Geeft de leraar de mogelijkheid om de beantwoorde vragen per student op te halen. 

##### Use case 

Examen beheren

##### Gebruik procedure
	EXEC pr_select_answers_for_exam_per_student
		@exam_id = 1,
		@student_no = 5
		
@exam_id varchar(20): Het nummer van het examen waarvan de vragen worden opgehaald
@student_no int: Het nummer van de student waarvan de vragen worden opgehaald

##### Relaties met tables 
ANSWER, REASON, STUDENT

##### Foutmeldingen
60001 'exam_id cannot be null'
60012 'student_no cannot be NULL'

#### pr_select_correct_answer_from_question

##### Functie
Geeft de leraar de mogelijkheid om van een vraag de goede antwoorden op te halen

##### Use case 

Examen beheren

##### Gebruik procedure 
	EXEC pr_select_correct_answer_from_question
		@question_no = 5 
		
@question_no int: Het nummer van de vraag waarvoor de goede antwoorden moeten worden opgehaald

##### Relaties met tables
CORRECT_ANSWER

##### Foutmeldingen
60002 'question_no cannot be null'

#### pr_select_all_question_assignments_from_exam

##### Functie

retouneert alle vragen/opdrachten van het gegeven examen.

##### Use case 

Examen beheren

##### Gebruik procedure

        exec pr_select_all_question_assignments_from_exam
                @exam_id = 'examId',

@exam_id (varchar(20)): Het examen waar de vragen/opdrachten geretouneerd van moeten worden.

##### Relaties met tables

QUESTION, QUESTION_IN_EXAM

##### Foutmeldingen

60001: 'exam_id cannot be null'

### UPDATE

#### pr_update_question

##### Functie

Laat een gebruiker een vraag updaten waarbij de db_name, question_assignment en question_points geupdate kunnen worden.

##### Use case 

Examen beheren

##### Gebruik procedure

        exec pr_update_question 
                @question_no = 1,
                @difficulty VARCHAR(10),
                @exam_db_name VARCHAR(20),
                @question_assignment VARCHAR(MAX),
                @comment VARCHAR(MAX),
                @remove_comment BIT

@question_no (int): Het nummer van de vraag die geupdate moet worden

@difficulty (varchar(10)): De nieuwe moeilijkheidsgraad van de vraag
 
@exam_db_name (varchar(20)): De nieuwe database die de vraag gebruikt

@question_assignment (varchar(max)): De nieuwe opdracht of vraag die de student moet uitvoeren of beantwoorden

@comment (varchar(max)): Het nieuwe commentaar wat bij de vraag hoort

@remove_comment (bit): Geeft aan of het bestaande commentaar verwijderd moet worden. 

##### Relaties met tables

QUESTION_IN_TEST, TEST, TEST_DATABASE

##### Foutmeldingen

60002: ‘question_no cannot be null’

60004: ‘exam_db_name cannot be null’

60005: ‘question_assignment cannot be null’

60024: ‘difficulty cannot be null’

60151: 'questions may not be changed once they are used in an exam that has been taken'

#### pr_update_correct_answer

##### Functie

Laat een gebruiker een correct antwoord updaten.

##### Use case 
Examen beheren

##### Gebruik procedure

        exec pr_update_correct_answer 
                @question_no = 1, 
                @correct_answer_id = 1, @correct_answer_statement = 'select * from table'

@question_no (int): het vraagnummer waarop het antwoord van toepassing is

@correct_answer_id (smallint): het correcte antwoord id dat aangepast moet worden

@correct_answer_statement (varchar(max)): het correcte antwoord

##### Relaties met tables

CORRECT_ANSWER, QUESTION

##### Foutmeldingen

60002: ‘question_no cannot be null’

60003: ‘correct_answer_statement cannot be null’

60025: ‘correct_answer_id cannot be null’

#### pr_update_class

##### Functie

Laat een gebruiker een klas bewerken.

##### Use case 
Examen beheren

##### Gebruik procedure

        exec pr_update_class 
                @class_id_old = 'old class',
                @class_id_new = 'new class'

@class_id_old (varchar(20)): de naam van een al bestaande klas.

@class_id_new (varchar(20)): de naam van de nieuwe bestaande klas.

##### Relaties met tables

EXAM_FOR_STUDENT

##### Foutmeldingen

60018: ‘class_id_new cannot be NULL’

60019: ‘class_id_old cannot be NULL’

#### pr_update_exam_group

##### Functie

Laat een gebruiker een groep veranderen

##### Use case 
Examen beheren

##### Gebruik procedure

        exec pr_update_exam_group 
                @old_exam_group_type = 'oude examengroep naam'
                @new_exam_group_type = 'nieuwe examengroep naam'


@old_exam_group_type (varchar(20)) : het te vervangen groepsnaam.

 @new_exam_group_type (varchar(20)) : het nieuwe groepsnaam.

##### Relaties met tables

EXAM_FOR_STUDENT, EXAM_GROUP_IN_EXAM

##### Foutmeldingen

60020: ‘old_exam_group_type cannot be NULL'

60021: ‘new_exam_group_type cannot be NULL'


#### pr_update_student

##### Functie

Laat een gebruiker een student bewerken.

##### Use case 

Student beheren

##### Gebruik procedure

        EXEC pr_update_student
                @student_no = 1,
                @class = 'klasnaam',
                @first_name = 'first name',
                @last_name = 'last name'

@student_no (int) : huidig studentnummer.

@class (varchar(20)) : de klas waarin de student zit 

@first_name (varchar(30)) : nieuw voornaam van de student.

@last_name (varchar(50)) : nieuwe achternaam van de student.

##### Relaties met tables

STUDENT

##### Foutmeldingen

60012: ‘student_no cannot be NULL’

60011: 'class cannot be NULL'

60013: ‘first_name cannot be NULL’

60014: ‘last_name cannot be NULL’

#### pr_update_answer_criteria

##### Functie

Laat een gebruiker een sleutelwoord voor een vraag updaten waarbij keyword en criteria_type geupdate kunnen worden.

##### Use case 
Examen beheren

##### Gebruik procedure

        EXEC pr_update_answer_criteria 
                @question_no = 1, 
                @keyword_old = 'JOIN', 
                @keyword_new = 'Exists',
                @criteria_type = 'banned'

@question_no (int): het nummer van de vraag waar het sleutelwoord voor is

@keyword_old (varchar(30)): het huidige sleutelwoord

@keyword_new (varchar(30)): het eventuele nieuwe sleutelwoord

@criteria_type (varchar(30)): De regel die bij het sleutelwoord hoord

##### Relaties met tables

ANSWER_CRITERIA, EXAM_GROUP_IN_EXAM

##### Foutmeldingen

60002: 'question_no cannot be null'

60022: 'keyword_old cannot be null'

60023: 'keyword_new cannot be null'

60017: 'criteria_type cannot be null'

60154: 'A keyword for a question may not be changed once the question has been used in an exam that has been taken'


#### pr_update_exam_database

##### Functie

Laat een gebruiker voor een huidige database de DDL en DML scripts updaten.

##### Use case 

Examen beheren

##### Gebruik procedure

        exec pr_update_exam_database
                @exam_db_name = 'chairsDB',
                @exam_ddl_script = 'create table CHAIRS(...)',
                @exam_dml_script = 'insert into CHAIRS (...) values (...)'

@exam_db_name (varchar(40)): De naam van de bestaande database

@exam_ddl_script (varchar(max)): Het nieuwe DDL script voor de bestaande database 

@exam_dml_script (varchar(max)): Het nieuwe DML script voor de bestaande database 

##### Relaties met tables

EXAM_DATABASE

##### Foutmeldingen

60004: 'exam_db_name cannot be null'

60027: 'exam_ddl_script cannot be null'

60028: 'exam_dml_script cannot be null'

#### pr_update_answer

##### Functie

Laat een student zijn antwoord updaten op een vraag van een examen.

##### Use case 
Examen beheren

##### Gebruik procedure

        exec pr_update_answer
                @student_no = 1,
                @exam_id = 'examId',
                @question_no = 2,
                @answer = 'SELECT * FROM FLOORS'

@student_no (int): Het studentnummer van de student die zijn antwoord wilt updaten

@exam_id (varchar(20)): Het examen waar de student zijn antwoord voor wilt updaten

@question_no (int): De vraag waar de student zijn antwoord voor wilt updaten

@answer (varchar(max)): Het nieuwe antwoord dat de student wilt inleveren

##### Relaties met tables

ANSWER, EXAM_GROUP_IN_EXAM, EXAM_FOR_STUDENT

##### Foutmeldingen

60012: 'student_no cannot be NULL'

60001: 'exam_id cannot be null'

60002: 'question_no cannot be null'

60009: 'answer cannot be null'

60160: 'An answer can only be modified while the exam is taking place'

#### pr_update_ddl

##### Functie 

Vervangt het bestaande DDL-script met een ander

##### Use case 

Examen beheren

##### Gebruik procedure

	pr_update_ddl
		@exam_db_name = 'MuziekdatabaseExtended',
		@ddl_script = 'CREATE'
		
@exam_db_name varchar(40): De naam van de database
@ddl_script varchar(max): Het nieuwe DDL script

##### Relaties

EXAM_DATABASE

##### Foutmeldingen

60004: 'exam_db_name cannot be null'
60030: 'ddl_script cannot be null'
60050: 'script: ',  @exam_db_name, ' does not exists'

#### pr_update_ddl

##### Functie 

Vervangt het bestaande DML-script met een ander

##### Use case 

Examen beheren

##### Gebruik procedure

	pr_update_ddl
		@exam_db_name = 'MuziekdatabaseExtended',
		@dml_script = 'CREATE'
		
@exam_db_name varchar(40): De naam van de database
@dml_script varchar(max): Het nieuwe DML script

##### Relaties

EXAM_DATABASE

##### Foutmeldingen

60004: 'exam_db_name cannot be null'
60030: 'dml_script cannot be null'
60050: 'script: ',  @exam_db_name, ' does not exists'

##### pr_update_exam

##### Functie
Past de data aan van een examen

##### Use case 
Examen beheren 

##### Gebruik procedure 

	pr_update_exam
		@exam_id = 'ITA-1A',
		@course = 'DI',
		@exam_name = 'scary',
		@starting_date = '2020-06-09 15:30:03.308272'
		@comment = NULL 
	
@exam_id varchar(20): Unieke id van een examen
@course varchar(20): De course waar het examen in plaats vind
@exam_name varchar(50): De naam van het examen
@starting_date DATETIME: De startdatum van het examen
@comment varchar(max): Opmerkingen die bij dit examen horen. 

##### Relaties

EXAM

##### Foutmeldingen

60001: 'exam_id cannot be null'
60007: 'course_id cannot be null'
60008: 'exam_name cannot be null'
60010: 'execution_year cannot be null or before the current year'
60152: 'An exam may not be modified when it is taking place or has taken place already'


#### pr_update_exam_for_student

##### Functie 

Update het examen van een docent

##### Use case 

Student beheren 

##### Gebruik procedure 

	pr_update_exam_for_student
		@exam_id = 'ITA',
		@student_no = 1,
		@class = 'ITA-1A',
		@exam_group_type 'STANDARD',
		@result = 7
of 

	pr_update_exam_for_student
		@exam_id = 'ITA',
		@student_no = 1,
		@class = 'ITA-1A',
		@exam_group_type 'STANDARD',
		@result = NULL

##### Relaties

EXAM_FOR_STUDENT

##### Foutmeldingen

60001: 'exam_id cannot be NULL'
60012: 'student_no cannot be NULL'
60011: 'class cannot be NULL'
60015: 'exam_group_type cannot be NULL'

