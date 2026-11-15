SET client_min_messages TO NOTICE;

\echo 'Upgrading 3DCityDB schemas to version 5.2.0 ...'
\echo

DO $$
DECLARE
  schema_name text;
  schema_srid integer;
  seq_name text;
  column_type text;
  upgrade_codelist_id bigint;
BEGIN
  FOR schema_name IN
    SELECT nspname FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'database_srs' AND c.relkind = 'r'
  LOOP
    EXECUTE format('set search_path to %I, citydb_pkg, public', schema_name);
    RAISE NOTICE 'Upgrading schema "%" ...', schema_name;

    RAISE NOTICE 'Creating extended statistics on "property(name, namespace_id)" ...';
    CREATE STATISTICS IF NOT EXISTS property_name_namespace_stx (dependencies, mcv)
      ON name, namespace_id FROM property;
    ANALYZE property (name, namespace_id);

    RAISE NOTICE 'Setting "objectclass.is_toplevel" to true for GenericThematicSurface ...';
    UPDATE objectclass SET is_toplevel = 1 WHERE id = 203;

    RAISE NOTICE 'Updating table "objectclass" ...';
    UPDATE objectclass
    SET SCHEMA = '{"identifier":"core:AbstractObject","description":"AbstractObject is the abstract superclass of all feature and object types.","table":"feature","properties":[{"name":"id","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the internal database ID of the object.","value":{"column":"id","type":"integer"}},{"name":"objectId","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the identifier of the object that is unique within the database. Using a globally unique identifier is recommended.","value":{"column":"objectid","type":"string"}},{"name":"identifier","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies an optional identifier of the object that is globally unique.","value":{"column":"identifier","type":"string"}},{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the code space of the identifier, typically a reference to the maintaining authority.","value":{"column":"identifier_codespace","type":"string"},"parent":2},{"name":"envelope","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the minimum bounding box that encloses the entire object.","value":{"column":"envelope","type":"core:Envelope"}},{"name":"objectClassId","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the internal object class ID of the object.","value":{"column":"objectclass_id","type":"integer"}},{"name":"lastModificationDate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Indicates the date and time at which the object was last updated in the database.","value":{"column":"last_modification_date","type":"timestamp"}},{"name":"updatingPerson","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the person who last updated the object in the database.","value":{"column":"updating_person","type":"string"}},{"name":"reasonForUpdate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the reason for the last update of the object in the database.","value":{"column":"reason_for_update","type":"string"}},{"name":"lineage","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the lineage information of the object.","value":{"column":"lineage","type":"string"}},{"name":"description","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies a text description of the object.","type":"core:StringOrRef"},{"name":"descriptionReference","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies a reference to a remote text description of the object.","type":"core:Reference"},{"name":"name","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies a label or identifier of the object, commonly a descriptive name.","type":"core:Code"}]}'
    WHERE ID = 2;

    -- the following steps catch up on changes of earlier releases that were not
    -- covered by an upgrade script; each step only acts if the old state is present

    -- fix of version 5.1.1
    RAISE NOTICE 'Fixing description of StandardFileTimeseries ...';
    UPDATE objectclass
    SET schema = jsonb_set(schema, '{description}', to_jsonb(replace(schema->>'description', '&amp;', '&')))
    WHERE id = 104 AND schema->>'description' LIKE '%&amp;%';

    -- fix of version 5.1.1: spelling of codelist entries
    RAISE NOTICE 'Fixing spelling of building codelist entries ...';
    UPDATE codelist_entry e
    SET definition = 'canteen'
    FROM codelist c
    WHERE c.id = e.codelist_id
      AND c.url IN ('http://www.sig3d.org/codelists/standard/building/2.0/_AbstractBuilding_function.xml',
                    'http://www.sig3d.org/codelists/standard/building/2.0/_AbstractBuilding_usage.xml')
      AND e.code = '1250' AND e.definition = 'cantine';

    UPDATE codelist_entry e
    SET definition = 'maintenance and waste management'
    FROM codelist c
    WHERE c.id = e.codelist_id
      AND c.url = 'http://www.sig3d.org/codelists/standard/building/2.0/_AbstractBuilding_class.xml'
      AND e.definition = 'maintainence and waste management';

    -- fix of the building class codelist: codes 1110 to 1130 were shifted by one
    -- and "communicating" was missing; only applied if still in its shipped state
    RAISE NOTICE 'Fixing codes of building class codelist ...';
    FOR upgrade_codelist_id IN
      SELECT c.id FROM codelist c
      WHERE c.url = 'http://www.sig3d.org/codelists/standard/building/2.0/_AbstractBuilding_class.xml'
        AND EXISTS (SELECT 1 FROM codelist_entry e WHERE e.codelist_id = c.id
                    AND e.code = '1120' AND e.definition = 'maintenance and waste management')
        AND EXISTS (SELECT 1 FROM codelist_entry e WHERE e.codelist_id = c.id
                    AND e.code = '1130' AND e.definition = 'healthcare')
        AND NOT EXISTS (SELECT 1 FROM codelist_entry e WHERE e.codelist_id = c.id
                        AND e.code = '1110')
    LOOP
      UPDATE codelist_entry e SET code = '1110'
      WHERE e.codelist_id = upgrade_codelist_id AND e.code = '1120';
      UPDATE codelist_entry e SET code = '1120'
      WHERE e.codelist_id = upgrade_codelist_id AND e.code = '1130';
      INSERT INTO codelist_entry (codelist_id, code, definition)
      VALUES (upgrade_codelist_id, '1130', 'communicating');
    END LOOP;

    -- change of version 5.1.1
    RAISE NOTICE 'Renaming primary keys of "codelist" and "codelist_entry" ...';
    EXECUTE format('ALTER INDEX IF EXISTS %I.codelist_pkey RENAME TO codelist_pk', schema_name);
    EXECUTE format('ALTER INDEX IF EXISTS %I.codelist_entry_pkey RENAME TO codelist_entry_pk', schema_name);

    -- change of version 5.1.2
    RAISE NOTICE 'Setting minimum value of sequences to 1 ...';
    FOR seq_name IN
      SELECT sequencename FROM pg_catalog.pg_sequences
      WHERE schemaname = schema_name AND min_value = 0
    LOOP
      EXECUTE format('ALTER SEQUENCE %I.%I MINVALUE 1', schema_name, seq_name);
    END LOOP;

    -- changes of version 5.1.1 to the changelog table
    IF EXISTS (
      SELECT 1 FROM pg_catalog.pg_class c
      JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname = schema_name AND c.relname = 'feature_changelog' AND c.relkind = 'r'
    ) THEN
      RAISE NOTICE 'Updating table "feature_changelog" ...';
      EXECUTE format('SELECT srid FROM %I.database_srs', schema_name) INTO schema_srid;

      SELECT format_type(a.atttypid, a.atttypmod) INTO column_type
      FROM pg_catalog.pg_attribute a
      WHERE a.attrelid = format('%I.feature_changelog', schema_name)::regclass
        AND a.attname = 'envelope';

      IF column_type IS DISTINCT FROM format('geometry(GeometryZ,%s)', schema_srid) THEN
        EXECUTE format(
          'ALTER TABLE %I.feature_changelog ALTER COLUMN envelope TYPE geometry(GEOMETRYZ, %s) '
          'USING CASE WHEN ST_SRID(envelope) = 0 THEN ST_SetSRID(envelope, %s) ELSE envelope END',
          schema_name, schema_srid, schema_srid);
      END IF;

      IF EXISTS (
        SELECT 1 FROM pg_catalog.pg_constraint
        WHERE conrelid = format('%I.feature_changelog', schema_name)::regclass
          AND conname = 'feature_changelog_fk1'
      ) THEN
        EXECUTE format('ALTER TABLE %I.feature_changelog DROP CONSTRAINT feature_changelog_fk1', schema_name);
        EXECUTE format(
          'ALTER TABLE %1$I.feature_changelog ADD CONSTRAINT feature_changelog_feature_fk '
          'FOREIGN KEY (feature_id) REFERENCES %1$I.feature (id) ON DELETE SET NULL',
          schema_name);
      END IF;

      EXECUTE format('ALTER INDEX %I.feature_changelog_pk RESET (fillfactor)', schema_name);
      EXECUTE format('ALTER INDEX IF EXISTS %I.feature_changelog_fkx1 RENAME TO feature_changelog_feature_fkx', schema_name);
      EXECUTE format('ALTER INDEX IF EXISTS %I.feature_changelog_fkx2 RENAME TO feature_changelog_objectclass_inx', schema_name);
      EXECUTE format('ALTER INDEX IF EXISTS %I.feature_changelog_inx1 RENAME TO feature_changelog_objectid_inx', schema_name);
      EXECUTE format('ALTER INDEX IF EXISTS %I.feature_changelog_inx2 RENAME TO feature_changelog_identifier_inx', schema_name);
      EXECUTE format('ALTER INDEX IF EXISTS %I.feature_changelog_inx3 RENAME TO feature_changelog_transaction_date_inx', schema_name);
      EXECUTE format('ALTER INDEX IF EXISTS %I.feature_changelog_spx RENAME TO feature_changelog_envelope_spx', schema_name);
      EXECUTE format('ALTER INDEX %I.feature_changelog_transaction_date_inx SET (fillfactor = 100)', schema_name);
    END IF;
  END LOOP;
END
$$;

-- re-create the changelog function and triggers; the statements below are
-- generated and executed once for every schema with a "feature_changelog"
-- table (%1$I = schema name)
SELECT format($sql$
SET search_path TO %1$I, citydb_pkg, public;

DO $$
BEGIN
  RAISE NOTICE E'Re-creating changelog triggers on "feature" table ...\n';
END
$$;

DROP TRIGGER IF EXISTS feature_changelog_trigger ON %1$I.feature;

CREATE OR REPLACE FUNCTION %1$I.log_feature_changes() RETURNS TRIGGER AS
$body$
DECLARE
  v_feature_id bigint;
  v_changelog_feature_id bigint;
  v_is_toplevel integer;
  v_objectclass_id integer;
  v_objectid text;
  v_identifier text;
  v_identifier_codespace text;
  v_envelope geometry;
  v_reason_for_update text;
  v_transaction_type text;
BEGIN
  v_transaction_type := TG_OP;

  IF v_transaction_type = 'UPDATE' AND OLD.last_modification_date IS NOT DISTINCT FROM NEW.last_modification_date THEN
    RETURN NULL;
  END IF;

  IF v_transaction_type = 'DELETE' THEN
    v_feature_id := OLD.id;
    v_changelog_feature_id := NULL;
    v_objectclass_id := OLD.objectclass_id;
    v_objectid := OLD.objectid;
    v_identifier := OLD.identifier;
    v_identifier_codespace := OLD.identifier_codespace;
    v_envelope := OLD.envelope;
    v_reason_for_update := NULL;
  ELSE
    v_feature_id := NEW.id;
    v_changelog_feature_id := v_feature_id;
    v_objectclass_id := NEW.objectclass_id;
    v_objectid := NEW.objectid;
    v_identifier := NEW.identifier;
    v_identifier_codespace := NEW.identifier_codespace;
    v_envelope := NEW.envelope;
    v_reason_for_update := NEW.reason_for_update;

    IF NEW.termination_date IS NOT NULL THEN
      v_transaction_type := 'TERMINATE';
    END IF;
  END IF;

  SELECT is_toplevel
  INTO v_is_toplevel
  FROM %1$I.objectclass o
  WHERE id = v_objectclass_id;

  IF v_is_toplevel = 1
     AND (v_objectclass_id <> 203 OR NOT EXISTS (
       SELECT 1
       FROM %1$I.property p
       WHERE p.val_feature_id = v_feature_id
         AND p.val_relation_type = 1
     )) THEN
    INSERT INTO %1$I.feature_changelog (
      feature_id, objectclass_id, objectid, identifier, identifier_codespace,
      envelope, transaction_type, transaction_date, db_user, reason_for_update
    ) VALUES (
      v_changelog_feature_id, v_objectclass_id, v_objectid, v_identifier, v_identifier_codespace,
      v_envelope, v_transaction_type, now(), user, v_reason_for_update
    );
  END IF;

  IF v_transaction_type = 'DELETE' THEN
    RETURN OLD;
  END IF;

  RETURN NULL;
END;
$body$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER feature_changelog_delete_trigger
  BEFORE DELETE ON %1$I.feature
  FOR EACH ROW EXECUTE PROCEDURE %1$I.log_feature_changes();

CREATE OR REPLACE TRIGGER feature_changelog_insert_update_trigger
  AFTER INSERT OR UPDATE ON %1$I.feature
  FOR EACH ROW EXECUTE PROCEDURE %1$I.log_feature_changes();

$sql$, nspname)
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname = 'feature_changelog' AND c.relkind = 'r'
\gexec

DO $$
DECLARE
  schema_name text;
  updated bigint;
  total bigint;
BEGIN
  FOR schema_name IN
    SELECT nspname FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'database_srs' AND c.relkind = 'r'
  LOOP
    EXECUTE format('set search_path to %I, citydb_pkg, public', schema_name);
    RAISE NOTICE 'Terminating active subfeatures of terminated features in schema "%" ...', schema_name;

    total := 0;
    LOOP
      WITH candidates AS (
        SELECT
          c.id,
          max(t.termination_date) AS termination_date
        FROM
          feature t
        JOIN
          property p
          ON p.feature_id = t.id AND p.val_relation_type = 1
        JOIN
          feature c
          ON c.id = p.val_feature_id
        WHERE
          t.termination_date IS NOT NULL
          AND c.termination_date IS NULL
          AND NOT EXISTS (
            SELECT
              1
            FROM
              property ap
            JOIN
              feature a
              ON a.id = ap.feature_id
            WHERE
              ap.val_feature_id = c.id
              AND ap.val_relation_type = 1
              AND a.termination_date IS NULL
          )
        GROUP BY
          c.id
      )
      UPDATE
        feature f
      SET
        termination_date = c.termination_date
      FROM
        candidates c
      WHERE
        f.id = c.id;

      GET DIAGNOSTICS updated = ROW_COUNT;
      EXIT WHEN updated = 0;
      total := total + updated;
    END LOOP;

    RAISE NOTICE 'Terminated % subfeatures in schema "%".', total, schema_name;
  END LOOP;
END
$$;
