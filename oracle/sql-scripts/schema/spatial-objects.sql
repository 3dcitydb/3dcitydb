DECLARE
  v_diminfo_2d MDSYS.SDO_DIM_ARRAY := MDSYS.SDO_DIM_ARRAY(
    MDSYS.SDO_DIM_ELEMENT('X', 0.0, 10000000.0, 0.001),
    MDSYS.SDO_DIM_ELEMENT('Y', 0.0, 10000000.0, 0.001)
  );
  v_diminfo_3d MDSYS.SDO_DIM_ARRAY := MDSYS.SDO_DIM_ARRAY(
    MDSYS.SDO_DIM_ELEMENT('X', 0.0, 10000000.0, 0.001),
    MDSYS.SDO_DIM_ELEMENT('Y', 0.0, 10000000.0, 0.001),
    MDSYS.SDO_DIM_ELEMENT('Z', -1000.0, 10000.0, 0.001)
  );
  v_diminfo MDSYS.SDO_DIM_ARRAY;
  v_target_srid INTEGER;
BEGIN
  FOR rec IN (
    SELECT table_name,
      column_name
    FROM user_tab_columns
    WHERE data_type = 'SDO_GEOMETRY'
  )
  LOOP
    IF rec.table_name = 'GEOMETRY_DATA' AND rec.column_name = 'IMPLICIT_GEOMETRY' THEN
      v_diminfo := v_diminfo_3d;
      v_target_srid := NULL;
    ELSIF rec.table_name = 'SURFACE_DATA' AND rec.column_name = 'GT_REFERENCE_POINT' THEN
      v_diminfo := v_diminfo_2d;
      v_target_srid := :V_SRID;
    ELSE
      v_diminfo := v_diminfo_3d;
      v_target_srid := :V_SRID;
    END IF;
    
    INSERT INTO user_sdo_geom_metadata (table_name, column_name, diminfo, srid)
    VALUES (rec.table_name, rec.column_name, v_diminfo, v_target_srid);
  END LOOP;
END;
/

CREATE INDEX FEATURE_ENVELOPE_SPX ON FEATURE ( ENVELOPE ) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

CREATE INDEX GEOMETRY_DATA_SPX ON GEOMETRY_DATA ( GEOMETRY ) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

DELETE FROM database_srs;

INSERT INTO database_srs (srid, srs_name) VALUES (:V_SRID , '&SRS_NAME');

COMMIT;