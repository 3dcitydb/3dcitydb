@echo off
:: Shell script to revoke read-only access from a 3DCityDB schema
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
echo ######################################################################################
echo.
echo This script will revoke read-only access on a 3DCityDB schema from a user. Note that
echo this operation cannot be undone. Please follow the instructions of the script.
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
echo ######################################################################################

:: cd to path of the SQL scripts
cd ..\..\SQLScripts\UTIL\RO_ACCESS

:: Prompt for RO_USERNAME -----------------------------------------------------
:ro_username
set var=
echo.
echo Please enter the username of the read-only user.
set /p var="(RO_USERNAME must not be empty): "

if /i not "%var%"=="" (
  set RO_USERNAME=%var%
) else (
  echo.
  echo Illegal input! RO_USERNAME must not be empty.
  goto ro_username
)

:: List the 3DCityDB schemas granted to RO_USERNAME ---------------------------
echo.
echo Reading 3DCityDB schemas granted to "%RO_USERNAME%" from "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "..\SCHEMAS\LIST_SCHEMAS_WITH_ACCESS_GRANT.sql" -v username="%RO_USERNAME%"

if errorlevel 1 (
  echo Failed to read 3DCityDB schemas from database.
  pause
  exit /b %errorlevel%
)

:: Prompt for schema name -----------------------------------------------------
set var=
set SCHEMA_NAME=citydb
echo Please enter the name of the 3DCityDB schema that shall be revoked from "%RO_USERNAME%".
set /p var="(default SCHEMA_NAME=%SCHEMA_NAME%): "
if /i not "%var%"=="" set SCHEMA_NAME=%var%

:: Run REVOKE_RO_ACCESS.sql to revoke read-only access on a specific schema ---
echo.
echo Connecting to "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "REVOKE_RO_ACCESS.sql" -v ro_username="%RO_USERNAME%" -v schema_name="%SCHEMA_NAME%"

pause