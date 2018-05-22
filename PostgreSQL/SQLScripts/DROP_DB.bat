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

:: Interactive mode or usage with arguments? ----------------------------------
if NOT [%1]==[] (
  GOTO:args
)

REM Run DROP_DB.sql to drop the 3D City Database instance ---------------------
psql -d "%CITYDB%" -f "DROP_DB.sql"
GOTO:EOF

:: Correct number of args supplied? -------------------------------------------
:args
set argC=0
for %%x in (%*) do Set /A argC+=1

if NOT %argC% EQU 5 (
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

set HOST=%1
set PORT=%2
set CITYDB=%3
set USERNAME=%4
set PASSWORD=%5

:: Run CREATE_DB.sql to create the 3D City Database instance ------------------
set PGHOST=%HOST%
set PGPORT=%PORT%
set PGUSER=%USERNAME%
set PGPASSWORD=%PASSWORD%

psql -d "%CITYDB%" -f "DROP_DB.sql"
GOTO:EOF

:: Print usage information ----------------------------------------------------
:usage
echo. 1<&2
echo Usage: %~n0%~x0 HOST PORT CITYDB USERNAME PASSWORD 1>&2
echo No args can be ommitted and the order is mandatory. 1>&2
echo. 1>&2
echo HOST          Database host 1>&2
echo PORT          Database port 1>&2
echo CITYDB        Database name 1>&2
echo USERNAME      Database username 1>&2
echo PASSWORD      Database password 1>&2
echo. 1>&2
GOTO:EOF
