-- MIGRATE_DB_V2_V3.sql
--
-- Author:     Arda Muftuoglu <amueftueoglu@moss.de>            
--
-- Copyright:  (c) 2014, M.O.S.S. Computer Grafik Systeme GmbH
--						 Hohenbrunner Weg 13, D-82024 Taufkirchen
--						 Germany
-- 
--              This script is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
-- Migration script from Oracle 3DCityDB version 2.1 to version 3.0
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2014-10-14   release version                             AM
-- 

SET SERVEROUTPUT ON;
ACCEPT SCHEMAINPUT PROMPT 'Enter the user name of 3DCityDB v3.0.0 instance : '

DECLARE
    schema_name_user VARCHAR2(30) := upper('&SCHEMAINPUT');
BEGIN
	FOR R IN (SELECT table_name FROM user_tables) LOOP
		EXECUTE IMMEDIATE 'grant select on '||R.table_name||' to "'||schema_name_user||'"';
		dbms_output.put_line('grant select on '||R.table_name||' to "'||schema_name_user||'"');
	END LOOP;
END;
/