SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SHOWMODE OFF
WHENEVER SQLERROR EXIT

PROMPT
PROMPT Dropping changelog extension ...

DECLARE
  TYPE t_object IS RECORD (
    type VARCHAR2(128),
    name VARCHAR2(128)
  );
  TYPE t_object_tab IS TABLE OF t_object;
  v_objects t_object_tab := t_object_tab(
    t_object('SEQUENCE', 'FEATURE_CHANGELOG_SEQ'),
    t_object('TRIGGER', 'LOG_FEATURE_DELETES'),
    t_object('TRIGGER', 'LOG_FEATURE_UPSERTS'),
    t_object('TABLE', 'FEATURE_CHANGELOG')
  );
  v_sql VARCHAR2(255);
BEGIN
  FOR i IN 1 .. v_objects.COUNT LOOP
    BEGIN
      v_sql := 'DROP ' || v_objects(i).type || ' ' || v_objects(i).name;
      IF v_objects(i).type = 'TABLE' THEN
        v_sql := v_sql || ' CASCADE CONSTRAINTS';
      END IF;

      EXECUTE IMMEDIATE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        IF NOT ((v_objects(i).type = 'SEQUENCE' AND SQLCODE = -2289)
             OR (v_objects(i).type = 'TRIGGER' AND SQLCODE = -4080)
             OR (v_objects(i).type = 'TABLE' AND SQLCODE = -942)) THEN
          RAISE;
        END IF;
    END;
  END LOOP;
END;
/

DELETE FROM user_sdo_geom_metadata WHERE table_name = 'FEATURE_CHANGELOG' AND column_name = 'ENVELOPE';

PURGE RECYCLEBIN;
COMMIT;

PROMPT Changelog extension successfully removed.
QUIT;
/