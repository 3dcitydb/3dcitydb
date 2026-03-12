-- select-ai-sys-setup.sql
-- Run as SYS (sqlplus / as sysdba), starting in CDB$ROOT.
-- Performs all SYS-level setup for DBMS_CLOUD and Select AI.
--
-- Required SQL*Plus defines:
--   SSL_WALLET_DIR (e.g. /opt/oracle/wallet)
--   CLOUD_OWNER    (e.g. C##CLOUD$SERVICE)
--   PDB_NAME       (e.g. FREEPDB1)
--   DB_USER        (e.g. CITYDB)

WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET VERIFY OFF

-- ============================================================
-- Safety check: must be executed in CDB$ROOT as SYS
-- ============================================================
DECLARE
  v_con_name VARCHAR2(128);
BEGIN
  v_con_name := SYS_CONTEXT('USERENV','CON_NAME');
  IF v_con_name <> 'CDB$ROOT' THEN
    RAISE_APPLICATION_ERROR(
      -20001,
      'This script must be run in CDB$ROOT as SYS. Current container = ' || v_con_name
    );
  END IF;
END;
/

-- ============================================================
-- 1. Network ACL + wallet ACE for CLOUD_OWNER (CDB$ROOT)
-- ============================================================

-- Remove existing ACEs to avoid duplicates on re-run
BEGIN
  DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE(
    host       => '*',
    lower_port => 443,
    upper_port => 443,
    ace        => xs$ace_type(
      privilege_list => xs$name_list('http', 'http_proxy'),
      principal_name => UPPER('&CLOUD_OWNER'),
      principal_type => xs_acl.ptype_db
    )
  );
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  DBMS_NETWORK_ACL_ADMIN.REMOVE_WALLET_ACE(
    wallet_path => 'file:&SSL_WALLET_DIR',
    ace         => xs$ace_type(
      privilege_list => xs$name_list('use_client_certificates', 'use_passwords'),
      principal_name => UPPER('&CLOUD_OWNER'),
      principal_type => xs_acl.ptype_db
    )
  );
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Allow HTTPS (port 443) to all hosts
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host        => '*',
    lower_port  => 443,
    upper_port  => 443,
    ace         => xs$ace_type(
      privilege_list => xs$name_list('http', 'http_proxy'),
      principal_name => UPPER('&CLOUD_OWNER'),
      principal_type => xs_acl.ptype_db
    )
  );
END;
/

-- Allow wallet usage
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE(
    wallet_path => 'file:&SSL_WALLET_DIR',
    ace         => xs$ace_type(
      privilege_list => xs$name_list('use_client_certificates', 'use_passwords'),
      principal_name => UPPER('&CLOUD_OWNER'),
      principal_type => xs_acl.ptype_db
    )
  );
END;
/

-- Set SSL_WALLET database property (required by DBMS_CLOUD / DBMS_CLOUD_AI)
-- Must be executed in CDB$ROOT (ALTER DATABASE PROPERTY is not allowed in PDBs)
ALTER DATABASE PROPERTY SET SSL_WALLET = 'file:&SSL_WALLET_DIR';

-- ============================================================
-- 2. Role, privileges, and INHERIT grants (CDB$ROOT)
-- ============================================================

PROMPT Granting INHERIT PRIVILEGES on SYS to &CLOUD_OWNER ...

GRANT INHERIT PRIVILEGES
ON USER SYS
TO &CLOUD_OWNER;

DEFINE userrole = C##CLOUD_USER_ROLE
DEFINE username = &CLOUD_OWNER

-- Create common role (idempotent)
DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921);
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE &userrole';
EXCEPTION
  WHEN role_exists THEN NULL;
END;
/

-- Grant the common role to the common user (across all containers)
GRANT &userrole TO &username CONTAINER=ALL;

-- Minimal system privileges via the common role (apply to all containers)
GRANT CREATE TABLE TO &userrole CONTAINER=ALL;
GRANT EXECUTE ON DBMS_CLOUD TO &userrole CONTAINER=ALL;

-- Optional packages: present only in some editions/versions.
BEGIN
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CLOUD_PIPELINE TO &userrole CONTAINER=ALL';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CLOUD_REPO TO &userrole CONTAINER=ALL';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON DBMS_CLOUD_NOTIFICATION TO &userrole CONTAINER=ALL';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ============================================================
-- 3. PDB-specific grants (switch to target PDB)
-- ============================================================

ALTER SESSION SET CONTAINER = &PDB_NAME;

-- Grant READ/WRITE on DATA_PUMP_DIR to cloud owner
BEGIN
  EXECUTE IMMEDIATE
    'GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO &username';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-1927, -942) THEN
      RAISE;
    END IF;
END;
/

-- Grant DBMS_CLOUD privileges to the application user
GRANT EXECUTE ON DBMS_CLOUD    TO &DB_USER;
GRANT EXECUTE ON DBMS_CLOUD_AI TO &DB_USER;

PROMPT DBMS_CLOUD grants to &DB_USER completed.

-- Network ACL for Google Gemini API endpoint (remove + append for idempotency)
BEGIN
  DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE(
    host       => 'generativelanguage.googleapis.com',
    lower_port => 443,
    upper_port => 443,
    ace        => xs$ace_type(
                    privilege_list => xs$name_list('http'),
                    principal_name => UPPER('&DB_USER'),
                    principal_type => xs_acl.ptype_db
                 )
  );
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host       => 'generativelanguage.googleapis.com',
    lower_port => 443,
    upper_port => 443,
    ace        => xs$ace_type(
                    privilege_list => xs$name_list('http'),
                    principal_name => UPPER('&DB_USER'),
                    principal_type => xs_acl.ptype_db
                 )
  );
END;
/

PROMPT SYS setup completed successfully.
