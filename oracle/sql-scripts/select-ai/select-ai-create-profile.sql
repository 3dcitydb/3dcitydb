-- select-ai-create-profile.sql
-- Run as the application user (e.g. CITYDB) in the target PDB.
-- Required SQL*Plus defines:
--   DB_USER    (e.g. citydb)
--   AI_API_KEY (the OpenAI API key value)
--   AI_MODEL   (the OpenAI model name, e.g. gpt-5.5)

WHENEVER SQLERROR EXIT FAILURE
WHENEVER OSERROR EXIT FAILURE

SET FEEDBACK ON
SET SERVEROUTPUT ON
SET VERIFY OFF

-- use the upper-case user name as owner of the tables in the AI profile
COLUMN db_user NEW_VALUE DB_USER
SELECT upper('&DB_USER') AS db_user FROM dual;

PROMPT Creating OpenAI credential (drop if exists) ...

-- Drop existing credential (idempotent)
BEGIN
  DBMS_CLOUD.DROP_CREDENTIAL(credential_name => 'OPENAI_CRED');
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -20004 THEN RAISE; END IF;  -- ORA-20004: credential does not exist
END;
/

BEGIN
  DBMS_CLOUD.CREATE_CREDENTIAL(
    credential_name => 'OPENAI_CRED',
    username        => 'OPENAI',
    password        => '&AI_API_KEY'
  );
END;
/

PROMPT Creating AI profile (drop if exists) ...

-- Drop existing profile (idempotent)
BEGIN
  DBMS_CLOUD_AI.DROP_PROFILE(profile_name => 'OPENAI', force => TRUE);
END;
/

-- object_list contains only the PHYSICAL data tables the generated SQL runs
-- against. The metadata/registry tables (OBJECTCLASS, DATATYPE, NAMESPACE, ADE)
-- and the PROPERTY_CATALOG view are intentionally EXCLUDED.
BEGIN
  DBMS_CLOUD_AI.CREATE_PROFILE(
    profile_name => 'OPENAI',
    attributes   => '{"provider": "openai",
      "credential_name": "OPENAI_CRED",
      "object_list": [
        {"owner": "&DB_USER", "name": "ADDRESS"},
        {"owner": "&DB_USER", "name": "APPEAR_TO_SURFACE_DATA"},
        {"owner": "&DB_USER", "name": "APPEARANCE"},
        {"owner": "&DB_USER", "name": "CODELIST"},
        {"owner": "&DB_USER", "name": "CODELIST_ENTRY"},
        {"owner": "&DB_USER", "name": "DATABASE_SRS"},
        {"owner": "&DB_USER", "name": "FEATURE"},
        {"owner": "&DB_USER", "name": "FEATURE_CHANGELOG"},
        {"owner": "&DB_USER", "name": "GEOMETRY_DATA"},
        {"owner": "&DB_USER", "name": "IMPLICIT_GEOMETRY"},
        {"owner": "&DB_USER", "name": "PROPERTY"},
        {"owner": "&DB_USER", "name": "SURFACE_DATA"},
        {"owner": "&DB_USER", "name": "SURFACE_DATA_MAPPING"},
        {"owner": "&DB_USER", "name": "TEX_IMAGE"}
      ],
      "model": "&AI_MODEL",
      "conversation": "true",
      "constraints": "true"
    }'
  );
END;
/

PROMPT Creating login trigger to auto-set AI profile ...

CREATE OR REPLACE TRIGGER set_ai_profile_on_login
AFTER LOGON ON SCHEMA
BEGIN
  DBMS_CLOUD_AI.SET_PROFILE('OPENAI');
END;
/

-- check for compilation errors
@util/check-compilation.sql

PROMPT AI profile created successfully.
