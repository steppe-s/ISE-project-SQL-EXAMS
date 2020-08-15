use HAN_SQL_EXAM_DATABASE
go

tSQLt.NewTestClass 'test_pr_delete_answer_criteria'
go

create or alter proc test_pr_delete_answer_criteria.test_if_pr_delete_correct_record
as
begin
    --Arrange
	declare @question_no int = 1
	declare @keyword varchar(30) = 'join'
	declare @keyword2 varchar(30) = 'where'
	declare @criteria_type varchar(30) = 'Banned'
	
    exec tSQLt.FakeTable 'ANSWER_CRITERIA'
    exec tSQLt.ExpectNoException
    
	insert into ANSWER_CRITERIA (question_no, keyword, criteria_type)
	values  (@question_no, @keyword, @criteria_type),
			(@question_no, @keyword2, @criteria_type)

    create table expected (
		question_no		int				not null,
		keyword			varchar(30)		not null,
		criteria_type	varchar(30)		not null,
	)
	
	insert into expected (question_no, keyword, criteria_type)
	values  (@question_no, @keyword2, @criteria_type)

    --Act
    exec pr_delete_answer_criteria @question_no, @keyword

    --Assert
    exec tSQLt.AssertEqualsTable 'expected', 'ANSWER_CRITERIA'
end
go

create or alter proc test_pr_delete_answer_criteria.test_if_pr_throws_when_question_no_is_null
as
begin
    --Arrange
	declare @question_no int = null
	declare @keyword varchar(30) = 'join'
	
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%question_no cannot be null%'
    
    --Act
    exec pr_delete_answer_criteria @question_no, @keyword
end
go

create or alter proc test_pr_delete_answer_criteria.test_if_pr_throws_when_keyword_is_null
as
begin
    --Arrange
	declare @question_no int = 1
	declare @keyword varchar(30) = null
	
    exec tSQLt.ExpectException @ExpectedMessagePattern = '%keyword cannot be null%'
    
    --Act
    exec pr_delete_answer_criteria @question_no, @keyword
end
go