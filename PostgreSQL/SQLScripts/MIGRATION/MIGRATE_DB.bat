REM 3D City Database - The Open Source CityGML Database
REM http://www.3dcitydb.org/
REM 
REM Copyright 2013 - 2016
REM Chair of Geoinformatics
REM Technical University of Munich, Germany
REM https://www.gis.bgu.tum.de/
REM 
REM The 3D City Database is jointly developed with the following
REM cooperation partners:
REM 
REM virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
REM M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
REM
REM Licensed under the Apache License, Version 2.0 (the "License");
REM you may not use this file except in compliance with the License.
REM You may obtain a copy of the License at
REM 
REM     http://www.apache.org/licenses/LICENSE-2.0
REM     
REM Unless required by applicable law or agreed to in writing, software
REM distributed under the License is distributed on an "AS IS" BASIS,
REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM See the License for the specific language governing permissions and
REM limitations under the License.
REM

REM Shell script to migrate an instance of the 3D City Database from v2.x to v3.1
REM on PostgreSQL/PostGIS >= 9.3

REM Provide your database details here
set PGPORT=5432
set PGHOST=your_host_address
set PGUSER=your_username
set CITYDB=your_database
set PGBIN=path_to_psql

REM cd to path of the shell script
cd /d %~dp0

REM Run MIGRATE_DB.sql to migrate the 3D City Database instance from v2.x to v3.1
"%PGBIN%\psql" -d "%CITYDB%" -f "MIGRATE_DB.sql"

pause