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

-- This script is called from MIGRATE_DB.bat
\set ON_ERROR_STOP ON
\pset footer off
SET client_min_messages TO WARNING;

SELECT srid FROM database_srs \gset

--// In the previous version binary data of textures could be stored multiple times
--// when referred to different entries in the surface_data tables (bad for texture atlases).
--// This can be avoided in the new version because of a separated table for texture files.
--// IMPORTANT: The user has to be sure, that no tex_image_uri is used for different textures!
\prompt 'No texture URI is used for multiple texture files (yes (y)/unknown (n)): ' tex_opt
\set texop :tex_opt

--// Set name of target schema to citydb
SELECT current_setting('search_path') AS current_path;
\gset
SET search_path TO citydb, :current_path;

--// create TABLES and SEQUENCES new in v3.1
\echo
\echo 'Create tables and sequences of 3DCityDB instance that are new in v3.3 ...'
\i CREATE_DB_V3.sql

--// fill tables OBJECTCLASS
\i ./../UTIL/CREATE_DB/OBJECTCLASS_INSTANCES.sql

--// create CITYDB_PKG (additional schema with PL/pgSQL-Functions)
\echo
\echo 'Creating additional schema ''citydb_pkg'' ...'
DROP SCHEMA IF EXISTS citydb_pkg CASCADE;
CREATE SCHEMA citydb_pkg;

\i ./../PL_pgSQL/CITYDB_PKG/UTIL/UTIL.sql
\i ./../PL_pgSQL/CITYDB_PKG/INDEX/IDX.sql
\i ./../PL_pgSQL/CITYDB_PKG/SRS/SRS.sql
\i ./../PL_pgSQL/CITYDB_PKG/STATISTICS/STAT.sql
\i ./../PL_pgSQL/CITYDB_PKG/ENVELOPE/ENVELOPE.sql
\i ./../PL_pgSQL/CITYDB_PKG/DELETE/DELETE.sql
\i ./../PL_pgSQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE.sql

--// create FUNCTIONS necessary for migration process
\echo
\echo 'Creating helper functions for migration process in geodb_pkg schema ...'
\i FUNCTIONS.sql

--// migrate TABLES from old to new schema
\echo
\echo 'Migrating database schema of 3DCityDB instance from v2.x to v3.3 ...'
\i MIGRATE_DB_V2_V3.sql

--// adding CONSTRAINTS in new schema
\echo
\echo 'Defining primary keys and foreign keys on v3.3 tables ...'
\i CONSTRAINTS_V3.sql

--// creating INDEXES in new schema
\echo
\echo 'Creating indexes on v3.3 tables ...'
\i INDEXES_V3.sql

--// removing v2.x schema (if the user wants to)
--\echo
--\echo 'Removing database elements of 3DCityDB v2.x schema ...'
--\i DROP_DB_V2.sql

--// update search_path on database level
ALTER DATABASE :"DBNAME" SET search_path TO citydb, citydb_pkg, :current_path;

\echo
\echo '3DCityDB migration complete!'