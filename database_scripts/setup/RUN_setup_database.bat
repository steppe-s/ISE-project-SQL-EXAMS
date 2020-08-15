@ECHO OFF
SET SQLCMD="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"

SET PATH="%~dp0"

SET DB="master"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)