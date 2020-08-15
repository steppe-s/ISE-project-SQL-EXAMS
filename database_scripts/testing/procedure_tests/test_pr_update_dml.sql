USE HAN_SQL_EXAM_DATABASE
GO
tSQLt.NewTestClass 'test_pr_update_dml'
GO

CREATE OR ALTER PROCEDURE test_pr_update_dml.[test if update_dml throws db_name cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_db_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_dml
		@exam_db_name = NULL,
		@dml_script =  'DML'

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_dml.[test if update_dml throws dml_script cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%dml_script cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_dml
		@exam_db_name = '',
		@dml_script =  NULL

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_dml.[test if update dml throws script <name> does not exists]
AS
BEGIN

exec tSQLt.FakeTable @TableName = EXAM_DATABASE
INSERT INTO EXAM_DATABASE VALUES('test', 'DDL', 'DML')

exec tSQLt.ExpectException @ExpectedMessagePattern = '%script: testing does not exists%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_dml 
	@exam_db_name = 'testing',
	@dml_script = 'DML'

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_dml.[test if update dml updates a dml]
AS
BEGIN

exec tSQLt.FakeTable @TableName = EXAM_DATABASE
INSERT INTO EXAM_DATABASE VALUES('TEST', 'DDL', 'DML')

CREATE TABLE expected (exam_db_name VARCHAR(20), exam_ddl_script varchar(max), exam_dml_script varchar(max))
    INSERT INTO expected (exam_db_name, exam_ddl_script, exam_dml_script) VALUES ('test', 'ddl', 'dml_updated') 

exec tSQLt.ExpectNoException
exec pr_update_dml
	@exam_db_name = 'test',
	@dml_script = 'dml_updated'

exec tSQLt.AssertEqualsTable @Expected = 'expected', @actual = 'EXAM_DATABASE'

END
GO