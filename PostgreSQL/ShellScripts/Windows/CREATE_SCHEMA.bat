@echo off
:: Shell script to create an new data schema for a 3DCityDB instance
:: on PostgreSQL/PostGIS

:: Provide your database details here -----------------------------------------
set PGBIN=path_to_psql
set PGHOST=your_host_address
set PGPORT=5432
set CITYDB=your_database
set PGUSER=your_username
::-----------------------------------------------------------------------------

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
echo #####################################################################################
echo.
echo This script will guide you through the process of setting up an additioanl 3DCityDB
echo schema for an existing database. Please follow the instructions of the script.
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
echo #####################################################################################

:: cd to path of the SQL scripts
cd ..\..\SQLScripts\UTIL\SCHEMAS

:: List the existing 3DCityDB schemas -----------------------------------------
echo.
echo Reading existing 3DCityDB schemas from the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "QUERY_SCHEMA.sql"

if errorlevel 1 (
  echo Failed to read 3DCityDB schemas from database.
  pause
  exit /b %errorlevel%
)

:: Prompt for schema name -----------------------------------------------------
set SCHEMA_NAME=citydb2
echo Please enter the name of the 3DCityDB schema you want to create.
set /p var="(default SCHEMA_NAME=%SCHEMA_NAME%): "
if /i not "%var%"=="" set SCHEMA_NAME=%var%

:: Create temporary SQL scripts -----------------------------------------------
echo.
echo|set /p="Preparing SQL scripts for setting up "%SCHEMA_NAME%" ... "
set TOKEN=citydb
set DELETE_FILE=..\..\SCHEMA\DELETE\DELETE.sql
set TMP_DELETE_FILE=TMP_%SCHEMA_NAME%_DELETE.sql

(for /f "delims=" %%A in (%DELETE_FILE%) do (
  set line=%%A
  setlocal enabledelayedexpansion
  echo !line:%TOKEN%=%SCHEMA_NAME%!
  endlocal
)) > %TMP_DELETE_FILE%

echo Done.

:: Run CREATE_SCHEMA.sql to create a new 3DCityDB schema ----------------------
echo.
echo Connecting to the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "CREATE_SCHEMA.sql" -v schema_name="%SCHEMA_NAME%" -v tmp_delete_file="%TMP_DELETE_FILE%" 

:: Remove temporary SQL scripts -----------------------------------------------
del %TMP_DELETE_FILE% >nul 2>&1

pause
