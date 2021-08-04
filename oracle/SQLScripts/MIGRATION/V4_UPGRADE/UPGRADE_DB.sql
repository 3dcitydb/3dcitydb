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

DEFINE DBVERSION=&1;
DEFINE NEW_MAJOR=4;
DEFINE NEW_MINOR=1;
DEFINE NEW_REVISION=1;

SELECT 'Upgrading 3DCityDB ...' as message from DUAL;

-- check current version
SELECT 'Checking version of the 3DCityDB instance ...' as message from DUAL;
VARIABLE major NUMBER;
VARIABLE minor NUMBER;
VARIABLE revision NUMBER;
BEGIN
  SELECT major_version, minor_version, minor_revision INTO :major, :minor, :revision FROM TABLE(citydb_util.citydb_version);
END;
/

SELECT :major || '.' || :minor || '.' || :revision as message from DUAL;

-- choose action depending on current version
column script new_value DO_ACTION
SELECT CASE
  WHEN &NEW_MAJOR = :major
       AND ( (&NEW_MINOR = :minor AND &NEW_REVISION > :revision)
	   OR &NEW_MINOR > :minor ) THEN 'DO_UPGRADE.sql'
  WHEN :major < &NEW_MAJOR THEN 'DO_MIGRATE.sql'
  ELSE 'DO_NOTHING.sql'
  END AS script
FROM dual;

@@&DO_ACTION

SHOW ERRORS;
COMMIT;

SELECT '3DCityDB upgrade complete!' as message from DUAL;

QUIT;
/