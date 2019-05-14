@echo off
:: Shell script to migrate an instance of the 3D City Database
:: on Oracle Spatial/Locator

:: read database connection details  
call ..\CONNECTION_DETAILS.bat

:: add sqlplus to PATH
set PATH=%SQLPLUSBIN%;%PATH%

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
  cd ..\..\..\SQLScripts\MIGRATION\V2_to_V4
  goto v2
) else (
  cd ..\..\..\SQLScripts\MIGRATION\V3_to_V4
  goto v3
)

:invalid_version
echo.
echo Illegal input! Enter a positive integer for the version.
goto version

:v2
:: Prompt for V2USER ----------------------------------------------------------
set var=
echo.
echo Enter the user name of 3DCityDB v2.1 instance.
set /p var="(V2USER must already exist in database): "

if /i not "%var%"=="" (
  set V2USER=%var%
) else (
  echo.
  echo Illegal input! V2USER must not be empty.
  goto v2
)

:: Prompt for TEXOP -----------------------------------------------------------
:texop
set var=
echo.
echo No texture URI is used for multiple texture files (yes/no)?
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
goto dbversion

:v3
set TEXOP=no

:: Prompt for DBVERSION -------------------------------------------------------
:dbversion
set var=
echo.
echo Which database license are you using (Spatial=S/Locator=L)?
set /p var="(default DBVERSION=S): "

if /i not "%var%"=="" (
  set DBVERSION=%var%
) else (
  set DBVERSION=S
)

set res=f
if /i "%DBVERSION%"=="s" (set res=t)
if /i "%DBVERSION%"=="l" (set res=t)
if "%res%"=="f" (
  echo.
  echo Illegal input! Enter S or L.
  goto dbversion
)

:: Run MIGRATE_DB.sql to create the 3D City Database instance ----------------
echo.
echo Connecting to the database "%USERNAME%@%HOST%:%PORT%/%SID%" ...
echo|set /p="Enter password: "
sqlplus -S -L "%USERNAME%@\"%HOST%:%PORT%/%SID%\"" @MIGRATE_DB.sql "%TEXOP%" "%DBVERSION%" "%V2USER%"

pause