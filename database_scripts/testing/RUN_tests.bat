@ECHO OFF

SET SQLCMD="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"

SET PATH="%~dp0\integration_tests"

SET DB="master"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

SET PATH="%~dp0\procedure_tests"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

SET PATH="%~dp0\trigger_tests"

CD %PATH%

for %%f in (*.sql) do (

%SQLCMD% -d %DB% -i %%~f

)

CD %~dp0


%SQLCMD% -d %DB% -i run_tests.sql > %~dp0test_results.txt

pause