# Prototype: nakijk functionaliteit

## Omschrijving

Een van de belangrijkste en complexe onderdelen is het nakijken van de ingevoerde SQL-queries. Dit prototype implementeert een vereenvoudigde versie van dit onderdeel. Het prototype kan een SQL-query vergelijken met een query uit een collectie antwoorden. Hier wordt gecontroleerd of de query uitvoerbaar is (syntax) en of de resultaten gelijk zijn. Dit wordt gedaan door zowel de opgegeven als de correcte query uit te voeren en de resultaten te vergelijken. Het resultaat van de vergelijking wordt in de ‘results’ tabel gezet.

## Prototype

Het Prototype is uitgewerkt in het bestand prototype.sql. Voor dit prototype is een stored procedure ontwikkeld. De stored procedure heeft transaction en error afhandeling gebaseerd op een template.

```SQL
DECLARE @query VARCHAR(MAX)
SELECT @query = query FROM SQLqueries WHERE queryNo = @queryNo
```

Deze code haalt de correcte query op uit de database. Dit wordt bepaald door het queryNo dat meegegeven is als parameter.

```SQL
BEGIN TRY
    EXEC (@query)
END TRY
BEGIN CATCH
    THROW 51001, 'Statement not executable', 1;
END CATCH
```

De bovenstaande code controleerd of de syntax van de query correct is door hem uit te voeren. Als de syntax van de query incorrect is dan geeft de EXEC een error waardoor de code wordt gestopt en het resultaat wordt geretourneerd. Om deze code ook voor CRUD queries correct te laten verlopen zal er een transaction toe moeten worden gevoegd.

```SQL
BEGIN TRY
    DECLARE @query2 NVARCHAR(MAX) = @query + ' Except ' + @correctQuery + ' union ' + @correctQuery + ' Except ' + @Query
    EXEC sp_executesql @query2
    if(@@rowcount > 0)
        THROW 51003, 'Queries do not return same rows', 1;
END TRY
BEGIN CATCH
    IF(ERROR_NUMBER() = 51003)
        THROW;
    THROW
END CATCH
```

Om de resultaten van de opgegeven query te vergelijken met het correcte antwoord worden de queries samen gevoegd tot een query met gebruik van de EXCEPT en UNION operator. Door EXCEPT te gebruiken om de twee queries te vergelijken worden de records teruggegeven die niet uit de select statement komen van de rechter query maar wel uit de linker query komen. Door UNION te gebruiken met een extra EXCEPT waar de twee queries zijn verwisselt worden dan alle verschillen gegeven. De samengevoegde query komt er dan ongeveer zo uit te zien:

```SQL
SELECT * FROM table_1 EXCEPT SELECT * FROM table_2
UNION
SELECT * FROM table_2 EXCEPT SELECT * FROM table_1
--SELECT * FROM table 1/2 wordt hier vervangen met de opgegeven queries.
```



Als deze query records geeft zijn de geselecteerde rows niet aan elkaar gelijk. Als de query een error geeft dan heeft de opgegeven query de incorrecte kolommen geselecteerd.



```SQL
INSERT INTO results (queryNo, correct) VALUES (@queryNo, 1)
```

Als de query langs alle bovenstaande code is gekomen wordt er de bovenstaande query uitgevoerd om op te slaan dat het antwoord correct is.

```SQL
BEGIN CATCH
    INSERT INTO results (queryNo, correct) VALUES (@queryNo, 0)
END CATCH
```

Indien een van de bovenstaande errors wordt gegeven wordt de bovenstaande query uitgevoerd om aan te geven dat de query incorrect is.

## DDL.sql

Het DDL script creëert een database met twee tabellen. De tabel ‘SQLqueries’ bevat de SQL queries die worden nagekeken. ‘results’ bevat de resultaten van het prototype. Hier wordt voor elke query bijgehouden of deze correct of incorrect is.

## DML.sql

Het DML-script voegt een aantal SQL-queries toe aan de database om deze te kunnen testen. De queries variëren zodat verschillende mogelijkheden kunnen worden getest in het prototype.
