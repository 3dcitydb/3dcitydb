-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
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

SET client_min_messages TO WARNING;

\echo 'Starting 3D City Database upgrade...'
\set ON_ERROR_STOP ON
\echo

--// add missing foreign key
DO
$$
DECLARE
  version record;
BEGIN
  version := citydb_pkg.citydb_version();
  
  IF version.major_version = 3 AND version.minor_version < 3 THEN
    ALTER TABLE citydb.bridge
	  ADD CONSTRAINT bridge_cityobject_fk FOREIGN KEY (id)
	  REFERENCES citydb.cityobject (id) MATCH FULL
	  ON DELETE NO ACTION ON UPDATE CASCADE;
  END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE '%', SQLERRM;
END;
$$;

--// drop old versions of CITYDB_PKG
DROP SCHEMA CITYDB_PKG CASCADE;

--// create CITYDB_PKG
\echo
\echo 'Upgrading CITYDB_PKG schema...'
CREATE SCHEMA CITYDB_PKG;

--// call PL/pgSQL-Scripts to add CITYDB_PKG functions
\i ../../PL_pgSQL/CITYDB_PKG/UTIL/UTIL.sql
\i ../../PL_pgSQL/CITYDB_PKG/INDEX/IDX.sql
\i ../../PL_pgSQL/CITYDB_PKG/SRS/SRS.sql
\i ../../PL_pgSQL/CITYDB_PKG/STATISTICS/STAT.sql
\i ../../PL_pgSQL/CITYDB_PKG/ENVELOPE/ENVELOPE.sql
\i ../../PL_pgSQL/CITYDB_PKG/DELETE/DELETE.sql
\i ../../PL_pgSQL/CITYDB_PKG/DELETE/DELETE_BY_LINEAGE.sql

--// rebuild spatial indexes
--// required if the default spatial indexes have been built with the 'gist_geometry_ops_nd' operation class
\echo
\echo 'Rebuilding spatial indexes (if required)...'
DO
$$
DECLARE
  opc_name text[];
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM citydb_pkg.index_table LOOP
    IF (rec.obj).type = 1 THEN
      SELECT
        array_agg(pgoc.opcname::text)
      INTO
        opc_name
      FROM pg_class pgc_t
      JOIN pg_index pgi ON pgi.indrelid = pgc_t.oid
      JOIN pg_class pgc_i ON pgc_i.oid = pgi.indexrelid
      JOIN pg_opclass pgoc ON pgoc.oid = ANY(pgi.indclass)
      JOIN pg_am pgam ON pgam.oid = pgc_i.relam
      JOIN pg_attribute pga ON pga.attrelid = pgc_i.oid
      JOIN pg_namespace pgns ON pgns.oid = pgc_i.relnamespace
      WHERE lower(pgns.nspname) = 'citydb'
        AND lower(pgc_t.relname) = (rec.obj).table_name
        AND lower(pga.attname) = (rec.obj).attribute_name
        AND lower(pgc_i.relname) = (rec.obj).index_name
        AND pgam.amname = 'gist';

      IF opc_name @> ARRAY['gist_geometry_ops_nd'::text] THEN
        RAISE INFO 'Rebuilding spatial index %. This may take some time - DO NOT INTERRUPT.', upper((rec.obj).index_name);

        -- drop spatial index...
        PERFORM citydb_pkg.drop_index(rec.obj);
        -- ...and recreate it
        PERFORM citydb_pkg.create_index(rec.obj);

        -- check index status
        IF upper(citydb_pkg.index_status(rec.obj)) <> 'VALID' THEN
	      RAISE 'Rebuilding index failed. Please check the index manually.';
        END IF;
      END IF;
    END IF;
  END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE '%', SQLERRM;
END;
$$;

\echo
\echo '3D City Database upgrade complete!'
