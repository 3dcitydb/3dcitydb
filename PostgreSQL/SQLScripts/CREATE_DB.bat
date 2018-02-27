@echo off
:: Shell script to create an instance of the 3D City Database
:: on PostgreSQL/PostGIS

:: Provide your database details here
set PGPORT=5432
set PGHOST=your_host_address
set PGUSER=your_username
set CITYDB=your_database
set PGBIN=path_to_psql.exe

:: cd to path of the shell script
cd /d %~dp0

:: Prompt for srsno
:srid_retry
set var=
echo.
echo Please enter a valid SRID (e.g., 3068 for DHDN/Soldner Berlin).
echo Press ENTER to use default.
set /p var="(default=3068): "

IF /i NOT "%var%"=="" (
  set srsno=%var%
) else (
  set srsno=3068
)

:: SRID is numeric?
SET "num="&for /f "delims=0123456789" %%i in ("%var%") do set num=%%i
IF defined num (
  echo.
  echo SRID must be numeric. Please retry.
  goto:srid_retry
)

:: Prompt for gmlsrsname
echo.
echo Please enter the corresponding SRSName to be used in GML exports (e.g., urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783).
echo Press ENTER to use default.
set /p var="(default=urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783): "

IF /i NOT "%var%"=="" (
  set gmlsrsname=%var%
) else (
  set gmlsrsname=urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783
)

:: Run CREATE_DB.sql to create the 3D City Database instance
"%PGBIN%\psql" -d "%CITYDB%" -f "CREATE_DB.sql" -v srsno="%srsno%" -v gmlsrsname="%gmlsrsname%"
