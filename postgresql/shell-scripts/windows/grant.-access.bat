@echo off
:: Shell script to grant access privileges to a 3DCityDB schema
:: on PostgreSQL/PostGIS

:: read database connection details  
call connection-details.bat

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
echo This script will guide you through the process of granting access privileges on a
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
cd ..\..\sql-scripts\util

:: Prompt for GRANTEE ---------------------------------------------------------
:grantee
set var=
echo.
echo Please enter the username of the grantee.
set /p var="(GRANTEE must already exist in database): "

if /i not "%var%"=="" (
  set GRANTEE=%var%
) else (
  echo.
  echo Illegal input! GRANTEE must not be empty.
  goto grantee
)

:: List the existing 3DCityDB schemas -----------------------------------------
echo.
echo Reading 3DCityDB schemas from "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "list-schemas.sql"

if errorlevel 1 (
  echo Failed to read 3DCityDB schemas from database.
  pause
  exit /b %errorlevel%
)

:: Prompt for SCHEMA_NAME -----------------------------------------------------
set var=
set SCHEMA_NAME=citydb
echo Please enter the name of the 3DCityDB schema "%GRANTEE%" shall have access to.
set /p var="(default SCHEMA_NAME=%SCHEMA_NAME%): "
if /i not "%var%"=="" set SCHEMA_NAME=%var%

:: Prompt for ACCESS_MODE -----------------------------------------------------
:access_mode
set var=
echo.
echo What level of access should be granted to "%GRANTEE%" (read-only=RO/read-write=RW)?
set /p var="(default ACCESS_MODE=RO): "

if /i not "%var%"=="" (
  set ACCESS_MODE=%var%
) else (
  set ACCESS_MODE=RO
)

set res=f
if /i "%ACCESS_MODE%"=="ro" (set res=t)
if /i "%ACCESS_MODE%"=="rw" (set res=t)
if "%res%"=="f" (
  echo.
  echo Illegal input! Enter RO or RW.
  goto access_mode
)

:: Run grant-access.sql to grant access privileges on a specific schema -------
echo.
echo Connecting to "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "grant-access.sql" -v username="%GRANTEE%" -v schema_name="%SCHEMA_NAME%" -v access_mode="%ACCESS_MODE%"

pause
