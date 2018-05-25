@echo off
:: Shell script to remove a read-only user for a specific database schema
:: on PostgreSQL/PostGIS

:: read database connection details  
call CONNECTION_DETAILS.bat

:: add PGBIN to PATH
set PATH=%PGBIN%;%PATH%

:: cd to path of the shell script
cd /d %~dp0

:: Welcome message
echo  _______   ___ _ _        ___  ___
echo ^|__ /   \ / __(_) ^|_ _  _^|   ^\^| _ )
echo  ^|_ \ ^|) ^| (__^| ^|  _^| ^|^| ^| ^|) ^| _ \
echo ^|___/___/ \___^|_^|\__^|\_, ^|___/^|___/
echo                      ^|__/
echo.
echo 3D City Database - The Open Source CityGML Database
echo.
echo ##################################################################################
echo.
echo This script will drop a read-only user for a specific 3DCityDB schema. Note that
echo this operation cannot be undone. Please follow the instructions of the script.
echo Enter the required parameters when prompted and press ENTER to confirm.
echo Just press ENTER to use the default values.
echo.
echo Documentation and help:
echo    3DCityDB website:    https://www.3dcitydb.org
echo    3DCityDB on GitHub:  https://github.com/3dcitydb
echo.
echo Having problems or need support?
echo    Please file an issue here:
echo    https://github.com/3dcitydb/3dcitydb/issues
echo.
echo ##################################################################################

:: cd to path of the SQL scripts
cd ..\..\SQLScripts\UTIL\RO_USER

:: Prompt for USERNAME --------------------------------------------------------
:username
set var=
echo.
echo Please enter the username of the read-only user.
set /p var="(USERNAME must not be empty): "

if /i not "%var%"=="" (
  set USERNAME=%var%
) else (
  echo.
  echo Illegal input! USERNAME must not be empty.
  goto username
)

:: List the existing 3DCityDB schemas -----------------------------------------
echo.
echo Reading existing 3DCityDB schemas from the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "..\SCHEMAS\QUERY_SCHEMA.sql"

if errorlevel 1 (
  echo Failed to read 3DCityDB schemas from database.
  pause
  exit /b %errorlevel%
)

:: Prompt for schema name -----------------------------------------------------
set var=
set SCHEMA_NAME=citydb
echo Please enter name of schema "%USERNAME%" has access to.
set /p var="(default SCHEMA_NAME=%SCHEMA_NAME%): "
if /i not "%var%"=="" set SCHEMA_NAME=%var%

:: Run CREATE_RO_USER.sql to remove a read-only user for a specific schema
echo.
echo Connecting to the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "DROP_RO_USER.sql" -v username="%USERNAME%" -v schema_name="%SCHEMA_NAME%"

pause