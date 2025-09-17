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
	feature_id bigint;
	is_toplevel integer;
	objectclass_id integer;
	objectid text;
	identifier text;
	identifier_codespace text;
	envelope geometry;
	reason_for_update text;
	transaction_type text;
BEGIN
	transaction_type := TG_OP;
	IF (TG_OP = 'DELETE') THEN
		feature_id := NULL;
		objectclass_id := OLD.objectclass_id;
		objectid := OLD.objectid;
		identifier := OLD.identifier;
		identifier_codespace := OLD.identifier_codespace;
		envelope := OLD.envelope;
		reason_for_update := NULL;
	ELSE
		feature_id := NEW.id;
		objectclass_id := NEW.objectclass_id;
		objectid := NEW.objectid;
		identifier := NEW.identifier;
		identifier_codespace := NEW.identifier_codespace;
		envelope := NEW.envelope;
		reason_for_update := NEW.reason_for_update;

		IF (NEW.termination_date IS NOT NULL) THEN
			transaction_type := 'TERMINATE';
		END IF;
	END IF;

	EXECUTE format('select oc.is_toplevel from %I.objectclass oc where oc.id = %L', TG_TABLE_SCHEMA, objectclass_id) INTO is_toplevel;

	IF (is_toplevel = 1) THEN
		IF (transaction_type = 'UPDATE' AND OLD.last_modification_date <> NEW.last_modification_date) OR (transaction_type <> 'UPDATE') THEN
            EXECUTE format('insert into %I.feature_changelog (feature_id, objectclass_id, objectid, identifier, identifier_codespace, envelope, transaction_type, transaction_date, db_user, reason_for_update)
                                select $1, $2, $3, $4, $5, $6, $7, $8, $9, $10', TG_TABLE_SCHEMA, TG_TABLE_SCHEMA)
            USING feature_id, objectclass_id, objectid, identifier, identifier_codespace, envelope, transaction_type, now(), user, reason_for_update;
		END IF;
	ELSIF (transaction_type = 'UPDATE' AND OLD.last_modification_date <> NEW.last_modification_date) THEN
    FOR rec IN
      EXECUTE format('select feature_id from %I.property where val_feature_id = %L and val_relation_type = 1', TG_TABLE_SCHEMA, feature_id)
    LOOP
      EXECUTE format('update %I.feature set last_modification_date = $1, updating_person = $2, reason_for_update = $3
            where id = $4', TG_TABLE_SCHEMA) using NEW.last_modification_date, NEW.updating_person, NEW.reason_for_update, rec.feature_id;
    END LOOP;
	END IF;

	RETURN NULL;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER feature_changelog_trigger
  AFTER INSERT OR UPDATE OR DELETE ON :SCHEMA_NAME.feature
  FOR EACH ROW EXECUTE PROCEDURE :SCHEMA_NAME.log_feature_changes();

\echo
\echo 'Changelog extension successfully created.'