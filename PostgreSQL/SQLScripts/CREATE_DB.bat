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

:: Interactive mode or usage with arguments? ----------------------------------
if NOT [%1]==[] (
  GOTO:args
)

:: INTERACTIVE MODE -----------------------------------------------------------
:: Prompt for SRSNO -----------------------------------------------------------
:srid
set var=
echo.
echo Please enter a valid SRID (e.g., 3068 for DHDN/Soldner Berlin): Press ENTER to use default.
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
  goto:srid
)

:: Prompt for GMLSRSNAME ------------------------------------------------------
echo.
echo Please enter the corresponding SRSName to be used in GML exports. Press ENTER to use default.
set /p var="(default GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783): "

IF /i NOT "%var%"=="" (
  set GMLSRSNAME=%var%
) else (
  set GMLSRSNAME=urn:ogc:def:crs,crs:EPSG:6.12:3068,crs:EPSG:6.12:5783
)

:: Run CREATE_DB.sql to create the 3D City Database instance ------------------
psql -d "%CITYDB%" -f "CREATE_DB.sql" -v srsno="%SRSNO%" -v gmlsrsname="%GMLSRSNAME%"
GOTO:EOF

:: Correct number of args supplied? -------------------------------------------
:args
set argC=0
for %%x in (%*) do Set /A argC+=1

if NOT %argC% EQU 7 (
  echo ERROR: Invalid number of arguments. 1>&2
  call :usage
  GOTO:EOF
)

:: Parse args -----------------------------------------------------------------
:: %1 = HOST
:: %2 = PORT
:: %3 = CITYDB
:: %4 = USERNAME
:: %5 = PASSWORD
:: %6 = SRSNO
:: %7 = GMLSRSNAME

set HOST=%1
set PORT=%2
set CITYDB=%3
set USERNAME=%4
set PASSWORD=%5
set SRSNO=%6
set GMLSRSNAME=%7

:: Run CREATE_DB.sql to create the 3D City Database instance ------------------
set PGHOST=%HOST%
set PGPORT=%PORT%
set PGUSER=%USERNAME%
set PGPASSWORD=%PASSWORD%

psql -d "%CITYDB%" -f "CREATE_DB.sql" -v srsno="%SRSNO%" -v gmlsrsname="%GMLSRSNAME%"
GOTO:EOF

:: Print usage information ----------------------------------------------------
:usage
echo. 1<&2
echo Usage: %~n0%~x0 HOST PORT CITYDB USERNAME PASSWORD SRSNO GMLSRSNAME 1>&2
echo No args can be ommitted and the order is mandatory. 1>&2
echo. 1>&2
echo HOST          Database host 1>&2
echo PORT          Database port 1>&2
echo CITYDB        Database name 1>&2
echo USERNAME      Database username 1>&2
echo PASSWORD      Database password 1>&2
echo SRSNO         Spatial reference system number (SRID) 1>&2
echo GMLSRSNAME    SRSName to be used in GML exports 1>&2
echo. 1>&2
GOTO:EOF
