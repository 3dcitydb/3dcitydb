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
\set version_string @versionString@

\echo 'Upgrading 3DCityDB to version ':version_string' ...'
\echo

-- check the current version
SELECT version AS current_version_string,
       major_version AS current_major,
       minor_version AS current_minor,
       minor_revision AS current_revision
       FROM citydb_pkg.citydb_version()
\gset

\echo 'The 3DCityDB instance is currently at version ':current_version_string'.'
\echo

-- execute upgrade action depending on the current version
SELECT CASE
  WHEN :major = :current_major AND :minor = :current_minor AND :revision = :current_revision
    AND :'current_version_string' <> :major || '.' || :minor || '.' || :revision
    AND (:'version_string' > :'current_version_string'
    OR length(:'version_string') > length(:'current_version_string')
    OR :'version_string' = :major || '.' || :minor || '.' || :revision) THEN 'upgrade/upgrade.sql'
  WHEN :major = :current_major
    AND ((:minor = :current_minor AND :revision > :current_revision)
    OR :minor > :current_minor) THEN 'upgrade/upgrade.sql'
  WHEN :current_major < 5 THEN 'upgrade/no-upgrade.sql'
  WHEN :major > :current_major THEN 'upgrade/no-upgrade.sql'
  ELSE 'upgrade/no-action.sql'
END AS do_action
\gset

\ir :do_action