-- 3D City Database - The Open Source CityGML Database
-- https://www.3dcitydb.org/
--
-- Copyright 2013 - 2021
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.lrg.tum.de/gis/
--
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
--
-- Virtual City Systems, Berlin <https://vc.systems/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set SRSNO :srsno
\set GMLSRSNAME :gmlsrsname

--// check if the raster data type is available
SELECT EXISTS(SELECT 1 AS create_raster from pg_type where typname= 'raster') AS raster_type_exists;
\gset

--// break if the raster data type is not available
SELECT CASE WHEN :'raster_type_exists' = 't'
  THEN 'UTIL/HINTS/DO_NOTHING.sql'
  ELSE 'UTIL/HINTS/HINT_ON_MISSING_RASTER_TYPE.sql'
  END AS do_action_for_raster_type_check;
\gset
\ir :do_action_for_raster_type_check

--// create schema
CREATE SCHEMA citydb;

--// set search_path for this session
SELECT current_setting('search_path') AS current_path;
\gset
SET search_path TO citydb, :current_path;

--// create TABLES, SEQUENCES, CONSTRAINTS, INDEXES
\echo
\echo 'Setting up database schema of 3DCityDB instance ...'
\ir SCHEMA/SCHEMA.sql

--// fill tables OBJECTCLASS
\ir SCHEMA/OBJECTCLASS/OBJECTCLASS_INSTANCES.sql
\ir SCHEMA/OBJECTCLASS/AGGREGATION_INFO_INSTANCES.sql

--// create schema FUNCTIONS
\ir SCHEMA/OBJECTCLASS/OBJCLASS.sql
\ir SCHEMA/ENVELOPE/ENVELOPE.sql
\ir SCHEMA/DELETE/DELETE.sql

--// create CITYDB_PKG (additional schema with PL/pgSQL-Functions)
\echo
\echo 'Creating additional schema ''citydb_pkg'' ...'
CREATE SCHEMA citydb_pkg;

\ir CITYDB_PKG/TYPES/TYPES.sql
\ir CITYDB_PKG/UTIL/UTIL.sql
\ir CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql
\ir CITYDB_PKG/INDEX/IDX.sql
\ir CITYDB_PKG/SRS/SRS.sql
\ir CITYDB_PKG/STATISTICS/STAT.sql

--// create and fill INDEX_TABLE
\ir SCHEMA/INDEX_TABLE/INDEX_TABLE.sql

--// update search_path on database level
ALTER DATABASE :"DBNAME" SET search_path TO citydb, citydb_pkg, :current_path;

\echo
\echo '3DCityDB creation complete!'

--// checks if the chosen SRID is provided by the spatial_ref_sys table
\echo
\echo 'Checking spatial reference system ...'
SELECT citydb_pkg.check_srid(:SRSNO);

\echo 'Setting spatial reference system of 3DCityDB instance ...'
SELECT citydb_pkg.change_schema_srid(:SRSNO,:'GMLSRSNAME');
\echo 'Done'