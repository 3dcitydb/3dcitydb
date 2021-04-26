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

\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\set USERNAME :username
\set SCHEMA_NAME :schema_name

\echo
\echo 'Revoking access priviliges priviliges on schema "':SCHEMA_NAME'" from user "':USERNAME'" ...' 

REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA :"SCHEMA_NAME" FROM :"USERNAME";
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA :"SCHEMA_NAME" FROM :"USERNAME";
REVOKE USAGE, CREATE ON SCHEMA :"SCHEMA_NAME" FROM :"USERNAME";
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA citydb_pkg FROM :"USERNAME";
REVOKE USAGE ON SCHEMA citydb_pkg FROM :"USERNAME";
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM :"USERNAME";
REVOKE USAGE ON SCHEMA public FROM :"USERNAME";
REVOKE CONNECT, TEMP ON DATABASE :"DBNAME" FROM :"USERNAME";

\echo
\echo 'Access priviliges successfully revoked.'