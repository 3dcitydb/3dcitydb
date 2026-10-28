-- revoke-access.sql (improved)
-- invoked by revoke-access.sh

SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET ECHO OFF
SET VERIFY OFF
SET TERMOUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE

-- parameters passed by caller
DEFINE USERNAME=&1;
DEFINE SCHEMA_NAME=&2;

/*
   Basic validation of the inputs and the existence of the
   schema and grantee in the database.  Any failure will cause
   the script to abort with a non‑zero return code.
*/
BEGIN
  IF TRIM('&USERNAME') IS NULL
     OR TRIM('&SCHEMA_NAME') IS NULL THEN
    raise_application_error(-20010,'username and schema_name are required');
  END IF;

  DECLARE
    v_cnt PLS_INTEGER;
  BEGIN
    SELECT COUNT(*) INTO v_cnt
      FROM all_users
     WHERE username = upper('&SCHEMA_NAME');
    IF v_cnt = 0 THEN
      raise_application_error(-20001,'Schema '||upper('&SCHEMA_NAME')||' does not exist');
    END IF;

    SELECT COUNT(*) INTO v_cnt
      FROM all_users
     WHERE username = upper('&USERNAME');
    IF v_cnt = 0 THEN
      raise_application_error(-20002,'User '||upper('&USERNAME')||' does not exist');
    END IF;
  END;
END;
/

DECLARE
  target_schema  VARCHAR2(128) := upper('&SCHEMA_NAME');
  user_name      VARCHAR2(128) := upper('&USERNAME');
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    'Revoking privileges on schema "' || target_schema || '" from user "' || user_name || '"...');

  -- tables, types, sequences, packages
  FOR rec IN (SELECT table_name, privilege FROM all_tab_privs WHERE grantee = user_name AND table_schema = target_schema) LOOP
    EXECUTE IMMEDIATE 'revoke '||rec.privilege||' on '||target_schema||'."'||rec.table_name||'" from "'||user_name||'"';
  END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Privileges successfully revoked.');

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR: '||SQLERRM);
    RAISE;
END;
/

EXIT SQL.SQLCODE;
