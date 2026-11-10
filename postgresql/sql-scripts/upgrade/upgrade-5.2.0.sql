SET client_min_messages TO NOTICE;

\echo 'Upgrading 3DCityDB schemas to version 5.2.0 ...'
\echo

DO $$
DECLARE
  schema_name text;
BEGIN
  FOR schema_name IN
    SELECT nspname FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'database_srs' AND c.relkind = 'r'
  LOOP
    EXECUTE format('set search_path to %I, citydb_pkg, public', schema_name);
    RAISE NOTICE 'Upgrading schema "%" ...', schema_name;

    RAISE NOTICE 'Creating extended statistics on "property(name, namespace_id)" ...';
    CREATE STATISTICS property_name_namespace_stx (dependencies, mcv)
      ON name, namespace_id FROM property;
    ANALYZE property (name, namespace_id);

    RAISE NOTICE 'Setting "objectclass.is_toplevel" to true for GenericThematicSurface ...';
    UPDATE objectclass SET is_toplevel = 1 WHERE id = 203;

    RAISE NOTICE 'Updating table "objectclass" ...';
    UPDATE objectclass
    SET SCHEMA = '{"identifier":"core:AbstractObject","description":"AbstractObject is the abstract superclass of all feature and object types.","table":"feature","properties":[{"name":"id","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the internal database ID of the object.","value":{"column":"id","type":"integer"}},{"name":"objectId","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the identifier of the object that is unique within the database. Using a globally unique identifier is recommended.","value":{"column":"objectid","type":"string"}},{"name":"identifier","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies an optional identifier of the object that is globally unique.","value":{"column":"identifier","type":"string"}},{"name":"codeSpace","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the code space of the identifier, typically a reference to the maintaining authority.","value":{"column":"identifier_codespace","type":"string"},"parent":2},{"name":"envelope","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the minimum bounding box that encloses the entire object.","value":{"column":"envelope","type":"core:Envelope"}},{"name":"objectClassId","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the internal object class ID of the object.","value":{"column":"objectclass_id","type":"integer"}},{"name":"lastModificationDate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Indicates the date and time at which the object was last updated in the database.","value":{"column":"last_modification_date","type":"timestamp"}},{"name":"updatingPerson","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the person who last updated the object in the database.","value":{"column":"updating_person","type":"string"}},{"name":"reasonForUpdate","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the reason for the last update of the object in the database.","value":{"column":"reason_for_update","type":"string"}},{"name":"lineage","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies the lineage information of the object.","value":{"column":"lineage","type":"string"}},{"name":"description","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies a text description of the object.","type":"core:StringOrRef"},{"name":"descriptionReference","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies a reference to a remote text description of the object.","type":"core:Reference"},{"name":"name","namespace":"http://3dcitydb.org/3dcitydb/core/5.0","description":"Specifies a label or identifier of the object, commonly a descriptive name.","type":"core:Code"}]}'
    WHERE ID = 2;
  END LOOP;
END
$$;

SELECT format($sql$
SET search_path TO %I, citydb_pkg, public;

DO $$
BEGIN
  RAISE NOTICE E'Re-creating changelog triggers on "feature" table ...\n';
END
$$;

DROP TRIGGER IF EXISTS feature_changelog_trigger ON feature;

CREATE OR REPLACE FUNCTION log_feature_changes() RETURNS TRIGGER AS
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
  FROM objectclass o
  WHERE id = v_objectclass_id;

  IF v_is_toplevel = 1
     AND (v_objectclass_id <> 203 OR NOT EXISTS (
       SELECT 1
       FROM property p
       WHERE p.val_feature_id = v_feature_id
         AND p.val_relation_type = 1
     )) THEN
    INSERT INTO feature_changelog (
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
  BEFORE DELETE ON feature
  FOR EACH ROW EXECUTE PROCEDURE log_feature_changes();

CREATE OR REPLACE TRIGGER feature_changelog_insert_update_trigger
  AFTER INSERT OR UPDATE ON feature
  FOR EACH ROW EXECUTE PROCEDURE log_feature_changes();

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
