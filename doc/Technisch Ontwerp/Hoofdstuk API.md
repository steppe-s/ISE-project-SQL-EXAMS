API Omschrijving
----------------

Voor de API hebben we gebruik gemaakt van Stored Procedures, maar om de Stored Procedures vollediger te maken en goed te documenteren hebben we dit opgedeeld in meerdere onderdelen.

De complete API bestaat uit:
- Stored Procedures API
- Stored Procedures Code
- Foutmeldingen Handleiding
- Unit Tests
- Belangrijke Processen in de API
- Use Case koppeling met de code
- Staging

## Stored Procedures API

Voor elke Stored Procedure is er beschreven:
- Wat de naam van de procedure is
- Wat deze procedure doet 
- Op welke tabellen uit het CDM de procedure van invloed is
- Hoe de procedure gebruikt moet worden
- Welke foutmeldingen de procedure terug kan geven

Een voorbeeld hiervan uit de Stored Procedures API is:
> ***pr_connect_question_to_exam***

> **Functie**: Laat een gebruiker een vraag toevoegen aan een bestaand examen.

> **Gebruik Procedure**
```sql
EXECUTE pr_connect_question_to_exam 
    @exam_id = 'examId', 
    @question_no = 1, 
    @question_points = 20
```
> **Parameters**
> - @exam_id (VARCHAR(20)): het examen waar de vraag aan toegevoegd moet worden
> - @question_no (INT): de vraag die toegevoegd moet worden aan het examen
> - @question_points (SMALLINT): het aantal punten dat een goed antwoord kan opleveren
> Relaties met tables: EXAM, QUESTION, EXAM_GROUP_IN_EXAM, QUESTION_IN_EXAM

> **Foutmeldingen**
> - 60002: ‘question_no cannot be null’
> - 60001: ’exam_id cannot be null’
> - 60006, 'question_points cannot be null or 0'
> - 60155: ‘questions may not be added to an exam that has taken place’


## Stored Procedures Code

De Stored Procedures zijn in SQL Server geschreven en in mappen gesorteerd op functie, zo zijn er de volgende mappen voor:
- delete
- update
- insert 
- overig
- select
- tests


> Voorbeeld van de uitwerking van ***pr_connect_question_to_exam***
```sql

CREATE OR ALTER PROCEDURE pr_connect_question_to_exam
    @question_no INT,
    @exam_id VARCHAR(20),
    @question_points SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startTC INT = @@TRANCOUNT;
    DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    BEGIN TRY
        BEGIN TRANSACTION
            SAVE TRANSACTION @savepoint;
			IF(@question_no IS NULL)THROW 60002, 'question_no cannot be null', 1;
			IF(@exam_id IS NULL)THROW 60001, 'exam_id cannot be null', 1;
			IF(@question_points IS NULL OR @question_points < 1)THROW 60006, 'question_points cannot be null or 0', 1;

			IF(
                EXISTS(
                    SELECT exam_id 
                    FROM EXAM_GROUP_IN_EXAM 
                    WHERE exam_id = @exam_id AND begin_date < GETDATE()
                )
            )
			THROW 60155, 'questions may not be added to an exam that has taken place', 1;

			INSERT INTO QUESTION_IN_EXAM 
            VALUES(@exam_id, @question_no, @question_points)


        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1 AND @startTC = 0
            ROLLBACK TRANSACTION;
        ELSE
            IF XACT_STATE() = 1
                BEGIN
                    ROLLBACK TRANSACTION @savepoint;
                    COMMIT TRANSACTION;
                END;
        DECLARE @errormessage VARCHAR(2000) =
                'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END
```


## Foutmeldingen Handleiding

De foutmeldingen die kunnen voorkomen en die we afvangen in de Store Procedures zijn allemaal opgenomen in de Foutmeldingen Handleiding onder verschillende categoriën beginnend vanaf nummer 60000, om zo een duidelijk overzicht te hebben van alle foutmeldingen. Het startgetal 60000 is gekozen om zo ook te zorgen dat onze foutmeldingen duidelijk te onderscheiden zijn van de andere SQL foutmeldingen.

De categoriën zijn:
- Categorie 60001 t/m 60050: invalid values
- Categorie 60051 t/m 60100: unknown value
- Categorie 60101 t/m 60150: SQL verification
- Categorie 60151 t/m 60200: disallowed modification

Zo staan de foutmeldingen uit de ***pr_connect_question_to_exam***, 60005 & 60155, er onder verschillende categoriën in:

> Categorie 60001 t/m 60050: not null:
Elk van de volgende foutmeldingen verschijnt wanneer er een invalide NULL-waarde
wordt meegegeven als parameter van een stored procedure. Om dit op te lossen
moet deze waarde worden veranderd naar het juiste type, die beschreven staat bij
elke foutmelding.

> Categorie 60151 t/m 60200: disallowed modification:
De foutmeldingen in deze categorie verschijnen wanneer een modificatie aan
bestaande waardes worden gedaan waar dat niet is toegestaan.

| Error code | Message | Problem | Solution |
|------------|---------|---------|----------|
| 60005      | ‘question_assignment cannot be null’ | An invalid null value has been provided where it is not allowed  | Provide a VARCHAR(MAX) value |
| 60155      | ‘Questions may not be added to an exam that has taken place’ | An exam is failing to be modified | A question may not be added to an exam that has taken place or is taking place, create a new exam |


## Unit Tests

Om de integriteit en kwaliteit van de Stored Procedures te waarborgen hebben we voor elke Stored Procedure ook unit tests geschreven. 

> Een voorbeeld van een unit test, voor ***pr_connect_question_to_exam***, om te testen dat er geen *NULL* ingevoerd kan worden voor een *question_no*.

```sql
CREATE OR ALTER PROCEDURE test_pr_connect_question_to_exam.[test if connect_question_to_exam throws question_no cannot be NULL] 
AS
BEGIN
	
	EXECUTE tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;

	EXECUTE  pr_connect_question_to_exam @question_no = NULL, @exam_id = 'exam_id', @question_points = 1

END
GO
```


## Belangrijke Processen in de API

In de hele code zijn processen die belangrijker zijn voor de opdracht dan andere processen. Enkele van deze essentiële processen zijn:

- 'Toets Maken' Proces


### Toets Maken

- Leraar plant toets in
    - Begin en eindtijd wordt geset voor ingeschreven **EXAM_GROUPS**
    - Docent maakt vragen
    - Docent kiest vragen

- Aanvang toetsmoment
    - De databases die nodig zijn voor het beantwoorden van de vragen uit **TOETS** worden aangemaakt
    - De DDL en DML worden op de databases uitgevoerd
    - ***START TOETS***

- Tijdens de TOETS
    - Studenten kunnen de opdrachten opvragen
    - Studenten kunnen vervolgens de antwoorden PER vraag uploaden
    - Na het uploaden van de antwoorden worden de geselecteerde kolommen(de resultaten van de geuploade query) naar de student teruggestuurd

- EINDTIJD TOETS Bereikt
    - Studenten kunnen geen vragen meer opvragen en beantwoorden
    - Alle geuploade antwoorden worden door het systeem nagekeken
    - De reden waarom een geupload antwoord fout is, wordt opgeslagen

> Activity Diagram
![Activity Diagram voor maken van een toets](BPMN-Diagrams/Toets-maken-activity.png)
 
> BPMN Diagram
![BPMN Diagram voor maken van een toets](BPMN-Diagrams/TOETSMAKEN-2.png) 


## Use Case koppeling met de code
> N.B. <br/>
Op het moment van schrijven zijn nog niet alle use cases geïmplementeerd.
Dit zijn de volgende use cases:
> - Student moet kunnen inloggen

#### Student moet vragen kunnen beantwoorden
- pr_insert_answer
- pr_update_answer
- pr_hand_in_exam

#### Een Leraar moet een DDL en DML script kunnen uploaden.
- pr_insert_exam_database
- pr_update_exam_database

#### Een Leraar moet een set vragen met bijbehorende antwoorden kunnen uploaden.
- pr_insert_question
- pr_insert_answer_criteria
- pr_connect_question_to_exam

- pr_update_question
- pr_update_answer_criteria

- pr_delete_question
- pr_delete_answer_criteria
- pr_delete_answer
- pr_disconnect_question_from_examen

#### Een leraar moet een gegeven antwoord van een student kunnen toevoegen aan de lijst met correcte antwoorden
- pr_insert_correct_answer
- pr_update_correct_answer
- pr_delete_correct_answer

#### Een Leraar moet de antwoorden van de student kunnen inzien
- pr_select_all_answers_for_exam
- pr_select_answers_for_exam_per_student
- pr_select_results_for_student_answer

#### Alleen Leraren mogen van alle studenten de behaalde resultaten zien
- door in de database gebruik te maken van Users, is het mogelijk dat alleen leraren resultaten van studenten kunnen zien. Verder kunnen overzichten met Staging bekeken worden en daar kunnen authorisaties toegevoegd worden.

> Use Case Diagram:
![UCD](../Functional&#32;Ontwerp/Use-cases/images/UCD-sql-exam.jpg)


## Staging
Om niet iedereen zomaar toegang te geven tot de data van de door de studenten gemaakte toetsen, de toetsvragen en resultaten, maar docenten wel een inzicht te geven
van hoe de toetsen gemaakt zijn per klas, groep en per vraag door middel van grafieken, is ervoor gekozen om gebruik te maken van een staging database.

Op deze staging database wordt alleen data opgeslagen waar vervolgens grafieken mee gemaakt kan worden.
Zo kan de leraar via deze grafieken makkelijker inzicht krijgen in hoe de toetsen door de studenten zijn gemaakt. Ook is er zo een beter overzicht welke vragen vaak niet goed gemaakt worden. 

Om gebruik te maken van de staging database hebben we er eerst voor gekozen een prototype met RESTFUL API toe te voegen.
Deze RESTFUL API vraagt data op bij de relationele database en stuurt dit in JSON door naar de staging database.

Later is er besloten om toch gebruik te maken van Python API, omdat hierdoor geen installatie van TomEE nodig was, de documentstructuur voor de JSON bestanden sneller aangepast kon worden en Python more easy executable is.

Voor de staging database hebben we gekozen om gebruik te maken van MongoDB. Dit is een document georiënteerde database.
Wij vonden het niet nodig om gebruik te maken van een relationele database voor het staging gedeelte omdat dat overbodig veel moeite zou zijn voor het genereren van grafieken.

Met MongoDB en MongoDB Charts kan er namelijk snel een grafiek gemaakt worden, daarnaast is het makkelijker om JSON objecten te maken met een RESTFUL API omdat we deze kennis al hebben opgedaan in de course DEA.

Hieronder zijn enkele voorbeelden te zien van het Staging onderdeel, zowel hoe de geuploade JSON documenten eruit zien als enkele gemaakte grafieken. Voor een gedetaillerder overzicht kan de staging site ook live bezocht worden via: https://charts.mongodb.com/charts-project-0-bjbuh/public/dashboards/1d0e5a3d-fdc0-4844-b9f9-bb6aeb72e22e :

> JSON Doc's:
![JSON docs](staging/images/jsondoc.png)

```json
{"_id":"ObjectId('5eddedd44c675fca73bbc3e2')",
"exam_id":"DB-1",
"student":
{"student_no":{"$numberInt":"12"},
"exam_group_type":"Herkanser",
"class":"ISE-A",
"result":{"$numberInt":"8"},
"hand_in_date":"2015-09-21T16:37:16+00:00",

"answer":[
    {"answer_status":"INCORRECT",
    "answer_fill_in_date":"2017-03-31T18:02:48+00:00",
    "question_no":{"$numberInt":"1"}},
    {"answer_status":"CORRECT",
    "answer_fill_in_date":"2014-05-19T14:16:08+00:00"
    ,"question_no":{"$numberInt":"2"}},
    {"answer_status":"CORRECT",
    "answer_fill_in_date":"2015-03-21T01:38:17+00:00",
    "question_no":{"$numberInt":"3"}},
    {"answer_status":"CORRECT",
    "answer_fill_in_date":"2019-09-02T19:11:14+00:00",
    "question_no":{"$numberInt":"4"}},
    {"answer_status":"CORRECT",
    "answer_fill_in_date":"2020-01-07T17:59:32+00:00",
    "question_no":{"$numberInt":"5"}}]}}
```

<iframe style="background: #21313C;border: none;border-radius: 2px;box-shadow: 0 2px 10px 0 rgba(70, 76, 79, .2);" width="640" height="480" src="https://charts.mongodb.com/charts-project-0-bjbuh/embed/charts?id=4cc4f213-c062-420e-a697-0e8888e70e69&theme=dark"></iframe>

> Cijfers per examen:
![cijfers per examen floored](staging/images/cijfers_per_examen.png)

> Score per vraag:
![score per vraag](staging/images/score_per_vraag.png)