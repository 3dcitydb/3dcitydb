\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set QUIET 1
\t on
\pset format unaligned
\pset fieldsep '.'

\set major @majorVersion@
\set minor @minorVersion@
\set revision @minorRevision@

\echo 'Upgrading 3DCityDB to version ':major'.':minor'.':revision' ...'

-- check the current version
\echo
\echo 'Checking version of the 3DCityDB instance ...'
SELECT major_version AS current_major,
       minor_version AS current_minor,
       minor_revision AS current_revision FROM citydb_pkg.citydb_version();
\gset

-- execute upgrade action depending on the current version
SELECT CASE
  WHEN :major = :current_major
       AND ((:minor = :current_minor AND :revision > :current_revision)
       OR :minor > :current_minor) THEN 'upgrade/upgrade.sql'
  WHEN :current_major < 5 THEN 'upgrade/no-upgrade.sql'
  WHEN :major > :current_major THEN 'upgrade/no-upgrade.sql'
  ELSE 'upgrade/no-action.sql'
END AS do_action;
\gset

\ir :do_action