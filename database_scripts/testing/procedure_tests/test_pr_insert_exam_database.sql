use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_insert_exam_database
go

create or alter proc test_pr_insert_exam_database.[test if insert_exam_database throws exam_db_name cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_db_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_insert_exam_database @exam_db_name = NULL, @exam_ddl_script = 'exam_ddl_script', @exam_dml_script = 'exam_dml_script'
end
go

create or alter proc test_pr_insert_exam_database.[test if insert_exam_database throws exam_ddl_script cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_ddl_script cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_insert_exam_database @exam_db_name = 'exam_db_name', @exam_ddl_script = NULL, @exam_dml_script = 'exam_dml_script'
end
go

create or alter proc test_pr_insert_exam_database.[test if insert_exam_database throws exam_dml_script cannot be null] 
as
begin
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%exam_dml_script cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	EXEC pr_insert_exam_database @exam_db_name = 'exam_db_name', @exam_ddl_script = 'exam_ddl_script', @exam_dml_script = NULL
end
go

create or alter proc test_pr_insert_exam_database.[test if insert_exam_database inserts exam_database] 
as
begin

	CREATE TABLE EXPECTED(exam_db_name VARCHAR(40), exam_ddl_script VARCHAR(MAX), exam_dml_script VARCHAR(MAX))
	INSERT INTO EXPECTED VALUES('exam_db_name', 'exam_ddl_script', 'exam_dml_script')

	EXEC tSQLt.ExpectNoException
	EXEC pr_insert_exam_database @exam_db_name = 'exam_db_name', @exam_ddl_script = 'exam_ddl_script', @exam_dml_script = 'exam_dml_script'
end
go