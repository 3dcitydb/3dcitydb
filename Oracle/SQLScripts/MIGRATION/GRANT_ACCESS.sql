-- GRANT_ACCESS.sql
--
-- Author:     Arda Muftuoglu <amueftueoglu@moss.de>
--             Felix Kunde <felix-kunde@gmx.de>
--
-- Copyright:  (c) 2012-2016  Chair of Geoinformatics,
--                            Technische Universität München, Germany
--                            http://www.gis.bv.tum.de
--
--              This script is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Script to grant reading access on a 3DCityDB instance of v2.1 to a user 
-- with an installed version of the 3DCityDB v3.1
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2015-01-22   release version                             AM
--                                                                    FKun
--

SET SERVEROUTPUT ON;
ACCEPT SCHEMAINPUT PROMPT 'Enter the user name of 3DCityDB v3.1 instance : '

DECLARE
    schema_name_user VARCHAR2(30) := upper('&SCHEMAINPUT');
BEGIN
	FOR R IN (SELECT table_name FROM user_tables) LOOP
		EXECUTE IMMEDIATE 'grant select on '||R.table_name||' to "'||schema_name_user||'"';
		dbms_output.put_line('grant select on '||R.table_name||' to "'||schema_name_user||'"');
	END LOOP;
END;
/