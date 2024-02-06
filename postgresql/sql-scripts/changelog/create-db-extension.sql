\echo 'Setting up changelog extension ...'

\set SCHEMA_NAME :schema_name

-- Tables
CREATE TABLE :SCHEMA_NAME.feature_changelog (
	id bigint NOT NULL,
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
  CONSTRAINT feature_changelog_pk PRIMARY KEY (id)
  WITH (FILLFACTOR=100)
);

-- Sequences
CREATE SEQUENCE :SCHEMA_NAME.feature_changelog_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- Constraints
ALTER TABLE :SCHEMA_NAME.feature_changelog ADD CONSTRAINT feature_changelog_fk1 FOREIGN KEY (feature_id)
REFERENCES :SCHEMA_NAME.feature (id) MATCH FULL
ON DELETE SET NULL ON UPDATE NO ACTION;

-- Indexes
CREATE INDEX feature_changelog_fkx1 ON :SCHEMA_NAME.feature_changelog
	USING btree
	(
	  feature_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX feature_changelog_fkx2 ON :SCHEMA_NAME.feature_changelog
	USING btree
	(
	  objectclass_id ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX feature_changelog_inx1 ON :SCHEMA_NAME.feature_changelog
	USING btree
	(
	  objectid ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX feature_changelog_inx2 ON :SCHEMA_NAME.feature_changelog
	USING btree
	(
	  identifier ASC NULLS LAST,
	  identifier_codespace
	)	WITH (FILLFACTOR = 90);

CREATE INDEX feature_changelog_inx3 ON :SCHEMA_NAME.feature_changelog
	USING btree
	(
	  transaction_date ASC NULLS LAST
	)	WITH (FILLFACTOR = 90);

CREATE INDEX feature_changelog_spx ON :SCHEMA_NAME.feature_changelog
	USING gist
	(
	  envelope
	);

-- Functions
CREATE OR REPLACE FUNCTION :SCHEMA_NAME.log_feature_changes() RETURNS TRIGGER AS
$feature_changelog_trigger$
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
            EXECUTE format('insert into %I.feature_changelog
                                select nextval(''%I.feature_changelog_seq''::regclass),
                                        $1, $2, $3, $4, $5, $6, $7, $8, $9', TG_TABLE_SCHEMA, TG_TABLE_SCHEMA)
            USING feature_id, objectclass_id, objectid, identifier, identifier_codespace, envelope, transaction_type, now(), user, reason_for_update;
		END IF;
	ELSE
    FOR rec IN
      EXECUTE format('select feature_id from %I.property where val_feature_id = %L and val_relation_type = 1', TG_TABLE_SCHEMA, feature_id)
    LOOP
      EXECUTE format('update %I.feature set last_modification_date = $1 where id = %L', TG_TABLE_SCHEMA, rec.feature_id) using NEW.last_modification_date;
    END LOOP;
	END IF;

	RETURN NULL;
END;
$feature_changelog_trigger$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER feature_changelog_trigger
AFTER INSERT OR UPDATE OR DELETE ON :SCHEMA_NAME.feature
  FOR EACH ROW EXECUTE PROCEDURE :SCHEMA_NAME.log_feature_changes();

\echo
\echo 'Changelog extension created!'
  