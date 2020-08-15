USE HAN_SQL_EXAM_DATABASE
GO

CREATE OR ALTER FUNCTION ft_execute_statement_into_json
(@statement varchar(max), @exam_db_name varchar(40))
RETURNS VARCHAR(max)
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @json_resultset VARCHAR(MAX)
    DECLARE @sql_statement NVARCHAR(MAX) = ('SELECT @json = ('+@statement+' FOR JSON AUTO)')
    DECLARE @cross_statement NVARCHAR(MAX) = @exam_db_name + '.dbo.sp_executesql N''' + @sql_statement + ''', N''@json VARCHAR(MAX) out'', @json_resultset out'
    EXEC sp_executesql @cross_statement, N'@json_resultset VARCHAR(MAX) out', @json_resultset out
    RETURN @json_resultset
END
GO