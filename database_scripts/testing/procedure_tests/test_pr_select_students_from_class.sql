use HAN_SQL_EXAM_DATABASE
go

exec tSQLt.NewTestClass 'test_pr_select_students_from_class'
go

create or alter proc test_pr_select_students_from_class.test_if_pr_throw_when_class_id_is_null
as
begin
	exec tSQLt.ExpectException @ExpectedMessagePattern = '%class cannot be NULL%'
	exec pr_select_students_from_class @class = null
end
go

create or alter proc test_pr_select_students_from_class.test_if_pr_does_returns_correct_data
as
begin
	declare @exam_id varchar(20) = 'eId'
	declare @student_no	int = 123
	declare @class varchar(20) = 'cId'
	declare @exam_group_type varchar(20) = 'gId'
	declare @result numeric(4, 2) = 5.5

	exec tSQLt.FakeTable 'EXAM_FOR_STUDENT'
	exec tSQLt.ExpectNoException 

	insert into EXAM_FOR_STUDENT(exam_id, student_no, class, exam_group_type, result)
	values  (@exam_id, @student_no, @class, @exam_group_type, @result)

	exec tSQLt.AssertResultSetsHaveSameMetaData @expectedCommand = 'select distinct s.*
		from EXAM_FOR_STUDENT e
			inner join STUDENT s on e.student_no = s.student_no
		where e.class = ''cId''', @actualCommand = 'exec pr_select_students_from_class @class = ''cId'''
end
go