-- 3D City Database - The Open Source CityGML Database
-- https://www.3dcitydb.org/
--
-- Copyright 2013 - 2021
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.lrg.tum.de/gis/
--
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
--
-- Virtual City Systems, Berlin <https://vc.systems/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

-- This script is called from UPGRADE_DB.bat
\set QUIET 1
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP on

\pset footer off
\pset tuples_only on
\pset format unaligned
\pset fieldsep '.'

\set NEW_MAJOR 4
\set NEW_MINOR 0
\set NEW_REVISION 3

\echo
\echo 'Upgrading 3DCityDB ...'

--// check current version
\echo
\echo 'Checking version of the 3DCityDB instance ...'
SELECT major_version AS major, 
       minor_version AS minor, 
	   minor_revision AS revision FROM citydb_pkg.citydb_version();
\gset

--// choose action depending on current version
SELECT CASE 
  WHEN :NEW_MAJOR = :major
       AND ( (:NEW_MINOR = :minor AND :NEW_REVISION > :revision) 
	   OR :NEW_MINOR > :minor ) THEN 'DO_UPGRADE.sql'
  WHEN :major < :NEW_MAJOR THEN 'DO_MIGRATE.sql'
  ELSE 'DO_NOTHING.sql' 
  END AS do_action;
\gset

\ir :do_action;

\echo
\echo '3DCityDB upgrade complete!'