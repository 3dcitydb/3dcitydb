@echo off
:: Shell script to drop an instance of the 3D City Database
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

REM Run DROP_DB.sql to drop the 3D City Database instance ---------------------
psql -d "%CITYDB%" -f "DROP_DB.sql"

pause