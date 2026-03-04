\set SEQ_NAME :SCHEMA_NAME.feature_changelog_seq

CREATE SEQUENCE :SCHEMA_NAME.feature_changelog_seq START WITH 1  INCREMENT BY 1  MINVALUE 1  NO MAXVALUE CACHE 1  NO CYCLE;

CREATE  TABLE :SCHEMA_NAME.feature_changelog (
	id                   bigint DEFAULT nextval(:'SEQ_NAME'::regclass) NOT NULL  ,
	feature_id           bigint    ,
	objectclass_id       integer  NOT NULL  ,
	objectid             text    ,
	identifier           text    ,
	identifier_codespace text    ,
	envelope             geometry(GEOMETRYZ)    ,
	transaction_type     text  NOT NULL  ,
	transaction_date     timestamptz  NOT NULL  ,
	db_user              text    ,
	reason_for_update    text    ,
	CONSTRAINT feature_changelog_pk PRIMARY KEY ( id  )
 );

CREATE INDEX feature_changelog_feature_fkx ON :SCHEMA_NAME.feature_changelog  ( feature_id ) WITH ( FILLFACTOR = 90 );

CREATE INDEX feature_changelog_objectclass_inx ON :SCHEMA_NAME.feature_changelog  ( objectclass_id ) WITH ( FILLFACTOR = 90 );

CREATE INDEX feature_changelog_objectid_inx ON :SCHEMA_NAME.feature_changelog  ( objectid ) WITH ( FILLFACTOR = 90 );

CREATE INDEX feature_changelog_identifier_inx ON :SCHEMA_NAME.feature_changelog  ( identifier, identifier_codespace ) WITH ( FILLFACTOR = 90 );

CREATE INDEX feature_changelog_transaction_date_inx ON :SCHEMA_NAME.feature_changelog  ( transaction_date ) WITH ( FILLFACTOR = 100 );

ALTER TABLE :SCHEMA_NAME.feature_changelog ADD CONSTRAINT feature_changelog_feature_fk FOREIGN KEY ( feature_id ) REFERENCES :SCHEMA_NAME.feature( id ) ON DELETE SET NULL;

