use HAN_SQL_EXAM_DATABASE
go
-----------------------------------------------------------------------------------
delete from dbo.ANSWER
delete from dbo.CORRECT_ANSWER
delete from dbo.QUESTION_IN_EXAM
delete from dbo.ANSWER_CRITERIA
delete from dbo.QUESTION
delete from dbo.EXAM_FOR_STUDENT
delete from dbo.EXAM_GROUP_IN_EXAM
delete from dbo.EXAM
delete from dbo.COURSE
delete from dbo.DIFFICULTY
delete from dbo.EXAM_GROUP
delete from dbo.STUDENT
delete from dbo.CLASS
delete from dbo.REASON
delete from dbo.CRITERIA_TYPE
delete from dbo.EXAM_DATABASE

DBCC CHECKIDENT ('QUESTION', RESEED, 0)
-----------------------------------------------------------------------------------

INSERT INTO dbo.EXAM_DATABASE (exam_db_name, exam_ddl_script, exam_dml_script)
VALUES ('MuziekdatabaseUitgebreid',
    'create table Bezettingsregel (
    stuknr               numeric(5)           not null,
    instrumentnaam       varchar(14)          not null,
    toonhoogte           varchar(7)           not null,
    aantal               numeric(2)           not null
    )

    alter table Bezettingsregel
    add constraint PK_BEZETTINGSREGEL primary key (stuknr, instrumentnaam, toonhoogte)

    create table Componist (
    componistId          numeric(4)           not null,
    naam                 varchar(20)          not null,
    geboortedatum        datetime             null,
    schoolId             numeric(2)           null
    )

    alter table Componist
    add constraint AK_COMPONIST unique (naam)

    alter table Componist
    add constraint PK_COMPONIST primary key (componistId)

    create table Genre (
    genrenaam            varchar(10)          not null
    )

    alter table Genre
    add constraint PK_GENRE primary key (genrenaam)

    create table Instrument (
    instrumentnaam       varchar(14)          not null,
    toonhoogte           varchar(7)           not null
    )

    alter table Instrument
    add constraint PK_INSTRUMENT primary key (instrumentnaam, toonhoogte)

    create table Muziekschool (
    schoolId             numeric(2)           not null,
    naam                 varchar(30)          not null,
    plaatsnaam           varchar(20)          not null
    )

    alter table Muziekschool
    add constraint AK_MUZIEKSCHOOL unique (naam)

    alter table Muziekschool
    add constraint PK_MUZIEKSCHOOL primary key (schoolId)

    create table Niveau (
    niveaucode           char(1)              not null,
    omschrijving         varchar(15)          not null
    )

    alter table Niveau
    add constraint AK_NIVEAU unique (omschrijving)

    alter table Niveau
    add constraint PK_NIVEAU primary key (niveaucode)

    create table Student (
    studentId            numeric(10)          not null,
    schoolId             numeric(2)           not null,
    voornaam             varchar(25)          not null,
    achternaam           varchar(25)          not null,
    inschrijfdatum		date				 not null,
    uitschrijfdatum		date				 null
    )

    alter table Student
    add constraint PK_STUDENT primary key (studentId)


    create table StudentInstrument (
    instrumentnaam       varchar(14)          not null,
    toonhoogte           varchar(7)           not null,
    studentId            numeric(10)           not null,
    niveaucode           char(1)              not null
    )

    alter table StudentInstrument
    add constraint PK_STUDENTINSTRUMENT primary key (instrumentnaam, toonhoogte, studentId)

    create table StudentInstrumentUitvoeringStuk (
    instrumentnaam       varchar(14)          not null,
    toonhoogte           varchar(7)           not null,
    studentId            numeric(10)           not null,
    stuknr               numeric(5)           not null,
    datumtijdUitvoering  datetime             not null
    )

    alter table StudentInstrumentUitvoeringStuk
    add constraint PK_STUD_INSTR_UITV_STUK primary key (instrumentnaam, toonhoogte, studentId, stuknr, datumtijdUitvoering)

    create table Stuk (
    stuknr               numeric(5)           not null,
    componistId          numeric(4)           not null,
    titel                varchar(20)          not null,
    stuknrOrigineel      numeric(5)           null,
    genrenaam            varchar(10)          not null,
    niveaucode           char(1)              null,
    speelduur            numeric(3,1)         null,
    jaartal              numeric(4)           not null
    )

    alter table Stuk
    add constraint PK_STUK primary key (stuknr)

    alter table Stuk
    add constraint AK_STUK unique (componistId, titel)

    create table UitvoeringStuk (
    stuknr               numeric(5)           not null,
    datumtijdUitvoering  datetime             not null
    )

    alter table UitvoeringStuk
    add constraint PK_UITVOERINGSTUK primary key (stuknr, datumtijdUitvoering)

    alter table Bezettingsregel
    add constraint FK_BZTRGL_REF_INSTR foreign key (instrumentnaam, toonhoogte)
        references Instrument (instrumentnaam, toonhoogte)

    alter table Bezettingsregel
    add constraint FK_BZTRGL_REF_STUK foreign key (stuknr)
        references Stuk (stuknr)

    alter table Componist
    add constraint FK_COMP_REF_SCHOOL foreign key (schoolId)
        references Muziekschool (schoolId)

    alter table Student
    add constraint FK_STUDENT_REF_SCHOOL foreign key (schoolId)
        references Muziekschool (schoolId)

    alter table StudentInstrument
    add constraint FK_STUDENT_REF_NIVEAU foreign key (niveaucode)
        references Niveau (niveaucode)

    alter table StudentInstrument
    add constraint FK_STUDINSTR_REF_STUDENT foreign key (studentId)
        references Student (studentId)

    alter table StudentInstrument
    add constraint FK_STUD_REF_INSTRUMENT foreign key (instrumentnaam, toonhoogte)
        references Instrument (instrumentnaam, toonhoogte)

    alter table StudentInstrumentUitvoeringStuk
    add constraint FK_STUDINSTR_REF_STUDINSTRUITV foreign key (instrumentnaam, toonhoogte, studentId)
        references StudentInstrument (instrumentnaam, toonhoogte, studentId)

    alter table StudentInstrumentUitvoeringStuk
    add constraint FK_STUDINSTR_REF_UITVOERING foreign key (stuknr, datumtijdUitvoering)
        references UitvoeringStuk (stuknr, datumtijdUitvoering)

    alter table Stuk
    add constraint FK_STUK_REF_COMPONIST foreign key (componistId)
        references Componist (componistId)

    alter table Stuk
    add constraint FK_STUK_REF_GENRE foreign key (genrenaam)
        references Genre (genrenaam)

    alter table Stuk
    add constraint FK_STUK_REF_NIVEAU foreign key (niveaucode)
        references Niveau (niveaucode)

    alter table Stuk
    add constraint FK_STUK_REF_STUK foreign key (stuknrOrigineel)
        references Stuk (stuknr)

    alter table UitvoeringStuk
    add constraint FK_UITVOERING_REF_STUK foreign key (stuknr)
        references Stuk (stuknr)',
    'INSERT INTO Muziekschool VALUES (1, ''Muziekschool Amsterdam'',   ''Amsterdam'');
    INSERT INTO Muziekschool VALUES (2, ''Reijnders'''' Muziekschool'', ''Nijmegen'');
    INSERT INTO Muziekschool VALUES (3, ''Het Muziekpakhuis'',        ''Amsterdam'');

    INSERT INTO Componist VALUES ( 1, ''Charlie Parker'', ''12-dec-1904'', NULL);
    INSERT INTO Componist VALUES ( 2, ''Thom Guidi'',     ''05-jan-1946'', 1);
    INSERT INTO Componist VALUES ( 4, ''Rudolf Escher'',  ''08-jan-1912'', NULL);
    INSERT INTO Componist VALUES ( 5, ''Sofie Bergeijk'', ''12-jul-1960'', 2);
    INSERT INTO Componist VALUES ( 8, ''W.A. Mozart'',    ''27-jan-1756'', NULL);
    INSERT INTO Componist VALUES ( 9, ''Karl Schumann'',  ''10-oct-1935'', 2);
    INSERT INTO Componist VALUES (10, ''Jan van Maanen'', ''08-sep-1965'', 1);

    INSERT INTO genre VALUES (''klassiek'');
    INSERT INTO genre VALUES (''jazz'');
    INSERT INTO genre VALUES (''pop'');
    INSERT INTO genre VALUES (''techno'');

    INSERT INTO niveau VALUES (''A'', ''beginners'');
    INSERT INTO niveau VALUES (''B'', ''gevorderden'');
    INSERT INTO niveau VALUES (''C'', ''vergevorderden'');

    INSERT INTO stuk VALUES ( 1,  1, ''Blue bird'',       NULL, ''jazz'',     NULL, 4.5,  1954);
    INSERT INTO stuk VALUES ( 2,  2, ''Blue bird'',       1,    ''jazz'',     ''B'',  4,    1988);
    INSERT INTO stuk VALUES ( 3,  4, ''Air pur charmer'', NULL, ''klassiek'', ''B'',  4.5,  1953);
    INSERT INTO stuk VALUES ( 5,  5, ''Lina'',            NULL, ''klassiek'', ''B'',  5,    1979);
    INSERT INTO stuk VALUES ( 8,  8, ''Berceuse'',        NULL, ''klassiek'', NULL, 4,    1786);
    INSERT INTO stuk VALUES ( 9,  2, ''Cradle song'',     8,    ''klassiek'', ''B'',  3.5,  1990);
    INSERT INTO stuk VALUES (10,  8, ''Non piu andrai'',  NULL, ''klassiek'', NULL, NULL, 1791);
    INSERT INTO stuk VALUES (12,  9, ''I''''ll never go'',  10,   ''pop'',      ''A'',  6,    1996);
    INSERT INTO stuk VALUES (13, 10, ''Swinging Lina'',   5,    ''jazz'',     ''B'',  8,    1997);
    INSERT INTO stuk VALUES (14,  5, ''Little Lina'',     5,    ''klassiek'', ''A'',  4.3,  1998);
    INSERT INTO stuk VALUES (15, 10, ''Blue sky'',        1,    ''jazz'',     ''A'',  4,    1998);


    INSERT INTO instrument VALUES (''piano'',    ''''       );
    INSERT INTO instrument VALUES (''fluit'',    ''''       );
    INSERT INTO instrument VALUES (''fluit'',    ''alt''    );
    INSERT INTO instrument VALUES (''saxofoon'', ''alt''    );
    INSERT INTO instrument VALUES (''saxofoon'', ''tenor''  );
    INSERT INTO instrument VALUES (''saxofoon'', ''sopraan'');
    INSERT INTO instrument VALUES (''gitaar'',   ''''       );
    INSERT INTO instrument VALUES (''viool'',    ''''       );
    INSERT INTO instrument VALUES (''viool'',    ''alt''    );
    INSERT INTO instrument VALUES (''drums'',    ''''       );

    INSERT INTO bezettingsregel VALUES ( 2, ''drums'',    '''',      1);
    INSERT INTO bezettingsregel VALUES ( 2, ''saxofoon'', ''alt'',   2);
    INSERT INTO bezettingsregel VALUES ( 2, ''saxofoon'', ''tenor'', 1);
    INSERT INTO bezettingsregel VALUES ( 2, ''piano'',    '''',      1);
    INSERT INTO bezettingsregel VALUES ( 3, ''fluit'',    '''',      1);
    INSERT INTO bezettingsregel VALUES ( 5, ''fluit'',    '''',      3);
    INSERT INTO bezettingsregel VALUES ( 9, ''fluit'',    '''',      1);
    INSERT INTO bezettingsregel VALUES ( 9, ''fluit'',    ''alt'',   1);
    INSERT INTO bezettingsregel VALUES ( 9, ''piano'',    '''',      1);
    INSERT INTO bezettingsregel VALUES (12, ''piano'',    '''',      1);
    INSERT INTO bezettingsregel VALUES (12, ''fluit'',    '''',      2);
    INSERT INTO bezettingsregel VALUES (13, ''drums'',    '''',      1);
    INSERT INTO bezettingsregel VALUES (13, ''saxofoon'', ''alt'',   1);
    INSERT INTO bezettingsregel VALUES (13, ''saxofoon'', ''tenor'', 1);
    INSERT INTO bezettingsregel VALUES (13, ''fluit'',    '''',      2);
    INSERT INTO bezettingsregel VALUES (14, ''piano'',    '''',      1);
    INSERT INTO bezettingsregel VALUES (14, ''fluit'',    '''',      1);
    INSERT INTO bezettingsregel VALUES (15, ''saxofoon'', ''alt'',   2);
    INSERT INTO bezettingsregel VALUES (15, ''fluit'',    ''alt'',   2);
    INSERT INTO bezettingsregel VALUES (15, ''piano'',    '''',      1);

    INSERT INTO student (studentid, schoolid, voornaam, achternaam, inschrijfdatum)
        VALUES(1, 1, ''Emmy'', ''Verhey'', ''2000-09-01''),
        (2,2, ''Candy'', ''Dulfer'', ''2000-09-01''),
        (3,3, ''Thijs'', ''van Leer'', ''2000-09-01''),
        (4,1, ''Ome'', ''Willem'', ''2000-09-01''),
        (5,2, ''Wibi'', ''Soerjadi'', ''2000-09-01''),
        (7,3, ''Misja'', ''Nabben'', ''2000-09-01''),
        (8,2, ''Harrie'', ''van Seters'', ''2000-09-01''),
        (9,1, ''Jan'', ''Akkerman'', ''2000-09-01''),
        (10,2, ''Hans'', ''Dulfer'', ''2000-09-01'') 

    INSERT INTO studentinstrument (instrumentnaam, toonhoogte, studentid, niveaucode)
        VALUES (''viool'', ''alt'', 1, ''C''),
        (''saxofoon'', ''alt'', 2, ''C''),
        (''fluit'', '''', 3, ''C''),
        (''drums'', '''', 4, ''B''),
        (''piano'', '''', 5, ''C''),
        (''saxofoon'', ''alt'', 7, ''B''),
        (''fluit'', ''alt'', 8, ''A''),
        (''saxofoon'', ''tenor'', 2, ''B''),
        (''fluit'', ''alt'', 3, ''B''),
        (''gitaar'', '''', 9, ''C''),
        (''saxofoon'', ''tenor'', 10, ''C'')

    INSERT INTO uitvoeringstuk (stuknr, datumtijduitvoering)
        VALUES (2, ''20141224''),
        (3, ''20150101''),
        (9, ''20151231''),
        (12, ''20151206''),
        (15, ''20160101'')

    INSERT INTO StudentInstrumentUitvoeringStuk(instrumentnaam, toonhoogte, studentId, stuknr, datumtijduitvoering)
        VALUES (''drums'', '''', 4, 2, ''20141224''),
        (''saxofoon'', ''alt'', 2, 2, ''20141224''),
        (''saxofoon'', ''alt'', 7, 2, ''20141224''),
        (''saxofoon'', ''tenor'', 10, 2, ''20141224''),
        (''piano'', '''', 5, 2, ''20141224''),
        (''fluit'', '''', 3, 3, ''20150101''),
        (''piano'', '''', 5, 12, ''20151206''),
        (''fluit'', '''', 3, 12, ''20151206'')'
    )

insert into dbo.CRITERIA_TYPE (criteria_type)
values  ('Banned'),
		('Required')

insert into dbo.REASON (reason_no, reason_description)
values  (60101, 'The database associated with the question currently being graded is unaccessable. This may mean that de DDL script has not yet been executed or an error connection to said database occured.'),
		(60102, 'The SQL statement being graded is not executable'),
		(60103, 'The SQL statement being graded does not return the same records as the correct statement does'),
		(60104, 'The SQL statement being graded does not return the same columns as the correct statement does'),
		(60110, 'No answer was provided by the student')

insert into dbo.CLASS (class)
values  ('ISE-A'),
		('ISE-B'),
		('OOSE-A'),
		('OOSE-B'),
		('OOSE-C')

INSERT INTO STUDENT([student_no],[class],[first_name],[last_name],[is_dyslexic]) VALUES(1,'ISE-A','Alice','Fletcher','0'),(2,'OOSE-B','Jolie','Baker','0'),(3,'OOSE-B','Maggie','Saunders','0'),(4,'OOSE-C','Arden','Delgado','0'),(5,'OOSE-A','Oren','Eaton','0'),(6,'OOSE-C','Autumn','Larson','0'),(7,'ISE-A','Kameko','Hurst','0'),(8,'ISE-B','Acton','Clements','1'),(9,'ISE-A','Jesse','Hayes','0'),(10,'ISE-B','Cain','Russell','1');
INSERT INTO STUDENT([student_no],[class],[first_name],[last_name],[is_dyslexic]) VALUES(11,'ISE-B','Hedy','Le','0'),(12,'OOSE-A','Xenos','Carey','0'),(13,'OOSE-A','Jonah','Ferrell','0'),(14,'ISE-A','Jolene','Buck','0'),(15,'ISE-A','Malik','Hyde','0'),(16,'OOSE-A','April','Freeman','1'),(17,'OOSE-A','Rigel','Bell','0'),(18,'ISE-A','Anjolie','Burgess','0'),(19,'ISE-A','Jonah','Hahn','1'),(20,'ISE-B','Azalia','Pope','0');
INSERT INTO STUDENT([student_no],[class],[first_name],[last_name],[is_dyslexic]) VALUES(21,'OOSE-B','Evangeline','Parrish','0'),(22,'ISE-A','Melodie','Howell','1'),(23,'ISE-A','Ann','Valencia','0'),(24,'OOSE-B','Urielle','Best','1'),(25,'OOSE-B','Rhea','Bowman','1'),(26,'ISE-A','Chadwick','Cotton','0'),(27,'OOSE-A','Mannix','Bartlett','1'),(28,'OOSE-B','Aristotle','Ewing','1'),(29,'OOSE-B','Megan','Sweeney','0'),(30,'OOSE-B','Cedric','Hines','1');

insert into dbo.EXAM_GROUP (exam_group_type)
values  ('Standaard'),
		('Dyslexie'),
		('Herkanser')

insert into dbo.DIFFICULTY (difficulty)
values  ('Year 1'),
		('Year 2'),
		('Year 3')

insert into dbo.COURSE (course, difficulty)
values  ('DB', 'Year 1'),
		('DI', 'Year 2'),
		('ADB', 'Year 3')

INSERT INTO EXAM([exam_id],[course],[exam_name],[starting_date],[comment]) 
VALUES  (1,'DB','Eind Tentame',GETDATE()+1,'metus eu erat semper rutrum. Fusce dolor quam, elementum at, egestas a, scelerisque sed, sapien. Nunc pulvinar arcu et pede. Nunc sed orci lobortis'),
		(2,'DI','Eind Tentame',GETDATE()+2,null),
		(3,'DB','Eind Tentame',GETDATE()+3,'velit. Sed malesuada augue ut lacus. Nulla tincidunt, neque vitae semper egestas,'),
		(4,'DB','Eind Tentame',GETDATE()+4,'vestibulum lorem, sit amet ultricies sem'),
		(5,'DI','Tussentijdse Toets',GETDATE()+5,null),
		(6,'DB','Eind Tentame',GETDATE()+6,'felis ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem, auctor quis, tristique ac, eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie dapibus'),
		(7,'DB','Eind Tentame',GETDATE()+7,'nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc'),
		(8,'DB','Eind Tentame',GETDATE()+8,'sodales at, velit. Pellentesque ultricies'),
		(9,'DI','Tussentijdse Toets',GETDATE()+9,'vel arcu. Curabitur ut odio vel est tempor bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus ut, nulla. Cras eu tellus eu augue porttitor interdum. Sed auctor odio'),
		(10,'DB','Eind Tentame',GETDATE()+10,null);

insert into dbo.EXAM_GROUP_IN_EXAM (exam_id, exam_group_type, end_date)
values  (1, 'Standaard', GETDATE()+1.083),
		(1, 'Dyslexie', GETDATE()+1.104),
		(2, 'Standaard', GETDATE()+2.083),
		(2, 'Herkanser', GETDATE()+2.083),
		-- De examens hieronder worden niet gebruikt
		(3, 'Standaard', GETDATE()+3.083),
		(3, 'Dyslexie', GETDATE()+3.104),
		(3, 'Herkanser', GETDATE()+3.083),
		(4, 'Standaard', GETDATE()+4.083),
		(4, 'Dyslexie', GETDATE()+4.104),
		(4, 'Herkanser', GETDATE()+4.083),
		(5, 'Standaard',  GETDATE()+5.083),
		(5, 'Herkanser', GETDATE()+5.083),
		(6, 'Standaard', GETDATE()+6.083),
		(6, 'Dyslexie', GETDATE()+6.104),
		(6, 'Herkanser', GETDATE()+6.083),
		(7, 'Standaard',  GETDATE()+7.083),
		(7, 'Dyslexie', GETDATE()+7.104),
		(7, 'Herkanser', GETDATE()+7.083),
		(8, 'Standaard', GETDATE()+8.083),
		(8, 'Herkanser', GETDATE()+8.083),
		(9, 'Standaard', GETDATE()+9.083),
		(9, 'Dyslexie', GETDATE()+9.104),
		(9, 'Herkanser', GETDATE()+9.083),
		(10, 'Standaard', GETDATE()+10.083),
		(10, 'Dyslexie', GETDATE()+10.104)

insert into dbo.EXAM_FOR_STUDENT (exam_id, student_no, class, exam_group_type, hand_in_date, result)
values  (1, 1, 'ISE-A', 'Standaard', GETDATE()+1.05 ,1.88),
		(1, 2, 'ISE-A', 'Dyslexie', GETDATE()+1.05, 5.00),
		(2, 3, 'OOSE-C', 'Standaard', null, null),
		(2, 4, 'OOSE-C', 'Herkanser', null, null)

insert into dbo.QUESTION (difficulty, exam_db_name, question_assignment, comment, status)
values  ('Year 1', 'MuziekdatabaseUitgebreid', 'Geef van alle speelstukken van na 1995 het stuknummer, het genre, het niveau en de speelduur. Orden het overzicht op speelduur (van groot naar klein), en bij gelijke speelduur op genre.Stel een SQL SELECT-statement op voor deze informatiebehoefte.', null, 'Active'),
		('Year 1', 'MuziekdatabaseUitgebreid', 'Welke componisten hebben 2 of meer bewerkingen op hun naam staan? Geef componistId en het aantal bewerkingen. Stel een SQL SELECT-statement op voor deze informatiebehoefte.', null, 'Active'),
		('Year 2', 'MuziekdatabaseUitgebreid', 'Geef voor elkniveau de niveaucode, de omschrijving en het aantal klassieke speelstukken. Opmerking: Dus ook als er voor een niveau geen klassieke speelstukken zijn. Stel een SQL SELECT-statement op voor deze informatiebehoefte.', null, 'Active'),
		('Year 3', 'MuziekdatabaseUitgebreid', 'Geef de componistId en naam van alle componisten die geen klassieke stukken hebben geschreven. Stel een SQL SELECT-statement op voor deze informatiebehoefte.', null, 'Active'),
		('Year 3', 'MuziekdatabaseUitgebreid', 'Geef het stuknummer en de titel van het meest recent gecomponeerde muziekstuk. Stel een SQL SELECT-statement op voor deze informatiebehoefte.', null, 'Active'),
		('Year 2', 'MuziekdatabaseUitgebreid', 'Geef van alle speelstukken van na 1995 het stuknummer, het genre, het niveau en de speelduur. Orden het overzicht op speelduur (van groot naar klein), en bij gelijke speelduur op genre.Stel een SQL SELECT-statement op voor deze informatiebehoefte.', null, 'Active'),
		('Year 2', 'MuziekdatabaseUitgebreid', 'Welke componisten hebben 2 of meer bewerkingen op hun naam staan? Geef componistId en het aantal bewerkingen. Stel een SQL SELECT-statement op voor deze informatiebehoefte.', null, 'Active'),
		('Year 2', 'MuziekdatabaseUitgebreid', 'Geef voor elkniveau de niveaucode, de omschrijving en het aantal klassieke speelstukken. Opmerking: Dus ook als er voor een niveau geen klassieke speelstukken zijn. Stel een SQL SELECT-statement op voor deze informatiebehoefte.', null, 'Active')
		
insert into dbo.ANSWER_CRITERIA (question_no, keyword, criteria_type)
values  (1, 'exists', 'Banned'),
		(7, 'join', 'Required')
		
insert into dbo.QUESTION_IN_EXAM (exam_id, question_no, question_points)
values  (1, 1, 15),
		(1, 2, 15),
		(1, 3, 10),
		(1, 4, 40),
		(2, 5, 5),
		(2, 6, 10),
		(2, 7, 20),
		(2, 8, 25)		

insert into dbo.CORRECT_ANSWER (question_no, correct_answer_id, correct_answer_statement)
values  (1, 1, 'SELECT stuknr, genrenaam, niveaucode, speelduur FROM stuk WHERE jaartal = 1995'),
		(2, 1, 'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2'),
		(3, 1, 'SELECT n.niveaucode, n.omschrijving, COUNT(s.stuknr) FROM niveau n JOIN stuk s ON n.niveaucode = s.niveaucode WHERE s.genrenaam = ''klassiek'' GROUP BY n.niveaucode'),
		(4, 1, 'SELECT c.componistId, c.naam FROM componist WHERE componistId IN (SELECT c.componistId FROM componist c JOIN stuk s ON c.componistId = s.componistId WHERE s.genrenaam = ''klassiek'')'),
		(5, 1, 'SELECT TOP 1 stuknr, titel FROM stuk ORDER BY jaartal DESC'),
		(6, 1, 'SELECT stuknr, genrenaam, niveaucode, speelduur FROM stuk WHERE jaartal = 1995'),
		(7, 1, 'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2'),
		(8, 1, 'SELECT n.niveaucode, n.omschrijving, COUNT(s.stuknr) FROM niveau n JOIN stuk s ON n.niveaucode = s.niveaucode WHERE s.genrenaam = ''klassiek'' GROUP BY n.niveaucode')

insert into dbo.ANSWER (student_no, exam_id, question_no, reason_no, answer, answer_status, answer_fill_in_date)
values  (1, 1, 1, 60103, 'SELECT * FROM stuk', 'INCORRECT', GETDATE()+1.01), -- Foute results
		(1, 1, 2, null, 'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'REQUIRE CHECK', GETDATE()+1.02), -- Goed antwoord
		(1, 1, 3, 60104, 'SELECT n.omschrijving, COUNT(s.stuknr) FROM niveau n JOIN stuk s ON n.niveaucode = s.niveaucode WHERE s.genre = "klassiek" GROUP BY n.niveaucode', 'INCORRECT', GETDATE()+1.03), -- Foute kollomen
		(1, 1, 4, 60102, 'Ik weet het niet...', 'INCORRECT', GETDATE()+1.04), -- Foute syntax
		(2, 1, 1, null, 'SELECT stuknr, genre, niveaucode, speelduur FROM stuk WHERE jaartal = 1995 ORDER BY speelduur, genre DESC', 'REQUIRE CHECK', GETDATE()+1.01), -- Goed antwoord
		(2, 1, 2, null, 'SELECT componistId, COUNT(stuknr) FROM stuk WHERE stuknrorgineel is not null GROUP BY componistId HAVING COUNT(stuknr) >= 2', 'PENDING', GETDATE()+1.02), -- Goed antwoord
		(2, 1, 3, null, 'SELECT n.niveaucode, n.omschrijving, COUNT(s.stuknr) FROM niveau n JOIN stuk s ON n.niveaucode = s.niveaucode WHERE s.genre = ''klassiek'' GROUP BY n.niveaucode', 'PENDING', GETDATE()+1.03), -- Goed antwoord
		(2, 1, 4, 60102, '-', 'INCORRECT', GETDATE()+1.04) -- Foute syntax
