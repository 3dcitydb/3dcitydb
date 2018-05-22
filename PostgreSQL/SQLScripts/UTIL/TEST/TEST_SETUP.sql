-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2018
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

\set SRS_NO 3068
\set VERT_NO 5783

-- prepare GML_SRS_NAME
SELECT CASE
  WHEN :VERT_NO = 0 THEN 'urn:ogc:def:crs,crs:EPSG::' || :SRS_NO
  ELSE 'urn:ogc:def:crs,crs:EPSG::' || :SRS_NO || ',crs:EPSG::' || :VERT_NO
  END AS srs_string \gset

-- set SRID and GML_SRS_NAME
\set GMLSRSNAME :srs_string
\set SRSNO :SRS_NO

--// check if the PostGIS extension is available
SELECT postgis_version();

--// create schema
CREATE SCHEMA citydb;

--// set search_path for this session
SELECT current_setting('search_path') AS current_path;
\gset
SET search_path TO citydb, :current_path;

--// create TABLES, SEQUENCES, CONSTRAINTS, INDEXES
\echo
\echo 'Setting up database schema of 3DCityDB instance ...'
\i SCHEMA/SCHEMA.sql

--// fill tables OBJECTCLASS
\i UTIL/CREATE_DB/OBJECTCLASS_INSTANCES.sql

--// create CITYDB_PKG (additional schema with PL/pgSQL-Functions)
\echo
\echo 'Creating additional schema ''citydb_pkg'' ...'
CREATE SCHEMA citydb_pkg;
\i CITYDB_PKG/UTIL/UTIL.sql
\i CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql
\i CITYDB_PKG/INDEX/IDX.sql
\i CITYDB_PKG/SRS/SRS.sql
\i CITYDB_PKG/STATISTICS/STAT.sql

--// update search_path on database level
ALTER DATABASE :"DBNAME" SET search_path TO citydb, citydb_pkg, :current_path;

\echo
\echo '3DCityDB creation complete!'

--// checks if the chosen SRID is provided by the spatial_ref_sys table
\echo
\echo 'Checking spatial reference system ...'
SELECT citydb_pkg.check_srid(:SRS_NO);

\echo 'Setting spatial reference system of 3DCityDB instance ...'
INSERT INTO citydb.DATABASE_SRS(SRID,GML_SRS_NAME) VALUES (:SRS_NO,:'GMLSRSNAME');
SELECT citydb_pkg.change_schema_srid(:SRS_NO,:'GMLSRSNAME');
\echo 'Done'