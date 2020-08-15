USE HAN_SQL_EXAM_DATABASE
GO
CREATE OR ALTER PROCEDURE pr_create_database
@exam_db_name NVARCHAR(40)
AS
BEGIN
    BEGIN TRY
    IF @exam_db_name is NULL
        THROW 60004, 'exam_db_name cannot be null', 1;
    DECLARE @prep NVARCHAR(MAX) = N'DROP DATABASE IF EXISTS ' + @exam_db_name
    EXEC sp_executesql @prep
    SET @prep = N'CREATE DATABASE ' + @exam_db_name
    EXEC sp_executesql @prep
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END