SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SHOWMODE OFF
WHENEVER SQLERROR EXIT

-- parse arguments
DEFINE SRID=&1;
DEFINE SRS_NAME=&2;
DEFINE CHANGELOG=&3;
VARIABLE V_SRID NUMBER;
VARIABLE V_SRS_NAME VARCHAR2(4000);

-- check if the provided SRID is supported
PROMPT
PROMPT Checking spatial reference system for SRID &SRID ...
BEGIN
  SELECT SRID INTO :V_SRID FROM MDSYS.CS_SRS WHERE SRID = &SRID;
  :V_SRS_NAME := '&SRS_NAME';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'The SRID ' || &SRID || ' is not supported. To add it manually, see CRS definitions at https://spatialreference.org/.');
END;
/

-- create tables, sequences, constraints, indexes
PROMPT Setting up database schema of 3DCityDB instance ...
@@schema/schema.sql
@@schema/schema-annotations.sql

-- populate metadata tables
@@schema/namespace-instances.sql
@@schema/objectclass-instances.sql
@@schema/datatype-instances.sql

-- populate codelist tables
@@schema/codelist-instances.sql
@@schema/codelist-entry-instances.sql

-- create citydb packages
PROMPT Creating 'citydb' packages ...
@@citydb-pkg/srs.sql

PROMPT Setting spatial reference system of 3DCityDB instance ...
EXEC citydb_srs.change_schema_srid(:V_SRID, :V_SRS_NAME);

PROMPT 3DCityDB instance successfully created.
QUIT;
/