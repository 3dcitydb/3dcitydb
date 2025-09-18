SET client_min_messages TO NOTICE;

SELECT format($sql$
SET search_path TO %I, citydb_pkg, public;

DO $$
BEGIN
  RAISE NOTICE 'Upgrading schema "%%" ...', '%I';

  RAISE NOTICE 'Setting "feature_changelog.id" to default to sequence "feature_changelog_seq" ...';
  ALTER TABLE feature_changelog ALTER COLUMN id SET DEFAULT nextval('%I.feature_changelog_seq'::regclass);

  RAISE NOTICE 'Setting NOT NULL on "feature_changelog.transaction_date" ...';
  UPDATE feature_changelog SET transaction_date = '0001-01-01 00:00:00+00'::timestamptz WHERE transaction_date IS NULL;
  ALTER TABLE feature_changelog ALTER COLUMN transaction_date SET NOT NULL;

  RAISE NOTICE E'Re-creating changelog trigger on "feature" table ...\n';
END
$$;

CREATE OR REPLACE FUNCTION log_feature_changes() RETURNS TRIGGER AS
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
$body$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER feature_changelog_trigger
  AFTER INSERT OR UPDATE OR DELETE ON feature
  FOR EACH ROW EXECUTE PROCEDURE log_feature_changes();

$sql$, nspname, nspname, nspname, nspname, nspname)
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname = 'feature_changelog' AND c.relkind = 'r'
\gexec