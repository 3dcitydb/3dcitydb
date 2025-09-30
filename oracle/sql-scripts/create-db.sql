SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

-- parse arguments
DEFINE SRSNO=&1;
DEFINE SRSNAME=&2;
-- DEFINE VERSIONING=&3;
-- DEFINE CHANGELOG=&4;

-- check if the chosen SRID is provided by the MDSYS.CS_SRS table
VARIABLE SRID NUMBER;

WHENEVER SQLERROR CONTINUE;

BEGIN
  SELECT SRID INTO :SRID FROM MDSYS.CS_SRS WHERE SRID=&SRSNO;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'The SRID ' || &SRSNO || ' is not supported. To add it manually, see CRS definitions at https://spatialreference.org/.');
END;
/

-- populate database SRS
INSERT INTO DATABASE_SRS(SRID, SRS_NAME) VALUES (&SRSNO, '&SRSNAME');
COMMIT;

-- create tables, sequences, constraints, indexes
SELECT 'Setting up database schema of 3DCityDB instance ...' AS message FROM dual;
@@schema/schema.sql

-- populate metadata tables
@@schema/namespace-instances.sql
@@schema/objectclass-instances.sql
@@schema/datatype-instances.sql

-- populate codelist tables
@@schema/codelist-instances.sql
@@schema/codelist-entry-instances.sql

-- create citydb_pkg schema
SELECT 'Creating additional schema ''citydb_pkg'' ...' AS message FROM dual;
@@citydb-pkg/srs.sql
-- @@citydb-pkg/util.sql
-- @@citydb-pkg/envelope.sql
-- @@citydb-pkg/delete.sql

SELECT 'Setting spatial reference system of 3DCityDB instance ...' AS message FROM dual;

BEGIN
  citydb_pkg.change_schema_srid(:SRID, '&SRSNAME');
END;
/

--- success message
SELECT '3DCityDB instance successfully created.' AS message FROM dual;