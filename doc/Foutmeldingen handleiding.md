Foutmeldingen handleiding
=========================

Inleiding
---------

In dit document staan alle gespecialiseerde verschillende foutmeldingen die
specifiek in dit systeem kunnen voorkomen. Bij elke foutmelding staat wat deze foutmelding
weergeeft en hoe deze foutmelding opgelost kan worden.

Categorie 60001 t/m 60050: Invalid value
-----------------------------------

Elk van de volgende foutmeldingen verschijnt wanneer er een invalide waarde
wordt meegegeven als parameter van een stored procedure. Om dit op te lossen
moet deze waarde worden veranderd naar het juiste type, die beschreven staat bij
elke foutmelding.

| Error code | Message | Problem | Solution |
|------------|---------|---------|----------|
| 60001      | ‘exam_id cannot be NULL’                                   | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(20) value                                          |
| 60002      | ‘question_no cannot be NULL’                               | An invalid null value has been provided where it is not allowed                                | Provide a INT value                                                  |
| 60003      | ‘correct_answer_statement cannot be NULL’                  | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(MAX) value                                         |
| 60004      | ‘exam_db_name cannot be NULL’                              | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(40) value                                          |
| 60005      | ‘question_assignment cannot be NULL’                       | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(MAX) value                                         |
| 60006      | ‘question_points cannot be NULL or 0’                      | An invalid null or 0 value has been provided where it is not allowed                           | Provide a SMALLINT value that is larger than 0                       |
| 60007      | ‘course_id cannot be NULL’                                 | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(20) value                                          |
| 60008      | ‘exam_name cannot be NULL’                                 | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(50) value                                          |
| 60009      | ‘answer cannot be NULL’                                 | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(MAX) value                                          |
| 60010      | ‘starting_date cannot be NULL or before the current date’ | An invalid null or lower than the current date value has been provided where it is not allowed | Provide a DATETIME value that is the current date or a date in the future |
| 60011      | ‘class_id cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(20) value                                          |
| 60012      | ‘student_no cannot be NULL’                                | An invalid NULL has been provided where it is not allowed                                      | Provide a INT value                                                  |
| 60013      | ‘first_name cannot be NULL’                                | An invalid NULL has been provided where it is not allowed                                      | Provide a VARCHAR(30) value                                          |
| 60014      | ‘last_name cannot be NULL’                                 | An invalid NULL has been provided where it is not allowed                                      | Provide a VARCHAR(50) value                                          |
| 60015      | ‘exam_group_type cannot be NULL’                                  | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(20) value                                          |
| 60016      | ‘keyword cannot be NULL’                                   | An invalid null value has been provided where it is not allowed                                | Provide a VARCHAR(30) value                                          |
| 60017      | ‘criteria_type cannot be NULL’                             | An invalid null value has been provided where it is not allowed                                | Provide a known criteria type                                        |
| 60018      | ‘class_id_new cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(20) value                                          |
| 60019      | ‘class_id_old cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(20) value                                          |
| 60020      | ‘old_exam_group_type cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(20) value                                          |
| 60021      | ‘new_exam_group_type cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(20) value                                          |
| 60022      | ‘keyword_old cannot be NULL'                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(30) value                                          |
| 60023      | ‘keyword_new cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(30) value                                          |
| 60024      | ‘difficulty cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(10) value                                          |
| 60025      | ‘correct_answer_id cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a SMALLINT value                                          |
| 60026		 |‘Query_statement cannot be NULL’								|	An invalid null has been provided where it is not allowed										|	Provide a VARCHAR(MAX) value							|
| 60027      | ‘exam_ddl_script cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(MAX) value                                          |
| 60028      | ‘exam_dml_script cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a VARCHAR(MAX) value                                          |
| 60029      | ‘answer_fill_in_date must be between the starting and end date of the corresponding exam’                                  | An invalid value has been provided where it is not allowed                                      | Provide a date for the answer that is between the starting date and end date of the corresponding exam                                          |
| 60030      | ‘end_date must be after starting_time’                                  | The end date of an exam must be after the starting time of the corresponding exam                                      | Provide a date which is after the starting date of the corresponding exam                                          |
| 60031      | ‘Student: <student_no> is already registered for exam: <exam_id>'            |  The student is already registered for the given exam | Provide a different student or exam |
| 60032      | ‘class does not exist'            |  The given class cannot be found in the CLASS look-up table | Provide a existing class or make a class |
| 60033      | ‘group does not exist'            |  The given group cannot be found in the GROUP look-up table | Provide a existing group or make a class |
| 60037      | ‘end_date cannot be before getdate()’  | An invalid value has been provided where it is not allowed    | Provide a DATE value       |
| 60034      | ‘is_dyslexic cannot be NULL’                                  | An invalid null has been provided where it is not allowed                                      | Provide a bit value                                          |
| 60035      | ‘end_date cannot be NULL’  | An invalid null has been provided where it is not allowed    | Provide a DATE value       |
| 60036      | ‘scheduled date cannot be in the past’  | A date has been provided that has already passed    | Provide a DATE value later than the currect date       |


Categorie 60051 t/m 60100: unknown value
----------------------------------------

De foutmeldingen in deze categorie verschijnen wanneer een refererende waarde is
opgegeven die nog niet bestaat in het systeem, zoals bijvoorbeeld een exam_id of
question_no.

| **Error code** | **Message**                                                   | **Problem**                                                      | **Solution**                                                                  |
|----------------|---------------------------------------------------------------|------------------------------------------------------------------|-------------------------------------------------------------------------------|
| 60051          | ‘Given exam Id is unknown, please add an exam first’           | The given exam Id does not exist as a test yet in the table EXAM | Add this test to the EXAM table or change the exam_id to an existing exam     |
| 60052          | ‘Given database is unknown, please add an exam database first’ | The given database does not exist yet in the table EXAM_DATABASE | Add this database to the EXAM_DATABASE table or use an existing exam database |
| 60053          | ‘Student is not signed up for exam’ | The exam cannot be handed in because the student was never assigned to it |Make sure the student is signed up for the right exam |
| 60054          | ‘exam group has not been created yet for this exam’ | A student cannot be asigned to an exam unless an exam group is created for it |Make sure to create an exam group before asigning students to the exam |

Categorie 60101 t/m 60150: SQL verification
-------------------------------------------

De foutmeldingen in deze categorie verschijnen bij het vergelijken en
controleren van SQL statements, zoals bijvoorbeeld een antwoord op een
vraag

| **Error code** | **Message**                                       | **Problem**                                                                                                                                                                                   | **Solution**                                                                                       |
|----------------|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| 60101          | ‘Database required for question is not available’ | The database associated with the question currently being graded is unaccessable. This may mean that de DDL script has not yet been executed or an error connection to said database occured. | Rerun the DDL script and check the naming of the database in both the script as the db_name column |
| 60102          | ‘Statement not executable’                        | The SQL statement being graded is not executable                                                                                                                                              | No action needed (Student error)                                                                   |
| 60103          | ‘Queries do not return same rows’                 | The SQL statement being graded does not return the same records as the correct statement does                                                                                                 | No action needed (Student error)                                                                   |
| 60104          | ‘Queries do not return same columns’              | The SQL statement being graded does not return the same columns as the correct statement does                                                                                                 | No action needed (Student error)                                                                   |
|60105			 |‘Statement contains illicit drop statement’		 |The SQL statement provided contains an illicit drop statement																																	 |Remove the illicit statement																		  |
|60106			 |‘Statement contains illicit delete statement’		 |The SQL statement provided contains an illicit delete statement																																 |Remove the illicit statement																		  |
|60107			 |‘Statement contains illicit comment characters’	 |The SQL statement provided contains illicit comment characters																																 |Remove all comments from the provided statement													  |
|60108			 |‘Statement contains illicit create statement’		 |The SQL statement provided contains illicit create database statements																														 |Remove the illicit statement																		  |
|60109			 |‘Statement contains illicit update statement’		 |The SQL statement provided contains an illicit update statement																																 |Remove the illicit statement																		  |
|60110			 |'No answer was provided by the student'		 |The student did not provide an answer for the specified question																																 | -																	  |
|60111			 |'Answer uses an illicit word'		 |The student used a banned statement or word in the answer																																 | -																	  |
|60112			 |'Answer does not include the required statements'		 |The student did not use the required words or statements in the answer																																 | -																	  |


Categorie 60151 t/m 60200: disallowed modification
--------------------------------------------------

De foutmeldingen in deze categorie verschijnen wanneer een modificatie aan
bestaande waardes worden gedaan waar dat niet is toegestaan.

| **Error** | **Message**                                                                      | **Problem**                                                                                              | **Solution**                                                                                                      |
|-----------|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| 60151     | 'questions may not be changed once they are used in an exam that has been taken' | A question that has been used in a previous exam is failing to be modified                               | A question may not be modified once it is used in a taken exam. You cannot update this question                   |
| 60152     | 'An exam may not be modified when it is taking place or has taken place already' | An exam that is taking place or has taken place is failing to be modified                                | For an exam, only the comment may be modified once the exam has taken place or is taking place                    |
| 60153     | ‘At least one correct answer must be provided for a question’                    | This issue occurs when only one correct answer is provided for a question which is failing to be removed | A question must at least have one correct answer, either add another correct answer or modify the existing answer |
| 60154 | 'A keyword for a question may not be changed once the question has been used in an exam that has been taken' | A keyword for a question that has been used in a previous exam is failing to be modified | A keyword for a question may not be modified once it is used in a taken exam. You cannot update this keyword |
| 60155     | ‘Questions may not be added to an exam that has taken place’                     | An exam is failing to be modified                                                                        | A question may not be added to an exam that has taken place or is taking place, create a new exam                 |
| 60156 | 'The end date is not allowed to be modified after the exam has been taken place' | The user tried to update the end date of an exam that has already been taken place | - |
| 60157 | 'The provided database name does not exist' | A keyword for a database name is incorrect/non-existent | Provide an existing database name |
| 60158     | 'An answer cannot be submitted before the begin_date of an exam' | An answer may not get submitted before the exam has started | Wait untill the exam has started and resubmit the answer |
| 60159     | 'An answer cannot be submitted after the end_date of an exam' | An answer may not get submitted after the exam has been taken place | - |
| 60160     | 'An answer can only be modified while the exam is taking place' | An answer may not modified before or after the exam has been taken place | - |
| 60161     | 'you cannot asign a student to an exam that has taken place already' | A student may not be asigned to an exam that has taken place already | - |
| 60162     | 'you cannot remove a student from an exam that has taken place already' | A student may not be removed from an exam that has taken place already | - |
| 60163     | 'procedure pr_manipulate_population_of_current_database cannot be used on database: HAN_SQL_EXAM_DATABASE' | The system tries to manipulate the data of the HAN_SQL_EXAM_DATABASE database, this is not allowed. | - |


Categorie 60201 t/m 60250: Exam database creation and usage errors
--------------------------------------------------

De foutmeldingen in deze categorie verschijnen wanneer er bij het gebruiken en maken van de examen databases die aan vragen zijn gekoppeld fouten verschijnen.

| **Error** | **Message**                                                                      | **Problem**                                                                                              | **Solution**                                                                                                      |
|-----------|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| 60201     | 'Database required for script is not available' 								   | The database corresponding with the name given in the EXAM_DATABASE table does not exist or is unreachable. | Run pr_create_database with the name of the required database							                      |
| 60202     | 'Database associated with name not found' 								  	   | no database could be found for the given name 															  | Give a name present in the EXAM_DATABASE table or create a new record with said name.		                      |
