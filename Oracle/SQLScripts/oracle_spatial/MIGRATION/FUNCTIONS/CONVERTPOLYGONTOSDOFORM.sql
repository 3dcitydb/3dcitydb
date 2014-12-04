CREATE OR REPLACE 
FUNCTION convertPolygonToSdoForm
(polygon IN VARCHAR2)
RETURN VARCHAR2
  IS
    polygon_sdo VARCHAR2(4000);
    polygon_temp VARCHAR2(4000);
  BEGIN
    IF (polygon IS NULL) THEN
      RETURN NULL;
    END IF;

    FOR i IN 1 .. length(polygon) - length(REPLACE(polygon, ' ', '')) + 1 LOOP
      polygon_temp := regexp_substr(polygon, '[^ ]+', 1, i);
      -- When the number is exponential, convert it to decimal form
      IF (INSTR(polygon_temp, 'E')) > 0 THEN        
        EXECUTE IMMEDIATE 'select to_char('||polygon_temp||',''9.999999999999999999999999999999999999999999999999'') from dual' INTO polygon_temp;                        
        polygon_temp := REPLACE(polygon_temp,'.','0.');        
      END IF;
      IF MOD(i,2) = 1 THEN
          polygon_sdo := polygon_sdo || polygon_temp || ' ';
      ELSE
          polygon_sdo := polygon_sdo || polygon_temp || ',';
      END IF;
    END LOOP;
    polygon_sdo := SUBSTR(polygon_sdo, 0, length(polygon_sdo) - 1);
    RETURN polygon_sdo;
  END;
/