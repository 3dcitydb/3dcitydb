@echo off
:: Shell script to grant select on an v2 instance to v4 user
:: on Oracle

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
echo Enter the required parameters when echo prompted and press ENTER to confirm.
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

:: cd to path of the SQL script
cd ..\..\..\SQLScripts\MIGRATION\V2_to_V4

:: Prompt for V4USER ----------------------------------------------------------
:username
set var=
echo.
echo Enter the user name of 3DCityDB v4 instance.
set /p var="(V4USER must already exist in database): "

if /i not "%var%"=="" (
  set V4USER=%var%
) else (
  echo.
  echo Illegal input! V4USER must not be empty.
  goto username
)

:: Run GRANT_ACCESS_V2.sql to grant rights to V4USER --------------------------
echo.
echo Connecting to the database "%USERNAME%@%HOST%:%PORT%/%SID%" ...
sqlplus "%USERNAME%@\"%HOST%:%PORT%/%SID%\"" @GRANT_ACCESS_V2.sql "%V4USER%"

pause