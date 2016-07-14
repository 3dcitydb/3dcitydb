-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
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
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.1.0     2015-07-21   added citydb_envelope package               FKun
-- 2.0.0     2014-10-10   minor updates for 3DCityDB V3               FKun
-- 1.0.0     2008-09-10   release version                             CNag
--

SELECT 'Deleting packages ''citydb_util'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', ''citydb_delete'' and corresponding types' as message from DUAL;

--// drop index table and corresponding sequence
DROP TABLE INDEX_TABLE CASCADE CONSTRAINTS;
DROP SEQUENCE INDEX_TABLE_SEQ;

--// drop global types
DROP TYPE STRARRAY;
DROP TYPE ID_ARRAY;
DROP TYPE INDEX_OBJ;
DROP TYPE DB_VERSION_TABLE;
DROP TYPE DB_VERSION_OBJ;
DROP TYPE DB_INFO_TABLE;
DROP TYPE DB_INFO_OBJ;

--// drop packages
DROP PACKAGE citydb_util;
DROP PACKAGE citydb_idx;
DROP PACKAGE citydb_srs;
DROP PACKAGE citydb_stat;
DROP PACKAGE citydb_envelope;
DROP PACKAGE citydb_delete_by_lineage;
DROP PACKAGE citydb_delete;

SELECT 'Packages ''citydb_util'', ''citydb_idx'', ''citydb_srs'', ''citydb_stat'', ''citydb_envelope'', ''citydb_delete_by_lineage'', and ''citydb_delete'' deleted' as message from DUAL;