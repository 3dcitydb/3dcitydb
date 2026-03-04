@echo off
:: Shell script to grant access privileges to a 3DCityDB schema
:: on PostgreSQL/PostGIS

:: Get the current directory path of this script file
set CURRENT_DIR=%~dp0

:: Read database connection details
if NOT [%1]==[] (
  call %1
) else (
  if exist connection-details.bat (
    call connection-details.bat
  ) else (
    call "%CURRENT_DIR%connection-details.bat"
  )
)

:: Set database client
if "%PGBIN%"=="" (
  set "PGBIN=psql"
) else (
  if exist "%PGBIN%\" (
    set "PGBIN=%PGBIN%\psql"
  )
)

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
"%PGBIN%" -d "%CITYDB%" -f "%CURRENT_DIR%..\..\sql-scripts\util\list-schemas.sql"

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
echo What level of access should be granted to "%GRANTEE%" (read-only=RO/read-update=RU/read-write=RW)?
set /p var="(default ACCESS_MODE=RO): "

if /i not "%var%"=="" (
  set ACCESS_MODE=%var%
) else (
  set ACCESS_MODE=RO
)

set res=f
if /i "%ACCESS_MODE%"=="ro" (set res=t)
if /i "%ACCESS_MODE%"=="ru" (set res=t)
if /i "%ACCESS_MODE%"=="rw" (set res=t)
if "%res%"=="f" (
  echo.
  echo Illegal input! Enter RO, RU, or RW.
  goto access_mode
)

:: Run grant-access.sql to grant access privileges on a specific schema -------
echo.
echo Connecting to "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%" -d "%CITYDB%" -f "%CURRENT_DIR%..\..\sql-scripts\grant-access.sql" -v username="%GRANTEE%" -v schema_name="%SCHEMA_NAME%" -v access_mode="%ACCESS_MODE%"

echo.
pause