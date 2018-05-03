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

pause
