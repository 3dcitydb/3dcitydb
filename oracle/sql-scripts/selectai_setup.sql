-- selectai_citydb_setup.sql
-- Run as CITYDB in FREEPDB1

WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET FEEDBACK ON
SET SERVEROUTPUT ON
SET VERIFY OFF

PROMPT Creating OpenAI credential ...

BEGIN
  DBMS_CLOUD.CREATE_CREDENTIAL(
    credential_name => 'OPENAI_CRED',
    username        => 'OPENAI',
    password        => '&OPENAI_API_KEY'
  );
END;
/


--
-- Create AI profile
--
BEGIN
  DBMS_CLOUD_AI.CREATE_PROFILE(
  profile_name   => 'OPENAI',
  attributes     =>'{"provider": "openai",                                                                   
        "credential_name": "OPENAI_CRED",                                     
        "object_list": [ {"owner": "CITYDB", "name": "ADDRESS"},
        {"owner": "CITYDB", "name": "ADE"},
        {"owner": "CITYDB", "name": "APPEAR_TO_SURFACE_DATA"},
        {"owner": "CITYDB", "name": "APPEARANCE"},
        {"owner": "CITYDB", "name": "CODELIST"},
        {"owner": "CITYDB", "name": "CODELIST_ENTRY"},
        {"owner": "CITYDB", "name": "DATABASE_SRS"},
        {"owner": "CITYDB", "name": "DATATYPE"},
        {"owner": "CITYDB", "name": "FEATURE"},
        {"owner": "CITYDB", "name": "FEATURE_CHANGELOG"},
        {"owner": "CITYDB", "name": "GEOMETRY_DATA"},
        {"owner": "CITYDB", "name": "IMPLICIT_GEOMETRY"},
        {"owner": "CITYDB", "name": "MDRT_11B89$"},
        {"owner": "CITYDB", "name": "MDRT_11B90$"},
        {"owner": "CITYDB", "name": "MDRT_11B2$"},
        {"owner": "CITYDB", "name": "NAMESPACE"},
        {"owner": "CITYDB", "name": "OBJECTCLASS"},
        {"owner": "CITYDB", "name": "PROPERTY"},
        {"owner": "CITYDB", "name": "SURFACE_DATA"},
        {"owner": "CITYDB", "name": "SURFACE_DATA_MAPPING"},
        {"owner": "CITYDB", "name": "TEX_IMAGE"}],
        "conversation": "true"                
       }');                                                                  
END;                                                                         
/

-- Enable AI profile in current session
EXEC DBMS_CLOUD_AI.SET_PROFILE('OPENAI');

-- Get Profile in current session
SELECT DBMS_CLOUD_AI.get_profile() from dual;