USE master

DROP DATABASE IF EXISTS stagingTest
CREATE DATABASE stagingTest
USE stagingTest

CREATE TABLE ANSWER (
	student		BIGINT NOT NULL,
	question_no BIGINT NOT NULL,
	set_id	    bigint not null,
	answer		varchar(MAX) NOT NULL,
	correct		bit not null,
	PRIMARY KEY (student, question_no, set_id)
)