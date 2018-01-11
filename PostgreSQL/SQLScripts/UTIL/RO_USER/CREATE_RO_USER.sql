-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2017
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.gis.bgu.tum.de/
-- 
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
-- 
-- virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
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

-- the script can be called by using the psql-console e.g. with this command:
-- path_to_your_psql -h host -p 5432 -U Username -d database -f "path_to_this_file"

\prompt 'Please enter a username for the read-only user: ' RO_USERNAME
\prompt 'Please enter a password for the read-only user: ' RO_PASSWORD
\prompt 'Please enter name of schema the user shall have access to: ' target

\set tschema :"target"

\echo
\echo 'Creating read-only ':RO_USERNAME' user for schema ':target

CREATE ROLE :"RO_USERNAME" WITH NOINHERIT LOGIN PASSWORD :'RO_PASSWORD';

GRANT CONNECT, TEMP ON DATABASE :"DBNAME" TO :"RO_USERNAME";
GRANT USAGE ON SCHEMA :"target" TO :"RO_USERNAME";
GRANT SELECT ON ALL TABLES IN SCHEMA :"target" TO :"RO_USERNAME";
GRANT USAGE ON SCHEMA citydb_pkg TO :"RO_USERNAME";
GRANT SELECT ON ALL TABLES IN SCHEMA citydb_pkg TO :"RO_USERNAME";
GRANT USAGE ON SCHEMA vcdb_pkg TO :"RO_USERNAME";
GRANT SELECT ON ALL TABLES IN SCHEMA vcdb_pkg TO :"RO_USERNAME";
GRANT USAGE ON SCHEMA public TO :"RO_USERNAME";
GRANT SELECT ON ALL TABLES IN SCHEMA public TO :"RO_USERNAME";

\echo
\echo 'Read-only user ':RO_USERNAME' for schema ':target' successfully created.' 