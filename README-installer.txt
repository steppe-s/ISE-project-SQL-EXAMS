README DATABASE INSTALLEREN
In deze readme staan de instructies voor het testen van de database en het installeren daarvan.


Hoofdstukken:
I Database testen
I.I Los de tests runnen in productie
II Installeren database
II.I Los onderdelen installeren van de database
III Troubleshooting

I Database testen
Voordat de database geinstalleerd kan worden moet deze eerst getest worden. Wanneer de database nog niet in productie is, kan er gebruik gemaakt
worden van de .bat file RUN_testing_enviroment.bat. Wanneer deze wordt gerund, zal de complete database worden verwijderd en opnieuw leeg worden
aangemaakt, waarna vervolgens de testing enviroment wordt opgezet en alle tests worden uitgevoerd.
Alle resultaten van de tests worden opgeslagen in de folder testing, in de file test_results.txt

BELANGRIJK!
VOER DEZE .BAT FILE NIET UIT WANNEER DE DATABASE IN PRODUCTIE IS! HET VERWIJDERD NAMELIJK
DE COMPLETE DATABASE ZODAT ALLE INTEGRATIE TESTS VOLLEDIG UITGEVOERD KUNNEN WORDEN.

I.I Los de tests runnen in productie
Het is mogelijk om alle tests te runnen in de productiedatabase. Hiervoor moet er in de folder
testing eerst de TSQLT.sql worden gerund om ervoor te zorgen dat tSQLt geinstalleerd is. Vervolgens kan de .bat file RUN_tests.bat worden
uitgevoerd om alle tests uit te voeren. De integratie tests zullen echter hoogstwaarschijnlijk wel falen wegens andere resultaten. 
De resultaten van de tests zijn te vinden in de text file test_results.txt

II Installeren database
Voor het installeren van de productiedatabase hoeft alleen de .bat file RUN_create_full_database_system.bat uitgevoerd te worden. Deze verwijdert eerst
de database als die bestaat en maakt het opnieuw aan.

BELANGRIJK!
VOER DEZE .BAT FILE NIET UIT WANNEER DE DATABASE AL IN PRODUCTIE IS! HET VERWIJDERD NAMELIJK
DE COMPLETE DATABASE EN INSTALLEERT ALLES OPNIEUW

II.I Los onderdelen installeren van de database
Het is mogelijk om los procedures, triggers of functions te installeren. In elke bijbehorende folder (functions, setup, stored_procedures, triggers)
staat een bijbehorende .bat file die alle bestaande .sql files in die folder uitvoert. Het is daardoor ook mogelijk om gemakkelijk nieuwe stored procedures,
triggers of function toe te voegen zonder dat de database opnieuw geinstalleerd hoeft te worden.


III Troubleshooting
Hieronder staan een aantal bekende problemen en hoe deze op te lossen
"path not specified" in een .bat file
Deze foutmelding verschijnt wanneer de environment variables voor sqlcmd niet goed zijn ingesteld. Hiervoor zijn twee oplossingen.

Optie 1
In de .bat file RUN_testing_enviroment en RUN_create_full_database_system.bat kan bovenaan de SQLCMD variabele worden aangepast.
Door deze naar de SQLCMD.EXE te laten verwijzen kan dit probleem worden opgelost. Om dit te doen, voer de volgende stappen uit:

1. bewerk de .bat file door er met rechtermuisknop op te klikken en dan te openen met notepad
2. Verander de variabele SQLCMD naar de pathfile van SQLCMD.EXE, deze zal ongeveer op de volgende pad zitten:

"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"

NB: het nummer 130 moet hoogstwaarschijnlijk worden aangepast naar iets anders, kijk hiervoor in de program files waar SQLCMD.EXE precies zit


Optie 2
Voeg in Windows bij de path environment variables SQLCMD.EXE toe. Om dit te doen, voer de volgende stappen uit:

1. type in de Windows searchbar Environment variables in -> ENTER
2. Klik op Environment Variables...
3. Onder het kopje System variables, klik op Path -> Edit
4. Voer het pad in naar SQLCMD.EXE, dit zal ongeveer op de volgende pad zitten:
 
"C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"

NB: het nummer 130 moet hoogstwaarschijnlijk worden aangepast naar iets anders, kijk hiervoor in de program files waar SQLCMD.EXE precies zit

5. Klik op OK, de .bat files zouden nu volledig moeten werken.
