-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2017
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.gis.bgu.tum.de/
-- 
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
-- 
-- virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
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

\echo
\echo 'List of existing data schemas:'
SELECT nspname AS schema_name FROM pg_catalog.pg_class c JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'database_srs'
 AND c.relkind = 'r';
\prompt 'Please enter a name for the new data schema (e.g., citydb2): ' target

--// create schema
CREATE SCHEMA :"target";

--// set search_path for this session
SELECT current_setting('search_path') AS current_path;
\gset
SET search_path TO :"target", :current_path;

--// check if the PostGIS extension and the citydb_pkg package are available
SELECT postgis_version();
SELECT version as citydb_version from citydb_pkg.citydb_version();

--// create TABLES, SEQUENCES, CONSTRAINTS, INDEXES
\echo
\echo 'Setting up database schema ...'
\i SCHEMA.sql

--// fill tables OBJECTCLASS
\i OBJECTCLASS/OBJECTCLASS_INSTANCES.sql

--// create schema FUNCTIONS
\i OBJECTCLASS/OBJCLASS.sql
\i ENVELOPE/ENVELOPE.sql

\echo
\echo 'Created schema' :target '.'

\echo 'Setting spatial reference system of schema' :target ' (will be the same as of schema citydb) ...'
\set target_quoted '\'':target'\''
INSERT INTO :target.DATABASE_SRS SELECT srid, gml_srs_name FROM citydb.database_srs LIMIT 1;
SELECT citydb_pkg.change_schema_srid(database_srs.srid, database_srs.gml_srs_name, 0, :target_quoted) FROM citydb.database_srs LIMIT 1;
\echo 'Done'