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
\set ACCESS_MODE :access_mode

SELECT CASE WHEN upper(:'ACCESS_MODE') = 'RW' THEN 'read-write' ELSE 'read-only' END AS priviliges_type;
\gset

\echo 'Granting ':priviliges_type' priviliges on schema "':SCHEMA_NAME'" to user "':USERNAME'" ...'

SET tmp.dbname TO :"DBNAME";
SET tmp.username TO :"USERNAME";
SET tmp.schema_name TO :"SCHEMA_NAME";
SET tmp.access_mode TO :"ACCESS_MODE";

DO $$
DECLARE priviliges_type text;
BEGIN
  IF upper(current_setting('tmp.access_mode')) = 'RW' THEN
    priviliges_type := 'ALL';
  ELSE
    priviliges_type := 'SELECT';
  END IF;

  EXECUTE format('GRANT CONNECT, TEMP ON DATABASE %I TO %I', current_setting('tmp.dbname'), current_setting('tmp.username'));
  EXECUTE format('GRANT USAGE, CREATE ON SCHEMA %I TO %I', current_setting('tmp.schema_name'), current_setting('tmp.username'));
  EXECUTE format('GRANT '||priviliges_type||' ON ALL TABLES IN SCHEMA %I TO %I', current_setting('tmp.schema_name'), current_setting('tmp.username'));
  EXECUTE format('GRANT USAGE ON SCHEMA citydb_pkg TO %I', current_setting('tmp.username'));
  EXECUTE format('GRANT '||priviliges_type||' ON ALL TABLES IN SCHEMA citydb_pkg TO %I', current_setting('tmp.username'));
  EXECUTE format('GRANT USAGE ON SCHEMA public TO %I', current_setting('tmp.username'));
  EXECUTE format('GRANT '||priviliges_type||' ON ALL TABLES IN SCHEMA public TO %I', current_setting('tmp.username'));
  
  IF upper(current_setting('tmp.access_mode')) = 'RW' THEN
    EXECUTE format('GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA %I TO %I', current_setting('tmp.schema_name'), current_setting('tmp.username'));
  END IF;  
END
$$;

\echo
\echo 'Successfully granted ':priviliges_type' priviliges.'