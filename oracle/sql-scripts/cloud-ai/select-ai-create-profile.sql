-- select-ai-create-profile.sql
-- Run as the application user (e.g. CITYDB) in the target PDB.
-- Required SQL*Plus defines:
--   OPENAI_API_KEY (the API key value)
--   DB_USER        (e.g. CITYDB)

WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET FEEDBACK ON
SET SERVEROUTPUT ON
SET VERIFY OFF

PROMPT Creating OpenAI credential (drop if exists) ...

-- Drop existing credential (idempotent)
BEGIN
  DBMS_CLOUD.DROP_CREDENTIAL(credential_name => 'OPENAI_CRED');
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN NULL;  -- DBMS_CLOUD custom error (e.g. does not exist)
    ELSE RAISE;
    END IF;
END;
/

BEGIN
  DBMS_CLOUD.CREATE_CREDENTIAL(
    credential_name => 'OPENAI_CRED',
    username        => 'OPENAI',
    password        => '&OPENAI_API_KEY'
  );
END;
/

PROMPT Creating AI profile (drop if exists) ...

-- Drop existing profile (idempotent)
BEGIN
  DBMS_CLOUD_AI.DROP_PROFILE(profile_name => 'OPENAI');
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN NULL;  -- DBMS_CLOUD_AI custom error (e.g. does not exist)
    ELSE RAISE;
    END IF;
END;
/

BEGIN
  DBMS_CLOUD_AI.CREATE_PROFILE(
    profile_name => 'OPENAI',
    attributes   => '{"provider": "openai",
      "credential_name": "OPENAI_CRED",
      "object_list": [
        {"owner": "&DB_USER", "name": "ADDRESS"},
        {"owner": "&DB_USER", "name": "ADE"},
        {"owner": "&DB_USER", "name": "APPEAR_TO_SURFACE_DATA"},
        {"owner": "&DB_USER", "name": "APPEARANCE"},
        {"owner": "&DB_USER", "name": "CODELIST"},
        {"owner": "&DB_USER", "name": "CODELIST_ENTRY"},
        {"owner": "&DB_USER", "name": "DATABASE_SRS"},
        {"owner": "&DB_USER", "name": "DATATYPE"},
        {"owner": "&DB_USER", "name": "FEATURE"},
        {"owner": "&DB_USER", "name": "FEATURE_CHANGELOG"},
        {"owner": "&DB_USER", "name": "GEOMETRY_DATA"},
        {"owner": "&DB_USER", "name": "IMPLICIT_GEOMETRY"},
        {"owner": "&DB_USER", "name": "NAMESPACE"},
        {"owner": "&DB_USER", "name": "OBJECTCLASS"},
        {"owner": "&DB_USER", "name": "PROPERTY"},
        {"owner": "&DB_USER", "name": "SURFACE_DATA"},
        {"owner": "&DB_USER", "name": "SURFACE_DATA_MAPPING"},
        {"owner": "&DB_USER", "name": "TEX_IMAGE"}
      ],
      "conversation": "true"
    }'
  );
END;
/

PROMPT AI profile created successfully.
