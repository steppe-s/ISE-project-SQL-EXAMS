SQL Exam Database
=================

Handige link
------------

**Jira board** -\> https://isejira2.icaprojecten.nl:8443/secure/RapidBoard.jspa
**Git repos** -\> https://isegit2.icaprojecten.nl:8443/projects/IPG4

Handleiding uitwerken stored procedures/triggers
------------------------------------------------

Wanneer een stored procedure of trigger gemaakt moet worden moeten de volgende
regels gevolgd worden:

1.  Voor het maken van een stored procedure moet gebruik gemaakt worden van de
    stored_procedure_template.sql file in de folder SQL_templates. Voor het
    maken van een trigger moet gebruik gemaakt worden van de
    trigger_template.sql file in de folder SQL_templates.

2.  De naam van een stored procedure begint altijd met pr\_ en mag geen
    hoofdletters bevatten. Bijv:

pr_upload_vragen

Voor triggers geldt dat de naam met tr\_ begint.

1.  De triggers en procedures moeten in de bijbehorende folders worden
    geplaatsts genaamd SQL_triggers.sql en SQL_stored_procedures.sql

2.  De file naam van de trigger of stored procedure moet genoemd worden naar de
    stored procedure zelf, met pr\_ en tr\_ ervoor. Bijv:

JIRA-issue IPG4-85: Create functie maken voor uploaden vragen -\>
pr_uploaden_vraag.sql

1.  In beide folders zit een folder genaamd SQL_tests.sql. In deze folder moet
    voor elke trigger of procedure een test file aangemaakt worden. De naam van
    deze test moet beginnen met test\_ gevolgd door de naam die in de hoofdfile
    is gestopt.

**BELANGRIJK:**

Bij het maken van stored procedures, triggers, tests of andere SQL scripts is
het belangrijk dat er geen losse execute/select/delete/insert statements staan
want die worden allemaal uitgevoerd wanneer je de .bat files runt wat voor grote
problemen kan zorgen.

Gebruik .batfiles
-----------------

Voor het creëren van de database, stored procedures, triggers en bijbehorende
testen zijn .bat files gemaakt. Deze runnen automatisch alle sql files. Om deze
.bat files te kunnen gebruiken moet je ervoor zorgen dat je SQL via Windows
Authenticatie toegang kan verlenen en dat je via jouw Windows account de .bat
files uitvoert.
