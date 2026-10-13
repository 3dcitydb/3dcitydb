SELECT format($sql$
CREATE OR REPLACE FUNCTION %I.log_feature_changes() RETURNS TRIGGER AS
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
  FROM %I.objectclass o
  WHERE id = v_objectclass_id;

  IF v_is_toplevel = 1
     AND (v_objectclass_id <> 203 OR NOT EXISTS (
       SELECT 1
       FROM %I.property p
       WHERE p.val_feature_id = v_feature_id
         AND p.val_relation_type = 1
     )) THEN
    INSERT INTO %I.feature_changelog (
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
$body$ LANGUAGE plpgsql
$sql$, :'SCHEMA_NAME', :'SCHEMA_NAME', :'SCHEMA_NAME', :'SCHEMA_NAME')
\gexec

CREATE OR REPLACE TRIGGER feature_changelog_delete_trigger
  BEFORE DELETE ON :SCHEMA_NAME.feature
  FOR EACH ROW EXECUTE PROCEDURE :SCHEMA_NAME.log_feature_changes();

CREATE OR REPLACE TRIGGER feature_changelog_insert_update_trigger
  AFTER INSERT OR UPDATE ON :SCHEMA_NAME.feature
  FOR EACH ROW EXECUTE PROCEDURE :SCHEMA_NAME.log_feature_changes();