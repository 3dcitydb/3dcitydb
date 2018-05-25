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

:: cd to path of the SQL scripts
cd ..\..\SQLScripts

:: Prompt for SRSNO -----------------------------------------------------------
:srid
set var=
echo.
echo Please enter a valid SRID (e.g., EPSG code of the CRS to be used).
set /p var="(SRID must be an integer greater than zero): "

if /i not "%var%"=="" (
  set SRSNO=%var%
) else (
  goto invalid_srid
)

:: SRID is a positive integer?
set "num="&for /f "delims=0123456789" %%i in ("%var%") do set num=%%i
if defined num goto invalid_srid
if %SRSNO% LEQ 0 goto invalid_srid
goto height_epsg

:invalid_srid
echo.
echo Illegal input! Enter a positive integer for the SRID.
goto srid

:: Prompt for HEIGHT_EPSG -----------------------------------------------------
:height_epsg
set var=
echo.
echo Please enter the EPSG code of the height system (use 0 if unknown or '%SRSNO%' is already 3D).
set /p var="(default HEIGHT_EPSG=0): "

if /i not "%var%"=="" (
  set HEIGHT_EPSG=%var%
) else (
  set HEIGHT_EPSG=0
)

:: HEIGHT_EPSG is numeric?
set "num="&for /f "delims=0123456789" %%i in ("%var%") do set num=%%i
if defined num (
  echo.
  echo Illegal input! Enter 0 or a positive integer for the HEIGHT_EPSG.
  goto height_epsg
)

:: Prompt for GMLSRSNAME ------------------------------------------------------
:srsname
set var=
if %HEIGHT_EPSG% GTR 0 (
  set GMLSRSNAME=urn:ogc:def:crs,crs:EPSG::%SRSNO%,crs:EPSG::%HEIGHT_EPSG%
) else (
  set GMLSRSNAME=urn:ogc:def:crs:EPSG::%SRSNO%
)

echo.
echo Please enter the corresponding gml:srsName to be used in GML exports.
set /p var="(default GMLSRSNAME=%GMLSRSNAME%): "

if /i not "%var%"=="" set GMLSRSNAME=%var%

:: Run CREATE_DB.sql to create the 3D City Database instance ------------------
echo.
echo Connecting to the database "%PGUSER%@%PGHOST%:%PGPORT%/%CITYDB%" ...
psql -d "%CITYDB%" -f "CREATE_DB.sql" -v srsno="%SRSNO%" -v gmlsrsname="%GMLSRSNAME%"

pause
