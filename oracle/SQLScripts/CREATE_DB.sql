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

-- parse arguments
DEFINE SRSNO=&1;
DEFINE GMLSRSNAME=&2;
DEFINE VERSIONING=&3;

-- check if the chosen SRID is provided by the MDSYS.CS_SRS table
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

-- enable GeoRaster support
exec SDO_GEOR_ADMIN.enableGeoRaster;

-- create tables
@@SCHEMA/TABLES/TABLES_GEORASTER.sql

-- populate database SRS
INSERT INTO DATABASE_SRS(SRID,GML_SRS_NAME) VALUES (&SRSNO,'&GMLSRSNAME');
COMMIT;

-- create sequences
@@SCHEMA/SEQUENCES/SEQUENCES_GEORASTER.sql

-- activate constraints
@@SCHEMA/CONSTRAINTS/CONSTRAINTS_GEORASTER.sql

-- citydb packages
SELECT 'Creating packages ''citydb_util'', ''citydb_constraint'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', ''citydb_delete'', and corresponding types' as message from DUAL;
@@CITYDB_PKG/UTIL/UTIL.sql;
@@CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql;
@@CITYDB_PKG/INDEX/IDX.sql;
@@CITYDB_PKG/SRS/SRS.sql;
@@CITYDB_PKG/STATISTICS/STAT.sql;

-- create delete scripts
@@CITYDB_PKG/DELETE/DELETE_GEORASTER.sql

-- create envelope scripts
@@CITYDB_PKG/ENVELOPE/ENVELOPE_GEORASTER.sql

SELECT 'Packages ''citydb_util'', ''citydb_constraint'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', and ''citydb_delete'' created' as message from DUAL;

-- create objectclass instances and functions
@@SCHEMA/OBJECTCLASS/OBJECTCLASS_INSTANCES.sql
@@SCHEMA/OBJECTCLASS/AGGREGATION_INFO_INSTANCES.sql
@@SCHEMA/OBJECTCLASS/OBJCLASS.sql

-- create spatial metadata
exec citydb_constraint.set_schema_sdo_metadata(USER);
COMMIT;

-- build indexes
@@SCHEMA/INDEXES/SIMPLE_INDEXES_GEORASTER.sql
@@SCHEMA/INDEXES/SPATIAL_INDEXES.sql

-- activate versioning if requested
column script new_value VERSIONING
SELECT
  CASE WHEN upper('&VERSIONING')='YES' OR upper('&VERSIONING')='Y' THEN 'UTIL/VERSIONING/ENABLE_VERSIONING.sql'
  ELSE 'UTIL/HINTS/DO_NOTHING.sql'
  END AS script
FROM dual;

@@&VERSIONING

SHOW ERRORS;
COMMIT;

SELECT '3DCityDB creation complete!' AS message FROM dual;

QUIT;
/
