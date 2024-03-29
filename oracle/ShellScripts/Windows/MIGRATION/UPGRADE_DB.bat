@echo off
:: Shell script to upgrade an instance of the 3D City Database
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
echo #######################################################################################
echo.
echo Welcome to the 3DCityDB Upgrade Script. This script will upgrade an existing 3DCityDB
echo instance of version 4.x.y to the latest minor version.
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
echo #######################################################################################

:: cd to path of the SQL scripts
cd ..\..\..\SQLScripts\MIGRATION\V4_UPGRADE

:: Run UPGRADE_DB.sql to upgrade the 3D City Database instance ----------------
echo.
echo Connecting to the database "%USERNAME%@%HOST%:%PORT%/%SID%" ...
echo|set /p="Enter password: "
sqlplus -S -L "%USERNAME%@\"%HOST%:%PORT%/%SID%\"" @UPGRADE_DB.sql

pause