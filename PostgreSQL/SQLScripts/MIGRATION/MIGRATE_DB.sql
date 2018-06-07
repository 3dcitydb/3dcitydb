-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
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

-- This script is called from MIGRATE_DB.bat
\set ON_ERROR_STOP ON
\pset footer off
SET client_min_messages TO WARNING;

--// set variables
\set VERS :version
\set TEXOP :texop

SELECT current_setting('search_path') AS current_path \gset
SELECT srid FROM database_srs \gset

--// create FUNCTIONS necessary for migration process
\echo
\echo 'Creating helper functions for migration process in geodb_pkg schema ...'
--\i V2_to_V4/FUNCTIONS.sql

--// create SEQUENCES
\echo
\echo 'Create sequences that are new in v4 ...'
\i V3_to_V4/SEQUENCES.sql

--// create TABLES
\echo
\echo 'Create new tables of v4 and alter existing tables ...'
\i V3_to_V4/TABLES.sql

--// update table OBJECTCLASS
\i V3_to_V4/OBJECTCLASS_INSTANCES_V4.sql
\i ../SCHEMA/OBJECTCLASS/AGGREGATION_INFO_INSTANCES.sql

--// create schema FUNCTIONS
\i ../SCHEMA/OBJECTCLASS/OBJCLASS.sql
\i ../SCHEMA/ENVELOPE/ENVELOPE.sql
\i ../SCHEMA/DELETE/DELETE.sql

--// create CITYDB_PKG (additional schema with PL/pgSQL-Functions)
\echo
\echo 'Creating additional schema ''citydb_pkg'' ...'
DROP SCHEMA IF EXISTS citydb_pkg CASCADE;
CREATE SCHEMA citydb_pkg;

\i ../CITYDB_PKG/UTIL/UTIL.sql
\i ../CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql
\i ../CITYDB_PKG/INDEX/IDX.sql
\i ../CITYDB_PKG/SRS/SRS.sql
\i ../CITYDB_PKG/STATISTICS/STAT.sql

--// adding CONSTRAINTS in new schema
\echo
\echo 'Update primary keys, foreign keys and not null constraints ...'
\i V3_to_V4/CONSTRAINTS.sql

--// creating INDEXES in new schema
\echo
\echo 'Update indexes ...'
\i V3_to_V4/INDEXES.sql

--// removing v2.x schema (if the user wants to)
--\echo
--\echo 'Removing database elements of 3DCityDB v2.x schema ...'
--\i V2_to_V4/DROP_DB_V2.sql

--// update search_path on database level
ALTER DATABASE :"DBNAME" SET search_path TO citydb, citydb_pkg, :current_path;

\echo
\echo '3DCityDB migration complete!'