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

-- This script is called from MIGRATE_DB.bat
\set ON_ERROR_STOP ON
\pset footer off
SET client_min_messages TO WARNING;

--// set search_path for this session
SELECT current_setting('search_path') AS current_path;
\gset
SET search_path TO citydb, :current_path;

--// create SEQUENCES
\echo
\echo 'Create sequences that are new in v4 ...'
\ir SEQUENCES.sql

--// create TABLES
\echo
\echo 'Create new tables of v4 and alter existing tables ...'
\ir TABLES.sql

--// update table OBJECTCLASS
\ir OBJECTCLASS_INSTANCES_V4.sql
\ir ../../SCHEMA/OBJECTCLASS/AGGREGATION_INFO_INSTANCES.sql

--// create schema FUNCTIONS
\ir ../../SCHEMA/OBJECTCLASS/OBJCLASS.sql
\ir ../../SCHEMA/ENVELOPE/ENVELOPE.sql
\ir ../../SCHEMA/DELETE/DELETE.sql

--// create CITYDB_PKG (additional schema with PL/pgSQL-Functions)
\echo
\echo 'Creating additional schema ''citydb_pkg'' ...'
DROP SCHEMA IF EXISTS citydb_pkg CASCADE;
CREATE SCHEMA citydb_pkg;

\ir ../../CITYDB_PKG/TYPES/TYPES.sql
\ir ../../CITYDB_PKG/UTIL/UTIL.sql
\ir ../../CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql
\ir ../../CITYDB_PKG/INDEX/IDX.sql
\ir ../../CITYDB_PKG/SRS/SRS.sql
\ir ../../CITYDB_PKG/STATISTICS/STAT.sql

--// create and fill INDEX_TABLE
\ir ../../SCHEMA/INDEX_TABLE/INDEX_TABLE.sql

--// adding CONSTRAINTS in new schema
\echo
\echo 'Update primary keys, foreign keys and not null constraints ...'
\ir CONSTRAINTS.sql

--// creating INDEXES in new schema
\echo
\echo 'Update indexes ...'
\ir INDEXES.sql

\echo
\echo '3DCityDB migration complete!'