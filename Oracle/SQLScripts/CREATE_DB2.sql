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

VARIABLE VERSIONBATCHFILE VARCHAR2(50);

--// create tables
@@SCHEMA/TABLES/TABLES.sql

-- This script is called from CREATE_DB.sql and it
-- is required that the three substitution variables
-- &SRSNO, &GMLSRSNAME, and &VERSIONING are set properly.

INSERT INTO DATABASE_SRS(SRID,GML_SRS_NAME) VALUES (&SRSNO,'&GMLSRSNAME');
COMMIT;

--// create sequences
@@SCHEMA/SEQUENCES/SEQUENCES.sql

--// activate constraints
@@SCHEMA/CONSTRAINTS/CONSTRAINTS.sql

--// citydb packages
@@CREATE_CITYDB_PKG.sql

--// create objectclass instances and functions
@@SCHEMA/OBJECTCLASS/OBJECTCLASS_INSTANCES.sql
@@SCHEMA/OBJECTCLASS/OBJCLASS.sql

--// create spatial metadata
exec citydb_constraint.set_schema_sdo_metadata(USER);
COMMIT;

--// build indexes
@@SCHEMA/INDEXES/SIMPLE_INDEX.sql
@@SCHEMA/INDEXES/SPATIAL_INDEX.sql

--// (possibly) activate versioning
BEGIN
  IF ('&VERSIONING'='yes' OR '&VERSIONING'='YES' OR '&VERSIONING'='y' OR '&VERSIONING'='Y') THEN
    :VERSIONBATCHFILE := 'ENABLE_VERSIONING2.sql';
  ELSE
    :VERSIONBATCHFILE := 'UTIL/CREATE_DB/DO_NOTHING.sql';
  END IF;
END;
/
-- Transfer the value from the bind variable to the substitution variable
column mc2 new_value VERSIONBATCHFILE2 print
select :VERSIONBATCHFILE mc2 from dual;

START &VERSIONBATCHFILE2

SHOW ERRORS;
COMMIT;

SELECT '3DCityDB creation complete!' as message from DUAL;
