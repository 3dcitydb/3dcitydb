@echo off
:: Shell script to create an instance of the 3D City Database
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
echo Welcome to the 3DCityDB Migrate Script. This script will guide you through the
echo process of migrating an existing 3DCityDB instance of version 2 or 3 to version 4.
echo Please follow the instructions of the script. Enter the required parameters when
echo prompted and press ENTER to confirm. Just press ENTER to use the default values.
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

:: Prompt for VERS ------------------------------------------------------------
:version
set var=
echo.
echo Please enter the number of currently used major version.
set /p var="(number must be an integer 2 or 3): "

if /i not "%var%"=="" (
  set VERS=%var%
) else (
  goto invalid_version
)

:: VERS is a positive integer?
set "num="&for /f "delims=0123456789" %%i in ("%var%") do set num=%%i
if defined num goto invalid_version
if %VERS% LEQ 0 goto invalid_version
if %VERS% LEQ 2 (
  cd ..\..\SQLScripts\MIGRATION\V2_to_V4
  goto texop2
) else (
  cd ..\..\SQLScripts\MIGRATION\V3_to_V4
  goto texop3
)

:invalid_version
echo.
echo Illegal input! Enter a positive integer for the version.
goto version

:: Prompt for TEXOP ------------------------------------------------------
:texop2
set var=
echo.
echo No texture URI is used for multiple texture files (yes/no):?
set /p var="(default TEXOP=no): "

if /i not "%var%"=="" (
  set TEXOP=%var%
) else (
  set TEXOP=no
)

set res=f
if /i "%TEXOP%"=="no" (set res=t)
if /i "%TEXOP%"=="yes" (set res=t)
if "%res%"=="f" (
  echo.
  echo Illegal input! Enter yes or no.
  goto texop
)
goto run

:texop3
set TEXOP=no

:: Run MIGRATE_DB.sql to create the 3D City Database instance ----------------
:run
echo.
echo Connecting to the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "MIGRATE_DB.sql" -v version="%VERS%" -v texop="%TEXOP%"

pause