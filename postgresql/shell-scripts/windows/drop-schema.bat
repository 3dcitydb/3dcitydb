@echo off
:: Shell script to drop a schema from a 3DCityDB instance
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

:: List the existing 3DCityDB schemas -----------------------------------------
echo.
echo Reading 3DCityDB schemas "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "%CURRENT_DIR%..\..\sql-scripts\util\list-schemas.sql"

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

:: Run drop-schema.sql to remove the selected 3DCityDB schema -----------------
echo.
echo Connecting to "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "%CURRENT_DIR%..\..\sql-scripts\drop-schema.sql" -v schema_name="%SCHEMA_NAME%"

pause