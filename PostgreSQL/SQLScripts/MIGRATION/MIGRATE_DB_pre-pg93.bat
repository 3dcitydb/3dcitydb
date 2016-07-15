REM Shell script to migrate an instance of the 3D City Database from v2.x to v3.1
REM on PostgreSQL/PostGIS < 9.3

REM Provide your database details here
set PGPORT=5432
set PGHOST=your_host_address
set PGUSER=your_username
set CITYDB=your_database
set PGBIN=path_to_psql

REM cd to path of the shell script
cd /d %~dp0

REM Run MIGRATE_DB.sql to migrate the 3D City Database instance from v2.x to v3.1
"%PGBIN%\psql" -d "%CITYDB%" -f "MIGRATE_DB_pre-pg93.sql"

pause