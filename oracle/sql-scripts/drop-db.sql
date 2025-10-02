SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VER OFF

SELECT 'Dropping 3DCityDB tables and user objects' AS message FROM DUAL;
BEGIN
  FOR cur_rec IN (
    SELECT object_name, object_type
    FROM user_objects
    WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE', 'TYPE')
  ) LOOP
    BEGIN
	  IF cur_rec.object_type = 'TABLE' THEN
	    EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
	  ELSIF cur_rec.object_type = 'TYPE' THEN
	    EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" FORCE';
      ELSE
	    EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
      END IF;
    EXCEPTION
	  WHEN OTHERS THEN
      NULL;
    END;
  END LOOP;

  -- remove spatial metadata
  EXECUTE IMMEDIATE 'DELETE FROM user_sdo_geom_metadata';
END;
/

PURGE RECYCLEBIN;

SELECT '3DCityDB instance successfully removed!' AS message FROM DUAL;

QUIT;
/