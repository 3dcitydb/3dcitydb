-- fail if any object in the schema has compilation errors
DECLARE
  v_has_errors BOOLEAN := FALSE;
BEGIN
  FOR rec IN (
    SELECT name, type, line, text
    FROM user_errors
    WHERE attribute = 'ERROR'
    ORDER BY name, type, sequence
  ) LOOP
    v_has_errors := TRUE;
    DBMS_OUTPUT.PUT_LINE(rec.type || ' ' || rec.name || ' line ' || rec.line || ': ' || RTRIM(rec.text, CHR(10)));
  END LOOP;

  IF v_has_errors THEN
    RAISE_APPLICATION_ERROR(-20002, 'Compilation errors found. See the output above for details.');
  END IF;
END;
/
