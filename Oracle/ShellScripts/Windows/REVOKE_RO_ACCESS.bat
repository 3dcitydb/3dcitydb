@echo off
:: Shell script to revoke read-only access from a 3DCityDB schema
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
echo ######################################################################################
echo.
echo This script will revoke read-only access on a 3DCityDB schema from a user. Note that
echo this operation cannot be undone. Please follow the instructions of the script.
echo Enter the required parameters when prompted and press ENTER to confirm.
echo Just press ENTER to use the default values.
echo.
echo Note: This script requires SYSDBA privileges.
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

:: Run REVOKE_RO_ACCESS.sql to revoke read-only access on a specific schema ---
echo.
echo Connecting to "%SYSDBA_USERNAME%@%HOST%:%PORT%/%SID%" ...
echo|set /p="Enter password: "
sqlplus -S -L "%SYSDBA_USERNAME%@\"%HOST%:%PORT%/%SID%\"" AS SYSDBA @REVOKE_RO_ACCESS.sql "%RO_USERNAME%" "%USERNAME%"

pause