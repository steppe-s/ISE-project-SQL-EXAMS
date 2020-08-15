use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass 'test_tr_ddl_and_dml_filter'
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_correclty_removes_comments_in_ddl_script
as
begin
	exec tSQLt.FakeTable 'EXAM_DATABASE'

	exec tSQLt.ApplyTrigger 'EXAM_DATABASE', 'tr_ddl_and_dml_filter'

	create table expected (
		exam_db_name	varchar(40),
		exam_ddl_script	varchar(max),
		exam_dml_script	varchar(max)
	)

	insert into expected(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert into chairs')

	exec tSQLt.ExpectNoException

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'crea/*comments*/te table/*bla*/ chairs', 'insert into chairs')

	exec tSQLt.AssertEqualsTable 'expected', 'EXAM_DATABASE'
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_correclty_removes_comments_in_dml_script
as
begin
	exec tSQLt.FakeTable 'EXAM_DATABASE'

	exec tSQLt.ApplyTrigger 'EXAM_DATABASE', 'tr_ddl_and_dml_filter'

	create table expected (
		exam_db_name	varchar(40),
		exam_ddl_script	varchar(max),
		exam_dml_script	varchar(max)
	)

	insert into expected(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert into chairs')

	exec tSQLt.ExpectNoException

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert /*comments*/into chai/*bla*/rs')

	exec tSQLt.AssertEqualsTable 'expected', 'EXAM_DATABASE'
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_ddl_is_empty
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Query_statement cannot be null%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', '', 'insert /*comments*/into chai/*bla*/rs')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_dml_is_empty
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Query_statement cannot be null%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', '')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_ddl_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Query_statement cannot be null%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', null, 'insert /*comments*/into chai/*bla*/rs')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_dml_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Query_statement cannot be null%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', null)
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_ddl_contains_drop_database
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit drop statement%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs; drop database han_sql', 'insert into chairs')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_dml_contains_drop_database
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit drop statement%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert into chairs; drop database han_sql')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_ddl_contains_delete
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit delete statement%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs; delete from tables', 'insert into chairs')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_dml_contains_delete
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit delete statement%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert into chairs; delete from tables')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_ddl_contains_illegal_comments
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit comment characters%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs--werkt goed', 'insert into chairs')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_dml_contains_illegal_comments
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit comment characters%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert into chairs--werkt goed')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_ddl_contains_create_database
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit create statement%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs; create database han_sql', 'insert into chairs')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_dml_contains_drop_database
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit create statement%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert into chairs; create database han_sql')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_ddl_contains_update
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit update statement%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs; update chairs', 'insert into chairs')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_throw_when_dml_contains_update
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%Statement contains illicit update statement%'

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert into chairs; update chairs')
end
go

create or alter proc test_tr_ddl_and_dml_filter.test_if_tr_correclty_removes_comments_in_multiple_insert_statements
as
begin
	exec tSQLt.FakeTable 'EXAM_DATABASE'

	exec tSQLt.ApplyTrigger 'EXAM_DATABASE', 'tr_ddl_and_dml_filter'

	create table expected (
		exam_db_name	varchar(40),
		exam_ddl_script	varchar(max),
		exam_dml_script	varchar(max)
	)

	insert into expected(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'create table chairs', 'insert into chairs'),
		   ('dbName2', 'create table floors', 'insert into floors')

	exec tSQLt.ExpectNoException

	insert into EXAM_DATABASE(exam_db_name, exam_ddl_script, exam_dml_script)
	values ('dbName', 'crea/*comments*/te table/*bla*/ chairs', 'insert into chairs'),
		   ('dbName2', 'crea/*comments*/te table/*bla*/ floors', 'insert into floors')

	exec tSQLt.AssertEqualsTable 'expected', 'EXAM_DATABASE'
end
go
