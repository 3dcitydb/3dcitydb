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

SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

-- parse arguments
DEFINE SRSNO=&1;
DEFINE GMLSRSNAME=&2;
DEFINE VERSIONING=&3;
DEFINE DBVERSION=&4;

--check if the chosen SRID is provided by the MDSYS.CS_SRS table
VARIABLE SRID NUMBER;
VARIABLE HINTFILE VARCHAR2(50);

WHENEVER SQLERROR CONTINUE;

BEGIN
  :HINTFILE := 'UTIL/HINTS/DO_NOTHING';
  
  SELECT SRID INTO :SRID FROM MDSYS.CS_SRS WHERE SRID=&SRSNO;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      :HINTFILE := 'UTIL/HINTS/HINT_ON_MISSING_SRS';
END;
/

-- transfer the value from the bind variable to the substitution variable
column script new_value HINTFILE2 print
SELECT :HINTFILE script FROM dual;
@@&HINTFILE2

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

-- citydb packages
SELECT 'Creating packages ''citydb_util'', ''citydb_constraint'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', ''citydb_delete'', and corresponding types' as message from DUAL;
@@CITYDB_PKG/UTIL/UTIL.sql;
@@CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql;
@@CITYDB_PKG/INDEX/IDX.sql;
@@CITYDB_PKG/SRS/SRS.sql;
@@CITYDB_PKG/STATISTICS/STAT.sql;

-- check for SDO_GEORASTER support
VARIABLE GEORASTER_SUPPORT NUMBER;
BEGIN
  :GEORASTER_SUPPORT := 0;
  IF (upper('&DBVERSION')='S') THEN
    SELECT COUNT(*) INTO :GEORASTER_SUPPORT FROM ALL_SYNONYMS
	WHERE SYNONYM_NAME='SDO_GEORASTER';
  END IF;
END;
/

-- create delete scripts
column script new_value DELETE
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'CITYDB_PKG/DELETE/DELETE_GEORASTER.sql'
  ELSE 'CITYDB_PKG/DELETE/DELETE.sql'
  END AS script
FROM dual;

@@&DELETE

-- create envelope scripts
column script new_value ENVELOPE
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'CITYDB_PKG/ENVELOPE/ENVELOPE_GEORASTER.sql'
  ELSE 'CITYDB_PKG/ENVELOPE/ENVELOPE.sql'
  END AS script
FROM dual;

@@&ENVELOPE

SELECT 'Packages ''citydb_util'', ''citydb_constraint'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', and ''citydb_delete'' created' as message from DUAL;

-- create objectclass instances and functions
@@SCHEMA/OBJECTCLASS/OBJECTCLASS_INSTANCES.sql
@@SCHEMA/OBJECTCLASS/AGGREGATION_INFO_INSTANCES.sql
@@SCHEMA/OBJECTCLASS/OBJCLASS.sql

-- create spatial metadata
exec citydb_constraint.set_schema_sdo_metadata(USER);
COMMIT;

-- build indexes
column script new_value SIMPLE_INDEXES
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'SCHEMA/INDEXES/SIMPLE_INDEXES_GEORASTER.sql'
  ELSE 'SCHEMA/INDEXES/SIMPLE_INDEXES.sql'
  END AS script
FROM dual;

@@&SIMPLE_INDEXES
@@SCHEMA/INDEXES/SPATIAL_INDEXES.sql

-- activate versioning if requested
column script new_value VERSIONING
SELECT
  CASE WHEN upper('&VERSIONING')='YES' OR upper('&VERSIONING')='Y' THEN 'UTIL/VERSIONING/ENABLE_VERSIONING.sql'
  ELSE 'UTIL/HINTS/DO_NOTHING.sql'
  END AS script
FROM dual;

@@&VERSIONING &DBVERSION

SHOW ERRORS;
COMMIT;

SELECT '3DCityDB creation complete!' AS message FROM dual;

QUIT;
/
