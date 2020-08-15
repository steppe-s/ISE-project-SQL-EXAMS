Plan van aanpak - ISE Projectgroep 4
====================================

Assingment: SQL Exam Database
-----------------------------

| Documentinformatie   |                                                  |
|----------------------|--------------------------------------------------|
| Datum van publicatie | 17 april 2020                                    |
| Organisatie          | Hogeschool van Arnhem en Nijmegen                |
| Afdeling             | AIM                                              |
| Projectgroep         | Groep 4                                          |
| Opleiding            | HBO-ICT                                          |
| Profiel              | Software Development, Data Solutions Development |
| Semester             | ISE                                              |
| Begeleiders          | dhr. M. Engelbart                                |
|                      | dhr. L. Van Den Berge                            |
|                      | dhr M. De Jonge                                  |
|                      | mvr. E. Bouwman                                  |
|                      | dhr. C. Scholten                                 |

Inhoudsopgave
-------------

-   [Inleiding](#Inleiding)

-   [Achtergrond van het project](#Achtergrond-van-het-project)

-   [Doelstelling, opdracht en op te leveren resultaten voor het bedrijf en
    school](#Doelstelling,-opdracht-en-op-te-leveren-resultaten-voor-het-bedrijf-en-school)

-   [Projectgrenzen](#Projectgrenzen)

-   [Randvoorwaarden](#Randvoorwaarden)

-   [Op te leveren producten en kwaliteitseisen](#Op-te-leveren-producten-en-kwaliteitseisen)

-   [Ontwikkelmethode](#Ontwikkelmethode)

-   [Projectorganisatie en communicatie](#Projectorganisatie-en-communicatie)

-   [Planning](#Planning)

-   [Risico's](#Risico's)

-   [Literatuurlijst](#Literatuurlijst)

-   [Bronnen](#Bronnen)

Inleiding
---------

Op de HAN (Academy for Communication and Information, AIM), wordt lesgegeven in
het gebruik van SQL, een programmeertaal voor het opzetten en gebruiken van
databases. Hierbij moeten studenten leren om bepaalde informatiebehoeften weer
te kunnen geven aan de hand van ‘SQL-statements’. De docenten moeten deze
statements controleren en beoordelen of ze wel de juiste informatie teruggeven.

AIM wil een nieuwe manier om sneller deze antwoorden van studenten te kunnen
controleren voor gegeven vragen. Hiervoor moet een informatiesysteem opgezet
gaan worden waarin leraren vragen en antwoorden kunnen opslaan en studenten hun
eigen antwoorden kunnen geven en laten controleren.

In dit document is verdere achtergrondgegeven over de opdracht en het verloop
van dit project.

Voor dit project is als eerste een algemene doelstelling omschreven. Daarna
worden de projectgrenzen en randvoorwaarden beschreven. Vervolgens wordt er
beschreven welke producten er moeten worden opgeleverd binnen dit project en aan
welke kwaliteiten deze producten moeten voldoen. In het volgende hoofdstuk wordt
er toegelicht welke methodiek er gebruikt gaan worden en waarom. In het
hoofdstuk erna is er een planning opgesteld waarin elke deadline binnen dit
project staat weergegeven. Als laatste worden de risico's die binnen dit project
zouden kunnen optreden beschreven.

Achtergrond van het project
---------------------------

Dit hoofdstuk gaat in op de achtergrond van het project. Zaken zoals het bedrijf
en de stakeholders zijn hier beschreven. Verder is de aanleiding vanuit zowel
school als de projectopdracht beschreven.

### Aanleiding

Op de database course aan de HAN leren studenten over het gebruik van de query
taal SQL. Tijdens deze course moeten studenten meerdere tentamens maken waarin
ze bepaalde informatie moeten opgeven aan de hand van zogenoemde select
statements. Omdat hiervoor meerdere antwoorden mogelijk zijn, moeten de leraren
aan de HAN altijd alle beantwoorde vragen handmatig nakijken.

Voor de leraren kost het veel tijd om alle toetsen handmatig na te kijken,
daarom hebben ze gevraagd om een systeem op te zetten dat kan helpen bij het
nakijken zodat leraren meer tijd kunnen besparen.

### Stakeholders

| **Stakeholder**                                     | Belangen van de stakeholder                                                                                                                                |
|-----------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Studenten aan de HAN die de database courses volgen | De studenten willen niet meer fout gerekend worden op syntactische fouten bij het maken van een toets                                                      |
| Leraren aan de HAN die de database courses geven    | De leraren willen minder tijd hoeven besteden aan het handmatig nakijken van toetsen, en sneller een overzicht kunnen krijgen over hoe de toets is gemaakt |

Doelstelling, opdracht en op te leveren resultaten voor het bedrijf en school
-----------------------------------------------------------------------------

In dit hoofdstuk zal de gegeven opdracht, op te leveren resultaten en de
doelstelling worden toegelicht. Hiermee wordt de scope van het project duidelijk
in kaart gebracht.

### Opdracht

Bij de HAN worden meerdere courses aangeboden waarbij informatiebehoeftes moeten
worden opgelost via de query taal SQL. SQL heeft echter het probleem dat er
vrijwel altijd meer dan een oplossing voor elke informatiebehoefte. Dit maakt
het lastig om alle toetsen goed na te kijken.

De HAN wil een systeem introduceren die kan helpen met het nakijken van toetsen
voor de course databases. Hierbij moeten verschillende onderdelen van het
systeem worden ontworpen die hierbij kunnen helpen. Deze luiden:

1.  Is de syntax van de query correct?

2.  Komen de resultaten overeen met diegene in het gegeven antwoord?

Natuurlijk kan het niet systeem niet definitief bepalen of een vraag echt goed
is, hier zal altijd een bevoegde naar moeten kijken. Echter kan het systeem wel
fouten aantonen, deze fouten hebben betrekking tot de syntax en de
informatiebehoefte, op deze manier hoeft een leraar niet meer naar een gegeven
antwoord te kijken als deze al fout is.

Via DDL- en DML-script moeten de toets databases, de voorbeelddata en de vragen
met antwoorden toegevoegd kunnen worden. Deze vragen moeten door een leraar voor
een bepaalde tijd opengezet kunnen worden doorgegeven voor de studenten zodat
deze de vragen kunnen beantwoorden.

Naast het nakijksysteem moet het systeem ook de resultaten per studenten en
groepering van studenten in kaart kunnen brengen via een aparte database.

### Doelstelling

Het doel van dit project is om ervoor te zorgen dat leraren van de course
database aan de HAN minder tijd hoeven te besteden aan het handmatig nakijken
van toetsen. Voor ons als projectteam is het doel om de backend van dit systeem
te realiseren.

### Op te leveren resultaten

Voor deze opdracht moet er een backend databasesysteem worden ontworpen waarin
het nakijksysteem en rapport systeem zit. Het systeem zal zo gebouwd moeten zijn
dat een leraar een toets kan maken inclusief test database, vragen en
bijbehorende antwoorden. Daarnaast moet een leraar een toets kunnen openzetten
zodat studenten de vragen kunnen beantwoorden. Zodra de toets is afgerond moet
het systeem alle vragen kunnen nakijken en de resultaten van studenten kunnen
weergeven. Om deze opdracht te realiseren zijn er een aantal deelproducten die
moeten worden opgeleverd om dit systeem te ondersteunen en verduidelijken.

1.  Technisch Ontwerp (TO)

2.  Functioneel Ontwerp (FO)

3.  Testplan en rapport

Verder zal elk teamlid een persoonlijk verslag schrijven, waarin het leerproces
in kaart wordt gebracht. Dit verslag is de verantwoordelijkheid van het individu
zelf, de bovenstaande deelproducten bevatten alleen producten die betrekking
hebben tot het hele team.

Projectgrenzen
--------------

Om een duidelijk beeld te schetsen van het verloop van dit project zijn een
aantal punten opgesteld. Deze beschrijven wat er binnen en buiten de grenzen van
het project valt.

1.  Het project loopt tot het inlever moment op 11 juni.

2.  De werkomgeving van het project bestaat uit een combinatie van Jira,
    BitBucket, Microsoft Teams.

3.  Het project omvat een API ontwikkelt in SQL-server, een simpele
    userinterface/front-end zal alleen worden ontwikkeld wanneer de complete
    backend af is.

4.  De groep zal tijdens het project op werkdagen van 09:00 tot 17:00 aan het
    project werken. Tussen deze tijden zal het team aanwezig zijn op Microsoft
    Teams, dan wel een alternatief wanneer Teams niet beschikbaar is, en zal
    werk leveren aan het project.

5.  Tijdens het weekend wordt er niet aan het project gewerkt of gereageerd op
    de email.

6.  Tijdens de meivakantie wordt er niet aan het project gewerkt of gereageerd
    op de email.

7.  Tijdens Pinksteren, Hemelvaartsdag of de dag na Hemelvaart wordt er niet aan
    het project gewerkt of gereageerd op de email.

Randvoorwaarden
---------------

Om ervoor te zorgen dat het project geen belemmering ondervindt en teamleden
productief kunnen doorwerken zijn er randvoorwaarden opgesteld. Hierbij is bij
elke voorwaarde een verantwoordelijke partij aangegeven. Dit is de partij die de
voorwaarden realiseert zodat de projectgroep kan werken. Zonder deze
verantwoordelijke partijen zijn er mogelijke beperkingen die het project kunnen
belemmeren. In de onderstaande tabel staan de opgestelde randvoorwaarden en de
bijbehorende verantwoordelijke partij:

| Nr. | **Voorwaarde**                                                                                                                                                                                                                                                           | Verantwoordelijke partij      |
|-----|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| 1   | De door de student te gebruiken ontwikkelomgevingen (JIRA, BitBucket, Microsoft Teams) dienen beschikbaar te zijn vanaf 07-04-2020 t/m 05-06-2020 tussen 8:45 u en 17:45 u op werkdagen (maandag t/m vrijdag)                                                            | Hogeschool Arnhem en Nijmegen |
| 2   | Tijdens de wekelijkse vergaderingen verwacht de projectgroep dat er op zijn minst twee keer een begeleider beschikbaar is om de vergadering bij te wonen.                                                                                                                | Begeleiders                   |
| 3   | De begeleiders zijn bereid om buiten de standaard contactmomenten aanvullende vragen te beantwoorden via de mail. Daarnaast wordt er verwacht dat de begeleiders binnen twee werkdagen reageren. Deze randvoorwaarde is vermeld in de studiehandleiding (Breuker, 2019). | Begeleiders                   |
| 4   | Begeleiders zijn tijdens de werktijden van de projectgroep te bereiken via Microsoft Teams, dan wel een alternatief wanneer Teams niet beschikbaar is.                                                                                                                   | Begeleiders                   |
| 5   | Er moet door de HAN een werkruimte beschikbaar worden gesteld voor diegenen waar het niet voor mogelijk is thuis te werken tijdens de COVID-19 crisis gedurende een periode van 07-04-2020 tot 12-06-2020 tussen 8:45 u en 17:45 u. op werkdagen                         | Hogeschool Arnhem en Nijmegen |
| 6   | De begeleiders moeten een alternatieve communicatiemedium ter beschikking stellen wanneer Teams niet bruikbaar is.                                                                                                                                                       |                               |

Op te leveren producten en kwaliteitseisen
------------------------------------------

Tijdens het project worden een aantal producten opgeleverd. Om te garanderen dat
deze producten van voldoende kwaliteit zijn, staan hieronder de product
kwaliteitseisen. Als de producten aan deze eisen voldoen, dan zijn ze van
voldoende kwaliteit.

| Product             | Betrokken RUP-fase               | Productkwaliteiteisen                                                                                                                                                                                                  | Verplichte handelingen                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|---------------------|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Plan van Aanpak     | Inception/elaboratie             | Voldoet aan ICA controlekaart; Verwoord de aanpak van het project; Is goedgekeurd door alle leden van het team.                                                                                                        | Er moet minimaal een gesprek zijn gehouden met de opdrachtgever; Elk teamlid moet het plan van aanpak goedgekeurd hebben.                                                                                                                                                                                                                                                                                                                                                                        |
| Database            | Elaboratie/Constructie/ntegratie | Voldoet aan de eerder opgestelde requirements; Voldoet aan de opgestelde acceptatiecriteria; Voldoet aan de gestelde Definition of Done; Elk opgeleverd onderdeel moet volgens de voorgestelde standaard layouts zijn. | Elk opgeleverd onderdeel moet door minimaal twee groepsleden zijn goedgekeurd; Na elke iteratie moet er een goedkeuring zijn van de opdrachtgever Elk opgeleverd onderdeel moet een testplan bevatten die is uitgevoerd.                                                                                                                                                                                                                                                                         |
| Functioneel ontwerp | Inception/Elaboratie/Constructie | Het Voldoet aan de ICA controlekaart; Is goedgekeurd door alle leden van het team.                                                                                                                                     | Elk opgeleverd hoofdstuk moet door minimaal twee leden goedgekeurd zijn; Het moet een Business Process Model bevatten dat de verschillende handelingen binnen het systeem duidelijk weergeeft; Het moet een Use Case Model bevatten dat alle verschillende use cases van het systeem bevat; Het moet een Conceptual Data Model bevatten dat alle onderdelen van de backend van het systeem weergeeft; Bevat een uitleg van alle gemaakte keuzes inclusief alle afwegingen, voordelen en nadelen. |
| Technisch ontwerp   | Constructie/Integratie           | Het voldoet aan de ICA controlekaart; Geeft een duidelijke omschrijving van de werking van het systeem; Het moet een extensie zijn van het Functioneel Ontwerp en mag dus niet tegenstrijdig zijn.                     | Het moet een Physical Data Model bevatten dat exact de werking van de database weergeeft; Bevat een uitleg van alle gemaakte keuzes inclusief alle afwegingen, voordelen en nadelen; Het moet een API-omschrijving bevatten die de werking van alle functionaliteiten en constraints bevatten.                                                                                                                                                                                                   |
| Testplan            | Constructie/Integratie           | Het voldoet aan de ICA controlekaart; Het moet voor elk onderdeel van het systeem een testplan weergeven.                                                                                                              | Voor elk ontwikkeld onderdeel in de backend moeten tests zijn gemaakt en beschreven in het testplan; Er moet een testrapport worden opgeleverd waarin dit testplan is uitgevoerd.                                                                                                                                                                                                                                                                                                                |

Ontwikkelmethode
----------------

Gedurende dit project wordt gebruik gemaakt van de RUP (Rational Unified Proces)
project methode. Gedurende het project kan er feedback worden gegeven en
verwerkt doormiddel van deze methode. Het gebruik van RUP is voor dit project
verplicht gesteld door de opleiding. Deze methode bestaat uit vier fasen:
Inception, Elaboration, Construction en Transition. De construction fase wordt
drie keer uitgevoerd. De fases moeten resulteren in een werkend prototype dat
uiteindelijk moet worden gepresenteerd. 1. De inception fase zal plaats vinden
in OW-1. 2. De elaboratie fase start in OW-2 en loopt t/m de dinsdag in OW-4. 3.
De Construction fase 1 loopt vanaf de woensdag in OW-4 t/m de vrijdag van OW-5.
4. De Construction fase 2 loopt vanaf de maandag in OW-6 t/m de dinsdag van
OW-7. 5. De Construction fase 3 loopt vanaf de woensdag in OW-7 t/m de vrijdag
van OW-8. 6. De Transition fase vindt plaats in OW-9. \#

Vergaderingen 
--------------

1. Interview met de product owner: In de eerste week van het project zal een
interview plaats vinden waar de opdracht met de product owner wordt besproken.

2. Weekly meeting: Elke week wordt deze vergadering gehouden om te besluiten
welke taken er worden uitgevoerd en feedback te bespreken. Het hele team plus de
project begeleider is hierbij aanwezig.

3. Iteration meeting: Na elke iteratie wordt er een review gehouden over de
kwaliteit van een werkend prototype. Tijdens de vergadering presenteert de groep
het ontwerp en de code aan de begeleiders. Ook wordt hier een analyse gemaakt
van de samenwerking door de projectgroep.

4. IPV-meeting: In week 2 en 5 wordt er een vergadering gehouden waar de groep
feedback op elkaar kan leveren in het bijzijn van de project begeleider.

Projectorganisatie en communicatie
----------------------------------

In dit hoofdstuk wordt de communicatie dat het team heeft met de stakeholders
vastgesteld. Ook worden de rollen van alle teamleden hierin toegelicht zodat er
duidelijk wordt wie waar verantwoordelijk is tijdens het project. 

Er zijn twee begeleiders vanuit de ICA die betrokken zijn binnen het project,
namelijk:

### Begeleiders

| Naam                | Afkorting | Specialiteit                | E-mailadres            | Telefoonnummer | Organisatie                      | Afdeling                          | Bereikbaarheid                      |
|---------------------|-----------|-----------------------------|------------------------|----------------|----------------------------------|-----------------------------------|-------------------------------------|
| Mvr. Helen Visser   | VSRHL     | Professional Skills         | helen.visser\@han.nl   | **Onbekend**   | Hogeschool van Arnhem & Nijmegen | Academie Informatica & Multimedia | Elke woensdag om 11.30              |
| Dhr. Chris Scholten | STNCD     | Database System Development | chris.scholten\@han.nl | **Onbekend**   | Hogeschool van Arnhem & Nijmegen | Academie Informatica & Multimedia | Elke maandag en woensdag vanaf 9.00 |

### Opdrachtgever

| Naam                 | Afkorting | Specialiteit | E-mailadres             | Telefoonnummer | Organisatie                      | Afdeling                          | Bereikbaarheid |
|----------------------|-----------|--------------|-------------------------|----------------|----------------------------------|-----------------------------------|----------------|
| Dhr. Marco Engelbart | EGBC      | OOAD         | marco.engelbart\@han.nl | **Onbekend**   | Hogeschool van Arnhem & Nijmegen | Academie Informatica & Multimedia | Op afspraak    |

### Projectgroep ISE-4

| Naam               | Studentnummer | RUP Rol                 | E-mailadres                   | Profiel                       |
|--------------------|---------------|-------------------------|-------------------------------|-------------------------------|
| Kasteleijn, Justin | 618695        | Testmanager/Programmeur | JF.Kasteleijn\@student.han.nl | Software Development          |
| Nobel, Josse       | 615959        | Informatieanalist       | JL.Nobel\@student.han.nl      | Database Solution Development |
| Schepers, Jorrit   | 622148        | Teamleider              | J.Schepers3\@student.han.nl   | Software Development          |
| Schoolkate, Steppe | 619465        | Software Architect      | S.Schoolkate\@student.han.nl  | Software Development          |
| Soffers, Fedor     | 567780        | Usecase Ontwerper       | FKA.Soffers\@student.han.nl   | Software Development          |

Verder is er binnen de groep niet een specifiek contactpersoon. Iedereen kan bij
de gezamenlijke mail van onze groep, dus reageren op mails. Hiervoor moet er
goed gecommuniceerd worden wanneer, wie op welke mail reageert. Verder moet het
in de mail ook duidelijk zijn wie de mail gestuurd heeft binnen de groep. Dit
kan dan gebruikt worden als referentie mochten er onduidelijkheden zijn. Om dit
te waarborgen zal de volgende handtekening worden gebruikt.

Met vriendelijke groet,  
ISE-groep 4  
"naam"

Planning
--------

Voor dit project is er een algemene planning opgesteld waarin de algemene
structuur en deadlines staan weergegeven. In dit hoofdstuk wordt deze planning
weergegeven.

### Projectfases

Het project duurt negen weken met een week vakantie. Het project is volgens de
RUP op maat methode ingedeeld in vier verschillende fases. Deze vier fases staan
hieronder verder uitgewerkt.

| Fase              | Startdatum | Einddatum  | Op te leveren producten                                                |
|-------------------|------------|------------|------------------------------------------------------------------------|
| Inception fase    | 14-04-2020 | 17-04-2020 | Opstarten project, opzetten projectplan                                |
| Elaboratie fase   | 20-04-2020 | 04-05-2020 | Architecturale prototype opzetten, eerste versies project report en FO |
| Constructiefase 1 | 06-05-2020 | 15-05-2020 | Eerste versie TO, toevoegingen aan systeem en FO                       |
| Constructiefase 2 | 18-05-2020 | 27-05-2020 | Tweede versie TO, toevoegingen aan systeem, definitieve versie FO      |
| Constructiefase 3 | 28-05-2020 | 05-06-2020 | Definitieve versie FO, toevoegingen aan TO en systeem                  |
| Transitiefase     | 09-06-2020 | 12-06-2020 | Definitieve versie, FO, TO en systeem                                  |

In de tabel hieronder is de globale planning weergegeven van dit project.

| OW          | Maandag                 | Dinsdag                 | woensdag                | donderdag    | Vrijdag                                                                                            |
|-------------|-------------------------|-------------------------|-------------------------|--------------|----------------------------------------------------------------------------------------------------|
| 1           |                         | Start project 09:00u    |                         |              | Deadline inleveren plan van aanpak, individuele projectvoorbereiding 16:00u                        |
| 2           | Start Elaboratiefase    |                         |                         |              |                                                                                                    |
| Meivakantie |                         |                         |                         |              |                                                                                                    |
| 3           | Einde elaboratiefase    | 5 mei VRIJ              | Start constructiefase 1 |              |                                                                                                    |
| 4           |                         |                         |                         |              | Inleveren architecturale prototype en eerste versie FO, verantwoording projectbijdrage tussentijds |
| 5           |                         |                         |                         |              | Einde constructiefase 1, tussentijdse assessment                                                   |
| 6           | Start constructiefase 2 |                         |                         |              |                                                                                                    |
| 7           |                         | Einde constructiefase 2 | Start constructiefase 3 |              |                                                                                                    |
| 8           |                         |                         |                         |              | Einde constructiefase 3 Deadline inleveren FO, TO, project report en systeem                       |
| 9           | Start transitiefase     |                         |                         | Eindeproject |                                                                                                    |

Er is besloten de Elaboratiefase in te korten. Dit is besloten, met de reden dat
er weinig taken overblijven om de volledige twee weken mee op te vullen. Dit is
gedaan met bespreking van Marco Engelbart.

### Planning project

In dit hoofdstuk wordt beschreven wat wij verwachten welke fase op te leveren.
Dit kan afwijken van de daadwerkelijke oplevering.

#### Elaboratie fase

-   Functioneel ontwerp eerste versie af

-   Onderzoek staging

-   Software prototype nakijksysteem en eventueel staging systeem

#### Constructie fase 1

-   CDM naar PDM omzetten en functionele database opzetten

-   Eerste versie technisch ontwerp af

-   Prototype nakijksysteem implementeren in database

-   Docent CRUD-systeem voor uploaden vragen en antwoorden

-   User-instellingen opzetten

#### Constructie fase 2

-   Staging opzetten en implementeren, rapport systeem opzetten

-   Systeem voor het opgeven van vragen

-   Student CRUD-systeem beantwoorden van vragen

-   Beveiliging rondom maken toets

-   Docent CRUD-systeem uploaden DML en DDL

-   Tweede versie technisch ontwerp af

#### Constructie fase 3

-   Nakijksysteem verbeteren aan de hand van onderzoeken

-   Eventueel basic front-end systeem opzetten

-   Technisch ontwerp af

-   Functioneel ontwerp af

#### Integratie fase

-   Instructie document opzetten

-   Documentatie compleet

Daarnaast is er een algemene dag- en weekplanning die aangehouden zal worden.
Elke dag zal er een meeting zijn in Teams om 09:00. Op maandag en woensdag zal
de procesbegeleider aanwezig zijn bij deze meeting.

Risico's
--------

Hieronder zijn de risico's opgesteld die in dit project op kunnen treden. Per
risico wordt beschreven hoe groot de kans is dat het op zal treden, de impact
die het zal hebben op het team en het product, de tegenmaatregel die we
toepassen om het te voorkomen en de uitwijk strategie die toegepast zal worden
als het optreedt.

1.  Risico: Opdrachtgever is niet genoeg bereikbaar.

    1.  Kans: Middel

    2.  Impact: Middel

    3.  Tegenmaatregel: In het eerste gesprek met de opdrachtgever wordt er
        afgesproken dat de opdrachtgever minimaal een keer per week bereikbaar
        moet zijn via de mail.

    4.  Uitwijk Strategie: Als de opdrachtgever niets van zich laat weten,
        zullen wij hem voor twee dagen elke dag een mail sturen. Als we nog
        steeds geen reactie krijgen gaan we over op bellen. Als we dan nog
        steeds geen reactie ontvangen, gaan we dit bespreken met onze begeleider
        om tot een oplossing te komen.

2.  Risico: Een van de teamleden valt uit

    1.  Kans: Klein

    2.  Impact: Groot

    3.  Tegenmaatregel: De groep gemotiveerd houden.

    4.  Uitwijk Strategie: Als er een lid is uitgevallen, zal de rest van de
        groep met de begeleider gaan afspreken in hoeverre het product af kan
        worden gemaakt. Van de huidige iteratie zullen er een aantal taken weg
        gehaald worden. Ook zal er contact worden opgenomen met de opdrachtgever
        om hem/haar op de hoogte te stellen.

3.  Risico: Een van de leden heeft niet genoeg technische kennis.

    1.  Kans: Middel

    2.  Impact: Middel

    3.  Tegenmaatregel: Voor de start het project goed met elkaar bespreken
        welke vakken iedereen wel en niet gehaald heeft.

    4.  Uitwijk Strategie: Als het gebrek aan technische kennis van een lid te
        veel impact heeft, zullen de rest van het groepje hem/haar helpen om op
        hetzelfde niveau te komen.

Literatuurlijst
---------------

Bijlage
-------

Definition of done
==================

Voor dit project wordt de RUP-werkmethode uitgevoerd. Hiervoor zijn een aantal
rollen verdeeld over het team. Deze rollen staan hieronder weergegeven.

Rolverdeling
------------

Algemene definition of done voor softwareproducten
--------------------------------------------------

Voor elk softwareonderdeel dat moet worden opgeleverd zijn de volgende
verplichtingen opgelegd waaraan het opgeleverde onderdeel moet voldoen.

-   Elk op te leveren onderdeel moet op een aparte branche worden ontwikkeld die
    vanaf de Development branche is gemaakt.

-   Elk op te leveren onderdeel moet volledig werken in de afgesproken
    functionaliteit van dat onderdeel voordat het goedgekeurd mag worden.

-   Elk op te leveren onderdeel moet volledig getest zijn en moet deze tests en
    testresultaten meeleveren voordat het goedgekeurd mag worden.

-   Het op te leveren onderdeel moet door minimaal twee verschillende
    groepsleden worden nagekeken voordat het goedgekeurd mag worden.

-   Het op te leveren onderdeel moet door minimaal een hoofdprogrammeur worden
    goedgekeurd voordat het toegevoegd mag worden aan de development branche.

-   Het op te leveren onderdeel moet volledig gedocumenteerd zijn in het
    technisch ontwerp/test rapport. Hierbij moet een API-omschrijving zijn
    toegevoegd en een testplan en resultaten. Zie het onderdeel documentatie
    verplichtingen voor de complete verplichting voor documentatie.

Algemene definition of done voor documentatieproducten
------------------------------------------------------

Voor elke documentatie onderdeel zijn er de volgende verplichtingen opgelegd
waaraan het opgeleverde onderdeel moet voldoen.

-   Elk op te leveren onderdeel moet in correct Nederlands beschreven zijn en
    voldoen aan de ICA-controlekaart.

-   Elk op te leveren onderdeel moet nagekeken worden door tenminste twee
    verschillende groepsleden.

-   Elk op te leveren onderdeel dat betrekking heeft tot technische ontwerp
    keuzes moet door minimaal de software architect goedgekeurd worden.

Verplichtingen per RUP-rol
--------------------------

Naast deze verplichtingen zijn er tijdens het project verschillende
verplichtingen per RUP-rol en groepslid. Deze staan hieronder omschreven.

Teamleider
----------

De teamleider is eindverantwoordelijk voor het regelen dat taken verdeeld worden
en dat de groep aan de juiste onderdelen werkt. **Moet aangepast worden**

Software architect/Use case ontwerper/informatieanalist
-------------------------------------------------------

De software architect is eindverantwoordelijke voor het functioneel ontwerp,
technisch ontwerp en de API-omschrijvingen voor alle functionaliteiten van het
systeem. Daarnaast is deze persoon ook eindverantwoordelijke voor eventuele
onderzoeken en nieuwe modellen.

Programmeur
-----------

De programmeur is eindverantwoordelijke voor de op te leveren
softwareonderdelen. De programmeur moet ervoor zorgen dat de softwareonderdelen
die worden toegevoegd aan de development branche volledig werken.

Testmanager
-----------

De testmanager is eindverantwoordelijke voor de op te leveren testplan en
geschreven tests. Wanneer een softwareonderdeel af is mag deze pas worden
toegevoegd nadat de testmanager het testplan en de geschreven tests goedkeurt.

Integrator/toolbeheerder
------------------------

De integrator en toolbeheerder is eindverantwoordelijke voor het behoud van een
overzichtelijke JIRA-planning en Git omgeving. Daarnaast moet de integrator
samen met de programmeur ervoor zorgen dat een nieuwe toevoeging aan het systeem
niet andere onderdelen van het systeem breekt.
