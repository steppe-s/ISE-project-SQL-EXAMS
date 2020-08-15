use master
go

drop database if exists DATA_WAREHOUSE
go

CREATE DATABASE DATA_WAREHOUSE
GO

USE DATA_WAREHOUSE
GO

CREATE TABLE STUDENT_RESULTS (
	student		BIGINT NOT NULL,
	question_no BIGINT NOT NULL,
	set_id	    bigint not null,
	correct		bit not null,
	PRIMARY KEY (student, question_no, set_id)
)


