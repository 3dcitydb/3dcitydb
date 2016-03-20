-- DELETE.sql
--
-- Authors:     Felix Kunde <felix-kunde@gmx.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              György Hudra <hudra@moss.de>
--
-- Copyright:   (c) 2012-2016  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 3.0.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- All functions are part of the citydb_pkg.schema and DELETE-"Package" 
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                                    | Author
-- 2.4.1     2016-03-20   reset search_path by the end of each function    FKun
-- 2.4.0     2016-01-06   removed dynamic SQL code                         FKun
-- 2.3.0     2015-10-15   changed API for delete_genericattrib             FKun
-- 2.2.0     2015-02-10   added functions                                  FKun
-- 2.1.0     2014-11-07   delete with returning id of deleted features     FKun
-- 2.0.0     2014-10-10   complete revision for 3DCityDB V3                FKun
-- 1.2.0     2013-08-08   extended to all thematic classes                 FKun
--                                                                         GHud
-- 1.1.0     2012-02-22   some performance improvements                    CNag
-- 1.0.0     2011-02-11   release version                                  CNag
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   cleanup_addresses(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   cleanup_appearances(only_global INTEGER DEFAULT 1, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   cleanup_citymodels(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   cleanup_cityobjectgroups(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   cleanup_grid_coverages(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   cleanup_implicit_geometries(clean_apps INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   cleanup_schema(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   cleanup_tex_images(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_address(ad_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_appearance(app_id INTEGER, cleanup INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_breakline_relief(blr INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_bridge(brd_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_bridge_constr_element(brdce_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_bridge_furniture(brdf_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_bridge_installation(brdi_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_bridge_opening(brdo_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_bridge_room(brdr_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER	
*   delete_bridge_them_srf(brdts_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_building(b_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_building_furniture(bf_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_building_installation(bi_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_city_furniture(cf_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_citymodel(cm_id INTEGER, delete_members INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER 
*   delete_cityobject(co_id INTEGER, delete_members INTEGER DEFAULT 0, cleanup INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_cityobject_cascade(co_id INTEGER, cleanup INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_cityobjectgroup(cog_id INTEGER, delete_members INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_external_reference(ref_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_grid_coverage(gc_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_genericattrib(genattrib_id INTEGER, delete_members INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER AS
*   delete_generic_cityobject(gco_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_implicit_geometry(ig_id INTEGER, clean_apps INTEGER := 0 INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_land_use(lu_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_masspoint_relief(mpr_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_opening(o_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_plant_cover(pc_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_raster_relief(rr INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_relief_component(rc_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_relief_feature(rf_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_room(r_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_solitary_veg_obj(svo_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_surface_data(sd_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_surface_geometry(sg_id INTEGER, clean_apps INTEGER := 0 INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_thematic_surface(ts_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_tin_relief(tr INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_traffic_area(ta_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_transport_complex(tc_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_tunnel(tun_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_tunnel_furniture(tunf_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_tunnel_hollow_space(tunhs_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_tunnel_installation(tuni_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_tunnel_opening(tuno_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_tunnel_them_srf(tuntd_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_waterbnd_surface(wbs_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_waterbody(wb_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   intern_delete_cityobject(co_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   intern_delete_surface_geometry(sg_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
******************************************************************/

/*
delete from CITY_OBJECT
*/
CREATE OR REPLACE FUNCTION citydb_pkg.intern_delete_cityobject(
  co_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT; 
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);
  
  --// PRE DELETE CITY OBJECT //--
  -- delete reference to city model
  DELETE FROM cityobject_member WHERE cityobject_id = co_id;

  -- delete reference to city object group
  DELETE FROM group_to_cityobject WHERE cityobject_id = co_id;

  -- delete reference to generalization
  DELETE FROM generalization WHERE generalizes_to_id = co_id;
  DELETE FROM generalization WHERE cityobject_id = co_id;

  -- delete external references of city object
  DELETE FROM external_reference WHERE cityobject_id = co_id;

  -- delete generic attributes of city object
  DELETE FROM cityobject_genericattrib WHERE cityobject_id = co_id;
  UPDATE cityobjectgroup SET parent_cityobject_id = NULL WHERE parent_cityobject_id = co_id;

  -- delete local appearances of city object
  PERFORM citydb_pkg.delete_appearance(id, 0, schema_name) FROM appearance WHERE cityobject_id = co_id;

  --// DELETE CITY OBJECT //--
  DELETE FROM cityobject WHERE id = co_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'intern_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from SURFACE_GEOMETRY
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_geometry(
  sg_id INTEGER,
  clean_apps INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  surface_geometry_rec INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR surface_geometry_rec IN 
    WITH RECURSIVE geometry(id, parent_id, level) AS (
      SELECT sg.id, sg.parent_id, 1 AS level FROM surface_geometry sg WHERE sg.id = sg_id
    UNION ALL
      SELECT sg.id, sg.parent_id, g.level + 1 AS level FROM surface_geometry sg, geometry g WHERE sg.parent_id = g.id
    )
    SELECT id FROM geometry ORDER BY level DESC
  LOOP 			  
    DELETE FROM textureparam WHERE surface_geometry_id = surface_geometry_rec;
    DELETE FROM surface_geometry WHERE id = surface_geometry_rec RETURNING id INTO deleted_id;
	RETURN NEXT deleted_id;
  END LOOP;

  IF clean_apps <> 0 THEN
    PERFORM citydb_pkg.cleanup_appearances(0, schema_name);
  END IF;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_surface_geometry (id: %): %', sg_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;


/*
delete from IMPLICIT_GEOMETRY
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometry(
  ig_id INTEGER,
  clean_apps INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  rel_brep_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE IMPLICIT GEOMETRY //--
  -- get relative_geometry_id
  SELECT relative_brep_id INTO rel_brep_id FROM implicit_geometry WHERE id = ig_id;

  --// DELETE IMPLICIT GEOMETRY //--
  DELETE FROM implicit_geometry WHERE id = ig_id RETURNING id INTO deleted_id;

  --// POST DELETE IMPLICIT GEOMETRY //--
  -- delete geometry
  IF rel_brep_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(rel_brep_id, clean_apps, schema_name);
  END IF;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_implicit_geometry (id: %): %', ig_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from GRID_COVERAGE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_grid_coverage(
  gc_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  DELETE FROM grid_coverage WHERE id = gc_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_grid_coverage (id: %): %', gc_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from CITYOBJECT_GENERICATTRIB
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_genericattrib(
  genattrib_id INTEGER,
  delete_members INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  genattrib_parent_id INTEGER;
  data_type INTEGER;
  member_id INTEGER;
  member_rec RECORD;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  -- get parent_id and data type
  SELECT parent_genattrib_id, datatype INTO genattrib_parent_id, data_type
    FROM cityobject_genericattrib WHERE id = genattrib_id;

  --// PRE DELETE CITYOBJECT_GENERICATTRIB //--
  -- if the attribute to be deleted is a set, first handle nested attributes
  IF data_type = 7 THEN
    IF delete_members <> 0 THEN
      -- recursive delete of nested attributes
      FOR member_id IN
        WITH RECURSIVE parts AS (
          SELECT id FROM cityobject_genericattrib 
            WHERE parent_genattrib_id = genattrib_id
          UNION ALL
            SELECT part.id FROM cityobject_genericattrib part, parts p 
              WHERE part.parent_genattrib_id = p.id
        ) SELECT id FROM parts
      LOOP
        DELETE FROM cityobject_genericattrib WHERE id = member_id;
      END LOOP;
    ELSE
      -- recursive update of nested attributes
      FOR member_rec IN
        WITH RECURSIVE parts (id, parent_id, root_id) AS (
           SELECT id, genattrib_parent_id::integer AS parent_id, 
             CASE WHEN root_genattrib_id = genattrib_id THEN id ELSE root_genattrib_id END AS root_id
             FROM cityobject_genericattrib WHERE parent_genattrib_id = genattrib_id
           UNION ALL
             SELECT part.id, part.parent_genattrib_id AS parent_id, p.root_id FROM cityobject_genericattrib part, parts p 
               WHERE part.parent_genattrib_id = p.id
        )
        SELECT id, parent_id, root_id FROM parts
      LOOP
        UPDATE cityobject_genericattrib SET 
          parent_genattrib_id = member_rec.parent_id, root_genattrib_id = member_rec.root_id 
          WHERE id = member_rec.id;
      END LOOP;
    END IF;
  END IF;

  --// DELETE CITYOBJECT_GENERICATTRIB //--
  DELETE FROM cityobject_genericattrib WHERE id = genattrib_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_genericattrib (id: %): %', genattrib_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from EXTERNAL_REFERENCE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_external_reference(
  ref_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  DELETE FROM external_reference WHERE id = ref_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_external_reference (id: %): %', ref_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from APPEARANCE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(
  app_id INTEGER,
  cleanup INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE APPEARANCE //--
  -- delete surface data not being referenced by appearances any more
  PERFORM 'WITH get_ref_surface_data AS (
    SELECT surface_data_id FROM appear_to_surface_data
      WHERE appearance_id = app_id
  ), ref_to_other_app AS (
    SELECT a2sd.surface_data_id FROM appear_to_surface_data a2sd, get_ref_surface_data g
      WHERE a2sd.surface_data_id = g.surface_data_id AND appearance_id <> app_id
  )
  SELECT citydb_pkg.delete_surface_data(surface_data_id, schema_name) 
    FROM get_ref_surface_data WHERE NOT EXISTS
      (SELECT surface_data_id FROM ref_to_other_app)';

  -- delete references to surface data
  DELETE FROM appear_to_surface_data WHERE appearance_id = app_id;
  
  --// DELETE APPEARANCE //--
  DELETE FROM appearance WHERE id = app_id RETURNING id INTO deleted_id;

  IF cleanup <> 0 THEN
    -- delete tex images not referenced by surface data any more
    PERFORM citydb_pkg.cleanup_tex_images(schema_name); 
  END IF;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_appearance (id: %): %', app_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from SURFACE_DATA
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_data(
  sd_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE SURFACE DATA //--
  -- delete texture params
  DELETE FROM textureparam WHERE surface_data_id = sd_id;

  -- delete references to appearance
  DELETE FROM appear_to_surface_data WHERE surface_data_id = sd_id;

  --// DELETE SURFACE DATA //--
  DELETE FROM surface_data WHERE id = sd_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  -- to delete entries in TEX_IMAGE table use citydb_pkg.cleanup_tex_images('schema_name')

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_surface_data (id: %): %', sd_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from ADDRESS
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_address(
  ad_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE ADDRESS //--
  -- delete reference to building
  DELETE FROM address_to_building WHERE address_id = ad_id;

  -- delete reference to bridge
  DELETE FROM address_to_bridge WHERE address_id = ad_id;

  -- delete reference to opening
  UPDATE opening SET address_id = NULL WHERE address_id = ad_id;

  -- delete reference to bridge_opening
  UPDATE bridge_opening SET address_id = NULL WHERE address_id = ad_id;

  --// DELETE ADDRESS //--
  DELETE FROM address WHERE id = ad_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_address (id: %): %', ad_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from LAND_USE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_land_use(
  lu_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  lu_lod0_id INTEGER;
  lu_lod1_id INTEGER;
  lu_lod2_id INTEGER;
  lu_lod3_id INTEGER;
  lu_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE LAND USE //--
  -- get reference ids to surface_geometry table
  SELECT lod0_multi_surface_id, lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id
    INTO lu_lod0_id, lu_lod1_id, lu_lod2_id, lu_lod3_id, lu_lod4_id
    FROM land_use WHERE id = lu_id;

  --// DELETE LAND USE //--
  DELETE FROM land_use WHERE id = lu_id RETURNING id INTO deleted_id;

  --// POST DELETE LAND USE //--
  -- delete geometry
  IF lu_lod0_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(lu_lod0_id, 0, schema_name);
  END IF;
  IF lu_lod1_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(lu_lod1_id, 0, schema_name);
  END IF;
  IF lu_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(lu_lod2_id, 0, schema_name);
  END IF;
  IF lu_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(lu_lod3_id, 0, schema_name);
  END IF;
  IF lu_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(lu_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(lu_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_land_use (id: %): %', lu_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from GENERIC_CITYOBJECT
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_generic_cityobject(
  gco_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  gco_lod0_id INTEGER;
  gco_lod1_id INTEGER;
  gco_lod2_id INTEGER;
  gco_lod3_id INTEGER;
  gco_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE GENERIC CITY OBJECT //--
  -- get reference ids to surface_geometry table
  SELECT lod0_brep_id, lod1_brep_id, lod2_brep_id, lod3_brep_id, lod4_brep_id
    INTO gco_lod0_id, gco_lod1_id, gco_lod2_id, gco_lod3_id, gco_lod4_id
    FROM generic_cityobject WHERE id = gco_id;

  --// DELETE GENERIC CITY OBJECT //--
  DELETE FROM generic_cityobject WHERE id = gco_id RETURNING id INTO deleted_id;

  --// POST DELETE GENERIC CITY OBJECT //--
  -- delete geometry
  IF gco_lod0_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(gco_lod0_id, 0, schema_name);
  END IF;
  IF gco_lod1_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(gco_lod1_id, 0, schema_name);
  END IF;
  IF gco_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(gco_lod2_id, 0, schema_name);
  END IF;
  IF gco_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(gco_lod3_id, 0, schema_name);
  END IF;
  IF gco_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(gco_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(gco_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_generic_cityobject (id: %): %', gco_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from SOLITARY_VEGETAT_OBJECT
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_solitary_veg_obj(
  svo_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  svo_lod1_id INTEGER;
  svo_lod2_id INTEGER;
  svo_lod3_id INTEGER;
  svo_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE SOLITARY VEGETATION OBJECT //--
  -- get reference ids to surface_geometry table  
  SELECT lod1_brep_id , lod2_brep_id, lod3_brep_id, lod4_brep_id
    INTO svo_lod1_id, svo_lod2_id, svo_lod3_id, svo_lod4_id
      FROM solitary_vegetat_object WHERE id = svo_id;

  --// DELETE SOLITARY VEGETATION OBJECT //--
  DELETE FROM solitary_vegetat_object WHERE id = svo_id RETURNING id INTO deleted_id;

  --// POST DELETE SOLITARY VEGETATION OBJECT //--
  -- delete geometry
  IF svo_lod1_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(svo_lod1_id, 0, schema_name);
  END IF; 
  IF svo_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(svo_lod2_id, 0, schema_name);
  END IF;
  IF svo_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(svo_lod3_id, 0, schema_name);
  END IF;
  IF svo_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(svo_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(svo_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_solitary_veg_obj (id: %): %', svo_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from PLANT_COVER
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_plant_cover(
  pc_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  pc_lod1_msrf_id INTEGER;
  pc_lod2_msrf_id INTEGER;
  pc_lod3_msrf_id INTEGER;
  pc_lod4_msrf_id INTEGER;
  pc_lod1_msolid_id INTEGER;
  pc_lod2_msolid_id INTEGER;
  pc_lod3_msolid_id INTEGER;
  pc_lod4_msolid_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE PLANT COVER //--
  -- get reference ids to surface_geometry table  
  SELECT lod1_multi_surface_id , lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id,
         lod1_multi_solid_id , lod2_multi_solid_id, lod3_multi_solid_id, lod4_multi_solid_id
    INTO pc_lod1_msrf_id, pc_lod2_msrf_id, pc_lod3_msrf_id, pc_lod4_msrf_id, 
         pc_lod1_msolid_id, pc_lod2_msolid_id, pc_lod3_msolid_id, pc_lod4_msolid_id
    FROM plant_cover WHERE id = pc_id;

  --// DELETE PLANT COVER //--
  DELETE FROM plant_cover WHERE id = pc_id RETURNING id INTO deleted_id;

  --// POST DELETE PLANT COVER //--
  -- delete geometry
  IF pc_lod1_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(pc_lod1_msrf_id, 0, schema_name);
  END IF;
  IF pc_lod2_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(pc_lod2_msrf_id, 0, schema_name);
  END IF;
  IF pc_lod3_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(pc_lod3_msrf_id, 0, schema_name);
  END IF;
  IF pc_lod4_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(pc_lod4_msrf_id, 0, schema_name);
  END IF;
  IF pc_lod1_msolid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(pc_lod1_msolid_id, 0, schema_name);
  END IF;
  IF pc_lod2_msolid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(pc_lod2_msolid_id, 0, schema_name);
  END IF;
  IF pc_lod3_msolid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(pc_lod3_msolid_id, 0, schema_name);
  END IF;
  IF pc_lod4_msolid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(pc_lod4_msolid_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(pc_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_plant_cover (id: %): %', pc_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from WATERBODY
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_waterbody(
  wb_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  wb_lod0_msrf_id INTEGER;
  wb_lod1_msrf_id INTEGER;
  wb_lod1_solid_id INTEGER;
  wb_lod2_solid_id INTEGER;
  wb_lod3_solid_id INTEGER;
  wb_lod4_solid_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE WATERBODY //--
  -- delete water boundary surfaces being not referenced from waterbodies any more
  PERFORM 'WITH get_ref_surface AS (
    SELECT waterboundary_surface_id FROM waterbod_to_waterbnd_srf
      WHERE waterbody_id = wb_id
  ), ref_to_other_waterbody AS (
    SELECT wb2wbs.waterboundary_surface_id FROM waterbod_to_waterbnd_srf wb2wbs, get_ref_surface g
      WHERE wb2wbs.waterboundary_surface_id = g.waterboundary_surface_id AND waterbody_id <> wb_id
  )
  SELECT citydb_pkg.delete_waterbnd_surface(waterboundary_surface_id, schema_name) 
    FROM get_ref_surface WHERE NOT EXISTS
      (SELECT surface_data_id FROM ref_to_other_waterbody)';
	  
  -- delete reference to water boundary surface 
  DELETE FROM waterbod_to_waterbnd_srf WHERE waterbody_id = wb_id;

  -- get reference ids to surface_geometry table
  SELECT lod0_multi_surface_id, lod1_multi_surface_id, 
         lod1_solid_id , lod2_solid_id, lod3_solid_id, lod4_solid_id
    INTO wb_lod0_msrf_id, wb_lod1_msrf_id, 
         wb_lod1_solid_id, wb_lod2_solid_id, wb_lod3_solid_id, wb_lod4_solid_id
    FROM waterbody WHERE id = wb_id;

  --// DELETE WATERBODY //--
  DELETE FROM waterbody WHERE id = wb_id RETURNING id INTO deleted_id;

  --// POST DELETE WATERBODY //--
  -- delete geometry
  IF wb_lod0_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wb_lod0_msrf_id, 0, schema_name);
  END IF;
  IF wb_lod1_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wb_lod1_msrf_id, 0, schema_name);
  END IF;
  IF wb_lod1_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wb_lod1_solid_id, 0, schema_name);
  END IF;
  IF wb_lod2_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wb_lod2_solid_id, 0, schema_name);
  END IF;
  IF wb_lod3_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wb_lod3_solid_id, 0, schema_name);
  END IF;
  IF wb_lod4_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wb_lod4_solid_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(wb_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_waterbody (id: %): %', wb_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from WATER BOUNDARY SURFACE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_waterbnd_surface(
  wbs_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  wbs_lod2_id INTEGER;
  wbs_lod3_id INTEGER;
  wbs_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE WATER BOUNDARY SURFACE //--
  -- get reference ids to surface_geometry table
  SELECT lod2_surface_id, lod3_surface_id, lod4_surface_id
    INTO wbs_lod2_id, wbs_lod3_id, wbs_lod4_id
    FROM waterboundary_surface WHERE id = wbs_id; 

  -- delete reference to waterbody
  DELETE FROM waterbod_to_waterbnd_srf WHERE waterboundary_surface_id = wbs_id;

  --// DELETE WATER BOUNDARY SURFACE //--
  DELETE FROM waterboundary_surface WHERE id = wbs_id RETURNING id INTO deleted_id;
  
  --// POST DELETE WATER BOUNDARY SURFACE //--
  -- delete geometry
  IF wbs_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wbs_lod2_id, 0, schema_name);
  END IF;
  IF wbs_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wbs_lod3_id, 0, schema_name);
  END IF;
  IF wbs_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(wbs_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(wbs_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_waterbnd_surface (id: %): %', wbs_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from RELIEF_FEATURE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_relief_feature(
  rf_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE RELIEF FEATURE //--
  -- delete relief component(s) being not referenced from relief fetaures any more
  PERFORM 'WITH get_ref_component AS (
    SELECT relief_component_id FROM relief_feat_to_rel_comp
      WHERE relief_feature_id = rf_id
  ), ref_to_other_feature AS (
    SELECT rf2rc.relief_component_id FROM relief_feat_to_rel_comp rf2rc, get_ref_component g
      WHERE rf2rc.relief_component_id = g.relief_component_id AND relief_feature_id <> rf_id
  )
  SELECT citydb_pkg.delete_relief_component(relief_component_id, schema_name) 
    FROM get_ref_component WHERE NOT EXISTS
      (SELECT relief_component_id FROM ref_to_other_waterbody)';

  -- delete reference to relief_component
  DELETE FROM relief_feat_to_rel_comp WHERE relief_feature_id = rf_id;

  --// DELETE RELIEF FEATURE //--
  DELETE FROM relief_feature WHERE id = rf_id RETURNING id INTO deleted_id;

  --// POST DELETE RELIEF FEATURE //--
  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(rf_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_relief_feature (id: %): %', rf_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from RELIEF_COMPONENT
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_relief_component(
  rc_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE RELIEF COMPONENT //--
  -- delete reference to relief feature
  DELETE FROM relief_feat_to_rel_comp WHERE relief_component_id = rc_id;

  -- delete component
  PERFORM citydb_pkg.delete_masspoint_relief(rc_id, schema_name);
  PERFORM citydb_pkg.delete_breakline_relief(rc_id, schema_name);
  PERFORM citydb_pkg.delete_tin_relief(rc_id, schema_name);
  PERFORM citydb_pkg.delete_raster_relief(rc_id, schema_name);

  --// DELETE RELIEF COMPONENT //--
  DELETE FROM relief_component WHERE id = rc_id RETURNING id INTO deleted_id;

  --// POST DELETE RELIEF FEATURE //--
  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(rc_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_relief_component (id: %): %', rc_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from MASSPOINT_RELIEF
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_masspoint_relief(
  mpr_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// DELETE MASSPOINT RELIEF //--
  DELETE FROM masspoint_relief WHERE id = mpr_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_masspoint_relief (id: %): %', mpr_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BREAKLINE_RELIEF
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_breakline_relief(
  blr_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// DELETE BREAKLINE RELIEF //--
  DELETE FROM breakline_relief WHERE id = blr_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_breakline_relief (id: %): %', blr_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TIN_RELIEF
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tin_relief(
  tr_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  geom_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TIN RELIEF //--
  -- get reference id to surface_geometry table
  SELECT surface_geometry_id INTO geom_id FROM tin_relief WHERE id = tr_id;

  --// DELETE TIN RELIEF //--
  DELETE FROM tin_relief WHERE id = tr_id RETURNING id INTO deleted_id;

  --// POST DELETE TIN RELIEF //--
  -- delete geometry
  PERFORM citydb_pkg.delete_surface_geometry(geom_id, 0, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tin_relief (id: %): %', tr_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from RASTER_RELIEF
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_raster_relief(
  rr_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  cov_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE RATSER RELIEF //--
  -- get reference id to raster_relief_georaster table
  SELECT coverage_id INTO cov_id FROM raster_relief WHERE id = rr_id;

  --// DELETE RATSER RELIEF //--
  DELETE FROM raster_relief WHERE id = rr_id RETURNING id INTO deleted_id;

  --// POST DELETE RATSER RELIEF //--
  -- delete raster data
  PERFORM citydb_pkg.delete_grid_coverage(cov_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
	WHEN OTHERS THEN
      RAISE NOTICE 'delete_raster_relief (id: %): %', rr_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from CITY_FURNITURE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_city_furniture(
  cf_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  cf_lod1_id INTEGER;
  cf_lod2_id INTEGER;
  cf_lod3_id INTEGER;
  cf_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE CITY_FURNITURE //--
  -- get reference ids to surface_geometry table
  SELECT lod1_brep_id, lod2_brep_id, lod3_brep_id, lod4_brep_id
    INTO cf_lod1_id, cf_lod2_id, cf_lod3_id, cf_lod4_id
    FROM city_furniture WHERE id = cf_id;

  --// DELETE CITY_FURNITURE //--
  DELETE FROM city_furniture WHERE id = cf_id RETURNING id INTO deleted_id;

  --// POST DELETE CITY_FURNITURE //--
  -- delete geometry
  IF cf_lod1_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(cf_lod1_id, 0, schema_name);
  END IF; 
  IF cf_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(cf_lod2_id, 0, schema_name);
  END IF;
  IF cf_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(cf_lod3_id, 0, schema_name);
  END IF;
  IF cf_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(cf_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(cf_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_city_furniture (id: %): %', cf_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from CITYOBJECTGROUP
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobjectgroup(
  cog_id INTEGER,
  delete_members INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  geom_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE CITY OBJECT GROUP //--
  -- delete members
  IF delete_members <> 0 THEN
    PERFORM citydb_pkg.delete_cityobject(cityobject_id, delete_members, 0, schema_name)
      FROM group_to_cityobject WHERE cityobjectgroup_id = cog_id;

    -- cleanup
    PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
    PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  END IF;

  -- delete reference to city object
  DELETE FROM group_to_cityobject WHERE cityobjectgroup_id = cog_id;

  -- get reference id to surface_geometry table  
  SELECT brep_id INTO geom_id FROM cityobjectgroup WHERE id = cog_id;

  --// DELETE CITY OBJECT GROUP //--
  DELETE FROM cityobjectgroup WHERE id = cog_id RETURNING id INTO deleted_id;

  --// POST DELETE CITY OBJECT GROUP //--
  -- delete geometry
  IF geom_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(geom_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(cog_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobjectgroup (id: %): %', cog_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BUILDING
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_building(
  b_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  b_lod0_foot_id INTEGER;
  b_lod0_roof_id INTEGER;
  b_lod1_msrf_id INTEGER;
  b_lod2_msrf_id INTEGER;
  b_lod3_msrf_id INTEGER;
  b_lod4_msrf_id INTEGER;
  b_lod1_solid_id INTEGER;
  b_lod2_solid_id INTEGER;
  b_lod3_solid_id INTEGER;
  b_lod4_solid_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BUILDING //--
  -- delete referenced building part(s)
  PERFORM citydb_pkg.delete_building(id, schema_name) 
    FROM building WHERE id != b_id AND building_parent_id = b_id; 

  -- delete referenced building installation(s)
  PERFORM citydb_pkg.delete_building_installation(id, schema_name) 
    FROM building_installation WHERE building_id = b_id;

  -- delete referenced thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surface(id, schema_name) 
    FROM thematic_surface WHERE building_id = b_id;

  -- delete referenced room(s)
  PERFORM citydb_pkg.delete_room(id, schema_name) 
    FROM room WHERE building_id = b_id;

  -- delete address(es) being not referenced from buildings any more
  PERFORM 'WITH get_ref_address AS (
    SELECT address_id FROM address_to_building
      WHERE building_id = b_id
  ), ref_to_other_building AS (
    SELECT ad2b.address_id FROM address_to_building ad2b, get_ref_address g
      WHERE ad2b.address_id = g.address_id AND building_id <> b_id
  )
  SELECT citydb_pkg.delete_address(address_id, schema_name) 
    FROM get_ref_address WHERE NOT EXISTS
      (SELECT address_id FROM ref_to_other_building)';

  -- delete reference to address
  DELETE FROM address_to_building WHERE building_id = b_id;

  -- get reference ids to surface_geometry table  
  SELECT lod0_footprint_id, lod0_roofprint_id, 
         lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id,
         lod1_solid_id , lod2_solid_id, lod3_solid_id, lod4_solid_id
    INTO b_lod0_foot_id, b_lod0_roof_id, b_lod1_msrf_id, b_lod2_msrf_id, b_lod3_msrf_id, b_lod4_msrf_id,
         b_lod1_solid_id, b_lod2_solid_id, b_lod3_solid_id, b_lod4_solid_id
    FROM building WHERE id = b_id;

  --// DELETE BUILDING //--
  DELETE FROM building WHERE id = b_id RETURNING id INTO deleted_id;

  --// POST DELETE BUILDING //--
  -- delete geometry
  IF b_lod0_foot_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod0_foot_id, 0, schema_name);
  END IF; 
  IF b_lod0_roof_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod0_roof_id, 0, schema_name);
  END IF; 
  IF b_lod1_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod1_msrf_id, 0, schema_name);
  END IF; 
  IF b_lod2_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod2_msrf_id, 0, schema_name);
  END IF;
  IF b_lod3_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod3_msrf_id, 0, schema_name);
  END IF;
  IF b_lod4_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod4_msrf_id, 0, schema_name);
  END IF;
  IF b_lod1_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod1_solid_id, 0, schema_name);
  END IF; 
  IF b_lod2_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod2_solid_id, 0, schema_name);
  END IF;
  IF b_lod3_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod3_solid_id, 0, schema_name);
  END IF;
  IF b_lod4_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(b_lod4_solid_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(b_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_building (id: %): %', b_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BUILDING_INSTALLATION
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_building_installation(
  bi_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  bi_lod2_id INTEGER;
  bi_lod3_id INTEGER;
  bi_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BUILDING INSTALLATION //--
  -- delete referenced thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surface(id, schema_name) 
    FROM thematic_surface WHERE building_installation_id = bi_id;

  -- get reference ids to surface_geometry table 
  SELECT lod2_brep_id, lod3_brep_id, lod4_brep_id
    INTO bi_lod2_id, bi_lod3_id, bi_lod4_id
    FROM building_installation WHERE id = bi_id;

  --// DELETE BUILDING INSTALLATION //--
  DELETE FROM building_installation WHERE id = bi_id RETURNING id INTO deleted_id;

  --// POST DELETE BUILDING INSTALLATION //--
  -- delete geometry
  IF bi_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(bi_lod2_id, 0, schema_name);
  END IF;
  IF bi_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(bi_lod3_id, 0, schema_name);
  END IF;
  IF bi_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(bi_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(bi_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_building_installation (id: %): %', bi_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from THEMATIC_SURFACE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_thematic_surface(
  ts_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  ts_lod2_id INTEGER;
  ts_lod3_id INTEGER;
  ts_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE THEMATIC SURFACE //--
  -- delete opening(s) not being referenced by a thematic surface any more
  PERFORM 'WITH get_ref_opening AS (
    SELECT opening_id FROM opening_to_them_surface
      WHERE thematic_surface_id = ts_id
  ), ref_to_other_surface AS (
    SELECT o2ts.opening_id FROM opening_to_them_surface o2ts, get_ref_opening g
      WHERE o2ts.opening_id = g.opening_id AND thematic_surface_id <> ts_id
  )
  SELECT citydb_pkg.delete_opening(opening_id, schema_name) 
    FROM get_ref_opening WHERE NOT EXISTS
      (SELECT opening_id FROM ref_to_other_surface)';

  -- delete reference to opening
  DELETE FROM opening_to_them_surface WHERE thematic_surface_id = ts_id;

  -- get reference ids to surface_geometry table 
  SELECT lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id
    INTO ts_lod2_id, ts_lod3_id, ts_lod4_id
    FROM thematic_surface WHERE id = ts_id;

  --// DELETE THEMATIC SURFACE //--
  DELETE FROM thematic_surface WHERE id = ts_id RETURNING id INTO deleted_id;

  --// POST DELETE THEMATIC SURFACE //--
  -- delete geometry
  IF ts_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(ts_lod2_id, 0, schema_name);
  END IF;
  IF ts_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(ts_lod3_id, 0, schema_name);
  END IF;
  IF ts_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(ts_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(ts_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_thematic_surface (id: %): %', ts_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from OPENING
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_opening(
  o_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  o_add_id INTEGER;
  o_lod3_id INTEGER;
  o_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE OPENING //--
  -- delete reference to thematic surface
  DELETE FROM opening_to_them_surface WHERE opening_id = o_id;

  -- get reference ids to surface_geometry table and address_id
  SELECT lod3_multi_surface_id, lod4_multi_surface_id, address_id
    INTO o_lod3_id, o_lod4_id, o_add_id
    FROM opening WHERE id = o_id;

  -- delete addresses not being referenced from buildings and openings any more
  IF o_add_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_address(address_id, schema_name) 
      FROM opening WHERE id = o_id AND NOT EXISTS
        (SELECT address_id FROM opening 
           WHERE address_id = o_add_id AND id <> o_id)
      AND NOT EXISTS
        (SELECT address_id FROM address_to_building 
           WHERE address_id = o_add_id);
  END IF;

  --// DELETE OPENING //--
  DELETE FROM opening WHERE id = o_id RETURNING id INTO deleted_id;

  --// POST DELETE OPENING //--
  -- delete geometry
  IF o_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(o_lod3_id, 0, schema_name);
  END IF;
  IF o_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(o_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(o_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_opening (id: %): %', o_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BUILDING_FURNITURE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_building_furniture(
  bf_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  bf_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BUILDING FURNITURE //--
  -- get reference id to surface_geometry table 
  SELECT lod4_brep_id INTO bf_lod4_id 
    FROM building_furniture WHERE id = bf_id;

  --// DELETE BUILDING FURNITURE //--
  DELETE FROM building_furniture WHERE id = bf_id RETURNING id INTO deleted_id;

  --// POST DELETE BUILDING FURNITURE //--
  -- delete geometry
  IF bf_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(bf_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(bf_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_building_furniture (id: %): %', bf_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from ROOM
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_room(
  r_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  r_lod4_msrf_id INTEGER;
  r_lod4_solid_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE ROOM //--
  -- delete referenced building installation(s)
  PERFORM citydb_pkg.delete_building_installation(id, schema_name)
    FROM building_installation WHERE room_id = r_id;

  -- delete referenced thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surface(id, schema_name) 
    FROM thematic_surface WHERE room_id = r_id;
  
  -- delete referenced building furniture
  PERFORM citydb_pkg.delete_building_furniture(id, schema_name) 
    FROM building_furniture WHERE room_id = r_id;

  -- get reference id to surface_geometry table 
  SELECT lod4_multi_surface_id, lod4_solid_id
    INTO r_lod4_msrf_id, r_lod4_solid_id 
    FROM room WHERE id = r_id;
 
  --// DELETE ROOM //--
  DELETE FROM room WHERE id = r_id RETURNING id INTO deleted_id;

  --// POST DELETE ROOM //--
  -- delete geometry
  IF r_lod4_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(r_lod4_msrf_id, 0, schema_name);
  END IF;
  IF r_lod4_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(r_lod4_solid_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(r_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_room (id: %): %', r_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TRANSPORTATION_COMPLEX
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_transport_complex(
  tc_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tc_lod1_id INTEGER;
  tc_lod2_id INTEGER;
  tc_lod3_id INTEGER;
  tc_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TRANSPORTATION COMPLEX //--
  -- delete referenced traffic area(s)
  PERFORM citydb_pkg.delete_traffic_area(id, schema_name) 
    FROM traffic_area WHERE transportation_complex_id = tc_id;

  -- get reference ids to surface_geometry table
  SELECT lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id 
    INTO tc_lod1_id, tc_lod2_id, tc_lod3_id, tc_lod4_id
    FROM transportation_complex WHERE id = tc_id;

  --// DELETE TRANSPORTATION COMPLEX //--
  DELETE FROM transportation_complex WHERE id = tc_id RETURNING id INTO deleted_id;

  --// POST DELETE TRANSPORTATION COMPLEX //--
  -- delete geometry
  IF tc_lod1_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tc_lod1_id, 0, schema_name);
  END IF;
  IF tc_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tc_lod2_id, 0, schema_name);
  END IF;
  IF tc_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tc_lod3_id, 0, schema_name);
  END IF;
  IF tc_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tc_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(tc_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_transport_complex (id: %): %', tc_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TRAFFIC_AREA
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_traffic_area(
  ta_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  ta_lod2_id INTEGER;
  ta_lod3_id INTEGER;
  ta_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TRAFFIC AREA //--
  -- get reference ids to surface_geometry table 
  SELECT lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id 
    INTO ta_lod2_id, ta_lod3_id, ta_lod4_id
    FROM traffic_area WHERE id = ta_id;
			 
  --// DELETE TRAFFIC AREA //--
  DELETE FROM traffic_area WHERE id = ta_id RETURNING id INTO deleted_id;

  --// POST DELETE TRAFFIC AREA //--
  -- delete geometry
  IF ta_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(ta_lod2_id, 0, schema_name);
  END IF;
  IF ta_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(ta_lod3_id, 0, schema_name);
  END IF;
  IF ta_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(ta_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(ta_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_traffic_area (id: %): %', ta_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from CITYMODEL
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_citymodel(
  cm_id INTEGER,
  delete_members INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE CITY MODEL //--
  -- delete members
  IF delete_members <> 0 THEN
    PERFORM citydb_pkg.delete_cityobject(cityobject_id, delete_members, 0, schema_name)
      FROM cityobject_member WHERE citymodel_id = cm_id;

    -- cleanup
    PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
    PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  END IF;
  
  -- delete reference to city objects
  DELETE FROM cityobject_member WHERE citymodel_id = cm_id;

  -- delete appearances assigned to the city model
  PERFORM citydb_pkg.delete_appearance(id, 0, schema_name) FROM appearance WHERE cityobject_id = cm_id;

  --// DELETE CITY MODEL //--
  DELETE FROM citymodel WHERE id = cm_id RETURNING id INTO deleted_id;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_citymodel (id: %): %', cm_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BRIDGE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge(
  brd_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  brd_lod1_msrf_id INTEGER;
  brd_lod2_msrf_id INTEGER;
  brd_lod3_msrf_id INTEGER;
  brd_lod4_msrf_id INTEGER;
  brd_lod1_solid_id INTEGER;
  brd_lod2_solid_id INTEGER;
  brd_lod3_solid_id INTEGER;
  brd_lod4_solid_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BRIDGE //--
  -- delete referenced bridge part(s)
  PERFORM citydb_pkg.delete_bridge(id, schema_name) 
    FROM bridge WHERE id != brd_id AND bridge_parent_id = brd_id; 

  -- delete referenced bridge installation(s)
  PERFORM citydb_pkg.delete_bridge_installation(id, schema_name) 
    FROM bridge_installation WHERE bridge_id = brd_id;

  -- delete referenced bridge construction element(s)
  PERFORM citydb_pkg.delete_bridge_constr_element(id, schema_name) 
    FROM bridge_constr_element WHERE bridge_id = brd_id;

  -- delete referenced bridge thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srf(id, schema_name) 
    FROM bridge_thematic_surface WHERE bridge_id = brd_id;

  -- delete referenced bridge_room(s)
  PERFORM citydb_pkg.delete_bridge_room(id, schema_name) 
    FROM bridge_room WHERE bridge_id = brd_id;

  -- delete address(es) being not referenced from bridges any more
  PERFORM 'WITH get_ref_address AS (
    SELECT address_id FROM address_to_bridge
      WHERE bridge_id = brd_id
  ), ref_to_other_bridge AS (
    SELECT ad2brd.address_id FROM address_to_bridge ad2brd, get_ref_address g
      WHERE ad2brd.address_id = g.address_id AND bridge_id <> brd_id
  )
  SELECT citydb_pkg.delete_address(address_id, schema_name) 
    FROM get_ref_address WHERE NOT EXISTS
      (SELECT address_id FROM ref_to_other_bridge)';

  -- delete reference to address
  DELETE FROM address_to_bridge WHERE bridge_id = brd_id;

  -- get reference ids to surface_geometry table  
  SELECT lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id,
         lod1_solid_id, lod2_solid_id, lod3_solid_id, lod4_solid_id 
    INTO brd_lod1_msrf_id, brd_lod2_msrf_id, brd_lod3_msrf_id, brd_lod4_msrf_id,
         brd_lod1_solid_id, brd_lod2_solid_id, brd_lod3_solid_id, brd_lod4_solid_id 
    FROM bridge WHERE id = brd_id;

  --// DELETE BRIDGE //--
  DELETE FROM bridge WHERE id = brd_id RETURNING id INTO deleted_id;

  --// POST DELETE BRIDGE //--
  -- delete geometry
  IF brd_lod1_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brd_lod1_msrf_id, 0, schema_name);
  END IF; 
  IF brd_lod2_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brd_lod2_msrf_id, 0, schema_name);
  END IF;
  IF brd_lod3_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brd_lod3_msrf_id, 0, schema_name);
  END IF;
  IF brd_lod4_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brd_lod4_msrf_id, 0, schema_name);
  END IF;
  IF brd_lod1_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brd_lod1_solid_id, 0, schema_name);
  END IF; 
  IF brd_lod2_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brd_lod2_solid_id, 0, schema_name);
  END IF;
  IF brd_lod3_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brd_lod3_solid_id, 0, schema_name);
  END IF;
  IF brd_lod4_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brd_lod4_solid_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(brd_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridge (id: %): %', brd_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BRIDGE_INSTALLATION
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_installation(
  brdi_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  brdi_lod2_id INTEGER;
  brdi_lod3_id INTEGER;
  brdi_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BRIDGE INSTALLATION //--
  -- delete referenced bridge thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srf(id, schema_name) 
    FROM bridge_thematic_surface WHERE bridge_installation_id = brdi_id;

  -- get reference ids to surface_geometry table 
  SELECT lod2_brep_id, lod3_brep_id, lod4_brep_id 
    INTO brdi_lod2_id, brdi_lod3_id, brdi_lod4_id
    FROM bridge_installation WHERE id = brdi_id;

  --// DELETE BRIDGE INSTALLATION //--
  DELETE FROM bridge_installation WHERE id = brdi_id RETURNING id INTO deleted_id;

  --// POST DELETE BRIDGE INSTALLATION //--
  -- delete geometry
  IF brdi_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdi_lod2_id, 0, schema_name);
  END IF;
  IF brdi_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdi_lod3_id, 0, schema_name);
  END IF;
  IF brdi_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdi_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(brdi_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridge_installation (id: %): %', brdi_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BRIDGE_THEMATIC_SURFACE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_them_srf(
  brdts_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  brdts_lod2_id INTEGER;
  brdts_lod3_id INTEGER;
  brdts_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BRIDGE THEMATIC SURFACE //--
  -- delete opening(s) not being referenced by a bridge thematic surface any more
  PERFORM 'WITH get_ref_opening AS (
    SELECT bridge_opening_id FROM bridge_open_to_them_srf
      WHERE bridge_thematic_surface_id = brdts_id
  ), ref_to_other_surface AS (
    SELECT brdo2ts.bridge_opening_id FROM bridge_open_to_them_srf brdo2ts, get_ref_opening g
      WHERE brdo2ts.bridge_opening_id = g.bridge_opening_id AND bridge_thematic_surface_id <> brdts_id
  )
  SELECT citydb_pkg.delete_bridge_opening(bridge_opening_id, schema_name) 
    FROM get_ref_opening WHERE NOT EXISTS
      (SELECT bridge_opening_id FROM ref_to_other_surface)';

  -- delete reference to opening
  DELETE FROM bridge_open_to_them_srf WHERE bridge_thematic_surface_id = brdts_id;

  -- get reference ids to surface_geometry table 
  SELECT lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id
    INTO brdts_lod2_id, brdts_lod3_id, brdts_lod4_id
    FROM bridge_thematic_surface WHERE id = brdts_id;

  --// DELETE BRIDGE THEMATIC SURFACE //--
  DELETE FROM bridge_thematic_surface WHERE id = brdts_id RETURNING id INTO deleted_id;

  --// POST DELETE BRIDGE THEMATIC SURFACE //--
  -- delete geometry
  IF brdts_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdts_lod2_id, 0, schema_name);
  END IF;
  IF brdts_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdts_lod3_id, 0, schema_name);
  END IF;
  IF brdts_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdts_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(brdts_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridge_them_srf (id: %): %', brdts_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BRIDGE_OPENING
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_opening(
  brdo_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  brdo_add_id INTEGER;
  brdo_lod3_id INTEGER;
  brdo_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BRIDGE OPENING //--
  -- delete reference to bridge thematic surface
  DELETE FROM bridge_open_to_them_srf WHERE bridge_opening_id = brdo_id;

  -- get reference ids to surface_geometry table and address_id
  SELECT lod3_multi_surface_id, lod4_multi_surface_id, address_id 
    INTO brdo_lod3_id, brdo_lod4_id, brdo_add_id
    FROM bridge_opening WHERE id = brdo_id;

  -- delete addresses not being referenced from bridges and bridge openings any more
  IF brdo_add_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_address(address_id, schema_name) 
      FROM bridge_opening WHERE id = brdo_id AND NOT EXISTS
        (SELECT address_id FROM bridge_opening 
           WHERE address_id = brdo_add_id AND id <> brdo_id)
      AND NOT EXISTS
        (SELECT address_id FROM address_to_bridge 
           WHERE address_id = brdo_add_id);
  END IF;

  --// DELETE BRIDGE OPENING //--
  DELETE FROM bridge_opening WHERE id = brdo_id RETURNING id INTO deleted_id;

  --// POST DELETE BRIDGE OPENING //--
  -- delete geometry
  IF brdo_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdo_lod3_id, 0, schema_name);
  END IF;
  IF brdo_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdo_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(brdo_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridge_opening (id: %): %', brdo_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BRIDGE_FURNITURE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_furniture(
  brdf_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  brdf_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BRIDGE FURNITURE //--
  -- get reference id to surface_geometry table 
  SELECT lod4_brep_id INTO brdf_lod4_id
    FROM bridge_furniture WHERE id = brdf_id;

  --// DELETE BRIDGE FURNITURE //--
  DELETE FROM bridge_furniture WHERE id = brdf_id RETURNING id INTO deleted_id;

  --// POST DELETE BRIDGE FURNITURE //--
  -- delete geometry
  IF brdf_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdf_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(brdf_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridge_furniture (id: %): %', brdf_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BRIDGE_ROOM
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_room(
  brdr_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  brdr_lod4_msrf_id INTEGER;
  brdr_lod4_solid_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BRIDGE ROOM //--
  -- delete referenced bridge installation(s)
  PERFORM citydb_pkg.delete_bridge_installation(id, schema_name) 
    FROM bridge_installation WHERE bridge_room_id = brdr_id;

  -- delete referenced bridge thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srf(id, schema_name)
    FROM bridge_thematic_surface WHERE bridge_room_id = brdr_id;
  
  -- delete referenced bridge furniture
  PERFORM citydb_pkg.delete_bridge_furniture(id, schema_name)
    FROM bridge_furniture WHERE bridge_room_id = brdr_id;

  -- get reference id to surface_geometry table 
  SELECT lod4_multi_surface_id, lod4_solid_id 
    INTO brdr_lod4_msrf_id, brdr_lod4_solid_id
    FROM bridge_room WHERE id = brdr_id;
 
  --// DELETE BRIDGE ROOM //--
  DELETE FROM bridge_room WHERE id = brdr_id RETURNING id INTO deleted_id;

  --// POST DELETE BRIDGE ROOM //--
  -- delete geometry
  IF brdr_lod4_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdr_lod4_msrf_id, 0, schema_name);
  END IF;
  IF brdr_lod4_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdr_lod4_solid_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(brdr_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridge_room (id: %): %', brdr_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from BRIDGE_CONSTR_ELEMENT
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_constr_element(
  brdce_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  brdce_lod1_id INTEGER;
  brdce_lod2_id INTEGER;
  brdce_lod3_id INTEGER;
  brdce_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE BRIDGE CONSTRUCTION ELEMENT //--
  -- delete referenced bridge thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srf(id, schema_name) 
    FROM bridge_thematic_surface WHERE bridge_constr_element_id = brdce_id;

  -- get reference ids to surface_geometry table 
  SELECT lod1_brep_id, lod2_brep_id, lod3_brep_id, lod4_brep_id
    INTO brdce_lod1_id, brdce_lod2_id, brdce_lod3_id, brdce_lod4_id
    FROM bridge_constr_element WHERE id = brdce_id;

  --// DELETE BRIDGE CONSTRUCTION ELEMENT //--
  DELETE FROM bridge_constr_element WHERE id = brdce_id RETURNING id INTO deleted_id;

  --// POST DELETE BRIDGE CONSTRUCTION ELEMENT //--
  -- delete geometry
  IF brdce_lod1_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdce_lod1_id, 0, schema_name);
  END IF;
  IF brdce_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdce_lod2_id, 0, schema_name);
  END IF;
  IF brdce_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdce_lod3_id, 0, schema_name);
  END IF;
  IF brdce_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(brdce_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(brdce_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridge_constr_element (id: %): %', brdce_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TUNNEL
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel(
  tun_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tun_lod1_msrf_id INTEGER;
  tun_lod2_msrf_id INTEGER;
  tun_lod3_msrf_id INTEGER;
  tun_lod4_msrf_id INTEGER;
  tun_lod1_solid_id INTEGER;
  tun_lod2_solid_id INTEGER;
  tun_lod3_solid_id INTEGER;
  tun_lod4_solid_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TUNNEL //--
  -- delete referenced tunnel part(s)
  PERFORM citydb_pkg.delete_tunnel(id, schema_name) 
    FROM tunnel WHERE id != tun_id AND tunnel_parent_id = tun_id; 

  -- delete referenced tunnel installation(s)
  PERFORM citydb_pkg.delete_tunnel_installation(id, schema_name)
    FROM tunnel_installation WHERE tunnel_id = tun_id;

  -- delete referenced tunnel thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srf(id, schema_name)
    FROM tunnel_thematic_surface WHERE tunnel_id = tun_id;

  -- delete referenced tunnel hollow space(s)
  PERFORM citydb_pkg.delete_tunnel_hollow_space(id, schema_name)
    FROM tunnel_hollow_space WHERE tunnel_id = tun_id;

  -- get reference ids to surface_geometry table  
  SELECT lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id,
         lod1_solid_id , lod2_solid_id, lod3_solid_id, lod4_solid_id 
    INTO tun_lod1_msrf_id, tun_lod2_msrf_id, tun_lod3_msrf_id, tun_lod4_msrf_id,
         tun_lod1_solid_id, tun_lod2_solid_id, tun_lod3_solid_id, tun_lod4_solid_id
    FROM tunnel WHERE id = tun_id;

  --// DELETE TUNNEL //--
  DELETE FROM tunnel WHERE id = tun_id RETURNING id INTO deleted_id;

  --// POST DELETE TUNNEL //--
  -- delete geometry
  IF tun_lod1_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tun_lod1_msrf_id, 0, schema_name);
  END IF; 
  IF tun_lod2_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tun_lod2_msrf_id, 0, schema_name);
  END IF;
  IF tun_lod3_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tun_lod3_msrf_id, 0, schema_name);
  END IF;
  IF tun_lod4_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tun_lod4_msrf_id, 0, schema_name);
  END IF;
  IF tun_lod1_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tun_lod1_solid_id, 0, schema_name);
  END IF; 
  IF tun_lod2_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tun_lod2_solid_id, 0, schema_name);
  END IF;
  IF tun_lod3_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tun_lod3_solid_id, 0, schema_name);
  END IF;
  IF tun_lod4_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tun_lod4_solid_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(tun_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnel (id: %): %', tun_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TUNNEL_INSTALLATION
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_installation(
  tuni_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tuni_lod2_id INTEGER;
  tuni_lod3_id INTEGER;
  tuni_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TUNNEL INSTALLATION //--
  -- delete referenced tunnel thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srf(id, schema_name) 
    FROM tunnel_thematic_surface WHERE tunnel_installation_id = tuni_id;

  -- get reference ids to surface_geometry table 
  SELECT lod2_brep_id, lod3_brep_id, lod4_brep_id 
    INTO tuni_lod2_id, tuni_lod3_id, tuni_lod4_id 
    FROM tunnel_installation WHERE id = tuni_id;

  --// DELETE TUNNEL INSTALLATION //--
  DELETE FROM tunnel_installation WHERE id = tuni_id RETURNING id INTO deleted_id;

  --// POST DELETE TUNNEL INSTALLATION //--
  -- delete geometry
  IF tuni_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tuni_lod2_id, 0, schema_name);
  END IF;
  IF tuni_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tuni_lod3_id, 0, schema_name);
  END IF;
  IF tuni_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tuni_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(tuni_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnel_installation (id: %): %', tuni_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TUNNEL_THEMATIC_SURFACE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_them_srf(
  tunts_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tunts_lod2_id INTEGER;
  tunts_lod3_id INTEGER;
  tunts_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TUNNEL THEMATIC SURFACE //--
  -- delete opening(s) not being referenced by a tunnel thematic surface any more
  PERFORM 'WITH get_ref_opening AS (
    SELECT tunnel_opening_id FROM tunnel_open_to_them_srf
      WHERE tunnel_thematic_surface_id = tunts_id
  ), ref_to_other_surface AS (
    SELECT tuno2ts.tunnel_opening_id FROM tunnel_open_to_them_srf tuno2ts, get_ref_opening g
      WHERE tuno2ts.tunnel_opening_id = g.tunnel_opening_id AND tunnel_thematic_surface_id <> tunts_id
  )
  SELECT citydb_pkg.delete_tunnel_opening(tunnel_opening_id, schema_name) 
    FROM get_ref_opening WHERE NOT EXISTS
      (SELECT tunnel_opening_id FROM ref_to_other_surface)';

  -- delete reference to opening
  DELETE FROM tunnel_open_to_them_srf WHERE tunnel_thematic_surface_id = tunts_id;

  -- get reference ids to surface_geometry table 
  SELECT lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id 
    INTO tunts_lod2_id, tunts_lod3_id, tunts_lod4_id
    FROM tunnel_thematic_surface WHERE id = tunts_id;

  --// DELETE TUNNEL THEMATIC SURFACE //--
  DELETE FROM tunnel_thematic_surface WHERE id = tunts_id RETURNING id INTO deleted_id;

  --// POST DELETE TUNNEL THEMATIC SURFACE //--
  -- delete geometry
  IF tunts_lod2_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tunts_lod2_id, 0, schema_name);
  END IF;
  IF tunts_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tunts_lod3_id, 0, schema_name);
  END IF;
  IF tunts_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tunts_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(tunts_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnel_them_srf (id: %): %', tunts_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TUNNEL_OPENING
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_opening(
  tuno_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tuno_lod3_id INTEGER;
  tuno_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TUNNEL OPENING //--
  -- delete reference to tunnel thematic surface
  DELETE FROM tunnel_open_to_them_srf WHERE tunnel_opening_id = tuno_id;

  -- get reference ids to surface_geometry table 
  SELECT lod3_multi_surface_id, lod4_multi_surface_id 
    INTO tuno_lod3_id, tuno_lod4_id
    FROM tunnel_opening WHERE id = tuno_id;

  --// DELETE TUNNEL OPENING //--
  DELETE FROM tunnel_opening WHERE id = tuno_id RETURNING id INTO deleted_id;

  --// POST DELETE TUNNEL OPENING //--
  -- delete geometry
  IF tuno_lod3_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tuno_lod3_id, 0, schema_name);
  END IF;
  IF tuno_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tuno_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(tuno_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnel_opening (id: %): %', tuno_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TUNNEL_FURNITURE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_furniture(
  tunf_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tunf_lod4_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TUNNEL FURNITURE //--
  -- get reference id to surface_geometry table 
  SELECT lod4_brep_id INTO tunf_lod4_id
    FROM tunnel_furniture WHERE id = tunf_id;

  --// DELETE TUNNEL FURNITURE //--
  DELETE FROM tunnel_furniture WHERE id = tunf_id RETURNING id INTO deleted_id;

  --// POST DELETE TUNNEL FURNITURE //--
  -- delete geometry
  IF tunf_lod4_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tunf_lod4_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(tunf_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnel_furniture (id: %): %', tunf_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from TUNNEL_HOLLOW_SPACE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_hollow_space(
  tunhs_id INTEGER, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tunhs_lod4_msrf_id INTEGER;
  tunhs_lod4_solid_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  --// PRE DELETE TUNNEL HOLLOW SPACE //--
  -- delete referenced tunnel installation(s)
  PERFORM citydb_pkg.delete_tunnel_installation(id, schema_name) 
    FROM tunnel_installation WHERE tunnel_hollow_space_id = tunhs_id;

  -- delete referenced tunnel thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srf(id, schema_name) 
    FROM tunnel_thematic_surface WHERE tunnel_hollow_space_id = tunhs_id;
  
  -- delete referenced tunnel furniture
  PERFORM citydb_pkg.delete_tunnel_furniture(id, schema_name) 
    FROM tunnel_furniture WHERE tunnel_hollow_space_id = tunhs_id;

  -- get reference id to surface_geometry table 
  SELECT lod4_multi_surface_id, lod4_solid_id 
    INTO tunhs_lod4_msrf_id, tunhs_lod4_solid_id
    FROM tunnel_hollow_space WHERE id = tunhs_id;
 
  --// DELETE TUNNEL HOLLOW SPACE //--
  DELETE FROM tunnel_hollow_space WHERE id = tunhs_id RETURNING id INTO deleted_id;

  --// POST DELETE TUNNEL HOLLOW SPACE //--
  -- delete geometry
  IF tunhs_lod4_msrf_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tunhs_lod4_msrf_id, 0, schema_name);
  END IF;
  IF tunhs_lod4_solid_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(tunhs_lod4_solid_id, 0, schema_name);
  END IF;

  -- delete city object
  PERFORM citydb_pkg.intern_delete_cityobject(tunhs_id, schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnel_hollow_space (id: %): %', tunhs_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
cleanup procedures
*/
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_implicit_geometries(
  clean_apps INTEGER DEFAULT 0, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  ig_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR ig_id IN 
    SELECT ig.id FROM implicit_geometry ig
      LEFT JOIN bridge_furniture brdf ON brdf.lod4_implicit_rep_id = ig.id
      LEFT JOIN bridge_constr_element brdce1 ON brdce1.lod1_implicit_rep_id = ig.id
      LEFT JOIN bridge_constr_element brdce2 ON brdce1.lod2_implicit_rep_id = ig.id
      LEFT JOIN bridge_constr_element brdce3 ON brdce1.lod3_implicit_rep_id = ig.id
      LEFT JOIN bridge_constr_element brdce4 ON brdce1.lod4_implicit_rep_id = ig.id
      LEFT JOIN bridge_installation brdi1 ON brdi1.lod2_implicit_rep_id = ig.id
      LEFT JOIN bridge_installation brdi2 ON brdi2.lod3_implicit_rep_id = ig.id
      LEFT JOIN bridge_installation brdi3 ON brdi3.lod4_implicit_rep_id = ig.id
      LEFT JOIN bridge_opening brdo1 ON brdo1.lod3_implicit_rep_id = ig.id
      LEFT JOIN bridge_opening brdo2 ON brdo2.lod4_implicit_rep_id = ig.id
      LEFT JOIN building_furniture bf ON bf.lod4_implicit_rep_id = ig.id
      LEFT JOIN building_installation bi1 ON bi1.lod2_implicit_rep_id = ig.id
      LEFT JOIN building_installation bi2 ON bi2.lod3_implicit_rep_id = ig.id
      LEFT JOIN building_installation bi3 ON bi3.lod4_implicit_rep_id = ig.id
      LEFT JOIN city_furniture cf1 ON cf1.lod1_implicit_rep_id = ig.id
      LEFT JOIN city_furniture cf2 ON cf2.lod2_implicit_rep_id = ig.id
      LEFT JOIN city_furniture cf3 ON cf3.lod3_implicit_rep_id = ig.id
      LEFT JOIN city_furniture cf4 ON cf4.lod4_implicit_rep_id = ig.id
      LEFT JOIN generic_cityobject gco0 ON gco0.lod0_implicit_rep_id = ig.id
      LEFT JOIN generic_cityobject gco1 ON gco1.lod1_implicit_rep_id = ig.id
      LEFT JOIN generic_cityobject gco2 ON gco2.lod2_implicit_rep_id = ig.id
      LEFT JOIN generic_cityobject gco3 ON gco3.lod3_implicit_rep_id = ig.id
      LEFT JOIN generic_cityobject gco4 ON gco4.lod4_implicit_rep_id = ig.id
      LEFT JOIN opening o1 ON o1.lod3_implicit_rep_id = ig.id
      LEFT JOIN opening o2 ON o2.lod4_implicit_rep_id = ig.id
      LEFT JOIN solitary_vegetat_object svo1 ON svo1.lod1_implicit_rep_id = ig.id
      LEFT JOIN solitary_vegetat_object svo2 ON svo2.lod2_implicit_rep_id = ig.id
      LEFT JOIN solitary_vegetat_object svo3 ON svo3.lod3_implicit_rep_id = ig.id
      LEFT JOIN solitary_vegetat_object svo4 ON svo4.lod4_implicit_rep_id = ig.id
      LEFT JOIN tunnel_furniture tunf ON tunf.lod4_implicit_rep_id = ig.id
      LEFT JOIN tunnel_installation tuni1 ON tuni1.lod2_implicit_rep_id = ig.id
      LEFT JOIN tunnel_installation tuni2 ON tuni2.lod3_implicit_rep_id = ig.id
      LEFT JOIN tunnel_installation tuni3 ON tuni3.lod4_implicit_rep_id = ig.id
      LEFT JOIN tunnel_opening tuno1 ON tuno1.lod3_implicit_rep_id = ig.id
      LEFT JOIN tunnel_opening tuno2 ON tuno2.lod4_implicit_rep_id = ig.id
        WHERE (brdf.lod4_implicit_rep_id IS NULL)
          AND (brdce1.lod1_implicit_rep_id IS NULL)
          AND (brdce2.lod2_implicit_rep_id IS NULL)
          AND (brdce3.lod3_implicit_rep_id IS NULL)
          AND (brdce4.lod4_implicit_rep_id IS NULL)
          AND (brdi1.lod2_implicit_rep_id IS NULL)
          AND (brdi2.lod3_implicit_rep_id IS NULL)
          AND (brdi3.lod4_implicit_rep_id IS NULL)
          AND (brdo1.lod3_implicit_rep_id IS NULL)
          AND (brdo2.lod4_implicit_rep_id IS NULL)
          AND (bf.lod4_implicit_rep_id IS NULL)
          AND (bi1.lod2_implicit_rep_id IS NULL)
          AND (bi2.lod3_implicit_rep_id IS NULL)
          AND (bi3.lod4_implicit_rep_id IS NULL)
          AND (cf1.lod1_implicit_rep_id IS NULL)
          AND (cf2.lod2_implicit_rep_id IS NULL)
          AND (cf3.lod3_implicit_rep_id IS NULL)
          AND (cf4.lod4_implicit_rep_id IS NULL)
          AND (gco0.lod0_implicit_rep_id IS NULL)
          AND (gco1.lod1_implicit_rep_id IS NULL)
          AND (gco2.lod2_implicit_rep_id IS NULL)
          AND (gco3.lod3_implicit_rep_id IS NULL)
          AND (gco4.lod4_implicit_rep_id IS NULL)
          AND (o1.lod3_implicit_rep_id IS NULL)
          AND (o2.lod4_implicit_rep_id IS NULL)
          AND (svo1.lod1_implicit_rep_id IS NULL)
          AND (svo2.lod2_implicit_rep_id IS NULL)
          AND (svo3.lod3_implicit_rep_id IS NULL)
          AND (svo4.lod4_implicit_rep_id IS NULL)
          AND (tunf.lod4_implicit_rep_id IS NULL)
          AND (tuni1.lod2_implicit_rep_id IS NULL)
          AND (tuni2.lod3_implicit_rep_id IS NULL)
          AND (tuni3.lod4_implicit_rep_id IS NULL)
          AND (tuno1.lod3_implicit_rep_id IS NULL)
          AND (tuno2.lod4_implicit_rep_id IS NULL)
  LOOP
    deleted_id := citydb_pkg.delete_implicit_geometry(ig_id, 0, schema_name);
    RETURN NEXT deleted_id;
  END LOOP;

  IF clean_apps <> 0 THEN
    PERFORM citydb_pkg.cleanup_appearances(0, schema_name);
  END IF;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_implicit_geometries: %', SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_grid_coverages(
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  RETURN QUERY 
    SELECT citydb_pkg.delete_grid_coverage(gc.id, schema_name) FROM grid_coverage gc
      LEFT JOIN raster_relief rr ON rr.grid_coverage_id = gc.id
        WHERE sd.grid_coverage_id IS NULL;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_grid_coverages: %', SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_tex_images(
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  ti_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR ti_id IN SELECT ti.id FROM tex_image ti
                 LEFT JOIN surface_data sd ON sd.tex_image_id = ti.id
                   WHERE sd.tex_image_id IS NULL
  LOOP
    --// DELETE TEX IMAGE //--
    DELETE FROM tex_image WHERE id = ti_id RETURNING id INTO deleted_id;
    RETURN NEXT deleted_id;
  END LOOP;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_tex_images: %', SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_appearances(
  only_global INTEGER DEFAULT 1,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  app_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  -- global appearances are not related to a cityobject.
  -- however, we assume that all surface geometries of a cityobject
  -- have been deleted at this stage. thus, we can check and delete
  -- surface data which does not have a valid texture parameterization
  -- any more.
  PERFORM citydb_pkg.delete_surface_data(s.id, schema_name) FROM surface_data s 
    LEFT OUTER JOIN textureparam t ON s.id = t.surface_data_id 
      WHERE t.surface_data_id IS NULL;

  -- delete appearances which does not have surface data any more
  IF only_global=1 THEN
    FOR app_id IN 
      SELECT a.id FROM appearance a 
        LEFT OUTER JOIN appear_to_surface_data asd ON a.id=asd.appearance_id 
          WHERE a.cityobject_id IS NULL AND asd.appearance_id IS NULL
    LOOP
      deleted_id := citydb_pkg.delete_appearance(app_id, 0, schema_name);
      RETURN NEXT deleted_id;
    END LOOP;
  ELSE
    FOR app_id IN 
      SELECT a.id FROM appearance a 
        LEFT OUTER JOIN appear_to_surface_data asd ON a.id=asd.appearance_id 
          WHERE asd.appearance_id IS NULL
    LOOP
      deleted_id := citydb_pkg.delete_appearance(app_id, 0, schema_name);
      RETURN NEXT deleted_id;
    END LOOP;
  END IF;

  -- delete tex images not referenced by surface data any more
  PERFORM citydb_pkg.cleanup_tex_images(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_appearances: %', SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_addresses(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER AS
$$
DECLARE
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  RETURN QUERY 
    SELECT citydb_pkg.delete_address(ad.id, schema_name) FROM address ad
      LEFT OUTER JOIN address_to_building ad2b ON ad2b.address_id = ad.id
      LEFT OUTER JOIN address_to_bridge ad2brd ON ad2brd.address_id = ad.id
      LEFT OUTER JOIN opening o ON o.address_id = ad.id
      LEFT OUTER JOIN bridge_opening brdo ON brdo.address_id = ad.id
        WHERE ad2b.building_id IS NULL
          AND ad2brd.bridge_id IS NULL
          AND o.address_id IS NULL
          AND brdo.address_id IS NULL;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_addresses: %', SQLERRM;
END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_cityobjectgroups(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER AS
$$
DECLARE
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  RETURN QUERY
    SELECT citydb_pkg.delete_cityobjectgroup(g.id, 0, schema_name) FROM cityobjectgroup g 
      LEFT OUTER JOIN group_to_cityobject gtc ON g.id=gtc.cityobjectgroup_id 
        WHERE gtc.cityobject_id IS NULL;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_cityobjectgroups: %', SQLERRM;
END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_citymodels(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER AS
$$
DECLARE
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  PERFORM set_config('search_path', schema_name, true);

  RETURN QUERY
    SELECT citydb_pkg.delete_citymodel(c.id, 0, schema_name) FROM citymodel c 
      LEFT OUTER JOIN cityobject_member cm ON c.id=cm.citymodel_id 
        WHERE cm.cityobject_id IS NULL;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_citymodels: %', SQLERRM;
END;
$$ 
LANGUAGE plpgsql;


-- generic function to delete any cityobject
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject(
  co_id INTEGER,
  delete_members INTEGER DEFAULT 0,
  cleanup INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  SELECT objectclass_id INTO class_id FROM cityobject WHERE id = co_id;

  -- class_id can be NULL if object has already been deleted
  IF class_id IS NOT NULL THEN
    CASE
      WHEN class_id = 4 THEN deleted_id := citydb_pkg.delete_land_use(co_id, schema_name);
      WHEN class_id = 5 THEN deleted_id := citydb_pkg.delete_generic_cityobject(co_id, schema_name);
      WHEN class_id = 7 THEN deleted_id := citydb_pkg.delete_solitary_veg_obj(co_id, schema_name);
      WHEN class_id = 8 THEN deleted_id := citydb_pkg.delete_plant_cover(co_id, schema_name);
      WHEN class_id = 9 THEN deleted_id := citydb_pkg.delete_waterbody(co_id, schema_name);
      WHEN class_id = 11 OR 
           class_id = 12 OR 
           class_id = 13 THEN deleted_id := citydb_pkg.delete_waterbnd_surface(co_id, schema_name);
      WHEN class_id = 14 THEN deleted_id := citydb_pkg.delete_relief_feature(co_id, schema_name);
      WHEN class_id = 16 OR 
           class_id = 17 OR 
           class_id = 18 OR 
           class_id = 19 THEN deleted_id := citydb_pkg.delete_relief_component(co_id, schema_name);
      WHEN class_id = 21 THEN deleted_id := citydb_pkg.delete_city_furniture(co_id, schema_name);
      WHEN class_id = 23 THEN deleted_id := citydb_pkg.delete_cityobjectgroup(co_id, delete_members, schema_name);
      WHEN class_id = 25 OR 
           class_id = 26 THEN deleted_id := citydb_pkg.delete_building(co_id, schema_name);
      WHEN class_id = 27 OR 
           class_id = 28 THEN deleted_id := citydb_pkg.delete_building_installation(co_id, schema_name);
      WHEN class_id = 30 OR 
           class_id = 31 OR 
           class_id = 32 OR 
           class_id = 33 OR 
           class_id = 34 OR 
           class_id = 35 OR 
           class_id = 36 OR 
           class_id = 60 OR 
           class_id = 61 THEN deleted_id := citydb_pkg.delete_thematic_surface(co_id, schema_name);
      WHEN class_id = 38 OR 
           class_id = 39 THEN deleted_id := citydb_pkg.delete_opening(co_id, schema_name);
      WHEN class_id = 40 THEN deleted_id := citydb_pkg.delete_building_furniture(co_id, schema_name);
      WHEN class_id = 41 THEN deleted_id := citydb_pkg.delete_room(co_id, schema_name);
      WHEN class_id = 43 OR 
           class_id = 44 OR 
           class_id = 45 OR 
           class_id = 46 THEN deleted_id := citydb_pkg.delete_transport_complex(co_id, schema_name);
      WHEN class_id = 47 OR 
           class_id = 48 THEN deleted_id := citydb_pkg.delete_traffic_area(co_id, schema_name);
      WHEN class_id = 63 OR 
           class_id = 64 THEN deleted_id := citydb_pkg.delete_bridge(co_id, schema_name);
      WHEN class_id = 65 OR 
           class_id = 66 THEN deleted_id := citydb_pkg.delete_bridge_installation(co_id, schema_name);
      WHEN class_id = 68 OR 
           class_id = 69 OR 
           class_id = 70 OR 
           class_id = 71 OR 
           class_id = 72 OR 
           class_id = 73 OR 
           class_id = 74 OR 
           class_id = 75 OR 
           class_id = 76 THEN deleted_id := citydb_pkg.delete_bridge_them_srf(co_id, schema_name);
      WHEN class_id = 78 OR 
           class_id = 79 THEN deleted_id := citydb_pkg.delete_bridge_opening(co_id, schema_name);		 
      WHEN class_id = 80 THEN deleted_id := citydb_pkg.delete_bridge_furniture(co_id, schema_name);
      WHEN class_id = 81 THEN deleted_id := citydb_pkg.delete_bridge_room(co_id, schema_name);
      WHEN class_id = 82 THEN deleted_id := citydb_pkg.delete_bridge_constr_element(co_id, schema_name);
      WHEN class_id = 84 OR 
           class_id = 85 THEN deleted_id := citydb_pkg.delete_tunnel(co_id, schema_name);
      WHEN class_id = 86 OR 
           class_id = 87 THEN deleted_id := citydb_pkg.delete_tunnel_installation(co_id, schema_name);
      WHEN class_id = 88 OR 
           class_id = 89 OR 
           class_id = 90 OR 
           class_id = 91 OR 
           class_id = 92 OR 
           class_id = 93 OR 
           class_id = 94 OR 
           class_id = 95 OR 
           class_id = 96 THEN deleted_id := citydb_pkg.delete_tunnel_them_srf(co_id, schema_name);
      WHEN class_id = 99 OR 
           class_id = 100 THEN deleted_id := citydb_pkg.delete_tunnel_opening(co_id, schema_name);
      WHEN class_id = 101 THEN deleted_id := citydb_pkg.delete_tunnel_furniture(co_id, schema_name);
      WHEN class_id = 102 THEN deleted_id := citydb_pkg.delete_tunnel_hollow_space(co_id, schema_name);
      ELSE
        RAISE NOTICE 'Can not delete chosen object with ID % and objectclass_id %.', co_id, class_id;
    END CASE;
  END IF;

  IF cleanup <> 0 THEN
    PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
    PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
    PERFORM citydb_pkg.cleanup_citymodels(schema_name);
  END IF;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


-- delete a cityobject using its foreign key relations
-- NOTE: all constraints have to be set to ON DELETE CASCADE (function: citydb_pkg.update_schema_constraints)
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject_cascade(
  co_id INTEGER,
  cleanup INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  -- delete city object and all entries from other tables referencing the cityobject_id
  DELETE FROM cityobject WHERE id = co_id RETURNING id INTO deleted_id;

  IF cleanup <> 0 THEN
    PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
    PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
    PERFORM citydb_pkg.cleanup_grid_coverages(schema_name);
    PERFORM citydb_pkg.cleanup_addresses(schema_name);
    PERFORM citydb_pkg.cleanup_cityobjectgroups(schema_name);
    PERFORM citydb_pkg.cleanup_citymodels(schema_name);
  END IF;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobject_cascade (id: %): %', co_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


-- truncates all tables
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_schema(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID AS
$$
DECLARE
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  -- clear tables
  TRUNCATE TABLE cityobject CASCADE;
  TRUNCATE TABLE tex_image CASCADE;
  TRUNCATE TABLE grid_coverage CASCADE;
  TRUNCATE TABLE address CASCADE;
  TRUNCATE TABLE citymodel CASCADE;

  -- restart sequences
  ALTER SEQUENCE address_seq RESTART;
  ALTER SEQUENCE appearance_seq RESTART;
  ALTER SEQUENCE citymodel_seq RESTART;
  ALTER SEQUENCE cityobject_genericatt_seq RESTART;
  ALTER SEQUENCE cityobject_seq RESTART;
  ALTER SEQUENCE external_ref_seq RESTART;
  ALTER SEQUENCE grid_coverage_seq RESTART;
  ALTER SEQUENCE implicit_geometry_seq RESTART;
  ALTER SEQUENCE surface_data_seq RESTART;
  ALTER SEQUENCE surface_geometry_seq RESTART;
  ALTER SEQUENCE tex_image_seq RESTART;

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_schema: %', SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;