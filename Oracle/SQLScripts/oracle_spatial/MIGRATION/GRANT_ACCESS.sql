SET SERVEROUTPUT ON;
ACCEPT SCHEMAINPUTUSER PROMPT 'Enter the username for the accesses to be granted: '
ACCEPT SCHEMAINPUTSRC PROMPT 'Enter the schema name on which the accesses to be granted: ' 

DECLARE
  	schema_name_user VARCHAR2(30) := '&SCHEMAINPUTUSER';
	schema_name_source VARCHAR2(30) := '&SCHEMAINPUTSRC';	
BEGIN
	FOR R IN (SELECT owner, table_name FROM all_tables WHERE owner=schema_name_source) LOOP
		EXECUTE IMMEDIATE 'grant select on "'||R.owner||'".'||R.table_name||' to "'||schema_name_user||'"';
		dbms_output.put_line('grant select on "'||R.owner||'".'||R.table_name||' to "'||schema_name_user||'"');
	END LOOP;
END;
/