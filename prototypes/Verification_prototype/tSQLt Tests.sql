use VerifyPrototype
go

exec tSQLt.NewTestClass 'VerifyPrototypeTests'
go

create or alter proc VerifyPrototypeTests.[test if result is 1 when syntax is right]
as
begin
	exec tSQLt.FakeTable 'results' 

	exec tSQLt.ExpectNoException

	exec proc_prototype 1, 'select * from SQLqueries'

	if exists (
		select * 
		from results
		where queryNo = 1 and correct = 0
	)
		throw 52000, 'exception', 1
end
go

create or alter proc VerifyPrototypeTests.[test if result is 0 when syntax is wrong]
as
begin
	exec tSQLt.FakeTable 'results' 

	exec tSQLt.ExpectNoException

	exec proc_prototype 2, 'select * from SQLqueries'

	if exists (
		select * 
		from results
		where queryNo = 1 and correct = 1
	)
		throw 52000, 'exception', 1
end
go

create or alter proc VerifyPrototypeTests.[test if result is 0 when wrong records are returned]
as
begin
	exec tSQLt.FakeTable 'results' 

	exec tSQLt.ExpectNoException

	exec proc_prototype 3, 'select * from SQLqueries'

	if exists (
		select * 
		from results
		where queryNo = 1 and correct = 1
	)
		throw 52000, 'exception', 1
end
go

create or alter proc VerifyPrototypeTests.[test if result is 0 when wrong columns are returned]
as
begin
	exec tSQLt.FakeTable 'results' 

	exec tSQLt.ExpectNoException

	exec proc_prototype 4, 'select * from SQLqueries'

	if exists (
		select * 
		from results
		where queryNo = 1 and correct = 1
	)
		throw 52000, 'exception', 1
end
go
exec tSQLt.RunTestClass 'VerifyPrototypeTests'
