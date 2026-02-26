SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

-- parse arguments
DEFINE USERNAME=&1;
DEFINE SCHEMA_NAME=&2;

SELECT 'Revoking access privileges on schema "' || upper('&SCHEMA_NAME') || '" from "' || upper('&USERNAME') || '" ...' as message from DUAL;

DECLARE
  target_schema VARCHAR2(128) := upper('&SCHEMA_NAME');
  user_name VARCHAR2(128) := upper('&USERNAME');
BEGIN
  -- REVOKE ACCESS
  FOR rec IN (SELECT table_name, privilege FROM all_tab_privs WHERE grantee = user_name AND table_schema = target_schema) LOOP
    EXECUTE IMMEDIATE 'revoke '||rec.privilege||' on '||target_schema||'."'||rec.table_name||'" from "'||user_name||'"';
  END LOOP;
END;
/

SELECT 'Access privileges successfully revoked.' as message from DUAL;

QUIT;