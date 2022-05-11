-- noinspection SqlDialectInspectionForFile

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
SET client_min_messages TO NOTICE;
\set ON_ERROR_STOP ON

--// upgrade CITYDB_PKG (additional schema with PL/pgSQL functions)
\echo
\echo 'Upgrading schema ''citydb_pkg'' ...'

DO $$
DECLARE _sql text;
BEGIN
   SELECT INTO _sql
          string_agg(format('DROP FUNCTION %s;', oid::regprocedure), E'\n')
   FROM   pg_proc
   WHERE  pronamespace = 'citydb_pkg'::regnamespace;

   IF _sql IS NOT NULL THEN
      EXECUTE _sql;
   END IF;
END
$$;

\ir ../../CITYDB_PKG/UTIL/UTIL.sql
\ir ../../CITYDB_PKG/CONSTRAINT/CONSTRAINT.sql
\ir ../../CITYDB_PKG/INDEX/IDX.sql
\ir ../../CITYDB_PKG/SRS/SRS.sql
\ir ../../CITYDB_PKG/STATISTICS/STAT.sql

SET tmp.old_major TO :major;
SET tmp.old_minor TO :minor;
SET tmp.old_revision TO :revision;

DO $$
DECLARE
  schema_name text;
  old_major integer := current_setting('tmp.old_major')::integer;
  old_minor integer := current_setting('tmp.old_minor')::integer;
  old_revision integer := current_setting('tmp.old_revision')::integer;
BEGIN
    FOR schema_name in SELECT nspname AS schema_name FROM pg_catalog.pg_class c
                     JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
                     WHERE c.relname = 'database_srs' AND c.relkind = 'r'
    LOOP
      -- create indexes new in version > 4.0.2
      IF old_major = 4 AND old_minor = 0 AND old_revision <= 2 THEN
        RAISE NOTICE 'Creating additional indexes in schema ''%'' ...', schema_name;
        EXECUTE format('CREATE INDEX cityobj_creation_date_inx ON %I.cityobject USING btree (creation_date) WITH (FILLFACTOR = 90)', schema_name);
        EXECUTE format('CREATE INDEX cityobj_term_date_inx ON %I.cityobject USING btree (termination_date) WITH (FILLFACTOR = 90)', schema_name);
        EXECUTE format('CREATE INDEX cityobj_last_mod_date_inx ON %I.cityobject USING btree (last_modification_date) WITH (FILLFACTOR = 90)', schema_name);
        EXECUTE format('INSERT INTO %I.index_table (obj) VALUES (citydb_pkg.construct_normal(''cityobj_creation_date_inx'', ''cityobject'', ''creation_date''))', schema_name);
        EXECUTE format('INSERT INTO %I.index_table (obj) VALUES (citydb_pkg.construct_normal(''cityobj_term_date_inx'', ''cityobject'', ''termination_date''))', schema_name);
        EXECUTE format('INSERT INTO %I.index_table (obj) VALUES (citydb_pkg.construct_normal(''cityobj_last_mod_date_inx'', ''cityobject'', ''last_modification_date''))', schema_name);
      END IF;

      -- create columns and index new in version > 4.2
      IF old_major = 4 AND old_minor <= 2 THEN
        EXECUTE format('ALTER TABLE %I.implicit_geometry ADD COLUMN gmlid character varying(256), ADD COLUMN gmlid_codespace varchar(1000)', schema_name);
        EXECUTE format('UPDATE %I.implicit_geometry SET gmlid = sg.gmlid, gmlid_codespace = sg.gmlid_codespace FROM %I.surface_geometry sg WHERE relative_brep_id = sg.id;', schema_name, schema_name);
        EXECUTE format('CREATE INDEX implicit_geom_inx ON %I.implicit_geometry USING btree (gmlid ASC NULLS LAST, gmlid_codespace) WITH (FILLFACTOR = 90)', schema_name);
      END IF;
    END LOOP;
END
$$;

--// do bigint update
\echo
\echo 'Do bigint update ...'
\ir ../UTIL/BIGINT.sql

--// do VACUUM
\echo
\echo 'Do VACUUM ...'
\ir ../UTIL/VACUUM.sql