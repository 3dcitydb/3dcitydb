-- grant-access.sql (improved)
-- invoked by grant-access.sh

SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET ECHO OFF
SET VERIFY OFF
SET TERMOUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE

-- parameters passed by caller
DEFINE USERNAME=&1;
DEFINE SCHEMA_NAME=&2;
DEFINE ACCESS_MODE=&3;

/*
   Basic validation of the inputs and the existence of the
   schema and grantee in the database.  Any failure will cause
   the script to abort with a non‑zero return code.
*/
BEGIN
  IF TRIM('&USERNAME') IS NULL
     OR TRIM('&SCHEMA_NAME') IS NULL
     OR TRIM('&ACCESS_MODE') IS NULL THEN
    raise_application_error(-20010,'username, schema_name and access_mode are required');
  END IF;
  IF upper('&ACCESS_MODE') NOT IN ('RO','RU','RW') THEN
    raise_application_error(-20011,'ACCESS_MODE must be RO, RU, or RW');
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
  privilege_type VARCHAR2(30);
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    'Granting ' ||
    CASE WHEN upper('&ACCESS_MODE') = 'RW' THEN 'read-write'
         WHEN upper('&ACCESS_MODE') = 'RU' THEN 'read-update'
         ELSE 'read-only' END ||
    ' privileges on schema "' || target_schema || '" to user "' || user_name || '"...');

  -- types
  FOR rec IN (SELECT type_name FROM all_types WHERE owner = target_schema) LOOP
    EXECUTE IMMEDIATE 'grant execute on '||target_schema||'."'||rec.type_name||'" to "'||user_name||'"';
  END LOOP;

  -- common packages
  FOR rec IN (
        SELECT object_name
          FROM all_objects
         WHERE owner = target_schema
           AND upper(object_type) = 'PACKAGE'
           AND object_name IN ('CITYDB_SCHEMA','CITYDB_UTIL','CITYDB_SRS')
  ) LOOP
    EXECUTE IMMEDIATE 'grant execute on '||target_schema||'."'||rec.object_name||'" to "'||user_name||'"';
  END LOOP;

  IF upper('&ACCESS_MODE') IN ('RU','RW') THEN
    FOR rec IN (
          SELECT object_name
            FROM all_objects
           WHERE owner = target_schema
             AND upper(object_type) = 'PACKAGE'
             AND object_name = 'CITYDB_DELETE'
    ) LOOP
      EXECUTE IMMEDIATE 'grant execute on '||target_schema||'."'||rec.object_name||'" to "'||user_name||'"';
    END LOOP;
  END IF;

  -- tables and views
  FOR rec IN (
        SELECT table_name name FROM all_tables  WHERE owner = target_schema
        UNION ALL
        SELECT view_name FROM all_views WHERE owner = target_schema
  ) LOOP
    privilege_type := CASE WHEN upper('&ACCESS_MODE') = 'RW' THEN 'all'
                           WHEN upper('&ACCESS_MODE') = 'RU' THEN 'select, insert, update'
                           ELSE 'select' END;
    EXECUTE IMMEDIATE 'grant '||privilege_type||' on '||target_schema||'."'||rec.name||'" to "'||user_name||'"';
  END LOOP;

  -- sequences for RU and RW
  IF upper('&ACCESS_MODE') = 'RW' THEN
    FOR rec IN (
          SELECT sequence_name seq
            FROM all_sequences
           WHERE sequence_owner = target_schema
    ) LOOP
      EXECUTE IMMEDIATE 'grant all on '||target_schema||'."'||rec.seq||'" to "'||user_name||'"';
    END LOOP;
  ELSIF upper('&ACCESS_MODE') = 'RU' THEN
    FOR rec IN (
          SELECT sequence_name seq
            FROM all_sequences
           WHERE sequence_owner = target_schema
    ) LOOP
      EXECUTE IMMEDIATE 'grant select on '||target_schema||'."'||rec.seq||'" to "'||user_name||'"';
    END LOOP;
  END IF;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Successfully granted '||
    CASE WHEN upper('&ACCESS_MODE') = 'RW' THEN 'read-write'
         WHEN upper('&ACCESS_MODE') = 'RU' THEN 'read-update'
         ELSE 'read-only' END || ' privileges.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR: '||SQLERRM);
    RAISE;
END;
/

EXIT SQL.SQLCODE;
