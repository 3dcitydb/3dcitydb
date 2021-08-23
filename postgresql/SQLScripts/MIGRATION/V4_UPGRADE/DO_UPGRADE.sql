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
SET client_min_messages TO WARNING;
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
  meta_tables text[] := '{"objectclass", "ade", "schema", "schema_to_objectclass", "schema_referencing", "aggregation_info", "database_srs", "index_table"}';
  meta_sequences text[] := '{"schema_seq", "ade_seq", "index_table_id_seq"}';
  rec record;
  schema_name text;
  old_major integer := current_setting('tmp.old_major')::integer;
  old_minor integer := current_setting('tmp.old_minor')::integer;
  old_revision integer := current_setting('tmp.old_revision')::integer;
BEGIN
  -- create indexes new in version > 4.0.2
  IF old_major = 4 AND old_minor = 0 AND old_revision <=2 THEN
    FOR schema_name in SELECT nspname AS schema_name FROM pg_catalog.pg_class c
                     JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
                     WHERE c.relname = 'database_srs' AND c.relkind = 'r'
    LOOP
      EXECUTE format('CREATE INDEX cityobj_creation_date_inx ON %I.cityobject USING btree (creation_date) WITH (FILLFACTOR = 90)', schema_name);
      EXECUTE format('CREATE INDEX cityobj_term_date_inx ON %I.cityobject USING btree (termination_date) WITH (FILLFACTOR = 90)', schema_name);
      EXECUTE format('CREATE INDEX cityobj_last_mod_date_inx ON %I.cityobject USING btree (last_modification_date) WITH (FILLFACTOR = 90)', schema_name);
      EXECUTE format('INSERT INTO %I.index_table (obj) VALUES (citydb_pkg.construct_normal(''cityobj_creation_date_inx'', ''cityobject'', ''creation_date''))', schema_name);
      EXECUTE format('INSERT INTO %I.index_table (obj) VALUES (citydb_pkg.construct_normal(''cityobj_term_date_inx'', ''cityobject'', ''termination_date''))', schema_name);
      EXECUTE format('INSERT INTO %I.index_table (obj) VALUES (citydb_pkg.construct_normal(''cityobj_last_mod_date_inx'', ''cityobject'', ''last_modification_date''))', schema_name);
    END LOOP;
  END IF;

  -- do upgrade for version <= 4.1.0
  IF old_major = 4 AND old_minor <= 1 THEN
    FOR schema_name in SELECT nspname AS schema_name FROM pg_catalog.pg_class c
                     JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
                     WHERE c.relname = 'database_srs' AND c.relkind = 'r'
    LOOP
      -- update sequences
      FOR rec IN
          SELECT
            sequence_name
          FROM
            information_schema.sequences
          WHERE
            sequence_schema = schema_name AND NOT (sequence_name = ANY(meta_sequences))
          LOOP
        EXECUTE 'alter sequence ' || schema_name || '.' || rec.sequence_name || ' maxvalue 9223372036854775807';
      END LOOP;

      -- update non-ID columns
      FOR rec IN
          SELECT
            p.nspname,
            c.confrelid::regclass::text AS pk_table,
            c.conrelid::regclass::text AS fk_table,
            a.attname::text AS fk_column
          FROM
            pg_constraint c
          JOIN
            pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY (c.conkey)
          JOIN
            pg_namespace p ON c.connamespace = p.oid
          WHERE
            c.contype = 'f' AND a.attname::text <> 'id' AND p.nspname = schema_name
              AND NOT (substring(c.confrelid::regclass::text, position('.' in c.confrelid::regclass::text) + 1) = ANY(meta_tables))
          LOOP
        EXECUTE 'alter table ' || rec.fk_table || ' alter column ' || rec.fk_column || ' type bigint';
      END LOOP;

      -- update ID columns
      FOR rec IN
          SELECT
            table_name
          FROM
            information_schema.tables at
          WHERE
            table_schema = schema_name AND
            NOT (table_name = ANY(meta_tables)) AND
            EXISTS (
              SELECT
                table_name
              FROM
                information_schema.columns c
              WHERE
                c.table_name = at.table_name AND c.column_name = 'id' AND c.table_schema = schema_name
            )
          LOOP
        EXECUTE 'alter table ' || schema_name || '.' || rec.table_name || ' alter column id type bigint';
      END LOOP;

      -- update delete and envelope functions
      FOR rec IN
          SELECT
            oid::regprocedure as function_name,
            pg_get_functiondef(oid) as function_definition
          FROM
            pg_proc
          WHERE
            pronamespace = schema_name::regnamespace
            AND (position('del_' in oid::regprocedure::text) = 1
              OR position('env_' in oid::regprocedure::text) = 1
              OR position('box2envelope(box3d)' in oid::regprocedure::text) = 1
              OR position('cleanup_appearances(integer)' in oid::regprocedure::text) = 1
              OR position('cleanup_schema()' in oid::regprocedure::text) = 1
              OR position('cleanup_table(text)' in oid::regprocedure::text) = 1
              OR position('get_envelope_cityobjects(integer,integer,integer)' in oid::regprocedure::text) = 1
              OR position('get_envelope_implicit_geometry(integer,geometry,character varying)' in oid::regprocedure::text) = 1
              OR position('update_bounds(geometry,geometry)' in oid::regprocedure::text) = 1)
            LOOP
        EXECUTE 'drop function ' || rec.function_name;
        EXECUTE regexp_replace(rec.function_definition, '(?<!caller |class_id::|class_id |only_if_null |db_srid |only_global |set_envelope )(integer)|(?<=\s)(int)(?!\w)', 'bigint', 'gi');
      END LOOP;
    END LOOP;
  END IF;
END
$$;