# Triggers API

## Inleiding

In deze map staan alle triggers die gebruikt worden in het systeem. Voor elke
trigger is er een uitleg gegeven over hoe deze werkt, wat deze uitvoert en welke
foutmeldingen deze procedure kan teruggeven.

Per procedure moeten de volgende gegevens zijn opgegeven:

-   Naam van de trigger

-   Wat deze trigger doet

-   Op welke tables deze trigger van toepassing is

-   Welke foutmeldingen deze trigger terug kan geven

## Triggers

### tr_restrict_update_end_time_after_exam_has_been_taken

#### Functie

Weerhoudt het updaten van de eindtijd van een examen wat al afgenomen is. 

#### Overzicht

| Tabelnaam          | Waneer | INSERT | UPDATE | DELETE |
|--------------------|--------|--------|--------|--------|
| EXAM_GROUP_IN_EXAM | for    |        |    x   |        |

#### Koppeling Intregrity rules

--

#### Foutmeldingen

60156: 'The end date is not allowed to be modified after the exam has been taken place'

### tr_fill_in_date_of_answer_between_starting_and_end_date_of_exam

#### Functie

Controleert of een antwoord van een student is opgestuurd tijdens het examen en niet erbuiten.

#### Overzicht

| Tabelnaam | Waneer | INSERT | UPDATE | DELETE |
|-----------|--------|--------|--------|--------|
| ANSWER    | for    |   x    |    x   |        |

#### Koppeling Intregrity rules

IR6: Als de tijd van de toets is verstreken mag de student zijn antwoorden niet meer wijzigen of opsturen.

#### Foutmeldingen

60029: 'answer_fill_in_date must be between the starting and end date of the corresponding exam'

### tr_end_date_is_after_starting_date

#### Functie

Controleert of de eindtijd van een examen na de start tijd is.

#### Overzicht

| Tabelnaam          | Waneer | INSERT | UPDATE | DELETE |
|--------------------|--------|--------|--------|--------|
| EXAM_GROUP_IN_EXAM | for    |   x    |    x   |        |

#### Koppeling Intregrity rules

--

#### Foutmeldingen

60030: 'end_date must be after starting_time'

### tr_ddl_and_dml_filter

#### Functie

Filtered de comments uit het ddl en dml en geeft een error terug als het volgende voorkomt:
- ddl of dml is null
- ddl en dml bevat een **drop** query
- ddl en dml bevat een **delete** query
- ddl en dml bevat comment die begint met **--**
- ddl en dml bevat een **create database** query
- ddl en dml bevat een **update** query

#### Overzicht

| Tabelnaam     | Waneer     | INSERT | UPDATE | DELETE |
|---------------|------------|--------|--------|--------|
| EXAM_DATABASE | instead of |   x    |    x   |        |

#### Koppeling Intregrity rules

--

#### Foutmeldingen

60026, 'Query_statement cannot be null'

60105: 'Statement contains illicit drop statement'

60106: 'Statement contains illicit delete statement'

60107: 'Statement contains illicit comment characters'

60108: 'Statement contains illicit create statement'

60109: 'Statement contains illicit update statement'

### tr_set_question_to_pending

#### Functie

Past de status aan van correcte antwoorden zodat een docent deze kan controleren en kan bepalen of het antwoord ook daadwerkelijk correct is.

#### Overzicht

| Tabelnaam | Waneer | INSERT | UPDATE | DELETE |
|-----------|--------|--------|--------|--------|
| ANSWER    | for    |   x    |        |        |

#### Koppeling Intregrity rules

IR2: Wanneer een student een antwoord geeft dat de juiste syntax en resultaten geeft, maar niet in de lijst met goedgekeurde antwoorden staat, moet een leraar dit antwoord goedkeuren voordat het wordt toegevoegd aan de lijst met goede antwoorden.

#### Foutmeldingen

--

### tr_schedule_exam

#### Fucntie 

Maakt een job aan voor een examen die wordt toegevoegd 
Verwijderd een job voor een examen die wordt verwijderd 

#### Overzicht

| Tabelnaam     | Waneer     | INSERT | UPDATE | DELETE |
|---------------|------------|--------|--------|--------|
| EXAM			| instead of |   x    |    x   |        |

#### Koppeling Intregrity rules

--

#### Foutmeldingen

--

