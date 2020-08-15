use HAN_SQL_EXAM_DATABASE
go

tSQLt.NewTestClass 'test_pr_insert_exam'
go

create or alter proc test_pr_insert_exam.test_if_pr_inserts_correct_record
as
begin
    --Arrange
    declare @exam_id varchar(20) = 'eId1'
	declare @course varchar(20) = 'cId1'
	declare @exam_name varchar(50) = 'Name of exam'
	declare @starting_date	datetime = GETDATE()+120
	declare @comment varchar(max) = 'Be smart!'

    exec tSQLt.FakeTable 'EXAM'
    exec tSQLt.ExpectNoException

    create table expected (
		exam_id			varchar(20)		not null,
		course			varchar(20)		not null,
		exam_name		varchar(50)		not null,
		starting_date	datetime		not null,
		comment			varchar(max)	null,	
	)
    
	insert into expected (exam_id, course, exam_name, starting_date, comment)
	values (@exam_id, @course, @exam_name, @starting_date, @comment)
    
    --Act
    exec pr_insert_exam @exam_id, @course, @exam_name, @starting_date, @comment

    --Assert
    exec tSQLt.AssertEqualsTable 'expected', 'EXAM'
end
go

create or alter proc test_pr_insert_exam.test_if_pr_throws_when_exam_id_is_null
as
begin
    --Arrange
    declare @exam_id varchar(20) = null
	declare @course_id varchar(20) = 'cId1'
	declare @exam_name varchar(50) = 'Name of exam'
	declare @starting_date	datetime = GETDATE()+120
	declare @comment varchar(max) = 'Be smart!'

    exec tSQLt.FakeTable 'EXAM'
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_id cannot be null%'
    
    --Act
    exec pr_insert_exam @exam_id, @course_id, @exam_name, @starting_date, @comment
end
go

create or alter proc test_pr_insert_exam.test_if_pr_throws_when_course_id_is_null
as
begin
    --Arrange
    declare @exam_id varchar(20) = 'eId1'
	declare @course_id varchar(20) = null
	declare @exam_name varchar(50) = 'Name of exam'
	declare @starting_date	datetime = GETDATE()+120
	declare @comment varchar(max) = 'Be smart!'

    exec tSQLt.FakeTable 'EXAM'
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%course cannot be null%'
    
    --Act
    exec pr_insert_exam @exam_id, @course_id, @exam_name, @starting_date, @comment
end
go

create or alter proc test_pr_insert_exam.test_if_pr_throws_when_exam_name_is_null
as
begin
    --Arrange
    declare @exam_id varchar(20) = 'eId1'
	declare @course_id varchar(20) = 'cId1'
	declare @exam_name varchar(50) = null
	declare @starting_date datetime = GETDATE()+120
	declare @comment varchar(max) = 'Be smart!'

    exec tSQLt.FakeTable 'EXAM'
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%exam_name cannot be null%'
    
    --Act
    exec pr_insert_exam @exam_id, @course_id, @exam_name, @starting_date, @comment
end
go



create or alter proc test_pr_insert_exam.test_if_pr_throws_when_starting_date_is_null
as
begin
    --Arrange
    declare @exam_id varchar(20) = 'eId1'
	declare @course_id varchar(20) = 'cId1'
	declare @exam_name varchar(50) = 'Name of exam'
	declare @starting_date	datetime = null
	declare @comment varchar(max) = 'Be smart!'

    exec tSQLt.FakeTable 'EXAM'
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%starting_date cannot be null or before the current date%'
    
    --Act
    exec pr_insert_exam @exam_id, @course_id, @exam_name, @starting_date, @comment
end
go

create or alter proc test_pr_insert_exam.test_if_pr_throws_when_starting_date_is_in_the_past
as
begin
    --Arrange
    declare @exam_id varchar(20) = 'eId1'
	declare @course_id varchar(20) = 'cId1'
	declare @exam_name varchar(50) = 'Name of exam'
	declare @starting_date	datetime = GETDATE()-120
	declare @comment varchar(max) = 'Be smart!'

    exec tSQLt.FakeTable 'EXAM'
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%starting_date cannot be null or before the current date%'
    
    --Act
    exec pr_insert_exam @exam_id, @course_id, @exam_name,@starting_date, @comment
end
go

create or alter proc test_pr_insert_exam.test_if_pr_inserts_when_starting_date_is_further_than_current
as
begin
    --Arrange
    declare @exam_id varchar(20) = 'eId1'
	declare @course_id varchar(20) = 'cId1'
	declare @exam_name varchar(50) = 'Name of exam'
	declare @starting_date datetime = GETDATE()+120
	declare @comment varchar(max) = 'Be smart!'

    exec tSQLt.FakeTable 'EXAM'
    exec tSQLt.ExpectNoException
    
    --Act
    exec pr_insert_exam @exam_id, @course_id, @exam_name, @starting_date, @comment
end
go

create or alter proc test_pr_insert_exam.test_if_pr_inserts_when_comment_is_null
as
begin
    --Arrange
    declare @exam_id varchar(20) = 'eId1'
	declare @course_id varchar(20) = 'cId1'
	declare @exam_name varchar(50) = 'Name of exam'
	declare @starting_date	datetime = GETDATE()+120
	declare @comment varchar(max) = null

    exec tSQLt.FakeTable 'EXAM'
    exec tSQLt.ExpectNoException 
    
    --Act
    exec pr_insert_exam @exam_id, @course_id, @exam_name, @starting_date, @comment
end
go

