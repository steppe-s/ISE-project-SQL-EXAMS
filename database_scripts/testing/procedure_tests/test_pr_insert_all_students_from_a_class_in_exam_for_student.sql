use HAN_SQL_EXAM_DATABASE
go

tSQLt.NewTestClass test_pr_insert_all_students_from_a_class_in_exam_for_student
go

create or alter proc test_pr_insert_all_students_from_a_class_in_exam_for_student.test_if_pr_inserts_correct_records
as
begin
    exec tSQLt.FakeTable EXAM_FOR_STUDENT
	exec tSQLt.FakeTable STUDENT

	insert into STUDENT(student_no, class, is_dyslexic)
	values  (1, 'c1', 1),
			(2, 'c1', 0),
			(3, 'c2', 1)

	create table expected (
		exam_id			varchar(20)		not null,
		student_no		int				not null,
		class			varchar(20)		not null,
		exam_group_type	varchar(20)		not null,
		hand_in_date	datetime		null,
		result			numeric(4, 2)	null
	)

    exec tSQLt.ExpectNoException

    insert into expected(exam_id, student_no, class, exam_group_type, hand_in_date, result)
	values  ('eId', 1, 'c1', 'Dyslexie', null, null),
			('eId', 2, 'c1', 'Standaard', null, null)

    exec pr_insert_all_students_from_a_class_in_exam_for_student @class = 'c1', @exam_id = 'eId'

    exec tSQLt.AssertEqualsTable 'expected', 'EXAM_FOR_STUDENT'
end
go

create or alter proc test_pr_insert_all_students_from_a_class_in_exam_for_student.test_if_pr_throws_when_class_is_null
as
begin
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%class cannot be NULL%'

    exec pr_insert_all_students_from_a_class_in_exam_for_student @class = null, @exam_id = 'eId'
end
go

create or alter proc test_pr_insert_all_students_from_a_class_in_exam_for_student.test_if_pr_throws_when_exam_id_is_null
as
begin
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%'

    exec pr_insert_all_students_from_a_class_in_exam_for_student @class = 'c1', @exam_id = null
end
go