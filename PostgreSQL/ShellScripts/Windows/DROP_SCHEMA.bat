@echo off
:: Shell script to drop a schema from a 3DCityDB instance
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
echo ############################################################################
echo.
echo This script will drop a 3DCityDB schema including all data. Note that this
echo operation cannot be undone. Please follow the instructions of the script.
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
echo ############################################################################

:: cd to path of the SQL scripts
cd ..\..\SQLScripts\UTIL\SCHEMAS

:: List the existing 3DCityDB schemas -----------------------------------------
echo.
echo Reading existing 3DCityDB schemas from the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "LIST_SCHEMAS.sql"

if errorlevel 1 (
  echo Failed to read schemas from database.
  pause
  exit /b %errorlevel%
)

:: Prompt for schema name -----------------------------------------------------
:schema_name
set var=
echo Please enter the name of the 3DCityDB schema you want to remove.
set /p var="(enter SCHEMA_NAME): "

if /i not "%var%"=="" (
  set SCHEMA_NAME=%var%
) else (
  echo.
  echo Illegal input! Please provide a schema name.
  echo.
  goto schema_name
)

:: Run DROP_SCHEMA.sql to remove the selected 3DCityDB schema -----------------
echo.
echo Connecting to the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
"%PGBIN%\psql" -d "%CITYDB%" -f "DROP_SCHEMA.sql" -v schema_name="%SCHEMA_NAME%"

pause
