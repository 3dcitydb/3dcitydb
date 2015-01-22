-- MIGRATE_DB.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Top-level migration script that starts the migration process for a 3DCityDB 
-- instance of v2.1.0 to v3.0.0
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2014-12-28   release version                             FKun
--

-- This script is called from MIGRATE_DB.bat
\set ON_ERROR_STOP ON
\pset footer off
SET client_min_messages TO WARNING;

SELECT srid FROM database_srs \gset

-- alternative way for PostgreSQL versions pre 9.3 that have no \gset command
--\echo 'Database SRID:'
--SELECT srid FROM database_srs;
--\prompt 'Please enter the EPSG code of the SRID used in the current database: ' srs_no
--\set srid :srs_no

--// create TABLES and SEQUENCES new in v3.0
\echo
\echo 'Create tables and sequences of 3DCityDB instance that are new in v3.0 ...'
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
\i ./../PL_pgSQL/CITYDB_PKG/DELETE/DELETE.sql
\i ./../PL_pgSQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE.sql

--// create FUNCTIONS necessary for migration process
\echo
\echo 'Creating helper functions for migration process in geodb_pkg schema ...'
\i FUNCTIONS.sql

--// migrate TABLES from old to new schema
\echo
\echo 'Migrating database schema of 3DCityDB instance from v2.x to v3.0 ...'
\i MIGRATE_DB_V2_V3.sql

--// adding CONSTRAINTS in new schema
\echo
\echo 'Defining primary keys and foreign keys on v3.0 tables ...'
\i CONSTRAINTS_V3.sql

--// creating INDEXES in new schema
\echo
\echo 'Creating indexes on v3.0 tables ...'
\i INDEXES_V3.sql

--// removing v2.x schema (if the user wants to)
--\echo
--\echo 'Removing database elements of 3DCityDB v2.x schema ...'
--\i DROP_DB_V2.sql

--// update search_path on database level
ALTER DATABASE :"DBNAME" SET search_path TO citydb,citydb_pkg,public;

\echo
\echo '3DCityDB migration complete!'