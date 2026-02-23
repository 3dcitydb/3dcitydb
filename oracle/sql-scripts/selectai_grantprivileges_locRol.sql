-- Run in CDB$ROOT
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

PROMPT Granting INHERIT PRIVILEGES on SYS to C##CLOUD$SERVICE ...

GRANT INHERIT PRIVILEGES
ON USER SYS
TO C##CLOUD$SERVICE;

set verify off

-- Variables (no quotes)
define userrole = C##CLOUD_USER_ROLE
define username = C##CLOUD$SERVICE

-- Create common role (idempotent)
declare
  role_exists exception;
  pragma exception_init(role_exists, -1921); -- ORA-01921: role name already exists
begin
  execute immediate 'create role &userrole';
exception
  when role_exists then null;
end;
/

-- Grant the common role to the common user (across all containers)
grant &userrole to &username container=all;

-- Minimal system privileges via the common role (apply to all containers)
grant create table to &userrole container=all;
grant execute on dbms_cloud to &userrole container=all;

-- Optional packages: present only in some editions/versions.
-- Wrap in blocks so the script doesn't fail if they don't exist.
begin
  execute immediate 'grant execute on dbms_cloud_pipeline to &userrole container=all';
exception when others then null; end;
/
begin
  execute immediate 'grant execute on dbms_cloud_repo to &userrole container=all';
exception when others then null; end;
/
begin
  execute immediate 'grant execute on dbms_cloud_notification to &userrole container=all';
exception when others then null; end;
/

-- Core prerequisites (uncomment if needed for the common user)
-- grant create session to &username container=all;
-- alter user &username quota unlimited on USERS;  -- This must be done in each PDB; see PDB section


-- ============================================================
-- PDB-specific grants (DATA_PUMP_DIR)
-- ============================================================

ALTER SESSION SET CONTAINER = FREEPDB1;

-- Grant READ/WRITE on DATA_PUMP_DIR
BEGIN
  EXECUTE IMMEDIATE
    'GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO C##CLOUD$SERVICE';
EXCEPTION
  WHEN OTHERS THEN
    -- Ignore if already granted or directory does not exist
    IF SQLCODE NOT IN (-1927, -942) THEN
      RAISE;
    END IF;
END;
/

