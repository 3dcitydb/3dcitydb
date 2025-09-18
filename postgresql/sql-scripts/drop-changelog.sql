SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\echo 'Dropping changelog extension ...'

\set SCHEMA_NAME :schema_name

DROP TABLE IF EXISTS :SCHEMA_NAME.feature_changelog;
DROP SEQUENCE IF EXISTS :SCHEMA_NAME.feature_changelog_seq;
DROP TRIGGER IF EXISTS feature_changelog_trigger on :SCHEMA_NAME.feature;

\echo
\echo 'Changelog extension successfully removed.'