@echo off
:: Shell script to grant read-only access to a 3DCityDB schema
:: on PostgreSQL/PostGIS

:: read database connection details  
call CONNECTION_DETAILS.bat

:: add PGBIN to PATH
set PATH=%PGBIN%;%PATH%;%SYSTEMROOT%\System32

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
echo ####################################################################################
echo.
echo This script will guide you through the process of granting read-only access on a
echo 3DCityDB schema to an existing user. Please follow the instructions of the script.
echo Enter the required parameters when prompted and press ENTER to confirm.
echo Just press ENTER to use the default values.
echo.
echo Note: This script requires superuser privileges.
echo.
echo Documentation and help:
echo    3DCityDB website:    https://www.3dcitydb.org
echo    3DCityDB on GitHub:  https://github.com/3dcitydb
echo.
echo Having problems or need support?
echo    Please file an issue here:
echo    https://github.com/3dcitydb/3dcitydb/issues
echo.
echo ####################################################################################

:: cd to path of the SQL scripts
cd ..\..\SQLScripts\UTIL\RO_ACCESS

:: Prompt for RO_USERNAME -----------------------------------------------------
:ro_username
set var=
echo.
echo Please enter the username of the read-only user.
set /p var="(RO_USERNAME must already exist in database): "

if /i not "%var%"=="" (
  set RO_USERNAME=%var%
) else (
  echo.
  echo Illegal input! RO_USERNAME must not be empty.
  goto ro_username
)

:: List the existing 3DCityDB schemas -----------------------------------------
echo.
echo Reading 3DCityDB schemas from "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "..\SCHEMAS\LIST_SCHEMAS.sql"

if errorlevel 1 (
  echo Failed to read 3DCityDB schemas from database.
  pause
  exit /b %errorlevel%
)

:: Prompt for schema name -----------------------------------------------------
set var=
set SCHEMA_NAME=citydb
echo Please enter the name of the 3DCityDB schema "%RO_USERNAME%" shall have access to.
set /p var="(default SCHEMA_NAME=%SCHEMA_NAME%): "
if /i not "%var%"=="" set SCHEMA_NAME=%var%

:: Run GRANT_RO_ACCESS.sql to grant read-only access on a specific schema -----
echo.
echo Connecting to "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "GRANT_RO_ACCESS.sql" -v ro_username="%RO_USERNAME%" -v schema_name="%SCHEMA_NAME%"

pause
