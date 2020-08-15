USE HAN_SQL_EXAM_DATABASE
GO
tSQLt.NewTestClass 'test_pr_update_ddl'
GO

CREATE OR ALTER PROCEDURE test_pr_update_ddl.[test if update_ddl throws db_name cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_db_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_ddl
		@exam_db_name = NULL,
		@ddl_script =  'DML'

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_ddl.[test if update_ddl throws ddl_script cannot be null]
AS
BEGIN

exec tSQLt.ExpectException @ExpectedMessagePattern = '%ddl_script cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_ddl
		@exam_db_name = '',
		@ddl_script =  NULL

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_ddl.[test if update ddl throws script <name> does not exists]
AS
BEGIN

exec tSQLt.FakeTable @TableName = EXAM_DATABASE
INSERT INTO EXAM_DATABASE VALUES('test', 'DDL', 'DML')

exec tSQLt.ExpectException @ExpectedMessagePattern = '%script: testing does not exists%', @ExpectedSeverity = 16, @ExpectedState = NULL;
exec pr_update_ddl 
	@exam_db_name = 'testing',
	@ddl_script = 'DDL'

END
GO

CREATE OR ALTER PROCEDURE test_pr_update_ddl.[test if update ddl updates a ddl]
AS
BEGIN

exec tSQLt.FakeTable @TableName = EXAM_DATABASE
INSERT INTO EXAM_DATABASE VALUES('TEST', 'DDL', 'DML')

CREATE TABLE expected (exam_db_name VARCHAR(20), exam_ddl_script varchar(max), exam_dml_script varchar(max))
    INSERT INTO expected (exam_db_name, exam_ddl_script, exam_dml_script) VALUES ('test', 'ddl_updated', 'dml') 

exec tSQLt.ExpectNoException
exec pr_update_ddl
	@exam_db_name = 'test',
	@ddl_script = 'ddl_updated'

exec tSQLt.AssertEqualsTable @Expected = 'expected', @actual = 'EXAM_DATABASE'

END
GO