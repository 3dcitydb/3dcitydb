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

SET SERVEROUTPUT ON verify off;
SET FEEDBACK OFF;
ACCEPT SCHEMAINPUT PROMPT 'Enter the source schema name: '

DECLARE
	schema_name VARCHAR2(30) := '&SCHEMAINPUT';
BEGIN
	dbms_output.put_line('Starting DB migration...');
	dbms_output.put_line('Creating Synonyms...');

	FOR R IN (SELECT owner, table_name FROM all_tables WHERE owner=schema_name) LOOP
		EXECUTE IMMEDIATE 'CREATE SYNONYM '||R.table_name||'_v2 FOR "'||schema_name||'".'||R.table_name;
		-- dbms_output.put_line('CREATE SYNONYM '||R.table_name||'_v2 FOR "'||schema_name||'".'||R.table_name);
	END LOOP;

	dbms_output.put_line('Synonyms created.');
END;
/
START MIGRATE_DB2.sql
