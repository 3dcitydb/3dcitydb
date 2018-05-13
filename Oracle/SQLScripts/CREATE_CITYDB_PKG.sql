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

-- parse arguments
DEFINE DBVERSION=&1;

SELECT 'Creating packages ''citydb_util'', ''citydb_constraint'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', ''citydb_delete'', and corresponding types' as message from DUAL;
@@PL_SQL/CITYDB_PKG/UTIL/UTIL.sql;
@@PL_SQL/CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql;
@@PL_SQL/CITYDB_PKG/INDEX/IDX.sql;
@@PL_SQL/CITYDB_PKG/SRS/SRS.sql;
@@PL_SQL/CITYDB_PKG/STATISTICS/STAT.sql;
@@PL_SQL/CITYDB_PKG/ENVELOPE/ENVELOPE.sql;

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
  CASE WHEN :GEORASTER_SUPPORT <> 0 THEN 'PL_SQL/CITYDB_PKG/DELETE/DELETE_GEORASTER.sql'
  ELSE 'PL_SQL/CITYDB_PKG/DELETE/DELETE.sql'
  END AS script
FROM dual;

@@&DELETE

@@PL_SQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE;
SELECT 'Packages ''citydb_util'', ''citydb_constraint'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', and ''citydb_delete'' created' as message from DUAL;
