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

SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

-- parse arguments
DEFINE SRSNO=&1;
DEFINE GMLSRSNAME=&2;
DEFINE VERSIONING=&3;
DEFINE DBVERSION=&4;

-- check for SDO_GEORASTER support
VARIABLE GEORASTER_SUPPORT NUMBER;
BEGIN
  :GEORASTER_SUPPORT := 0;
  IF (upper('&DBVERSION')='S') THEN
    SELECT COUNT(*) INTO :GEORASTER_SUPPORT FROM ALL_SYNONYMS
	WHERE SYNONYM_NAME='SDO_GEORASTER';
  END IF;

  IF :GEORASTER_SUPPORT = 0 THEN
	dbms_output.put_line('NOTE: The data type SDO_GEORASTER is not available for this database. Raster relief tables will not be created.');
  END IF;
END;
/

-- create tables
column script new_value TABLES
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'SCHEMA/TABLES/TABLES_GEORASTER.sql'
  ELSE 'SCHEMA/TABLES/TABLES.sql'
  END AS script
FROM dual;

@@&TABLES

-- populate database SRS
INSERT INTO DATABASE_SRS(SRID,GML_SRS_NAME) VALUES (&SRSNO,'&GMLSRSNAME');
COMMIT;

-- create sequences
column script new_value SEQUENCES
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'SCHEMA/SEQUENCES/SEQUENCES_GEORASTER.sql'
  ELSE 'SCHEMA/SEQUENCES/SEQUENCES.sql'
  END AS script
FROM dual;

@@&SEQUENCES

-- activate constraints
column script new_value CONSTRAINTS
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'SCHEMA/CONSTRAINTS/CONSTRAINTS_GEORASTER.sql'
  ELSE 'SCHEMA/CONSTRAINTS/CONSTRAINTS.sql'
  END AS script
FROM dual;

@@&CONSTRAINTS

-- build indexes
column script new_value SIMPLE_INDEXES
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'SCHEMA/INDEXES/SIMPLE_INDEXES_GEORASTER.sql'
  ELSE 'SCHEMA/INDEXES/SIMPLE_INDEXES.sql'
  END AS script
FROM dual;

@@&SIMPLE_INDEXES
@@SCHEMA/INDEXES/SPATIAL_INDEXES.sql

-- create objectclass instances
@@UTIL/CREATE_DB/OBJECTCLASS_INSTANCES.sql

-- activate versioning if requested
column script new_value VERSIONING
SELECT
  CASE WHEN upper('&VERSIONING')='YES' OR upper('&VERSIONING')='Y' THEN 'ENABLE_VERSIONING2.sql'
  ELSE 'UTIL/CREATE_DB/DO_NOTHING.sql'
  END AS script
FROM dual;

@@&VERSIONING &DBVERSION

-- citydb packages
@@CREATE_CITYDB_PKG.sql &DBVERSION

SHOW ERRORS;
COMMIT;

SELECT '3DCityDB creation complete!' as message from DUAL;
