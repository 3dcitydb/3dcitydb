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
  _sql text;
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
      SELECT INTO _sql
             string_agg(format('DROP FUNCTION %s;', oid::regprocedure), E'\n')
      FROM   pg_proc
      WHERE  pronamespace = schema_name::regnamespace;

      IF _sql IS NOT NULL THEN
         EXECUTE _sql;
      END IF;

      EXECUTE 'alter sequence ' || schema_name || '.citymodel_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.cityobject_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.external_ref_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.surface_geometry_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.implicit_geometry_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.cityobject_genericatt_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.address_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.appearance_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.surface_data_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.tex_image_seq maxvalue 9223372036854775807';
      EXECUTE 'alter sequence ' || schema_name || '.grid_coverage_seq maxvalue 9223372036854775807';

      EXECUTE 'alter table ' || schema_name || '.cityobject_member alter column citymodel_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobject_member alter column citymodel_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generalization alter column cityobject_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generalization alter column generalizes_to_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobjectgroup alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobjectgroup alter column brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobjectgroup alter column parent_cityobject_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.group_to_cityobject alter column cityobject_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.group_to_cityobject alter column cityobjectgroup_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column lod1_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column lod2_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column lod3_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column lod1_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column lod2_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.city_furniture alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod0_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod1_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod2_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod3_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod0_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod1_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod2_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.generic_cityobject alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.address_to_building alter column building_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.address_to_building alter column address_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column building_parent_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column building_root_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod0_footprint_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod0_roofprint_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod1_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod1_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod2_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod3_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building alter column lod4_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_furniture alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_furniture alter column room_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_furniture alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_furniture alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column building_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column room_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column lod2_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column lod3_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column lod2_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.building_installation alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.opening alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.opening alter column address_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.opening alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.opening alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.opening alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.opening alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.opening_to_them_surface alter column opening_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.opening_to_them_surface alter column thematic_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.room alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.room alter column building_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.room alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.room alter column lod4_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.thematic_surface alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.thematic_surface alter column building_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.thematic_surface alter column room_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.thematic_surface alter column building_installation_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.thematic_surface alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.thematic_surface alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.thematic_surface alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.textureparam alter column surface_geometry_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.textureparam alter column surface_data_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.appear_to_surface_data alter column surface_data_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.appear_to_surface_data alter column appearance_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.breakline_relief alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.masspoint_relief alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.relief_component alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.relief_feat_to_rel_comp alter column relief_component_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.relief_feat_to_rel_comp alter column relief_feature_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.relief_feature alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tin_relief alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tin_relief alter column surface_geometry_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.transportation_complex alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.transportation_complex alter column lod1_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.transportation_complex alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.transportation_complex alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.transportation_complex alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.traffic_area alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.traffic_area alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.traffic_area alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.traffic_area alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.traffic_area alter column transportation_complex_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.land_use alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.land_use alter column lod0_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.land_use alter column lod1_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.land_use alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.land_use alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.land_use alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column lod1_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column lod1_multi_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column lod2_multi_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column lod3_multi_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.plant_cover alter column lod4_multi_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column lod1_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column lod2_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column lod3_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column lod1_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column lod2_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.solitary_vegetat_object alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbody alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbody alter column lod0_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbody alter column lod1_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbody alter column lod1_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbody alter column lod2_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbody alter column lod3_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbody alter column lod4_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbod_to_waterbnd_srf alter column waterboundary_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterbod_to_waterbnd_srf alter column waterbody_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterboundary_surface alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterboundary_surface alter column lod2_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterboundary_surface alter column lod3_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.waterboundary_surface alter column lod4_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.raster_relief alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.raster_relief alter column coverage_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column tunnel_parent_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column tunnel_root_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column lod1_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column lod1_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column lod2_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column lod3_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel alter column lod4_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_open_to_them_srf alter column tunnel_opening_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_open_to_them_srf alter column tunnel_thematic_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_hollow_space alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_hollow_space alter column tunnel_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_hollow_space alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_hollow_space alter column lod4_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_thematic_surface alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_thematic_surface alter column tunnel_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_thematic_surface alter column tunnel_hollow_space_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_thematic_surface alter column tunnel_installation_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_thematic_surface alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_thematic_surface alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_thematic_surface alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_opening alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_opening alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_opening alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_opening alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_opening alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column tunnel_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column tunnel_hollow_space_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column lod2_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column lod3_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column lod2_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_installation alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_furniture alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_furniture alter column tunnel_hollow_space_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_furniture alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tunnel_furniture alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column bridge_parent_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column bridge_root_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column lod1_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column lod1_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column lod2_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column lod3_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge alter column lod4_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_furniture alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_furniture alter column bridge_room_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_furniture alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_furniture alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column bridge_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column bridge_room_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column lod2_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column lod3_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column lod2_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_installation alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_opening alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_opening alter column address_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_opening alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_opening alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_opening alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_opening alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_open_to_them_srf alter column bridge_opening_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_open_to_them_srf alter column bridge_thematic_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_room alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_room alter column bridge_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_room alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_room alter column lod4_solid_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_thematic_surface alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_thematic_surface alter column bridge_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_thematic_surface alter column bridge_room_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_thematic_surface alter column bridge_installation_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_thematic_surface alter column bridge_constr_element_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_thematic_surface alter column lod2_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_thematic_surface alter column lod3_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_thematic_surface alter column lod4_multi_surface_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column bridge_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column lod1_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column lod2_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column lod3_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column lod4_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column lod1_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column lod2_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column lod3_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.bridge_constr_element alter column lod4_implicit_rep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.address_to_bridge alter column bridge_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.address_to_bridge alter column address_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobject alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.appearance alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.appearance alter column citymodel_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.appearance alter column cityobject_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.implicit_geometry alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.implicit_geometry alter column relative_brep_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.surface_geometry alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.surface_geometry alter column parent_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.surface_geometry alter column root_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.surface_geometry alter column cityobject_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.address alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.surface_data alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.surface_data alter column tex_image_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.citymodel alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobject_genericattrib alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobject_genericattrib alter column parent_genattrib_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobject_genericattrib alter column root_genattrib_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobject_genericattrib alter column surface_geometry_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.cityobject_genericattrib alter column cityobject_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.external_reference alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.external_reference alter column cityobject_id type bigint';
      EXECUTE 'alter table ' || schema_name || '.tex_image alter column id type bigint';
      EXECUTE 'alter table ' || schema_name || '.grid_coverage alter column id type bigint';
    END LOOP;
  END IF;
END
$$;

-- recreate delete and envelope functions for every database schema
\ir ../../SCHEMA/DELETE/DELETE.sql
\ir ../../SCHEMA/ENVELOPE/ENVELOPE.sql

DO $$
DECLARE
  schema_name text;
  _sql text;
  func_definition text;
BEGIN
  FOR schema_name in SELECT nspname AS schema_name FROM pg_catalog.pg_class c
                JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
                WHERE c.relname = 'database_srs' AND c.relkind = 'r' AND nspname <> 'citydb'
  LOOP
	FOR func_definition in SELECT REPLACE(pg_get_functiondef(oid),'citydb.', concat(schema_name, '.')) as func_definition FROM pg_proc where pronamespace = 'citydb'::regnamespace
	LOOP
	  EXECUTE func_definition;
	END LOOP;
  END LOOP;
END
$$;