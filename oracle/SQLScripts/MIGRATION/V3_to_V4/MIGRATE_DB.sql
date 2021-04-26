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

SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

DEFINE DBVERSION=&2;

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

--// create SEQUENCES
SELECT 'Create sequences that are new in v4 ...' as message from DUAL;
@@SEQUENCES.sql

--// create TABLES
SELECT 'Create new tables of v4 and alter existing tables ...' as message from DUAL;
column script new_value TABLES
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'TABLES_GEORASTER.sql'
  ELSE 'TABLES.sql'
  END AS script
FROM dual;
@@&TABLES

SELECT 'Dropping existing 3DCityDB PL/SQL packages' as message from DUAL;
DROP TABLE INDEX_TABLE CASCADE CONSTRAINTS;
DROP SEQUENCE INDEX_TABLE_SEQ;
BEGIN
  FOR cur_rec IN (SELECT object_name, object_type
                    FROM user_objects
                    WHERE object_type IN ('PACKAGE', 'TYPE')) LOOP
    BEGIN
	  IF cur_rec.object_type = 'TYPE' THEN
	    EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" FORCE';
      ELSE
	    EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
      END IF;
    EXCEPTION
	  WHEN OTHERS THEN
        NULL;
    END;
  END LOOP;
END;
/

-- citydb packages
SELECT 'Creating packages ''citydb_util'', ''citydb_constraint'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', ''citydb_delete'', and corresponding types' as message from DUAL;
@@../../CITYDB_PKG/UTIL/UTIL.sql;
@@../../CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql;
@@../../CITYDB_PKG/INDEX/IDX.sql;
@@../../CITYDB_PKG/SRS/SRS.sql;
@@../../CITYDB_PKG/STATISTICS/STAT.sql;

-- create objectclass instances and functions
@@OBJECTCLASS_INSTANCES_V4.sql
@@../../SCHEMA/OBJECTCLASS/AGGREGATION_INFO_INSTANCES.sql
@@../../SCHEMA/OBJECTCLASS/OBJCLASS.sql

-- create delete scripts
column script new_value DELETE
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN '../../CITYDB_PKG/DELETE/DELETE_GEORASTER.sql'
  ELSE '../../CITYDB_PKG/DELETE/DELETE.sql'
  END AS script
FROM dual;

@@&DELETE

-- create envelope scripts
column script new_value ENVELOPE
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN '../../CITYDB_PKG/ENVELOPE/ENVELOPE_GEORASTER.sql'
  ELSE '../../CITYDB_PKG/ENVELOPE/ENVELOPE.sql'
  END AS script
FROM dual;

@@&ENVELOPE

SELECT 'Packages ''citydb_util'', ''citydb_constraint'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', and ''citydb_delete'' created' as message from DUAL;

--// adding CONSTRAINTS in new schema
SELECT 'Update primary keys, foreign keys and not null constraints ...' as message from DUAL;
column script new_value CONSTRAINTS
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'CONSTRAINTS_GEORASTER.sql'
  ELSE 'CONSTRAINTS.sql'
  END AS script
FROM dual;
@@&CONSTRAINTS

--// creating INDEXES in new schema
SELECT 'Update indexes ...' as message from DUAL;
column script new_value INDEXES
SELECT
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'INDEXES_GEORASTER.sql'
  ELSE 'INDEXES.sql'
  END AS script
FROM dual;
@@&INDEXES

SHOW ERRORS;
COMMIT;

SELECT '3DCityDB migration complete!' as message from DUAL;

QUIT;
/