USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER FUNCTION ft_compare_sql_statements
(@st1 varchar(max), @st2 varchar(max))
RETURNS bit
WITH EXECUTE AS CALLER
AS
BEGIN
	IF(REPLACE(REPLACE(REPLACE(REPLACE(@st1, ' ', ''), char(13), ''), char(10), ''), char(9), '') != 
	REPLACE(REPLACE(REPLACE(REPLACE(@st2, ' ', ''), char(13), ''), char(10), ''), char(9), ''))
        RETURN 0
    RETURN 1
END