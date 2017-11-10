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

-- This script is called from CREATE_DB.bat
\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\prompt 'Please enter EPSG code of CRS to be used: ' SRS_NO
\prompt 'Please enter EPSG code of the height system (use 0 if unknown or a 3D CRS is used): ' VERT_NO

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

--// create TABLES, SEQUENCES, CONSTRAINTS, INDEXES
\echo
\echo 'Setting up database schema of 3DCityDB instance ...'
\i SCHEMA/SCHEMA.sql

--// fill tables OBJECTCLASS
\i UTIL/CREATE_DB/OBJECTCLASS_INSTANCES.sql

--// create CITYDB_PKG (additional schema with PL/pgSQL-Functions)
\echo
\echo 'Creating additional schema ''citydb_pkg'' ...'
\i CREATE_CITYDB_PKG.sql

--// update search_path on database level
DO
$$
BEGIN
  EXECUTE 'ALTER DATABASE "' || current_database() || '" SET search_path TO citydb, citydb_pkg, ' || current_setting('search_path');
END;
$$;

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