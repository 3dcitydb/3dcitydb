-- Package declaration
CREATE OR REPLACE PACKAGE citydb_delete
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
  FUNCTION terminate_feature(pid_array NUMBER_TAB, p_metadata VARCHAR2 DEFAULT '{}', p_cascade NUMBER DEFAULT 1) RETURN NUMBER_TAB;
  FUNCTION terminate_feature(pid NUMBER, p_metadata VARCHAR2 DEFAULT '{}', p_cascade NUMBER DEFAULT 1) RETURN NUMBER;
END citydb_delete;
/

-- Package body
CREATE OR REPLACE PACKAGE BODY citydb_delete
AS

  /*****************************************************************
  * cleanup_schema: truncates all data tables and resets sequences
  *****************************************************************/
  PROCEDURE cleanup_schema
  IS
  BEGIN
    -- Disable FK constraints
    FOR rec IN (SELECT constraint_name, table_name FROM user_constraints WHERE constraint_type = 'R') LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE ' || rec.table_name || ' DISABLE CONSTRAINT ' || rec.constraint_name;
    END LOOP;

    -- Truncate data tables (skip metadata tables)
    FOR rec IN (
      SELECT table_name FROM user_tables
      WHERE table_name NOT IN ('ADE','DATATYPE','DATABASE_SRS','CODELIST','CODELIST_ENTRY','NAMESPACE','OBJECTCLASS')
    ) LOOP
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || rec.table_name;
    END LOOP;

    -- Re-enable FK constraints
    FOR rec IN (SELECT constraint_name, table_name FROM user_constraints WHERE constraint_type = 'R') LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE ' || rec.table_name || ' ENABLE CONSTRAINT ' || rec.constraint_name;
    END LOOP;

    -- Reset sequences
    FOR rec IN (SELECT sequence_name FROM user_sequences WHERE sequence_name <> 'ADE_SEQ') LOOP
      EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || rec.sequence_name || ' RESTART';
    END LOOP;
  END cleanup_schema;

  /*****************************************************************
  * delete_address
  *****************************************************************/
  FUNCTION delete_address(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
  BEGIN
    DELETE FROM address
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;
    RETURN deleted_ids;
  END delete_address;

  FUNCTION delete_address(pid NUMBER) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := delete_address(NUMBER_TAB(pid));
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END delete_address;

  /*****************************************************************
  * delete_tex_image
  *****************************************************************/
  FUNCTION delete_tex_image(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
  BEGIN
    DELETE FROM tex_image
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;
    RETURN deleted_ids;
  END delete_tex_image;

  FUNCTION delete_tex_image(pid NUMBER) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := delete_tex_image(NUMBER_TAB(pid));
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END delete_tex_image;

  /*****************************************************************
  * delete_surface_data
  *****************************************************************/
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

    -- Delete orphan tex_images
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

  FUNCTION delete_surface_data(pid NUMBER) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := delete_surface_data(NUMBER_TAB(pid));
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END delete_surface_data;

  /*****************************************************************
  * delete_appearance
  *****************************************************************/
  FUNCTION delete_appearance(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    surface_data_ids NUMBER_TAB := NUMBER_TAB();
    orphan_ids NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    -- Delete mappings and collect surface_data_ids
    DELETE FROM appear_to_surface_data
    WHERE appearance_id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING surface_data_id BULK COLLECT INTO surface_data_ids;

    -- Delete orphan surface_data (not referenced by other appearances)
    IF surface_data_ids.COUNT > 0 THEN
      SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO orphan_ids
      FROM TABLE(surface_data_ids) a
      LEFT JOIN appear_to_surface_data atsd ON atsd.surface_data_id = a.COLUMN_VALUE
      WHERE a.COLUMN_VALUE IS NOT NULL AND atsd.surface_data_id IS NULL;

      IF orphan_ids.COUNT > 0 THEN
        dummy := delete_surface_data(orphan_ids);
      END IF;
    END IF;

    -- Delete appearances
    DELETE FROM appearance
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;

    RETURN deleted_ids;
  END delete_appearance;

  FUNCTION delete_appearance(pid NUMBER) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := delete_appearance(NUMBER_TAB(pid));
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END delete_appearance;

  /*****************************************************************
  * delete_geometry_data
  *****************************************************************/
  FUNCTION delete_geometry_data(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
  BEGIN
    DELETE FROM geometry_data
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;
    RETURN deleted_ids;
  END delete_geometry_data;

  FUNCTION delete_geometry_data(pid NUMBER) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := delete_geometry_data(NUMBER_TAB(pid));
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END delete_geometry_data;

  /*****************************************************************
  * delete_implicit_geometry
  *****************************************************************/
  FUNCTION delete_implicit_geometry(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    rel_geom_ids NUMBER_TAB := NUMBER_TAB();
    app_ids NUMBER_TAB;
    distinct_ids NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    -- Delete related appearances
    SELECT t.id BULK COLLECT INTO app_ids
    FROM appearance t
    WHERE t.implicit_geometry_id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array));

    IF app_ids.COUNT > 0 THEN
      dummy := delete_appearance(app_ids);
    END IF;

    -- Delete implicit geometries
    DELETE FROM implicit_geometry
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id, relative_geometry_id BULK COLLECT INTO deleted_ids, rel_geom_ids;

    -- Delete orphan relative geometries
    IF rel_geom_ids.COUNT > 0 THEN
      SELECT DISTINCT COLUMN_VALUE BULK COLLECT INTO distinct_ids
      FROM TABLE(rel_geom_ids) WHERE COLUMN_VALUE IS NOT NULL;

      IF distinct_ids.COUNT > 0 THEN
        dummy := delete_geometry_data(distinct_ids);
      END IF;
    END IF;

    RETURN deleted_ids;
  END delete_implicit_geometry;

  FUNCTION delete_implicit_geometry(pid NUMBER) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := delete_implicit_geometry(NUMBER_TAB(pid));
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END delete_implicit_geometry;

  /*****************************************************************
  * delete_property_row: low-level delete with cascade
  *****************************************************************/
  FUNCTION delete_property_row(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    v_ids NUMBER_TAB;
    v_feat_ids NUMBER_TAB;
    v_rel_types NUMBER_TAB;
    v_geom_ids NUMBER_TAB;
    v_ig_ids NUMBER_TAB;
    v_app_ids NUMBER_TAB;
    v_addr_ids NUMBER_TAB;
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    feature_ids NUMBER_TAB := NUMBER_TAB();
    geometry_ids NUMBER_TAB := NUMBER_TAB();
    implicit_geometry_ids NUMBER_TAB := NUMBER_TAB();
    appearance_ids NUMBER_TAB := NUMBER_TAB();
    address_ids NUMBER_TAB := NUMBER_TAB();
    v_temp NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    -- Delete properties and capture returned values
    DELETE FROM property
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id, val_feature_id, val_relation_type, val_geometry_id,
              val_implicitgeom_id, val_appearance_id, val_address_id
    BULK COLLECT INTO v_ids, v_feat_ids, v_rel_types, v_geom_ids, v_ig_ids, v_app_ids, v_addr_ids;

    -- Filter: only rows where val_feature_id IS NULL OR val_relation_type = 1
    FOR i IN 1..v_ids.COUNT LOOP
      IF v_feat_ids(i) IS NULL OR v_rel_types(i) = 1 THEN
        deleted_ids.EXTEND; deleted_ids(deleted_ids.COUNT) := v_ids(i);
        IF v_feat_ids(i) IS NOT NULL THEN
          feature_ids.EXTEND; feature_ids(feature_ids.COUNT) := v_feat_ids(i);
        END IF;
        IF v_geom_ids(i) IS NOT NULL THEN
          geometry_ids.EXTEND; geometry_ids(geometry_ids.COUNT) := v_geom_ids(i);
        END IF;
        IF v_ig_ids(i) IS NOT NULL THEN
          implicit_geometry_ids.EXTEND; implicit_geometry_ids(implicit_geometry_ids.COUNT) := v_ig_ids(i);
        END IF;
        IF v_app_ids(i) IS NOT NULL THEN
          appearance_ids.EXTEND; appearance_ids(appearance_ids.COUNT) := v_app_ids(i);
        END IF;
        IF v_addr_ids(i) IS NOT NULL THEN
          address_ids.EXTEND; address_ids(address_ids.COUNT) := v_addr_ids(i);
        END IF;
      END IF;
    END LOOP;

    -- Cascade delete composed features (not referenced by other compositions)
    IF feature_ids.COUNT > 0 THEN
      SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO v_temp
      FROM TABLE(feature_ids) a
      LEFT JOIN property p ON p.val_feature_id = a.COLUMN_VALUE
      WHERE p.val_feature_id IS NULL OR p.val_relation_type IS NULL OR p.val_relation_type = 0;

      IF v_temp.COUNT > 0 THEN
        dummy := delete_feature(v_temp);
      END IF;
    END IF;

    -- Cascade delete geometries
    IF geometry_ids.COUNT > 0 THEN
      SELECT DISTINCT COLUMN_VALUE BULK COLLECT INTO v_temp FROM TABLE(geometry_ids);
      dummy := delete_geometry_data(v_temp);
    END IF;

    -- Cascade delete implicit geometries (not referenced elsewhere)
    IF implicit_geometry_ids.COUNT > 0 THEN
      SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO v_temp
      FROM TABLE(implicit_geometry_ids) a
      LEFT JOIN property p ON p.val_implicitgeom_id = a.COLUMN_VALUE
      WHERE p.val_implicitgeom_id IS NULL;

      IF v_temp.COUNT > 0 THEN
        dummy := delete_implicit_geometry(v_temp);
      END IF;
    END IF;

    -- Cascade delete appearances
    IF appearance_ids.COUNT > 0 THEN
      SELECT DISTINCT COLUMN_VALUE BULK COLLECT INTO v_temp FROM TABLE(appearance_ids);
      dummy := delete_appearance(v_temp);
    END IF;

    -- Cascade delete addresses
    IF address_ids.COUNT > 0 THEN
      SELECT DISTINCT COLUMN_VALUE BULK COLLECT INTO v_temp FROM TABLE(address_ids);
      dummy := delete_address(v_temp);
    END IF;

    RETURN deleted_ids;
  END delete_property_row;

  /*****************************************************************
  * delete_feature
  *****************************************************************/
  FUNCTION delete_feature(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    deleted_ids NUMBER_TAB := NUMBER_TAB();
    candidate_ids NUMBER_TAB := NUMBER_TAB();
    feature_property_ids NUMBER_TAB := NUMBER_TAB();
    prop_ids NUMBER_TAB;
    dummy NUMBER_TAB;
    v_result NUMBER_TAB;
  BEGIN
    -- 1. Delete properties OF the features
    SELECT p.id BULK COLLECT INTO prop_ids
    FROM property p WHERE p.feature_id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array));

    IF prop_ids.COUNT > 0 THEN
      dummy := delete_property_row(prop_ids);
    END IF;

    -- 2. Find properties pointing TO these features
    SELECT p.val_feature_id, p.id
    BULK COLLECT INTO candidate_ids, feature_property_ids
    FROM property p WHERE p.val_feature_id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array));

    -- 3. Delete features
    DELETE FROM feature
    WHERE id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING id BULK COLLECT INTO deleted_ids;

    -- 4. Cascade delete referencing properties
    IF feature_property_ids.COUNT > 0 THEN
      dummy := delete_property(feature_property_ids);
    END IF;

    -- 5. Combine results
    SELECT COLUMN_VALUE BULK COLLECT INTO v_result
    FROM (
      SELECT COLUMN_VALUE FROM TABLE(deleted_ids)
      UNION
      SELECT COLUMN_VALUE FROM TABLE(candidate_ids)
    );

    RETURN v_result;
  END delete_feature;

  FUNCTION delete_feature(pid NUMBER) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := delete_feature(NUMBER_TAB(pid));
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END delete_feature;

  /*****************************************************************
  * delete_property: high-level delete with parent/child cascade
  *****************************************************************/
  FUNCTION delete_property(pid_array NUMBER_TAB) RETURN NUMBER_TAB
  IS
    cascade_delete_ids NUMBER_TAB := NUMBER_TAB();
    property_ids NUMBER_TAB := NUMBER_TAB();
    v_child_ids NUMBER_TAB;
    v_parent_ids NUMBER_TAB;
    v_deleted NUMBER_TAB;
    v_result NUMBER_TAB;
    v_dummy NUMBER;
  BEGIN
    -- Delete parent properties with same name/namespace
    SELECT c.id, p.id BULK COLLECT INTO v_child_ids, v_parent_ids
    FROM property c
    JOIN TABLE(pid_array) a ON c.id = a.COLUMN_VALUE
    JOIN property p ON p.id = c.parent_id
    WHERE p.name = c.name AND p.namespace_id = c.namespace_id;

    IF v_child_ids.COUNT > 0 THEN
      cascade_delete_ids := v_child_ids;
      FOR i IN 1..v_parent_ids.COUNT LOOP
        v_dummy := delete_property(v_parent_ids(i));
      END LOOP;
    END IF;

    -- Recursively collect all child properties
    WITH child_refs (id) AS (
      SELECT p.id FROM property p
      WHERE p.id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
      UNION ALL
      SELECT p.id FROM property p
      JOIN child_refs c ON p.parent_id = c.id
    )
    SELECT id BULK COLLECT INTO property_ids FROM child_refs;

    -- Delete all collected properties and combine results
    v_deleted := delete_property_row(property_ids);

    SELECT COLUMN_VALUE BULK COLLECT INTO v_result
    FROM (
      SELECT COLUMN_VALUE FROM TABLE(v_deleted)
      INTERSECT
      SELECT COLUMN_VALUE FROM TABLE(pid_array)
      UNION
      SELECT COLUMN_VALUE FROM TABLE(cascade_delete_ids)
    );

    RETURN v_result;
  END delete_property;

  FUNCTION delete_property(pid NUMBER) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := delete_property(NUMBER_TAB(pid));
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END delete_property;

  /*****************************************************************
  * terminate_feature: soft-delete by setting termination_date
  *****************************************************************/
  FUNCTION terminate_feature(pid_array NUMBER_TAB, p_metadata VARCHAR2 DEFAULT '{}', p_cascade NUMBER DEFAULT 1) RETURN NUMBER_TAB
  IS
    terminated_ids NUMBER_TAB := NUMBER_TAB();
    child_feature_ids NUMBER_TAB := NUMBER_TAB();
    v_temp NUMBER_TAB;
    dummy NUMBER_TAB;
  BEGIN
    UPDATE feature f SET
      termination_date = COALESCE(
        TO_TIMESTAMP_TZ(JSON_VALUE(p_metadata, '$.termination_date'), 'YYYY-MM-DD"T"HH24:MI:SS.FFTZH:TZM'),
        SYSTIMESTAMP),
      last_modification_date = COALESCE(
        TO_TIMESTAMP_TZ(JSON_VALUE(p_metadata, '$.last_modification_date'), 'YYYY-MM-DD"T"HH24:MI:SS.FFTZH:TZM'),
        SYSTIMESTAMP),
      reason_for_update = COALESCE(JSON_VALUE(p_metadata, '$.reason_for_update'), f.reason_for_update),
      updating_person = COALESCE(JSON_VALUE(p_metadata, '$.updating_person'), USER),
      lineage = COALESCE(JSON_VALUE(p_metadata, '$.lineage'), f.lineage)
    WHERE f.id IN (SELECT COLUMN_VALUE FROM TABLE(pid_array))
    RETURNING f.id BULK COLLECT INTO terminated_ids;

    IF p_cascade = 1 AND terminated_ids.COUNT > 0 THEN
      -- Find child features (composition, val_relation_type = 1)
      SELECT p.val_feature_id BULK COLLECT INTO child_feature_ids
      FROM property p
      WHERE p.feature_id IN (SELECT COLUMN_VALUE FROM TABLE(terminated_ids))
        AND p.val_relation_type = 1
        AND p.val_feature_id IS NOT NULL;

      IF child_feature_ids.COUNT > 0 THEN
        -- Only terminate children not still composed in non-terminated features
        SELECT DISTINCT a.COLUMN_VALUE BULK COLLECT INTO v_temp
        FROM TABLE(child_feature_ids) a
        WHERE NOT EXISTS (
          SELECT 1 FROM property p
          INNER JOIN feature f ON f.id = p.feature_id
          WHERE p.val_feature_id = a.COLUMN_VALUE
            AND f.termination_date IS NULL
            AND p.val_relation_type = 1
        );

        IF v_temp.COUNT > 0 THEN
          dummy := terminate_feature(v_temp, p_metadata, p_cascade);
        END IF;
      END IF;
    END IF;

    RETURN terminated_ids;
  END terminate_feature;

  FUNCTION terminate_feature(pid NUMBER, p_metadata VARCHAR2 DEFAULT '{}', p_cascade NUMBER DEFAULT 1) RETURN NUMBER
  IS
    v_result NUMBER_TAB;
  BEGIN
    v_result := terminate_feature(NUMBER_TAB(pid), p_metadata, p_cascade);
    IF v_result.COUNT > 0 THEN RETURN v_result(1); ELSE RETURN NULL; END IF;
  END terminate_feature;

END citydb_delete;
/
