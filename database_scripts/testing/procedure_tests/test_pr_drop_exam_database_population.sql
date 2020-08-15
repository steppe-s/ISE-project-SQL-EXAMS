use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass test_pr_drop_exam_database_population
go

create or alter proc test_pr_drop_exam_database_population.[test if drop_exam_database_population throws exam_db_name cannot be null] 
as
begin
	
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_db_name cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_drop_exam_database_population @exam_db_name = null

end
go


create or alter proc test_pr_drop_exam_database_population.[test if drop_exam_database_population throws provided database name does not exist] 
as
begin
	exec tSQLt.FakeTable @TableName = 'EXAM_DATABASE'

	exec tSQLt.ExpectException @ExpectedMessagePattern = '%The provided database name does not exist%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec pr_drop_exam_database_population @exam_db_name = 'exam_db_name'

end
go