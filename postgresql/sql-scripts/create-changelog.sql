SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo 'Setting up changelog extension ...'

\ir changelog/changelog-table.sql
\ir changelog/feature-trigger.sql

\echo
\echo 'Changelog extension successfully created.'