-- selectai_citydb_setup.sql
-- Run as the application schema (e.g. CITYDB) in the target PDB.

-- ============================================================
-- Grant DBMS_CLOUD privileges to CITYDB in FREEPDB1
-- Must be run as SYS or SYSTEM
-- ============================================================

WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET ECHO ON
SET FEEDBACK ON
SET VERIFY OFF
SET SERVEROUTPUT ON

-- Ensure correct PDB
ALTER SESSION SET CONTAINER = FREEPDB1;
ALTER SESSION SET CURRENT_SCHEMA = SYS;

DECLARE
  v_con VARCHAR2(128) := SYS_CONTEXT('USERENV','CON_NAME');
BEGIN
  IF v_con <> 'FREEPDB1' THEN
    RAISE_APPLICATION_ERROR(-20010, 'Must run in FREEPDB1. Current='||v_con);
  END IF;
END;
/

GRANT EXECUTE ON DBMS_CLOUD    TO CITYDB;
GRANT EXECUTE ON DBMS_CLOUD_AI TO CITYDB;

PROMPT Grants completed successfully in FREEPDB1.

-- Grant Network ACL for OpenAI endpoint
BEGIN  
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host => 'api.openai.com',
    ace  => xs$ace_type(
              privilege_list => xs$name_list('http'),
              principal_name => 'CITYDB',
              principal_type => xs_acl.ptype_db
           )
  );
END;
/