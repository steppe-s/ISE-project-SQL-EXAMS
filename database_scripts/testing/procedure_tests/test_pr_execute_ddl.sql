USE HAN_SQL_EXAM_DATABASE
GO
EXEC tSQLt.NewTestClass test_pr_execute_ddl
GO

CREATE OR ALTER PROC test_pr_execute_ddl.[test if pr_execute_ddl throws exam_db_name cannot be null]
AS
BEGIN

EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_db_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_execute_ddl null

END
GO

CREATE OR ALTER PROC test_pr_execute_ddl.[test if pr_execute_ddl throws Database associated with name not found]
AS
BEGIN
EXEC tSQLt.SpyProcedure pr_create_database
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%Database associated with name not found%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_execute_ddl 'db_name'

END
GO

CREATE OR ALTER PROC test_pr_execute_ddl.[test if pr_execute_ddl throws Database required for script is not available]
AS
BEGIN
EXEC tSQLt.SpyProcedure pr_create_database

EXEC tSQLt.FakeTable EXAM_DATABASE
INSERT INTO EXAM_DATABASE (exam_db_name, exam_ddl_script) VALUES ('non-name', 'CREATE TABLE test2 (column2 int)')

EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%Database required for script is not available%', @ExpectedSeverity = 16, @ExpectedState = NULL;
EXEC pr_execute_ddl 'non-name'

END
GO