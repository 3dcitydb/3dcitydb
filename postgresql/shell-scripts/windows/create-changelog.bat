@echo off
:: Shell script to create a changelog extension of the 3DCityDB
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

:: Add PGBIN to PATH
set PATH=%PGBIN%;%PATH%;%SYSTEMROOT%\System32

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
echo This script will guide you through the process of creating the changelog extension
echo for an existing 3DCityDB instance. Please follow the instructions of the script.
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

:: List the existing 3DCityDB schemas ------------------------------------
echo.
echo Reading 3DCityDB schemas "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "%CURRENT_DIR%..\..\sql-scripts\util\list-schemas-with-changelog.sql"

if errorlevel 1 (
  echo Failed to read schemas from database.
  pause
  exit /b %errorlevel%
)

:: Prompt for schema name -----------------------------------------------------
set SCHEMA_NAME=citydb
echo Please enter the name of the 3DCityDB schema in which the changelog extension will be created.
set /p var="(default SCHEMA_NAME=%SCHEMA_NAME%): "
if /i not "%var%"=="" set SCHEMA_NAME=%var%

:: Run create-db-extension.sql to create the 3DCityDB changelog extension --------------
echo.
echo Connecting to the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "%CURRENT_DIR%..\..\sql-scripts\create-changelog.sql" -v schema_name="%SCHEMA_NAME%"

pause