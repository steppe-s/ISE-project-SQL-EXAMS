USE MASTER
drop database if exists VerifyPrototype
go

CREATE DATABASE VerifyPrototype
go

USE VerifyPrototype

CREATE TABLE SQLqueries (
    queryNo int primary key, 
    query varchar(MAX)
)

CREATE TABLE results (
    queryNo int, 
    correct bit,
    CONSTRAINT fk_queryNo FOREIGN KEY (queryNo) REFERENCES SQLqueries(queryNo)
)

