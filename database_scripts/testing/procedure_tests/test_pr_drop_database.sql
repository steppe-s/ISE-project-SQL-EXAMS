USE HAN_SQL_EXAM_DATABASE
GO
EXEC tSQLt.NewTestClass test_pr_drop_ddl
GO

CREATE OR ALTER PROC test_pr_drop_ddl.[test if pr_drop_ddl throws exam_db_name cannot be null]
AS
BEGIN

EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_db_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_drop_ddl null

END
GO

CREATE OR ALTER PROC test_pr_drop_ddl.[test if pr_drop_ddl throws provided database does not exist]
AS
BEGIN

EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%The provided database name does not exist%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_drop_ddl 'niet-bestaande-database'

END
GO