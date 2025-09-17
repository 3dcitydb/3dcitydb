\set ON_ERROR_STOP ON

\echo 'Setting up changelog extension ...'

\set SCHEMA_NAME :schema_name
\set SEQ_NAME :SCHEMA_NAME.feature_changelog_seq

CREATE SEQUENCE :SCHEMA_NAME.feature_changelog_seq START WITH 1 INCREMENT BY 1 MINVALUE 0 MAXVALUE 9223372036854775807 CACHE 1 NO CYCLE;

CREATE TABLE :SCHEMA_NAME.feature_changelog (
  "id" bigint DEFAULT nextval(:'SEQ_NAME'::regclass) NOT NULL,
  feature_id bigint,
  objectclass_id integer NOT NULL,
  objectid text,
  identifier text,
  identifier_codespace text,
  envelope geometry(POLYGONZ),
  transaction_type text NOT NULL,
  transaction_date timestamp with time zone,
  db_user text,
  reason_for_update text,
  CONSTRAINT feature_changelog_pk PRIMARY KEY ( id ) WITH ( FILLFACTOR = 100 )
);

ALTER TABLE :SCHEMA_NAME.feature_changelog ADD CONSTRAINT feature_changelog_feature_fk
  FOREIGN KEY ( feature_id ) REFERENCES :SCHEMA_NAME.feature ( id )
  ON DELETE SET NULL ON UPDATE NO ACTION;

CREATE INDEX feature_changelog_feature_fkx ON :SCHEMA_NAME.feature_changelog ( feature_id ) WITH ( FILLFACTOR = 90 );

CREATE INDEX feature_changelog_objectclass_inx ON :SCHEMA_NAME.feature_changelog ( objectclass_id ) WITH ( FILLFACTOR = 90 );

CREATE INDEX feature_changelog_objectid_inx ON :SCHEMA_NAME.feature_changelog ( objectid ) WITH ( FILLFACTOR = 90 );

CREATE INDEX feature_changelog_identifier_inx ON :SCHEMA_NAME.feature_changelog ( identifier, identifier_codespace ) WITH ( FILLFACTOR = 90 );

CREATE INDEX feature_changelog_transaction_date_inx ON :SCHEMA_NAME.feature_changelog ( transaction_date ) WITH ( FILLFACTOR = 100 );

CREATE INDEX feature_changelog_envelope_spx ON :SCHEMA_NAME.feature_changelog USING gist ( envelope );

CREATE OR REPLACE FUNCTION :SCHEMA_NAME.log_feature_changes() RETURNS TRIGGER AS
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

	SELECT o.is_toplevel INTO v_is_toplevel
	FROM objectclass o
	WHERE o.id = v_objectclass_id;

  IF (v_is_toplevel = 1) THEN
    IF (transaction_type <> 'UPDATE')
        OR (transaction_type = 'UPDATE' AND OLD.last_modification_date IS DISTINCT FROM NEW.last_modification_date) THEN
      INSERT INTO feature_changelog (
        feature_id, objectclass_id, objectid, identifier, identifier_codespace,
        envelope, transaction_type, transaction_date, db_user, reason_for_update
	    )
      VALUES (
        v_feature_id, v_objectclass_id, v_objectid, v_identifier, v_identifier_codespace,
        v_envelope, transaction_type, now(), user, v_reason_for_update
      );
		END IF;
	ELSIF (transaction_type = 'UPDATE' AND OLD.last_modification_date IS DISTINCT FROM NEW.last_modification_date) THEN
    UPDATE feature f
    SET
      last_modification_date = NEW.last_modification_date,
      updating_person = NEW.updating_person,
      reason_for_update = NEW.reason_for_update
    WHERE f.id IN (
      SELECT p.feature_id
      FROM property p
      WHERE p.val_feature_id = v_feature_id
        AND p.val_relation_type = 1
    );
	END IF;

	RETURN NULL;
END;
$body$ LANGUAGE plpgsql
SET search_path = :SCHEMA_NAME, public;

CREATE TRIGGER feature_changelog_trigger
  AFTER INSERT OR UPDATE OR DELETE ON :SCHEMA_NAME.feature
  FOR EACH ROW EXECUTE PROCEDURE :SCHEMA_NAME.log_feature_changes();

\echo
\echo 'Changelog extension successfully created.'