@ECHO OFF
SET SQLCMD="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"

SET DB="master"

SET PATH="%~dp0\delete"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

SET PATH="%~dp0\insert"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

SET PATH="%~dp0\overig"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

SET PATH="%~dp0\overig\grading_procedures"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

SET PATH="%~dp0\select"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

SET PATH="%~dp0\select\reporting_procedures"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

SET PATH="%~dp0\update"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)
