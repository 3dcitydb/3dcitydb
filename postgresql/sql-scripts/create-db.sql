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

\set SRID :srid
\set SRS_NAME :srs_name

--// check if the PostGIS extension is available
SELECT postgis_lib_version() AS postgis_version;
\gset

--// create schema
CREATE SCHEMA citydb;

--// set search_path for this session
SELECT current_setting('search_path') AS current_path;
\gset
SET search_path TO citydb, :current_path;

--// create tables, sequences, constraints, indexes
\echo
\echo 'Setting up database schema of 3DCityDB instance ...'
\ir schema/schema.sql

--// populate metadata tables
\ir schema/namespace-instances.sql
\ir schema/objectclass-instances.sql
\ir schema/datatype-instances.sql

--// populate codelist tables
\ir schema/codelist-instances.sql
\ir schema/codelist-entry-instances.sql

--// create citydb_pkg schema
\echo
\echo 'Creating additional schema ''citydb_pkg'' ...'
CREATE SCHEMA citydb_pkg;

\ir citydb-pkg/util.sql
\ir citydb-pkg/constraint.sql
\ir citydb-pkg/srs.sql
\ir citydb-pkg/envelope.sql
\ir citydb-pkg/delete.sql

--// update search_path on database level
ALTER DATABASE :"DBNAME" SET search_path TO citydb, citydb_pkg, :current_path;

\echo
\echo '3DCityDB creation complete.'

--// checks if the chosen SRID is provided by the spatial_ref_sys table
\echo
\echo 'Checking spatial reference system ...'
SELECT citydb_pkg.check_srid(:SRID);

\echo 'Setting spatial reference system of 3DCityDB instance ...'
SELECT citydb_pkg.change_schema_srid(:SRID,:'SRS_NAME');
\echo 'Done'