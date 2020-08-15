-- Fill every XXX
use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass XXX 
go

create or alter proc XXX.[test if XXX] 
as
begin
	exec tSQLt.FakeTable XXX

	exec tSQLt.ApplyConstraint XXX
	exec tSQLt.ApplyTrigger XXX

	-- CHOOSE ONE
	EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%', @ExpectedSeverity = 16, @ExpectedState = NULL;
	exec tSQLt.ExpectNoException

	-- EXECUTE FOR PROC
	exec XXX 
end
go

exec tSQLt.RunTestClass XXX
