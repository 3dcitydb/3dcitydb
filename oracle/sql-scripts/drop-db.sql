SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SHOWMODE OFF
WHENEVER SQLERROR EXIT

-- drop 3DCityDB schema
PROMPT
PROMPT Dropping 3DCityDB schema ...
BEGIN
  FOR rec IN (
    SELECT object_name, object_type
    FROM user_objects
    WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE', 'TYPE')
  ) LOOP
    BEGIN
      IF rec.object_type = 'TABLE' THEN
        EXECUTE IMMEDIATE 'DROP ' || rec.object_type || ' "' || rec.object_name || '" CASCADE CONSTRAINTS';
      ELSIF rec.object_type = 'TYPE' THEN
        EXECUTE IMMEDIATE 'DROP ' || rec.object_type || ' "' || rec.object_name || '" FORCE';
      ELSE
        EXECUTE IMMEDIATE 'DROP ' || rec.object_type || ' "' || rec.object_name || '"';
      END IF;
    EXCEPTION
	    WHEN OTHERS THEN
        NULL;
    END;
  END LOOP;

  DELETE FROM user_sdo_geom_metadata;
END;
/

PURGE RECYCLEBIN;
COMMIT;

PROMPT 3DCityDB instance successfully removed.
QUIT;
/