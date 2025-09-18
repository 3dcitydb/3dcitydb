\set SCHEMA_NAME :schema_name

SELECT format($sql$
CREATE OR REPLACE FUNCTION %I.log_feature_changes() RETURNS TRIGGER AS
$body$
DECLARE
  rec RECORD;
	v_feature_id bigint;
	v_is_toplevel integer;
	v_objectclass_id integer;
	v_objectid text;
	v_identifier text;
	v_identifier_codespace text;
	v_envelope geometry;
	v_reason_for_update text;
	transaction_type text;
BEGIN
  transaction_type := TG_OP;

	IF (TG_OP = 'DELETE') THEN
		v_feature_id := NULL;
		v_objectclass_id := OLD.objectclass_id;
		v_objectid := OLD.objectid;
		v_identifier := OLD.identifier;
		v_identifier_codespace := OLD.identifier_codespace;
		v_envelope := OLD.envelope;
		v_reason_for_update := NULL;
	ELSE
		v_feature_id := NEW.id;
		v_objectclass_id := NEW.objectclass_id;
		v_objectid := NEW.objectid;
		v_identifier := NEW.identifier;
		v_identifier_codespace := NEW.identifier_codespace;
		v_envelope := NEW.envelope;
		v_reason_for_update := NEW.reason_for_update;

		IF (NEW.termination_date IS NOT NULL) THEN
			transaction_type := 'TERMINATE';
		END IF;
	END IF;

  IF transaction_type <> 'UPDATE' OR OLD.last_modification_date IS DISTINCT FROM NEW.last_modification_date THEN
    SELECT o.is_toplevel INTO v_is_toplevel
    FROM %I.objectclass o
    WHERE o.id = v_objectclass_id;

    IF v_is_toplevel = 1 THEN
      INSERT INTO %I.feature_changelog (
        feature_id, objectclass_id, objectid, identifier, identifier_codespace,
        envelope, transaction_type, transaction_date, db_user, reason_for_update
	    ) VALUES (
        v_feature_id, v_objectclass_id, v_objectid, v_identifier, v_identifier_codespace,
        v_envelope, transaction_type, now(), user, v_reason_for_update
      );
    END IF;
  END IF;

  RETURN NULL;
END;
$body$ LANGUAGE plpgsql
$sql$, :'SCHEMA_NAME', :'SCHEMA_NAME', :'SCHEMA_NAME')
\gexec

CREATE OR REPLACE TRIGGER feature_changelog_trigger
  AFTER INSERT OR UPDATE OR DELETE ON :SCHEMA_NAME.feature
  FOR EACH ROW EXECUTE PROCEDURE :SCHEMA_NAME.log_feature_changes();