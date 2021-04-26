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

-- parge arguments
DEFINE DBVERSION=&1;

-- disable versioning (if it was enabled before)
@@UTIL/VERSIONING/DISABLE_VERSIONING.sql &DBVERSION

SELECT 'Dropping 3DCityDB tables and user objects' as message from DUAL;
BEGIN
  FOR cur_rec IN (SELECT object_name, object_type
                    FROM user_objects
                    WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE', 'TYPE')) LOOP
    BEGIN
	  IF cur_rec.object_type = 'TABLE' THEN
	    EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
	  ELSIF cur_rec.object_type = 'TYPE' THEN
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

PURGE RECYCLEBIN;

SELECT '3DCityDB instance successfully removed!' as message from DUAL;

QUIT;
/