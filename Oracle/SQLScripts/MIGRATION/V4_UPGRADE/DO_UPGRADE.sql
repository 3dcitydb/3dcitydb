-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2019
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
-------------------------------------------------------------------------------

SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

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