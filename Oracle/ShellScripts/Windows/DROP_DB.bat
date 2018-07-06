@echo off
:: Shell script to drop an instance of the 3D City Database
:: on Oracle Spatial/Locator

:: read database connection details  
call CONNECTION_DETAILS.bat

:: add SQLPLUSBIN to PATH
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
echo ################################################################################
echo.
echo This script will drop the 3DCityDB instance including all data. Note that this
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
echo ################################################################################

:: cd to path of the SQL scripts
cd ..\..\SQLScripts

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

:: Run DROP_DB.sql to drop the 3D City Database instance ----------------------
echo.
echo Connecting to "%USERNAME%@%HOST%:%PORT%/%SID%" ...
echo|set /p="Enter password: "
sqlplus -S -L "%USERNAME%@\"%HOST%:%PORT%/%SID%\"" @DROP_DB.sql "%DBVERSION%"

pause
