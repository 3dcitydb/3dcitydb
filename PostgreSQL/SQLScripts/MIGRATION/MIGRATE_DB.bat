REM Shell script to migrate an instance of the 3D City Database from v2.x to v3.0
REM on PostgreSQL/PostGIS

REM Provide your database details here
set PGPORT=5432
set PGHOST=localhost
set PGUSER=vcs_user
set CITYDB=dresden
set PGBIN=C:\PostgreSQL\9.3\bin

REM cd to path of the shell script
cd /d %~dp0

REM Run MIGRATE_DB.sql to migrate the 3D City Database instance from v2.x to v3.0
"%PGBIN%\psql" -d "%CITYDB%" -f "MIGRATE_DB.sql"

pause