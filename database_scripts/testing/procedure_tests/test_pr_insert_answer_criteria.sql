use HAN_SQL_EXAM_DATABASE
go

tSQLt.NewTestClass 'test_pr_insert_answer_criteria'
go

create or alter proc test_pr_insert_answer_criteria.test_if_pr_inserts_correct_record
as
begin
    --Arrange
    declare @question_no int = 1
	declare @keyword varchar(30) = 'join'
	declare @criteria_type varchar(30) = 'banned'

    exec tSQLt.FakeTable 'ANSWER_CRITERIA'
    exec tSQLt.ExpectNoException

    create table expected (
		question_no		int				not null,
		keyword			varchar(30)		not null,
		criteria_type	varchar(30)		not null
	)
    
	insert into expected (question_no, keyword, criteria_type)
	values  (@question_no, @keyword, @criteria_type)
    
    --Act
    exec pr_insert_answer_criteria @question_no, @keyword, @criteria_type 

    --Assert
    exec tSQLt.AssertEqualsTable 'expected', 'ANSWER_CRITERIA'
end
go

create or alter proc test_pr_insert_answer_criteria.test_if_pr_throws_when_question_no_is_null
as
begin
    --Arrange
    declare @question_no int = null
	declare @keyword varchar(30) = 'join'
	declare @criteria_type varchar(30) = 'banned'

    exec tSQLt.FakeTable 'ANSWER_CRITERIA'
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%'
    
    --Act
    exec pr_insert_answer_criteria @question_no, @keyword, @criteria_type 
end
go

create or alter proc test_pr_insert_answer_criteria.test_if_pr_throws_when_keyword_is_null
as
begin
    --Arrange
    declare @question_no int = 1
	declare @keyword varchar(30) = null
	declare @criteria_type varchar(30) = 'banned'

    exec tSQLt.FakeTable 'ANSWER_CRITERIA'
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%keyword cannot be null%'
    
    --Act
    exec pr_insert_answer_criteria @question_no, @keyword, @criteria_type 
end
go

create or alter proc test_pr_insert_answer_criteria.test_if_pr_throws_when_criteria_type_is_null
as
begin
    --Arrange
    declare @question_no int = 1
	declare @keyword varchar(30) = 'join'
	declare @criteria_type varchar(30) = null

    exec tSQLt.FakeTable 'ANSWER_CRITERIA'
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%criteria_type cannot be null%'
    
    --Act
    exec pr_insert_answer_criteria @question_no, @keyword, @criteria_type 
end
go