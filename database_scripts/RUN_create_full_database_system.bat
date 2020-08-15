CD %~dp0\setup
call RUN_setup_database.bat

CD %~dp0\stored_procedures
call RUN_stored_procedures.bat

CD %~dp0\triggers
call RUN_triggers.bat

CD %~dp0\functions
call RUN_functions.bat

CD %~dp0\setup\users
call RUN_users.bat