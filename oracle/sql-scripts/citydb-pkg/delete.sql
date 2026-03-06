/*****************************************************************
 * CONTENT: PL/SQL Package CITYDB_DELETE
 *
 * Methods for deleting data from the 3DCityDB
 *****************************************************************/

-- Package declaration
CREATE OR REPLACE PACKAGE citydb_delete
AUTHID DEFINER
AS
  PROCEDURE cleanup_schema;
  FUNCTION delete_feature(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_feature(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_property_row(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_property(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_property(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_geometry_data(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_geometry_data(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_implicit_geometry(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_implicit_geometry(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_appearance(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_appearance(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_surface_data(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_surface_data(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_tex_image(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_tex_image(pid NUMBER) RETURN NUMBER;
  FUNCTION delete_address(pid_array NUMBER_TAB) RETURN NUMBER_TAB;
  FUNCTION delete_address(pid NUMBER) RETURN NUMBER;
  FUNCTION terminate_feature(pid_array NUMBER_TAB, metadata JSON DEFAULT '{}', cascade NUMBER DEFAULT 1) RETURN NUMBER_TAB;
  FUNCTION terminate_feature(pid NUMBER, metadata JSON DEFAULT '{}', cascade NUMBER DEFAULT 1) RETURN NUMBER;
END citydb_delete;
/

-- Package body definition
CREATE OR REPLACE PACKAGE BODY citydb_delete
AS

  /******************************************************************
  * truncates all data tables
  ******************************************************************/
  PROCEDURE cleanup_schema
  IS
  BEGIN
    FOR rec IN (
      SELECT constraint_name, table_name
      FROM user_constraints WHERE constraint_type = 'R'
    ) LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE ' || rec.table_name || ' DISABLE CONSTRAINT ' || rec.constraint_name;
    END LOOP;

    FOR rec IN (
      SELECT table_name FROM user_tables
      WHERE table_name NOT IN ('ADE','DATATYPE','DATABASE_SRS','CODELIST','CODELIST_ENTRY','NAMESPACE','OBJECTCLASS')
    ) LOOP
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || rec.table_name;
    END LOOP;

    FOR rec IN (
      SELECT constraint_name, table_name
      FROM user_constraints WHERE constraint_type = 'R'
    ) LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE ' || rec.table_name || ' ENABLE CONSTRAINT ' || rec.constraint_name;
    END LOOP;

    FOR rec IN (
      SELECT sequence_name FROM user_sequences
      WHERE sequence_name <> 'ADE_SEQ'
    ) LOOP
      EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || rec.sequence_name || ' RESTART';
    END LOOP;
  END cleanup_schema;

  /******************************************************************
  * delete from FEATURE table based on an id array
  ******************************************************************/
  FUNCTION delete_feature(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    candidate_ids NUMBER_TAB := NUMBER_TAB();
    feature_property_ids NUMBER_TAB := NUMBER_TAB();
    prop_ids NUMBER_TAB;
    dummy NUMBER_TAB;
    result NUMBER_TAB;
  BEGIN
    SELECT p.id BULK COLLECT INTO prop_ids
    FROM property p WHERE p.feature_id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array));

    IF prop_ids.COUNT > 0 THEN
      dummy := delete_property_row(prop_ids);
    END IF;

    SELECT p.val_feature_id, p.id
    BULK COLLECT INTO candidate_ids, feature_property_ids
    FROM property p WHERE p.val_feature_id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array));

    DELETE FROM feature
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;

    IF feature_property_ids.COUNT > 0 THEN
      dummy := delete_property(feature_property_ids);
    END IF;

    SELECT COLUMN_VALUE BULK COLLECT INTO result
    FROM (
      SELECT COLUMN_VALUE FROM TABLE(deleted_ids)
      UNION
      SELECT COLUMN_VALUE FROM TABLE(candidate_ids)
    );

    RETURN result;
  END delete_feature;

  /******************************************************************
  * delete from FEATURE table based on an id
  ******************************************************************/
  FUNCTION delete_feature(pid NUMBER) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := delete_feature(NUMBER_TAB(pid));
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END delete_feature;

  /******************************************************************
  * delete single row from PROPERTY table based on an id array
  ******************************************************************/
  FUNCTION delete_property_row(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    ids NUMBER_TAB;
    feat_ids NUMBER_TAB;
    rel_types NUMBER_TAB;
    geom_ids NUMBER_TAB;
    ig_ids NUMBER_TAB;
    app_ids NUMBER_TAB;
    addr_ids NUMBER_TAB;
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    feature_ids NUMBER_TAB := NUMBER_TAB();
    geometry_ids NUMBER_TAB := NUMBER_TAB();
    implicit_geometry_ids NUMBER_TAB := NUMBER_TAB();
    appearance_ids NUMBER_TAB := NUMBER_TAB();
    address_ids NUMBER_TAB := NUMBER_TAB();
    temp NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    DELETE FROM property
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id, val_feature_id, val_relation_type, val_geometry_id,
              val_implicitgeom_id, val_appearance_id, val_address_id
    BULK COLLECT INTO ids, feat_ids, rel_types, geom_ids, ig_ids, app_ids, addr_ids;

    FOR i IN 1..ids.COUNT LOOP
      IF feat_ids(i) IS NULL OR rel_types(i) = 1 THEN
        deleted_ids.EXTEND; deleted_ids(deleted_ids.COUNT) := ids(i);
        IF feat_ids(i) IS NOT NULL THEN
          feature_ids.EXTEND; feature_ids(feature_ids.COUNT) := feat_ids(i);
        END IF;
        IF geom_ids(i) IS NOT NULL THEN
          geometry_ids.EXTEND; geometry_ids(geometry_ids.COUNT) := geom_ids(i);
        END IF;
        IF ig_ids(i) IS NOT NULL THEN
          implicit_geometry_ids.EXTEND; implicit_geometry_ids(implicit_geometry_ids.COUNT) := ig_ids(i);
        END IF;
        IF app_ids(i) IS NOT NULL THEN
          appearance_ids.EXTEND; appearance_ids(appearance_ids.COUNT) := app_ids(i);
        END IF;
        IF addr_ids(i) IS NOT NULL THEN
          address_ids.EXTEND; address_ids(address_ids.COUNT) := addr_ids(i);
        END IF;
      END IF;
    END LOOP;

    IF feature_ids.COUNT > 0 THEN
      SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO temp
      FROM TABLE(feature_ids) a
      LEFT JOIN property p ON p.val_feature_id = a.COLUMN_VALUE
      WHERE p.val_feature_id IS NULL OR p.val_relation_type IS NULL OR p.val_relation_type = 0;

      IF temp.COUNT > 0 THEN
        dummy := delete_feature(temp);
      END IF;
    END IF;

    IF geometry_ids.COUNT > 0 THEN
      SELECT DISTINCT COLUMN_VALUE BULK COLLECT INTO temp FROM TABLE(geometry_ids);
      dummy := delete_geometry_data(temp);
    END IF;

    IF implicit_geometry_ids.COUNT > 0 THEN
      SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO temp
      FROM TABLE(implicit_geometry_ids) a
      LEFT JOIN property p ON p.val_implicitgeom_id = a.COLUMN_VALUE
      WHERE p.val_implicitgeom_id IS NULL;

      IF temp.COUNT > 0 THEN
        dummy := delete_implicit_geometry(temp);
      END IF;
    END IF;

    IF appearance_ids.COUNT > 0 THEN
      SELECT DISTINCT COLUMN_VALUE BULK COLLECT INTO temp FROM TABLE(appearance_ids);
      dummy := delete_appearance(temp);
    END IF;

    IF address_ids.COUNT > 0 THEN
      SELECT DISTINCT COLUMN_VALUE BULK COLLECT INTO temp FROM TABLE(address_ids);
      dummy := delete_address(temp);
    END IF;

    RETURN deleted_ids;
  END delete_property_row;

  /******************************************************************
  * delete from PROPERTY table based on an id array
  ******************************************************************/
  FUNCTION delete_property(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    cascade_delete_ids NUMBER_TAB := NUMBER_TAB();
    property_ids NUMBER_TAB := NUMBER_TAB();
    child_ids NUMBER_TAB;
    parent_ids NUMBER_TAB;
    deleted NUMBER_TAB;
    result NUMBER_TAB;
    dummy NUMBER;
  BEGIN
    SELECT c.id, p.id BULK COLLECT INTO child_ids, parent_ids
    FROM property c
    JOIN TABLE(pid_array) a ON c.id = a.COLUMN_VALUE
    JOIN property p ON p.id = c.parent_id
    WHERE p.name = c.name AND p.namespace_id = c.namespace_id;

    IF child_ids.COUNT > 0 THEN
      cascade_delete_ids := child_ids;
      FOR i IN 1..parent_ids.COUNT LOOP
        dummy := delete_property(parent_ids(i));
      END LOOP;
    END IF;

    WITH child_refs (id) AS (
      SELECT p.id FROM property p
      WHERE p.id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
      UNION ALL
      SELECT p.id FROM property p
      JOIN child_refs c ON p.parent_id = c.id
    )
    SELECT id BULK COLLECT INTO property_ids FROM child_refs;

    deleted := delete_property_row(property_ids);

    SELECT COLUMN_VALUE BULK COLLECT INTO result
    FROM (
      SELECT COLUMN_VALUE FROM TABLE(deleted)
      INTERSECT
      SELECT COLUMN_VALUE FROM TABLE(pid_array)
      UNION
      SELECT COLUMN_VALUE FROM TABLE(cascade_delete_ids)
    );

    RETURN result;
  END delete_property;

  /******************************************************************
  * delete from PROPERTY table based on an id
  ******************************************************************/
  FUNCTION delete_property(pid NUMBER) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := delete_property(NUMBER_TAB(pid));
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END delete_property;

  /******************************************************************
  * delete from GEOMETRY_DATA table based on an id array
  ******************************************************************/
  FUNCTION delete_geometry_data(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
  BEGIN
    DELETE FROM geometry_data
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;
    RETURN deleted_ids;
  END delete_geometry_data;

  /******************************************************************
  * delete from GEOMETRY_DATA table based on an id
  ******************************************************************/
  FUNCTION delete_geometry_data(pid NUMBER) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := delete_geometry_data(NUMBER_TAB(pid));
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END delete_geometry_data;

  /******************************************************************
  * delete from IMPLICIT_GEOMETRY table based on an id array
  ******************************************************************/
  FUNCTION delete_implicit_geometry(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    relative_geometry_ids NUMBER_TAB := NUMBER_TAB();
    app_ids NUMBER_TAB;
    distinct_ids NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    SELECT t.id BULK COLLECT INTO app_ids
    FROM appearance t
    WHERE t.implicit_geometry_id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array));

    IF app_ids.COUNT > 0 THEN
      dummy := delete_appearance(app_ids);
    END IF;

    DELETE FROM implicit_geometry
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id, relative_geometry_id BULK COLLECT INTO deleted_ids, relative_geometry_ids;

    IF relative_geometry_ids.COUNT > 0 THEN
      SELECT DISTINCT COLUMN_VALUE BULK COLLECT INTO distinct_ids
      FROM TABLE(relative_geometry_ids) WHERE COLUMN_VALUE IS NOT NULL;

      IF distinct_ids.COUNT > 0 THEN
        dummy := delete_geometry_data(distinct_ids);
      END IF;
    END IF;

    RETURN deleted_ids;
  END delete_implicit_geometry;

  /******************************************************************
  * delete from IMPLICIT_GEOMETRY table based on an id
  ******************************************************************/
  FUNCTION delete_implicit_geometry(pid NUMBER) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := delete_implicit_geometry(NUMBER_TAB(pid));
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END delete_implicit_geometry;

  /******************************************************************
  * delete from APPEARANCE table based on an id array
  ******************************************************************/
  FUNCTION delete_appearance(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    surface_data_ids NUMBER_TAB := NUMBER_TAB();
    orphan_ids NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    DELETE FROM appear_to_surface_data
    WHERE appearance_id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING surface_data_id BULK COLLECT INTO surface_data_ids;

    IF surface_data_ids.COUNT > 0 THEN
      SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO orphan_ids
      FROM TABLE(surface_data_ids) a
      LEFT JOIN appear_to_surface_data atsd ON atsd.surface_data_id = a.COLUMN_VALUE
      WHERE a.COLUMN_VALUE IS NOT NULL AND atsd.surface_data_id IS NULL;

      IF orphan_ids.COUNT > 0 THEN
        dummy := delete_surface_data(orphan_ids);
      END IF;
    END IF;

    DELETE FROM appearance
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;

    RETURN deleted_ids;
  END delete_appearance;

  /******************************************************************
  * delete from APPEARANCE table based on an id
  ******************************************************************/
  FUNCTION delete_appearance(pid NUMBER) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := delete_appearance(NUMBER_TAB(pid));
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END delete_appearance;

  /******************************************************************
  * delete from SURFACE_DATA table based on an id array
  ******************************************************************/
  FUNCTION delete_surface_data(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    tex_image_ids NUMBER_TAB := NUMBER_TAB();
    orphan_ids NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    DELETE FROM surface_data
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id, tex_image_id BULK COLLECT INTO deleted_ids, tex_image_ids;

    IF tex_image_ids.COUNT > 0 THEN
      SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO orphan_ids
      FROM TABLE(tex_image_ids) a
      LEFT JOIN surface_data sd ON sd.tex_image_id = a.COLUMN_VALUE
      WHERE a.COLUMN_VALUE IS NOT NULL AND sd.tex_image_id IS NULL;

      IF orphan_ids.COUNT > 0 THEN
        dummy := delete_tex_image(orphan_ids);
      END IF;
    END IF;

    RETURN deleted_ids;
  END delete_surface_data;

  /******************************************************************
  * delete from SURFACE_DATA table based on an id
  ******************************************************************/
  FUNCTION delete_surface_data(pid NUMBER) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := delete_surface_data(NUMBER_TAB(pid));
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END delete_surface_data;

  /******************************************************************
  * delete from TEX_IMAGE table based on an id array
  ******************************************************************/
  FUNCTION delete_tex_image(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
  BEGIN
    DELETE FROM tex_image
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;
    RETURN deleted_ids;
  END delete_tex_image;

  /******************************************************************
  * delete from TEX_IMAGE table based on an id
  ******************************************************************/
  FUNCTION delete_tex_image(pid NUMBER) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := delete_tex_image(NUMBER_TAB(pid));
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END delete_tex_image;

  /******************************************************************
  * delete from ADDRESS table based on an id array
  ******************************************************************/
  FUNCTION delete_address(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
  BEGIN
    DELETE FROM address
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;
    RETURN deleted_ids;
  END delete_address;

  /******************************************************************
  * delete from ADDRESS table based on an id
  ******************************************************************/
  FUNCTION delete_address(pid NUMBER) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := delete_address(NUMBER_TAB(pid));
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END delete_address;

  /******************************************************************
  * terminate feature based on an id array
  ******************************************************************/
  FUNCTION terminate_feature(pid_array NUMBER_TAB, metadata JSON DEFAULT '{}', cascade NUMBER DEFAULT 1) RETURN NUMBER_TAB
  IS
    terminated_ids NUMBER_TAB := NUMBER_TAB();
    child_feature_ids NUMBER_TAB := NUMBER_TAB();
    temp NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    UPDATE feature f SET
      termination_date = COALESCE(
        TO_TIMESTAMP_TZ(JSON_VALUE(metadata, '$.termination_date'), 'YYYY-MM-DD"T"HH24:MI:SS.FFTZH:TZM'),
        SYSTIMESTAMP),
      last_modification_date = COALESCE(
        TO_TIMESTAMP_TZ(JSON_VALUE(metadata, '$.last_modification_date'), 'YYYY-MM-DD"T"HH24:MI:SS.FFTZH:TZM'),
        SYSTIMESTAMP),
      reason_for_update = COALESCE(JSON_VALUE(metadata, '$.reason_for_update'), f.reason_for_update),
      updating_person = COALESCE(JSON_VALUE(metadata, '$.updating_person'), USER),
      lineage = COALESCE(JSON_VALUE(metadata, '$.lineage'), f.lineage)
    WHERE f.id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING f.id BULK COLLECT INTO terminated_ids;

    IF cascade = 1 AND terminated_ids.COUNT > 0 THEN
      SELECT p.val_feature_id BULK COLLECT INTO child_feature_ids
      FROM property p
      WHERE p.feature_id IN (SELECT COLUMN_VALUE FROM TABLE(terminated_ids))
        AND p.val_relation_type = 1
        AND p.val_feature_id IS NOT NULL;

      IF child_feature_ids.COUNT > 0 THEN
        SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO temp
        FROM TABLE(child_feature_ids) a
        WHERE NOT EXISTS (
          SELECT 1 FROM property p
          INNER JOIN feature f ON f.id = p.feature_id
          WHERE p.val_feature_id = a.COLUMN_VALUE
            AND f.termination_date IS NULL
            AND p.val_relation_type = 1
        );

        IF temp.COUNT > 0 THEN
          dummy := terminate_feature(temp, metadata, cascade);
        END IF;
      END IF;
    END IF;

    RETURN terminated_ids;
  END terminate_feature;

  /******************************************************************
  * terminate a feature based on an id
  ******************************************************************/
  FUNCTION terminate_feature(pid NUMBER, metadata JSON DEFAULT '{}', cascade NUMBER DEFAULT 1) RETURN NUMBER
  IS
    result NUMBER_TAB;
  BEGIN
    result := terminate_feature(NUMBER_TAB(pid), metadata, cascade);
    IF result.COUNT > 0 THEN RETURN result(1); ELSE RETURN NULL; END IF;
  END terminate_feature;

END citydb_delete;
/
