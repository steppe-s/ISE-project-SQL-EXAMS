@ECHO OFF
SET DB="master"

SET SQLCMD="sqlcmd"

%SQLCMD% -d %DB% -i CAUTION_RUN_drop_database.sql

call RUN_create_full_database_system.bat

CD %~dp0\testing

%SQLCMD% -d %DB% -i TSQLT.sql

call RUN_tests.bat


CD %~dp0


%SQLCMD% -d %DB% -i CAUTION_RUN_drop_database.sql
pause