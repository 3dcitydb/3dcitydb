CREATE OR REPLACE 
FUNCTION convertVarcharToSDOGeom
(polygon IN VARCHAR2)
RETURN SDO_GEOMETRY
  IS
    polygon_converted CLOB;
    polygon_temp VARCHAR2(4000);
    counter NUMBER;
    texture_coordinates SDO_GEOMETRY := NULL;
  BEGIN
    IF (polygon IS NULL) THEN
      RETURN NULL;
    END IF;
    
    polygon_converted := TO_CLOB('POLYGON(');    
    -- dbms_output.put_line('polygon: '||polygon);
    -- If semicolon exists, it means that more than one polygon exists
    IF (INSTR(polygon, ';')) > 0 THEN
      counter := length(polygon) - length(REPLACE(polygon, ';', '')) + 1;      
      FOR i IN 1 .. counter LOOP
        polygon_temp := regexp_substr(polygon, '[^;]+', 1, i);
        IF (i = counter) THEN 
          polygon_converted := polygon_converted || TO_CLOB('(') ||
                             TO_CLOB(convertPolygonToSdoForm(polygon_temp)) || TO_CLOB(')');
        ELSE
          polygon_converted := polygon_converted || TO_CLOB('(') ||
                             TO_CLOB(convertPolygonToSdoForm(polygon_temp)) || TO_CLOB('),');
        END IF;                
      END LOOP;      
    ELSE
      polygon_converted := polygon_converted || TO_CLOB('(');
      polygon_converted := polygon_converted ||
                           TO_CLOB(convertPolygonToSdoForm(polygon));
      polygon_converted := polygon_converted || TO_CLOB(')');
    END IF;
    polygon_converted := polygon_converted || TO_CLOB(')');   
    select SDO_GEOMETRY(polygon_converted) into texture_coordinates from dual;
    RETURN texture_coordinates;

--    EXCEPTION
--    WHEN others THEN
--      dbms_output.put_line('error: '||polygon);
--      dbms_output.put_line('polygon: '||polygon);
--      dbms_output.put_line('polygon_converted: '||polygon_converted);
--      RETURN NULL;
  END;
/