use HAN_SQL_EXAM_DATABASE
go 
-----------------------------------------------------------------------------------------------

drop table if exists dbo.ANSWER
drop table if exists dbo.CORRECT_ANSWER
drop table if exists dbo.QUESTION_IN_EXAM
drop table if exists dbo.ANSWER_CRITERIA
drop table if exists dbo.QUESTION
drop table if exists dbo.EXAM_FOR_STUDENT
drop table if exists dbo.EXAM_GROUP_IN_EXAM
drop table if exists dbo.EXAM
drop table if exists dbo.COURSE
drop table if exists dbo.DIFFICULTY
drop table if exists dbo.EXAM_GROUP
drop table if exists dbo.STUDENT
drop table if exists dbo.CLASS
drop table if exists dbo.REASON
drop table if exists dbo.CRITERIA_TYPE
drop table if exists dbo.EXAM_DATABASE
-----------------------------------------------------------------------------------------------

create table dbo.EXAM_DATABASE (
	exam_db_name		varchar(40)		not null,
	exam_ddl_script		varchar(max)	not null,
	exam_dml_script		varchar(max)	not null,

	constraint PK_TEST_DATABASE primary key (exam_db_name),
)

create table dbo.CRITERIA_TYPE (
	criteria_type	varchar(30)		not null,

	constraint PK_CRITERIA_TYPE primary key (criteria_type)
)

create table dbo.REASON (
	reason_no			int				not null,
	reason_description	varchar(1024)	not null,

	constraint PK_REASON primary key (reason_no),

	constraint UN_reason_description unique(reason_description)
)

create table dbo.CLASS (
	class	varchar(20)		not null,

	constraint PK_CLASS primary key (class)
)

create table dbo.STUDENT (
	student_no	int				not null,
	class		varchar(20)		not null,
	first_name	varchar(30)		not null,
	last_name	varchar(50)		not null,
	is_dyslexic	bit				not null,

	constraint PK_STUDENT primary key (student_no),
	constraint FK_class_in_student_to_class	foreign key (class) references dbo.CLASS(class)
)

create table dbo.EXAM_GROUP (
	exam_group_type	varchar(20) not null,

	constraint PK_EXAM_GROUP primary key (exam_group_type),
)

create table dbo.DIFFICULTY (
	difficulty	varchar(10)		not null,

	constraint PK_DIFFICULTY primary key (difficulty)
)

create table dbo.COURSE (
	course		varchar(20)		not null,
	difficulty	varchar(10)		not null,

	constraint PK_COURSE primary key (course),

	constraint FK_difficulty_in_COURSE_to_DIFFICULTY foreign key (difficulty) references dbo.DIFFICULTY(difficulty)
		on update cascade 
		on delete cascade
)

create table dbo.EXAM (
	exam_id			varchar(20)		not null,
	course			varchar(20)		not null,
	exam_name		varchar(50)		not null,
	starting_date	datetime		not null,
	comment			varchar(max)	null,	

	constraint PK_EXAM primary key (exam_id),

	constraint FK_course_in_EXAM_to_COURSE foreign key (course) references dbo.COURSE(course)
		on update cascade 
		on delete cascade,

	constraint CK_starting_date check (starting_date >= getDate()),
	constraint UN_course_exam_name_and_starting_date_in_EXAM unique (course, exam_name, starting_date)
)


create table dbo.EXAM_GROUP_IN_EXAM (
	exam_id			varchar(20)		not null,
	exam_group_type varchar(20)		not null,
	end_date		datetime		not null,

	constraint PK_EXAM_GROUP_IN_EXAM primary key (exam_id, exam_group_type),

	constraint FK_exam_id_in_EXAM_GROUP_IN_EXAM_to_EXAM foreign key (exam_id) references dbo.EXAM(exam_id)
		on update cascade 
		on delete cascade,
	constraint FK_exam_group_type_in_EXAM_GROUP_IN_EXAM_to_EXAM_GROUP foreign key (exam_group_type) references dbo.EXAM_GROUP(exam_group_type)
		on update cascade 
		on delete cascade,
)

create table dbo.EXAM_FOR_STUDENT (
	exam_id		varchar(20)		not null,
	student_no	int				not null,
	class	varchar(20)		not null,
	exam_group_type	varchar(20)		not null,
	hand_in_date datetime		null,
	result		numeric(4, 2)	null,

	constraint PK_EXAM_FOR_STUDENT primary key (exam_id, student_no),
	
	constraint FK_exam_id_in_EXAM_FOR_STUDENT_to_EXAM foreign key (exam_id) references dbo.EXAM(exam_id)
		on update cascade
		on delete cascade,
	constraint FK_student_no_in_EXAM_FOR_STUDENT_to_STUDENT foreign key (student_no) references dbo.STUDENT(student_no)
		on update cascade
		on delete cascade,
	constraint FK_class_in_EXAM_FOR_STUDENT_to_CLASS foreign key (class) references dbo.CLASS(class)
		on update cascade 
		on delete cascade,
	constraint FK_group_type_in_EXAM_FOR_STUDENT_to_EXAM_GROUP foreign key (exam_group_type) references dbo.EXAM_GROUP(exam_group_type)
		on update cascade 
		on delete cascade,
	
	constraint CH_result_is_not_higher_than_ten check (result >= 0 and result <= 10)
)

create table dbo.QUESTION (
	question_no				int				not null	identity(1,1),
	difficulty				varchar(10)		not null,
	exam_db_name			varchar(40)		not null,
	question_assignment		varchar(max)	not null,
	comment					varchar(max)	null,
	status					varchar(20)		not null,

	constraint PK_QUESTION primary key (question_no),

	constraint FK_exam_db_name_in_QUESTION_to_EXAM_DATABASE foreign key (exam_db_name) references dbo.EXAM_DATABASE(exam_db_name)
		on update cascade
		on delete no action,
	constraint FK_difficulty_in_QUESTION_to_DIFFICULTY foreign key (difficulty) references dbo.DIFFICULTY(difficulty)
		on update cascade 
		on delete cascade,

	constraint CK_status check (status = 'deleted' or status = 'active' or status = 'old' or status = 'unused')
)

create table dbo.ANSWER_CRITERIA (
	question_no		int				not null,
	keyword			varchar(30)		not null,
	criteria_type	varchar(30)		not null,

	constraint PK_ANSWER_CRITERIA primary key (question_no, keyword),

	constraint FK_question_no_in_ANSWER_CRITERIA_to_QUESTION foreign key (question_no) references dbo.QUESTION(question_no),
	constraint FK_criteria_type_in_ANSWER_CRITERIA_to_CRITERIA_TYPE foreign key (criteria_type) references dbo.CRITERIA_TYPE(criteria_type)
)

create table dbo.QUESTION_IN_EXAM (
	exam_id					varchar(20)		not null,
	question_no				int				not null,
	question_points			smallint		not null,

	constraint PK_QUESTION_IN_EXAM primary key (exam_id, question_no),
	
	constraint FK_exam_id_in_QUESTION_IN_EXAM_to_EXAM foreign key (exam_id) references dbo.EXAM(exam_id)
		on update cascade
		on delete cascade,
	constraint FK_question_no_in_QUESTION_IN_EXAM_to_QUESTION foreign key (question_no) references dbo.QUESTION(question_no)
		on update no action
		on delete no action,

	constraint CK_question_points_must_be_higher_than_zero check (question_points > 0)
)

create table dbo.CORRECT_ANSWER (
	question_no					int				not null,
	correct_answer_id			smallint		not null,
	correct_answer_statement	varchar(max)	not null,

	constraint PK_CORRECT_ANSWER primary key (question_no, correct_answer_id),
	
	constraint FK_question_no_in_CORRECT_ANSWER_to_QUESTION foreign key (question_no) references dbo.QUESTION(question_no)
		on update cascade
		on delete cascade,
)

create table dbo.ANSWER (
	student_no			int				not null,
	exam_id				varchar(20)		not null,
	question_no			int				not null,
	reason_no			int				null,
	answer				varchar(max)	null,
	answer_status		varchar(50)		not null,
	answer_fill_in_date	datetime		not null

	constraint PK_ANSWER primary key (student_no, exam_id, question_no),
	
	constraint FK_student_no_in_ANSWER_to_STUDENT foreign key (student_no) references dbo.STUDENT(student_no)
		on update cascade
		on delete cascade,
	constraint FK_exam_id_and_question_no_in_ANSWER_to_QUESTION_IN_EXAM foreign key (exam_id, question_no) references dbo.QUESTION_IN_EXAM(exam_id, question_no)
		on update cascade
		on delete cascade,
	constraint FK_reason_no_in_ANSWER_to_REASON foreign key (reason_no) references dbo.REASON(reason_no)
		on update cascade
		on delete set null,
		
	constraint CK_answer_status_is_required_values check (answer_status = 'REQUIRE CHECK' OR answer_status = 'INCORRECT' OR answer_status = 'PENDING' OR answer_status = 'MOVED TO CORRECT ANSWER')
)