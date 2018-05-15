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
echo ######################################################################################
echo.
echo Welcome to the 3DCityDB Setup Script. This script will guide you through the process
echo of setting up a 3DCityDB instance. Please follow the instructions of the script.
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
echo ######################################################################################

:: List the existing data schemas ------------------------------------------------------
"%PGBIN%\psql" -d "%CITYDB%" -f "QUERY_SCHEMA.sql"

:: Prompt for SCHEMANAME ------------------------------------------------------
set PLACEHOLDER=citydb
set SCHEMANAME=citydb2

echo Please enter the name of the data schema you want to create.
set /p var="(default SCHEMANAME=%SCHEMANAME%): "
if /i not "%var%"=="" set SCHEMANAME=%var%

set DELETE_FILE_PATH=DELETE\DELETE.sql
set TMP_DELETE_FILENAME=DELETE_TMP.sql 
set TMP_DELETE_FILE_PATH=DELETE\%TMP_DELETE_FILENAME%

powershell -Command "(gc %DELETE_FILE_PATH%) -replace '%PLACEHOLDER%.', '%SCHEMANAME%.' | Out-File %TMP_DELETE_FILE_PATH% -encoding Ascii"

REM Run CREATE_SCHEMA.sql to create a new data schema %var%
"%PGBIN%\psql" -d "%CITYDB%" -f "CREATE_SCHEMA.sql" -v schemaname="%SCHEMANAME%" -v tmp_delete_filename="%TMP_DELETE_FILENAME%" 

del %TMP_DELETE_FILE_PATH% >nul 2>&1

pause
