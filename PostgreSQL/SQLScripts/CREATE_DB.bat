@echo off
:: Shell script to create an instance of the 3D City Database
:: on PostgreSQL/PostGIS

:: Provide your database details here -----------------------------------------
set PGBIN=path_to_psql
set PGHOST=your_host_address
set PGPORT=5432
set CITYDB=your_database
set PGUSER=your_username
::-----------------------------------------------------------------------------

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
echo Please enter a valid SRID (e.g., 3068 for DHDN/Soldner Berlin).
set /p var="(default SRID=3068): "

IF /i NOT "%var%"=="" (
  set SRSNO=%var%
) else (
  set SRSNO=3068
)

:: SRID is numeric?
SET "num="&for /f "delims=0123456789" %%i in ("%var%") do set num=%%i
IF defined num (
  echo.
  echo SRID must be numeric. Please retry.
  GOTO srid
)

:: Prompt for GMLSRSNAME ------------------------------------------------------
echo.
echo Please enter the corresponding gml:srsName to be used in GML exports.
set /p var="(default GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783): "

IF /i NOT "%var%"=="" (
  set GMLSRSNAME=%var%
) else (
  set GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783
)

:: Run CREATE_DB.sql to create the 3D City Database instance ------------------
echo.
echo Connecting to the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "CREATE_DB.sql" -v srsno="%SRSNO%" -v gmlsrsname="%GMLSRSNAME%"

pause
