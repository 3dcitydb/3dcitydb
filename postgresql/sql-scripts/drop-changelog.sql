SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set SCHEMA_NAME :schema_name

\echo
\echo 'Dropping changelog extension ...'

DROP TRIGGER IF EXISTS feature_changelog_insert_update_trigger ON :SCHEMA_NAME.feature;
DROP TRIGGER IF EXISTS feature_changelog_delete_trigger ON :SCHEMA_NAME.feature;
DROP TRIGGER IF EXISTS feature_changelog_trigger ON :SCHEMA_NAME.feature;
DROP FUNCTION IF EXISTS :SCHEMA_NAME.log_feature_changes();
DROP TABLE IF EXISTS :SCHEMA_NAME.feature_changelog;
DROP SEQUENCE IF EXISTS :SCHEMA_NAME.feature_changelog_seq;

\echo
\echo 'Changelog extension successfully removed.'