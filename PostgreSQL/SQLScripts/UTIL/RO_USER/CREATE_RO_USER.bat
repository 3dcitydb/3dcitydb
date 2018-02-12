REM Shell script to create a read-only user for a specific schema of the 
REM virtualcityDATABASE on PostgreSQL/PostGIS

REM Provide your database details here
set PGPORT=5432
set PGHOST=your_host_address
set PGUSER=your_username
set CITYDB=your_database
set PGBIN=path_to_psql.exe

REM cd to path of the shell script
cd /d %~dp0

REM Run CREATE_RO_USER.sql to create a read-only user for a specific schema
"%PGBIN%\psql" -d "%CITYDB%" -f "CREATE_RO_USER.sql"

pause