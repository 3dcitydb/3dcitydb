@echo off
:: Shell script to create an instance of the 3D City Database
:: on Oracle Spatial/Locator

:: Provide your database details here -----------------------------------------
set SQLPLUSBIN=path_to_sqlplus
set HOST=your_host_address
set PORT=1521
set SID=your_SID_or_database_name
set USERNAME=your_username
::-----------------------------------------------------------------------------

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
echo Welcome to the 3DCityDB Setup Script. This script will guide you through the process
echo of setting up a 3DCityDB instance. Please follow the instructions of the script.
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

:: Prompt for SRSNO -----------------------------------------------------------
:srid
set var=
echo.
echo Please enter a valid SRID (e.g. Berlin: 81989002).
set /p var="(default SRID=81989002): "

IF /i NOT "%var%"=="" (
  set SRSNO=%var%
) else (
  set SRSNO=81989002
)

:: SRID is numeric?
SET "num="&for /f "delims=0123456789" %%i in ("%var%") do set num=%%i
IF defined num (
  echo.
  echo SRID must be numeric. Please retry.
  GOTO srid
)

:: Prompt for GMLSRSNAME ------------------------------------------------------
set var=
echo.
echo Please enter the corresponding gml:srsName to be used in GML exports.
set /p var="(default GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783): "

IF /i NOT "%var%"=="" (
  set GMLSRSNAME=%var%
) else (
  set GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783
)

:: Prompt for VERSIONING ------------------------------------------------------
:versioning
set var=
echo.
echo Shall versioning be enabled (yes/no)?
set /p var="(default VERSIONING=no): "

IF /i NOT "%var%"=="" (
  set VERSIONING=%var%
) else (
  set VERSIONING=no
)

set res=f
IF /i "%VERSIONING%"=="no" (set res=t)
IF /i "%VERSIONING%"=="yes" (set res=t)
IF "%res%"=="f" (
  echo.
  echo Illegal input! Enter yes or no.
  GOTO versioning
)

:: Prompt for DBVERSION -------------------------------------------------------
:dbversion
set var=
echo.
echo Which database license are you using (Spatial=S/Locator=L)?
set /p var="(default DBVERSION=S): "

IF /i NOT "%var%"=="" (
  set DBVERSION=%var%
) else (
  set DBVERSION=S
)

set res=f
IF /i "%DBVERSION%"=="s" (set res=t)
IF /i "%DBVERSION%"=="l" (set res=t)
IF "%res%"=="f" (
  echo.
  echo Illegal input! Enter S or L.
  GOTO dbversion
)

:: Run CREATE_DB.sql to create the 3D City Database instance ------------------
echo.
echo Connecting to the database "%USERNAME%@%HOST%:%PORT%/%SID%" ...
sqlplus "%USERNAME%@\"%HOST%:%PORT%/%SID%\"" @CREATE_DB.sql "%SRSNO%" "%GMLSRSNAME%" "%VERSIONING%" "%DBVERSION%"

pause
