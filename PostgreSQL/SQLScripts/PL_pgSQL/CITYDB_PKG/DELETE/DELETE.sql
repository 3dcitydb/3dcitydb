-- DELETE.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              György Hudra <hudra@moss.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
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
*   delete_appearance(app_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
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
*   delete_cityobject_cascade(co_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_cityobjectgroup(cog_id INTEGER, delete_members INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   delete_grid_coverage(gc_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
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
*   is_not_referenced(table_name TEXT, check_column TEXT, check_id INTEGER, not_column TEXT, 
*     not_id INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS BOOLEAN
******************************************************************/

/*
helper functions
*/
CREATE OR REPLACE FUNCTION citydb_pkg.is_not_referenced(
  table_name TEXT, 
  check_column TEXT, 
  check_id INTEGER, 
  not_column TEXT, 
  not_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS BOOLEAN AS
$$
DECLARE
  dummy INTEGER;
  is_not_referenced BOOLEAN := false;
BEGIN
  EXECUTE format('SELECT 1 FROM %I.%I WHERE %I = %L AND NOT %I = %L',
                    schema_name, table_name, check_column, check_id, not_column, not_id) INTO dummy;

  IF dummy IS NULL THEN
    is_not_referenced := true;
  END IF;  
  
  RETURN is_not_referenced;
END; 
$$ 
LANGUAGE plpgsql;


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
BEGIN
  --// PRE DELETE CITY OBJECT //--
  -- delete reference to city model
  EXECUTE format('DELETE FROM %I.cityobject_member WHERE cityobject_id = %L', schema_name, co_id);

  -- delete reference to city object group
  EXECUTE format('DELETE FROM %I.group_to_cityobject WHERE cityobject_id = %L', schema_name, co_id);

  -- delete reference to generalization
  EXECUTE format('DELETE FROM %I.generalization WHERE generalizes_to_id = %L', schema_name, co_id);
  EXECUTE format('DELETE FROM %I.generalization WHERE cityobject_id = %L', schema_name, co_id);

  -- delete external references of city object
  EXECUTE format('DELETE FROM %I.external_reference WHERE cityobject_id = %L', schema_name, co_id);

  -- delete generic attributes of city object
  EXECUTE format('DELETE FROM %I.cityobject_genericattrib WHERE cityobject_id = %L', schema_name, co_id);
  EXECUTE format('UPDATE %I.cityobjectgroup SET parent_cityobject_id=null WHERE parent_cityobject_id = %L', schema_name, co_id);

  -- delete local appearances of city object 
  EXECUTE format('SELECT citydb_pkg.delete_appearance(id, %L) FROM %I.appearance WHERE cityobject_id = %L', schema_name, schema_name, co_id);

  --// DELETE CITY OBJECT //--
  EXECUTE format('DELETE FROM %I.cityobject WHERE id = %L RETURNING id', schema_name, co_id) INTO deleted_id;

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
BEGIN
  FOR surface_geometry_rec IN 
    EXECUTE format('WITH RECURSIVE geometry(id, parent_id, level) AS (
                      SELECT sg.id, sg.parent_id, 1 AS level FROM %I.surface_geometry sg WHERE sg.id = %L
                    UNION ALL
                      SELECT sg.id, sg.parent_id, g.level + 1 AS level FROM %I.surface_geometry sg, geometry g WHERE sg.parent_id = g.id
                    )
                    SELECT id FROM geometry ORDER BY level DESC',
                    schema_name, sg_id, schema_name) LOOP 			  
    EXECUTE format('DELETE FROM %I.textureparam WHERE surface_geometry_id = %L', schema_name, surface_geometry_rec);
    EXECUTE format('DELETE FROM %I.surface_geometry WHERE id = %L RETURNING id', schema_name, surface_geometry_rec) INTO deleted_id;
	RETURN NEXT deleted_id;
  END LOOP;

  IF clean_apps <> 0 THEN
    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(0, $1)' USING schema_name;
  END IF;

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
BEGIN
  --// PRE DELETE IMPLICIT GEOMETRY //--
  -- get relative_geometry_id
  EXECUTE format('SELECT relative_brep_id FROM %I.implicit_geometry WHERE id = %L',
                    schema_name, ig_id) INTO rel_brep_id;

  --// DELETE IMPLICIT GEOMETRY //--
  EXECUTE format('DELETE FROM %I.implicit_geometry WHERE id = %L RETURNING id', schema_name, ig_id) INTO deleted_id;

  --// POST DELETE IMPLICIT GEOMETRY //--
  -- delete geometry
  IF rel_brep_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, $2, $3)' USING rel_brep_id, clean_apps, schema_name;
  END IF;

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
BEGIN
  EXECUTE format('DELETE FROM %I.grid_coverage WHERE id = %L RETURNING id', schema_name, gc_id) INTO deleted_id;

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_grid_coverage (id: %): %', gc_id, SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;


/*
delete from APPEARANCE
*/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(
  app_id INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
BEGIN
  --// PRE DELETE APPEARANCE //--
  -- delete surface data not being referenced by appearances any more
  EXECUTE format('SELECT citydb_pkg.delete_surface_data(sd.id, %L) FROM %I.surface_data sd, %I.appear_to_surface_data ats 
                    WHERE sd.id = ats.surface_data_id AND ats.appearance_id = %L
                    AND citydb_pkg.is_not_referenced(%L, %L, sd.id, %L, %L, %L)', 
                    schema_name, schema_name, schema_name, app_id, 
                    'appear_to_surface_data', 'surface_data_id', 'appearance_id', app_id, schema_name);

  -- delete references to surface data
  EXECUTE format('DELETE FROM %I.appear_to_surface_data WHERE appearance_id = %L', schema_name, app_id);
  
  --// DELETE APPEARANCE //--
  EXECUTE format('DELETE FROM %I.appearance WHERE id = %L RETURNING id', schema_name, app_id) INTO deleted_id;

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
BEGIN
  --// PRE DELETE SURFACE DATA //--
  -- delete references to appearance
  EXECUTE format('DELETE FROM %I.appear_to_surface_data WHERE surface_data_id = %L', schema_name, sd_id);

  -- delete texture params
  EXECUTE format('DELETE FROM %I.textureparam WHERE surface_data_id = %L', schema_name, sd_id);

  --// DELETE SURFACE DATA //--
  EXECUTE format('DELETE FROM %I.surface_data WHERE id = %L RETURNING id', schema_name, sd_id) INTO deleted_id;

  -- to delete entries in TEX_IMAGE table use citydb_pkg.cleanup_tex_images('schema_name')

  RETURN deleted_id;

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
BEGIN
  --// PRE DELETE ADDRESS //--
  -- delete reference to building
  EXECUTE format('DELETE FROM %I.address_to_building WHERE address_id = %L', schema_name, ad_id);

  -- delete reference to bridge
  EXECUTE format('DELETE FROM %I.address_to_bridge WHERE address_id = %L', schema_name, ad_id);

  -- delete reference to opening
  EXECUTE format('UPDATE %I.opening SET address_id=null WHERE address_id = %L', schema_name, ad_id);

  -- delete reference to bridge_opening
  EXECUTE format('UPDATE %I.bridge_opening SET address_id=null WHERE address_id = %L', schema_name, ad_id);

  --// DELETE ADDRESS //--
  EXECUTE format('DELETE FROM %I.address WHERE id = %L RETURNING id', schema_name, ad_id) INTO deleted_id;

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
BEGIN
  --// PRE DELETE LAND USE //--
  -- get reference ids to surface_geometry table
  EXECUTE format('SELECT lod0_multi_surface_id, lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id
                    FROM %I.land_use WHERE id = %L', schema_name, lu_id) 
                    INTO lu_lod0_id, lu_lod1_id, lu_lod2_id, lu_lod3_id, lu_lod4_id;

  --// DELETE LAND USE //--
  EXECUTE format('DELETE FROM %I.land_use WHERE id = %L RETURNING id', schema_name, lu_id) INTO deleted_id;

  --// POST DELETE LAND USE //--
  -- delete geometry
  IF lu_lod0_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING lu_lod0_id, schema_name;
  END IF;
  IF lu_lod1_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING lu_lod1_id, schema_name;
  END IF;
  IF lu_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING lu_lod2_id, schema_name;
  END IF;
  IF lu_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING lu_lod3_id, schema_name;
  END IF;
  IF lu_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING lu_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING lu_id, schema_name;

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
BEGIN
  --// PRE DELETE GENERIC CITY OBJECT //--
  -- get reference ids to surface_geometry table
  EXECUTE format('SELECT lod0_brep_id, lod1_brep_id , lod2_brep_id, lod3_brep_id, lod4_brep_id 
                    FROM %I.generic_cityobject WHERE id = %L', schema_name, gco_id)
                    INTO gco_lod0_id, gco_lod1_id, gco_lod2_id, gco_lod3_id, gco_lod4_id;

  --// DELETE GENERIC CITY OBJECT //--
  EXECUTE format('DELETE FROM %I.generic_cityobject WHERE id = %L RETURNING id', schema_name, gco_id) INTO deleted_id;

  --// POST DELETE GENERIC CITY OBJECT //--
  -- delete geometry
  IF gco_lod0_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING gco_lod0_id, schema_name;
  END IF;
  IF gco_lod1_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING gco_lod1_id, schema_name;
  END IF;
  IF gco_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING gco_lod2_id, schema_name;
  END IF;
  IF gco_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING gco_lod3_id, schema_name;
  END IF;
  IF gco_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING gco_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING gco_id, schema_name;

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
BEGIN
  --// PRE DELETE SOLITARY VEGETATION OBJECT //--
  -- get reference ids to surface_geometry table  
  EXECUTE format('SELECT lod1_brep_id , lod2_brep_id, lod3_brep_id, lod4_brep_id
                    FROM %I.solitary_vegetat_object WHERE id = %L', schema_name, svo_id) 
                    INTO svo_lod1_id, svo_lod2_id, svo_lod3_id, svo_lod4_id;

  --// DELETE SOLITARY VEGETATION OBJECT //--
  EXECUTE format('DELETE FROM %I.solitary_vegetat_object WHERE id = %L RETURNING id', schema_name, svo_id) INTO deleted_id;

  --// POST DELETE SOLITARY VEGETATION OBJECT //--
  -- delete geometry
  IF svo_lod1_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING svo_lod1_id, schema_name;
  END IF; 
  IF svo_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING svo_lod2_id, schema_name;
  END IF;
  IF svo_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING svo_lod3_id, schema_name;
  END IF;
  IF svo_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING svo_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING svo_id, schema_name;

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
BEGIN
  --// PRE DELETE PLANT COVER //--
  -- get reference ids to surface_geometry table  
  EXECUTE format('SELECT lod1_multi_surface_id , lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id,
                    lod1_multi_solid_id , lod2_multi_solid_id, lod3_multi_solid_id, lod4_multi_solid_id FROM %I.plant_cover WHERE id = %L', schema_name, pc_id) 
                    INTO pc_lod1_msrf_id, pc_lod2_msrf_id, pc_lod3_msrf_id, pc_lod4_msrf_id, 
                         pc_lod1_msolid_id, pc_lod2_msolid_id, pc_lod3_msolid_id, pc_lod4_msolid_id;

  --// DELETE PLANT COVER //--
  EXECUTE format('DELETE FROM %I.plant_cover WHERE id = %L RETURNING id', schema_name, pc_id) INTO deleted_id;

  --// POST DELETE PLANT COVER //--
  -- delete geometry
  IF pc_lod1_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING pc_lod1_msrf_id, schema_name;
  END IF;
  IF pc_lod2_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING pc_lod2_msrf_id, schema_name;
  END IF;
  IF pc_lod3_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING pc_lod3_msrf_id, schema_name;
  END IF;
  IF pc_lod4_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING pc_lod4_msrf_id, schema_name;
  END IF;
  IF pc_lod1_msolid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING pc_lod1_msolid_id, schema_name;
  END IF;
  IF pc_lod2_msolid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING pc_lod2_msolid_id, schema_name;
  END IF;
  IF pc_lod3_msolid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING pc_lod3_msolid_id, schema_name;
  END IF;
  IF pc_lod4_msolid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING pc_lod4_msolid_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING pc_id, schema_name;

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
BEGIN
  --// PRE DELETE WATERBODY //--
  -- delete water boundary surfaces being not referenced from waterbodies any more
  EXECUTE format('SELECT citydb_pkg.delete_waterbnd_surface(wbs.id, %L) 
                    FROM %I.waterboundary_surface wbs, %I.waterbod_to_waterbnd_srf wb2wbs
                    WHERE wbs.id = wb2wbs.waterboundary_surface_id AND wb2wbs.waterbody_id = %L
                    AND citydb_pkg.is_not_referenced(%L, %L, wbs.id, %L, %L, %L)', 
                    schema_name, schema_name, schema_name, wb_id, 
                    'waterbod_to_waterbnd_srf', 'waterboundary_surface_id', 'waterbody_id', wb_id, schema_name);

  -- delete reference to water boundary surface 
  EXECUTE format('DELETE FROM %I.waterbod_to_waterbnd_srf WHERE waterbody_id = %L', schema_name, wb_id);

  -- get reference ids to surface_geometry table
  EXECUTE format('SELECT lod0_multi_surface_id, lod1_multi_surface_id, 
                    lod1_solid_id , lod2_solid_id, lod3_solid_id, lod4_solid_id 
                    FROM %I.waterbody WHERE id = %L', schema_name, wb_id)   
                    INTO wb_lod0_msrf_id, wb_lod1_msrf_id, wb_lod1_solid_id, wb_lod2_solid_id, wb_lod3_solid_id, wb_lod4_solid_id;

  --// DELETE WATERBODY //--
  EXECUTE format('DELETE FROM %I.waterbody WHERE id = %L RETURNING id', schema_name, wb_id) INTO deleted_id;

  --// POST DELETE WATERBODY //--
  -- delete geometry
  IF wb_lod0_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wb_lod0_msrf_id, schema_name;
  END IF;
  IF wb_lod1_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wb_lod1_msrf_id, schema_name;
  END IF;
  IF wb_lod1_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wb_lod1_solid_id, schema_name;
  END IF;
  IF wb_lod2_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wb_lod2_solid_id, schema_name;
  END IF;
  IF wb_lod3_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wb_lod3_solid_id, schema_name;
  END IF;
  IF wb_lod4_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wb_lod4_solid_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING wb_id, schema_name;

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
BEGIN
  --// PRE DELETE WATER BOUNDARY SURFACE //--
  -- get reference ids to surface_geometry table
  EXECUTE format('SELECT lod2_surface_id, lod3_surface_id, lod4_surface_id 
                    FROM %I.waterboundary_surface WHERE id = %L', schema_name, wbs_id)   
                    INTO wbs_lod2_id, wbs_lod3_id, wbs_lod4_id; 

  -- delete reference to waterbody
  EXECUTE format('DELETE FROM %I.waterbod_to_waterbnd_srf WHERE waterboundary_surface_id = %L', schema_name, wbs_id);

  --// DELETE WATER BOUNDARY SURFACE //--
  EXECUTE format('DELETE FROM %I.waterboundary_surface WHERE id = %L RETURNING id', schema_name, wbs_id) INTO deleted_id;
  
  --// POST DELETE WATER BOUNDARY SURFACE //--
  -- delete geometry
  IF wbs_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wbs_lod2_id, schema_name;
  END IF;
  IF wbs_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wbs_lod3_id, schema_name;
  END IF;
  IF wbs_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING wbs_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING wbs_id, schema_name;

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
BEGIN
  --// PRE DELETE RELIEF FEATURE //--
  -- delete relief component(s) being not referenced from relief fetaures any more
  EXECUTE format('SELECT citydb_pkg.delete_relief_component(rc.id, %L) FROM %I.relief_component rc, %I.relief_feat_to_rel_comp rf2rc
                    WHERE rc.id = rf2rc.relief_component_id AND relief_feature_id = %L
                    AND citydb_pkg.is_not_referenced(%L, %L, rc.id, %L, %L, %L)', 
                    schema_name, schema_name, schema_name, rf_id, 
                    'relief_feat_to_rel_comp', 'relief_component_id', 'relief_feature_id', rf_id, schema_name);

  -- delete reference to relief_component
  EXECUTE format('DELETE FROM %I.relief_feat_to_rel_comp WHERE relief_feature_id = %L', schema_name, rf_id);

  --// DELETE RELIEF FEATURE //--
  EXECUTE format('DELETE FROM %I.relief_feature WHERE id = %L RETURNING id', schema_name, rf_id) INTO deleted_id;

  --// POST DELETE RELIEF FEATURE //--
  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING rf_id, schema_name;

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
BEGIN
  --// PRE DELETE RELIEF COMPONENT //--
  -- delete reference to relief feature
  EXECUTE format('DELETE FROM %I.relief_feat_to_rel_comp WHERE relief_component_id = %L', schema_name, rc_id);

  -- delete component
  EXECUTE 'SELECT citydb_pkg.delete_masspoint_relief($1, $2)' USING rc_id, schema_name;
  EXECUTE 'SELECT citydb_pkg.delete_breakline_relief($1, $2)' USING rc_id, schema_name;
  EXECUTE 'SELECT citydb_pkg.delete_tin_relief($1, $2)' USING rc_id, schema_name;
  EXECUTE 'SELECT citydb_pkg.delete_raster_relief($1, $2)' USING rc_id, schema_name;

  --// DELETE RELIEF COMPONENT //--
  EXECUTE format('DELETE FROM %I.relief_component WHERE id = %L RETURNING id', schema_name, rc_id) INTO deleted_id;

  --// POST DELETE RELIEF FEATURE //--
  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING rc_id, schema_name;

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
BEGIN
  --// DELETE MASSPOINT RELIEF //--
  EXECUTE format('DELETE FROM %I.masspoint_relief WHERE id = %L RETURNING id', schema_name, mpr_id) INTO deleted_id;

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
BEGIN
  --// DELETE BREAKLINE RELIEF //--
  EXECUTE format('DELETE FROM %I.breakline_relief WHERE id = %L RETURNING id', schema_name, blr_id) INTO deleted_id;

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
BEGIN
  --// PRE DELETE TIN RELIEF //--
  -- get reference id to surface_geometry table
  EXECUTE format('SELECT surface_geometry_id FROM %I.tin_relief WHERE id = %L', schema_name, tr_id) INTO geom_id;

  --// DELETE TIN RELIEF //--
  EXECUTE format('DELETE FROM %I.tin_relief WHERE id = %L RETURNING id', schema_name, tr_id) INTO deleted_id;

  --// POST DELETE TIN RELIEF //--
  -- delete geometry
  EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING geom_id, schema_name;

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
BEGIN
  --// PRE DELETE RATSER RELIEF //--
  -- get reference id to raster_relief_georaster table
  EXECUTE format('SELECT coverage_id FROM %I.raster_relief WHERE id = %L', schema_name, rr_id) INTO cov_id;

  --// DELETE RATSER RELIEF //--
  EXECUTE format('DELETE FROM %I.raster_relief WHERE id = %L RETURNING id', schema_name, rr_id) INTO deleted_id;

  --// POST DELETE RATSER RELIEF //--
  -- delete raster data
  EXECUTE 'SELECT citydb_pkg.delete_grid_coverage($1, $2)' USING cov_id, schema_name;

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
BEGIN
  --// PRE DELETE CITY_FURNITURE //--
  -- get reference ids to surface_geometry table
  EXECUTE format('SELECT lod1_brep_id, lod2_brep_id, lod3_brep_id, lod4_brep_id
                    FROM %I.city_furniture WHERE id = %L', schema_name, cf_id)
                    INTO cf_lod1_id, cf_lod2_id, cf_lod3_id, cf_lod4_id;

  --// DELETE CITY_FURNITURE //--
  EXECUTE format('DELETE FROM %I.city_furniture WHERE id = %L RETURNING id', schema_name, cf_id) INTO deleted_id;

  --// POST DELETE CITY_FURNITURE //--
  -- delete geometry
  IF cf_lod1_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING cf_lod1_id, schema_name;
  END IF; 
  IF cf_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING cf_lod2_id, schema_name;
  END IF;
  IF cf_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING cf_lod3_id, schema_name;
  END IF;
  IF cf_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING cf_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING cf_id, schema_name;

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
  member_id INTEGER;
  geom_id INTEGER;
BEGIN
  --// PRE DELETE CITY OBJECT GROUP //--
  -- delete members
  IF delete_members <> 0 THEN
    FOR member_id IN EXECUTE format('SELECT cityobject_id FROM %I.group_to_cityobject WHERE cityobjectgroup_id = %L', 
                                       schema_name, cog_id) LOOP
      BEGIN
        EXECUTE 'SELECT citydb_pkg.delete_cityobject($1, $2, 0, $3)' USING member_id, delete_members, schema_name;

        EXCEPTION
          WHEN OTHERS THEN
            RAISE NOTICE 'delete_cityobjectgroup: deletion of group_member with ID % threw %', member_id, SQLERRM;
      END;
    END LOOP;

    -- cleanup
    EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
  END IF;

  -- delete reference to city object
  EXECUTE format('DELETE FROM %I.group_to_cityobject WHERE cityobjectgroup_id = %L', schema_name, cog_id);

  -- get reference id to surface_geometry table  
  EXECUTE format('SELECT brep_id FROM %I.cityobjectgroup WHERE id = %L', schema_name, cog_id) INTO geom_id;

  --// DELETE CITY OBJECT GROUP //--
  EXECUTE format('DELETE FROM %I.cityobjectgroup WHERE id = %L RETURNING id', schema_name, cog_id) INTO deleted_id;

  --// POST DELETE CITY OBJECT GROUP //--
  -- delete geometry
  IF geom_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING geom_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING cog_id, schema_name;

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
BEGIN
  --// PRE DELETE BUILDING //--
  -- delete referenced building part(s)
  EXECUTE format('SELECT citydb_pkg.delete_building(id, %L) FROM %I.building WHERE id != %L AND building_parent_id = %L', 
                    schema_name, schema_name, b_id, b_id);

  -- delete referenced building installation(s)
  EXECUTE format('SELECT citydb_pkg.delete_building_installation(id, %L) FROM %I.building_installation WHERE building_id = %L', 
                    schema_name, schema_name, b_id);

  -- delete referenced thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_thematic_surface(id, %L) FROM %I.thematic_surface WHERE building_id = %L', 
                    schema_name, schema_name, b_id);

  -- delete referenced room(s)
  EXECUTE format('SELECT citydb_pkg.delete_room(id, %L) FROM %I.room WHERE building_id = %L', 
                    schema_name, schema_name, b_id);

  -- delete address(es) being not referenced from buildings any more
  EXECUTE format('SELECT citydb_pkg.delete_address(ad.id, %L) FROM %I.address ad, %I.address_to_building ad2b 
                    WHERE ad.id = ad2b.address_id AND ad2b.building_id = %L
                    AND citydb_pkg.is_not_referenced(%L, %L, ad.id, %L, %L, %L)', 
                    schema_name, schema_name, schema_name, b_id, 
                    'address_to_building', 'address_id', 'building_id', b_id, schema_name);

  -- delete reference to address
  EXECUTE format('DELETE FROM %I.address_to_building WHERE building_id = %L', schema_name, b_id);

  -- get reference ids to surface_geometry table  
  EXECUTE format('SELECT lod0_footprint_id, lod0_roofprint_id, 
                    lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id,
                    lod1_solid_id , lod2_solid_id, lod3_solid_id, lod4_solid_id FROM %I.building WHERE id = %L', schema_name, b_id)   
                    INTO b_lod0_foot_id, b_lod0_roof_id, b_lod1_msrf_id, b_lod2_msrf_id, b_lod3_msrf_id, b_lod4_msrf_id,
                         b_lod1_solid_id, b_lod2_solid_id, b_lod3_solid_id, b_lod4_solid_id;

  --// DELETE BUILDING //--
  EXECUTE format('DELETE FROM %I.building WHERE id = %L RETURNING id', schema_name, b_id) INTO deleted_id;

  --// POST DELETE BUILDING //--
  -- delete geometry
  IF b_lod0_foot_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod0_foot_id, schema_name;
  END IF; 
  IF b_lod0_roof_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod0_roof_id, schema_name;
  END IF; 
  IF b_lod1_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod1_msrf_id, schema_name;
  END IF; 
  IF b_lod2_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod2_msrf_id, schema_name;
  END IF;
  IF b_lod3_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod3_msrf_id, schema_name;
  END IF;
  IF b_lod4_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod4_msrf_id, schema_name;
  END IF;
  IF b_lod1_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod1_solid_id, schema_name;
  END IF; 
  IF b_lod2_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod2_solid_id, schema_name;
  END IF;
  IF b_lod3_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod3_solid_id, schema_name;
  END IF;
  IF b_lod4_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING b_lod4_solid_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING b_id, schema_name;

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
BEGIN
  --// PRE DELETE BUILDING INSTALLATION //--
  -- delete referenced thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_thematic_surface(id, %L) FROM %I.thematic_surface WHERE building_installation_id = %L', 
                    schema_name, schema_name, bi_id);

  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod2_brep_id, lod3_brep_id, lod4_brep_id 
                    FROM %I.building_installation WHERE id = %L', schema_name, bi_id)
                    INTO bi_lod2_id, bi_lod3_id, bi_lod4_id;

  --// DELETE BUILDING INSTALLATION //--
  EXECUTE format('DELETE FROM %I.building_installation WHERE id = %L RETURNING id', schema_name, bi_id) INTO deleted_id;

  --// POST DELETE BUILDING INSTALLATION //--
  -- delete geometry
  IF bi_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING bi_lod2_id, schema_name;
  END IF;
  IF bi_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING bi_lod3_id, schema_name;
  END IF;
  IF bi_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING bi_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING bi_id, schema_name;

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
BEGIN
  --// PRE DELETE THEMATIC SURFACE //--
  -- delete opening(s) not being referenced by a thematic surface any more
  EXECUTE format('SELECT citydb_pkg.delete_opening(o.id, %L) FROM %I.opening o, %I.opening_to_them_surface o2ts
                    WHERE o.id = o2ts.opening_id AND o2ts.thematic_surface_id = %L
                    AND citydb_pkg.is_not_referenced(%L, %L, o.id, %L, %L, %L)',
                    schema_name, schema_name, schema_name, ts_id, 
                    'opening_to_them_surface', 'opening_id', 'thematic_surface_id', ts_id, schema_name);

  -- delete reference to opening
  EXECUTE format('DELETE FROM %I.opening_to_them_surface WHERE thematic_surface_id = %L', schema_name, ts_id);

  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id 
                    FROM %I.thematic_surface WHERE id = %L', schema_name, ts_id)
                    INTO ts_lod2_id, ts_lod3_id, ts_lod4_id;

  --// DELETE THEMATIC SURFACE //--
  EXECUTE format('DELETE FROM %I.thematic_surface WHERE id = %L RETURNING id', schema_name, ts_id) INTO deleted_id;

  --// POST DELETE THEMATIC SURFACE //--
  -- delete geometry
  IF ts_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING ts_lod2_id, schema_name;
  END IF;
  IF ts_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING ts_lod3_id, schema_name;
  END IF;
  IF ts_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING ts_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING ts_id, schema_name;

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
BEGIN
  --// PRE DELETE OPENING //--
  -- delete reference to thematic surface
  EXECUTE format('DELETE FROM %I.opening_to_them_surface WHERE opening_id = %L', schema_name, o_id);

  -- get reference ids to surface_geometry table and address_id
  EXECUTE format('SELECT lod3_multi_surface_id, lod4_multi_surface_id, address_id 
                    FROM %I.opening WHERE id = %L', schema_name, o_id)
                    INTO o_lod3_id, o_lod4_id, o_add_id;

  -- delete addresses not being referenced from buildings and openings any more
  IF o_add_id IS NOT NULL THEN
    EXECUTE format('SELECT citydb_pkg.delete_address(ad.id, %L) FROM %I.address ad 
                      LEFT OUTER JOIN %I.address_to_building ad2b ON ad.id = ad2b.address_id 
                      WHERE ad.id = %L AND ad2b.address_id IS NULL
                        AND citydb_pkg.is_not_referenced(%L, %L, ad.id, %L, %L, %L)',
                        schema_name, schema_name, schema_name, o_add_id, 
                        'opening', 'address_id', 'id', o_id, schema_name);
  END IF;

  --// DELETE OPENING //--
  EXECUTE format('DELETE FROM %I.opening WHERE id = %L RETURNING id', schema_name, o_id) INTO deleted_id;

  --// POST DELETE OPENING //--
  -- delete geometry
  IF o_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING o_lod3_id, schema_name;
  END IF;
  IF o_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING o_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING o_id, schema_name;

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
BEGIN
  --// PRE DELETE BUILDING FURNITURE //--
  -- get reference id to surface_geometry table 
  EXECUTE format('SELECT lod4_brep_id FROM %I.building_furniture WHERE id = %L', schema_name, bf_id) INTO bf_lod4_id;

  --// DELETE BUILDING FURNITURE //--
  EXECUTE format('DELETE FROM %I.building_furniture WHERE id = %L RETURNING id', schema_name, bf_id) INTO deleted_id;

  --// POST DELETE BUILDING FURNITURE //--
  -- delete geometry
  IF bf_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING bf_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING bf_id, schema_name;

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
BEGIN
  --// PRE DELETE ROOM //--
  -- delete referenced building installation(s)
  EXECUTE format('SELECT citydb_pkg.delete_building_installation(id, %L) FROM %I.building_installation WHERE room_id = %L', 
                    schema_name, schema_name, r_id);

  -- delete referenced thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_thematic_surface(id, %L) FROM %I.thematic_surface WHERE room_id = %L', 
                    schema_name, schema_name, r_id);
  
  -- delete referenced building furniture
  EXECUTE format('SELECT citydb_pkg.delete_building_furniture(id, %L) FROM %I.building_furniture WHERE room_id = %L', 
                    schema_name, schema_name, r_id);

  -- get reference id to surface_geometry table 
  EXECUTE format('SELECT lod4_multi_surface_id, lod4_solid_id FROM %I.room WHERE id = %L', schema_name, r_id) 
                    INTO r_lod4_msrf_id, r_lod4_solid_id;
 
  --// DELETE ROOM //--
  EXECUTE format('DELETE FROM %I.room WHERE id = %L RETURNING id', schema_name, r_id) INTO deleted_id;

  --// POST DELETE ROOM //--
  -- delete geometry
  IF r_lod4_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING r_lod4_msrf_id, schema_name;
  END IF;
  IF r_lod4_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING r_lod4_solid_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING r_id, schema_name;

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
BEGIN
  --// PRE DELETE TRANSPORTATION COMPLEX //--
  -- delete referenced traffic area(s)
  EXECUTE format('SELECT citydb_pkg.delete_traffic_area(id, %L) FROM %I.traffic_area WHERE transportation_complex_id = %L', 
                    schema_name, schema_name, tc_id);

  -- get reference ids to surface_geometry table
  EXECUTE format('SELECT lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id 
                    FROM %I.transportation_complex WHERE id = %L', schema_name, tc_id)
                    INTO tc_lod1_id, tc_lod2_id, tc_lod3_id, tc_lod4_id;

  --// DELETE TRANSPORTATION COMPLEX //--
  EXECUTE format('DELETE FROM %I.transportation_complex WHERE id = %L RETURNING id', schema_name, tc_id) INTO deleted_id;

  --// POST DELETE TRANSPORTATION COMPLEX //--
  -- delete geometry
  IF tc_lod1_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tc_lod1_id, schema_name;
  END IF;
  IF tc_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tc_lod2_id, schema_name;
  END IF;
  IF tc_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tc_lod3_id, schema_name;
  END IF;
  IF tc_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tc_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tc_id, schema_name;

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
BEGIN
  --// PRE DELETE TRAFFIC AREA //--
  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id 
                    FROM %I.traffic_area WHERE id = %L', schema_name, ta_id) 
                    INTO ta_lod2_id, ta_lod3_id, ta_lod4_id;
			 
  --// DELETE TRAFFIC AREA //--
  EXECUTE format('DELETE FROM %I.traffic_area WHERE id = %L RETURNING id', schema_name, ta_id) INTO deleted_id;

  --// POST DELETE TRAFFIC AREA //--
  -- delete geometry
  IF ta_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING ta_lod2_id, schema_name;
  END IF;
  IF ta_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING ta_lod3_id, schema_name;
  END IF;
  IF ta_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING ta_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING ta_id, schema_name;

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
  member_id INTEGER;
BEGIN
  --// PRE DELETE CITY MODEL //--
  -- delete members
  IF delete_members <> 0 THEN
    FOR member_id IN EXECUTE format('SELECT cityobject_id FROM %I.cityobject_member WHERE citymodel_id = %L', 
                                        schema_name, cm_id) LOOP
      BEGIN
        EXECUTE 'SELECT citydb_pkg.delete_cityobject($1, $2, 0, $3)' USING member_id, delete_members, schema_name;

        EXCEPTION
          WHEN OTHERS THEN
            RAISE NOTICE 'delete_citymodel: deletion of cityobject_member with ID % threw %', member_id, SQLERRM;
      END;
    END LOOP;

    -- cleanup
    EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
  END IF;
  
  -- delete reference to city objects
  EXECUTE format('DELETE FROM %I.cityobject_member WHERE citymodel_id = %L', schema_name, cm_id);

  -- delete appearances assigned to the city model
  EXECUTE format('SELECT citydb_pkg.delete_appearance(id, %L) FROM %I.appearance WHERE cityobject_id = %L', 
                    schema_name, schema_name, cm_id);

  --// DELETE CITY MODEL //--
  EXECUTE format('DELETE FROM %I.citymodel WHERE id = %L RETURNING id', schema_name, cm_id) INTO deleted_id;

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
BEGIN
  --// PRE DELETE BRIDGE //--
  -- delete referenced bridge part(s)
  EXECUTE format('SELECT citydb_pkg.delete_bridge(id, %L) FROM %I.bridge WHERE id != %L AND bridge_parent_id = %L', 
                    schema_name, schema_name, brd_id, brd_id);

  -- delete referenced bridge installation(s)
  EXECUTE format('SELECT citydb_pkg.delete_bridge_installation(id, %L) FROM %I.bridge_installation WHERE bridge_id = %L', 
                    schema_name, schema_name, brd_id);

  -- delete referenced bridge construction element(s)
  EXECUTE format('SELECT citydb_pkg.delete_bridge_constr_element(id, %L) FROM %I.bridge_constr_element WHERE bridge_id = %L', 
                    schema_name, schema_name, brd_id);

  -- delete referenced bridge thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_bridge_them_srf(id, %L) FROM %I.bridge_thematic_surface WHERE bridge_id = %L', 
                    schema_name, schema_name, brd_id);

  -- delete referenced bridge_room(s)
  EXECUTE format('SELECT citydb_pkg.delete_bridge_room(id, %L) FROM %I.bridge_room WHERE bridge_id = %L', 
                    schema_name, schema_name, brd_id);

  -- delete address(es) being not referenced from bridges any more
  EXECUTE format('SELECT citydb_pkg.delete_address(ad.id, %L) FROM %I.address ad, %I.address_to_bridge ad2brd 
                    WHERE ad.id = ad2brd.address_id AND ad2brd.bridge_id = %L
                    AND citydb_pkg.is_not_referenced(%L, %L, ad.id, %L, %L, %L)',
                    schema_name, schema_name, schema_name, brd_id, 
                    'address_to_bridge', 'address_id', 'bridge_id', brd_id, schema_name);

  -- delete reference to address
  EXECUTE format('DELETE FROM %I.address_to_bridge WHERE bridge_id = %L', schema_name, brd_id);

  -- get reference ids to surface_geometry table  
  EXECUTE format('SELECT lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id,
                    lod1_solid_id, lod2_solid_id, lod3_solid_id, lod4_solid_id FROM %I.bridge WHERE id = %L', schema_name, brd_id)   
                    INTO brd_lod1_msrf_id, brd_lod2_msrf_id, brd_lod3_msrf_id, brd_lod4_msrf_id,
                         brd_lod1_solid_id, brd_lod2_solid_id, brd_lod3_solid_id, brd_lod4_solid_id;

  --// DELETE BRIDGE //--
  EXECUTE format('DELETE FROM %I.bridge WHERE id = %L RETURNING id', schema_name, brd_id) INTO deleted_id;

  --// POST DELETE BRIDGE //--
  -- delete geometry
  IF brd_lod1_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brd_lod1_msrf_id, schema_name;
  END IF; 
  IF brd_lod2_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brd_lod2_msrf_id, schema_name;
  END IF;
  IF brd_lod3_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brd_lod3_msrf_id, schema_name;
  END IF;
  IF brd_lod4_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brd_lod4_msrf_id, schema_name;
  END IF;
  IF brd_lod1_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brd_lod1_solid_id, schema_name;
  END IF; 
  IF brd_lod2_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brd_lod2_solid_id, schema_name;
  END IF;
  IF brd_lod3_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brd_lod3_solid_id, schema_name;
  END IF;
  IF brd_lod4_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brd_lod4_solid_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING brd_id, schema_name;

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
BEGIN
  --// PRE DELETE BRIDGE INSTALLATION //--
  -- delete referenced bridge thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_bridge_them_srf(id, %L) FROM %I.bridge_thematic_surface WHERE bridge_installation_id = %L', 
                    schema_name, schema_name, brdi_id);

  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod2_brep_id, lod3_brep_id, lod4_brep_id 
                    FROM %I.bridge_installation WHERE id = %L', schema_name, brdi_id)
                    INTO brdi_lod2_id, brdi_lod3_id, brdi_lod4_id;

  --// DELETE BRIDGE INSTALLATION //--
  EXECUTE format('DELETE FROM %I.bridge_installation WHERE id = %L RETURNING id', schema_name, brdi_id) INTO deleted_id;

  --// POST DELETE BRIDGE INSTALLATION //--
  -- delete geometry
  IF brdi_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdi_lod2_id, schema_name;
  END IF;
  IF brdi_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdi_lod3_id, schema_name;
  END IF;
  IF brdi_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdi_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING brdi_id, schema_name;

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
BEGIN
  --// PRE DELETE BRIDGE THEMATIC SURFACE //--
  -- delete opening(s) not being referenced by a bridge thematic surface any more
  EXECUTE format('SELECT citydb_pkg.delete_bridge_opening(brdo.id, %L) FROM %I.bridge_opening brdo, %I.bridge_open_to_them_srf brdo2ts
                    WHERE brdo.id = brdo2ts.bridge_opening_id AND brdo2ts.bridge_thematic_surface_id = %L
                    AND citydb_pkg.is_not_referenced(%L, %L, brdo.id, %L, %L, %L)',
                    schema_name, schema_name, schema_name, brdts_id, 
                    'bridge_open_to_them_srf', 'bridge_opening_id', 'bridge_thematic_surface_id', brdts_id, schema_name);

  -- delete reference to opening
  EXECUTE format('DELETE FROM %I.bridge_open_to_them_srf WHERE bridge_thematic_surface_id = %L', schema_name, brdts_id);

  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id 
                    FROM %I.bridge_thematic_surface WHERE id = %L', schema_name, brdts_id)
                    INTO brdts_lod2_id, brdts_lod3_id, brdts_lod4_id;

  --// DELETE BRIDGE THEMATIC SURFACE //--
  EXECUTE format('DELETE FROM %I.bridge_thematic_surface WHERE id = %L RETURNING id', schema_name, brdts_id) INTO deleted_id;

  --// POST DELETE BRIDGE THEMATIC SURFACE //--
  -- delete geometry
  IF brdts_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdts_lod2_id, schema_name;
  END IF;
  IF brdts_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdts_lod3_id, schema_name;
  END IF;
  IF brdts_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdts_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING brdts_id, schema_name;

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
BEGIN
  --// PRE DELETE BRIDGE OPENING //--
  -- delete reference to bridge thematic surface
  EXECUTE format('DELETE FROM %I.bridge_open_to_them_srf WHERE bridge_opening_id = %L', schema_name, brdo_id);

  -- get reference ids to surface_geometry table and address_id
  EXECUTE format('SELECT lod3_multi_surface_id, lod4_multi_surface_id, address_id 
                    FROM %I.bridge_opening WHERE id = %L', schema_name, brdo_id) 
                    INTO brdo_lod3_id, brdo_lod4_id, brdo_add_id;

  -- delete addresses not being referenced from bridges and bridge openings any more
  IF brdo_add_id IS NOT NULL THEN
    EXECUTE format('SELECT citydb_pkg.delete_address(ad.id, %L) FROM %I.address ad 
                      LEFT OUTER JOIN %I.address_to_bridge ad2brd ON ad.id = ad2brd.address_id 
                      WHERE ad.id = %L AND ad2brd.address_id IS NULL
                      AND citydb_pkg.is_not_referenced(%L, %L, ad.id, %L, %L, %L)',
                      schema_name, schema_name, schema_name, brdo_add_id,
                      'bridge_opening', 'address_id', 'id', brdo_id, schema_name);
  END IF;

  --// DELETE BRIDGE OPENING //--
  EXECUTE format('DELETE FROM %I.bridge_opening WHERE id = %L RETURNING id', schema_name, brdo_id) INTO deleted_id;

  --// POST DELETE BRIDGE OPENING //--
  -- delete geometry
  IF brdo_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdo_lod3_id, schema_name;
  END IF;
  IF brdo_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdo_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING brdo_id, schema_name;

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
BEGIN
  --// PRE DELETE BRIDGE FURNITURE //--
  -- get reference id to surface_geometry table 
  EXECUTE format('SELECT lod4_brep_id FROM %I.bridge_furniture WHERE id = %L', schema_name, brdf_id) INTO brdf_lod4_id;

  --// DELETE BRIDGE FURNITURE //--
  EXECUTE format('DELETE FROM %I.bridge_furniture WHERE id = %L RETURNING id', schema_name, brdf_id) INTO deleted_id;

  --// POST DELETE BRIDGE FURNITURE //--
  -- delete geometry
  IF brdf_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdf_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING brdf_id, schema_name;

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
BEGIN
  --// PRE DELETE BRIDGE ROOM //--
  -- delete referenced bridge installation(s)
  EXECUTE format('SELECT citydb_pkg.delete_bridge_installation(id, %L) FROM %I.bridge_installation WHERE bridge_room_id = %L', 
                    schema_name, schema_name, brdr_id);

  -- delete referenced bridge thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_bridge_them_srf(id, %L) FROM %I.bridge_thematic_surface WHERE bridge_room_id = %L', 
                    schema_name, schema_name, brdr_id);
  
  -- delete referenced bridge furniture
  EXECUTE format('SELECT citydb_pkg.delete_bridge_furniture(id, %L) FROM %I.bridge_furniture WHERE bridge_room_id = %L', 
                    schema_name, schema_name, brdr_id);

  -- get reference id to surface_geometry table 
  EXECUTE format('SELECT lod4_multi_surface_id, lod4_solid_id FROM %I.bridge_room WHERE id = %L', schema_name, brdr_id)   
                    INTO brdr_lod4_msrf_id, brdr_lod4_solid_id;
 
  --// DELETE BRIDGE ROOM //--
  EXECUTE format('DELETE FROM %I.bridge_room WHERE id = %L RETURNING id', schema_name, brdr_id) INTO deleted_id;

  --// POST DELETE BRIDGE ROOM //--
  -- delete geometry
  IF brdr_lod4_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdr_lod4_msrf_id, schema_name;
  END IF;
  IF brdr_lod4_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdr_lod4_solid_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING brdr_id, schema_name;

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
BEGIN
  --// PRE DELETE BRIDGE CONSTRUCTION ELEMENT //--
  -- delete referenced bridge thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_bridge_them_srf(id, %L) FROM %I.bridge_thematic_surface WHERE bridge_constr_element_id = %L', 
                    schema_name, schema_name, brdce_id);

  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod1_brep_id, lod2_brep_id, lod3_brep_id, lod4_brep_id 
                    FROM %I.bridge_constr_element WHERE id = %L', schema_name, brdce_id)
                    INTO brdce_lod1_id, brdce_lod2_id, brdce_lod3_id, brdce_lod4_id;

  --// DELETE BRIDGE CONSTRUCTION ELEMENT //--
  EXECUTE format('DELETE FROM %I.bridge_constr_element WHERE id = %L RETURNING id', schema_name, brdce_id) INTO deleted_id;

  --// POST DELETE BRIDGE CONSTRUCTION ELEMENT //--
  -- delete geometry
  IF brdce_lod1_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdce_lod1_id, schema_name;
  END IF;
  IF brdce_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdce_lod2_id, schema_name;
  END IF;
  IF brdce_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdce_lod3_id, schema_name;
  END IF;
  IF brdce_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING brdce_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING brdce_id, schema_name;

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
BEGIN
  --// PRE DELETE TUNNEL //--
  -- delete referenced tunnel part(s)
  EXECUTE format('SELECT citydb_pkg.delete_tunnel(id, %L) FROM %I.tunnel WHERE id != %L AND tunnel_parent_id = %L', 
                    schema_name, schema_name, tun_id, tun_id);

  -- delete referenced tunnel installation(s)
  EXECUTE format('SELECT citydb_pkg.delete_tunnel_installation(id, %L) FROM %I.tunnel_installation WHERE tunnel_id = %L', 
                    schema_name, schema_name, tun_id);

  -- delete referenced tunnel thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_tunnel_them_srf(id, %L) FROM %I.tunnel_thematic_surface WHERE tunnel_id = %L', 
                    schema_name, schema_name, tun_id);

  -- delete referenced tunnel hollow space(s)
  EXECUTE format('SELECT citydb_pkg.delete_tunnel_hollow_space(id, %L) FROM %I.tunnel_hollow_space WHERE tunnel_id = %L', 
                    schema_name, schema_name, tun_id);

  -- get reference ids to surface_geometry table  
  EXECUTE format('SELECT lod1_multi_surface_id, lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id,
                    lod1_solid_id , lod2_solid_id, lod3_solid_id, lod4_solid_id FROM %I.tunnel WHERE id = %L', schema_name, tun_id) 
                    INTO tun_lod1_msrf_id, tun_lod2_msrf_id, tun_lod3_msrf_id, tun_lod4_msrf_id,
                         tun_lod1_solid_id, tun_lod2_solid_id, tun_lod3_solid_id, tun_lod4_solid_id;

  --// DELETE TUNNEL //--
  EXECUTE format('DELETE FROM %I.tunnel WHERE id = %L RETURNING id', schema_name, tun_id) INTO deleted_id;

  --// POST DELETE TUNNEL //--
  -- delete geometry
  IF tun_lod1_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tun_lod1_msrf_id, schema_name;
  END IF; 
  IF tun_lod2_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tun_lod2_msrf_id, schema_name;
  END IF;
  IF tun_lod3_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tun_lod3_msrf_id, schema_name;
  END IF;
  IF tun_lod4_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tun_lod4_msrf_id, schema_name;
  END IF;
  IF tun_lod1_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tun_lod1_solid_id, schema_name;
  END IF; 
  IF tun_lod2_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tun_lod2_solid_id, schema_name;
  END IF;
  IF tun_lod3_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tun_lod3_solid_id, schema_name;
  END IF;
  IF tun_lod4_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tun_lod4_solid_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tun_id, schema_name;

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
BEGIN
  --// PRE DELETE TUNNEL INSTALLATION //--
  -- delete referenced tunnel thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_tunnel_them_srf(id, %L) FROM %I.tunnel_thematic_surface WHERE tunnel_installation_id = %L', 
                    schema_name, schema_name, tuni_id);

  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod2_brep_id, lod3_brep_id, lod4_brep_id 
                    FROM %I.tunnel_installation WHERE id = %L', schema_name, tuni_id) 
                    INTO tuni_lod2_id, tuni_lod3_id, tuni_lod4_id;

  --// DELETE TUNNEL INSTALLATION //--
  EXECUTE format('DELETE FROM %I.tunnel_installation WHERE id = %L RETURNING id', schema_name, tuni_id) INTO deleted_id;

  --// POST DELETE TUNNEL INSTALLATION //--
  -- delete geometry
  IF tuni_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tuni_lod2_id, schema_name;
  END IF;
  IF tuni_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tuni_lod3_id, schema_name;
  END IF;
  IF tuni_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tuni_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tuni_id, schema_name;

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
BEGIN
  --// PRE DELETE TUNNEL THEMATIC SURFACE //--
  -- delete opening(s) not being referenced by a tunnel thematic surface any more
  EXECUTE format('SELECT citydb_pkg.delete_tunnel_opening(tuno.id, %L) FROM %I.tunnel_opening tuno, %I.tunnel_open_to_them_srf tuno2ts
                    WHERE tuno.id = tuno2ts.tunnel_opening_id AND tuno2ts.tunnel_thematic_surface_id = %L
                      AND citydb_pkg.is_not_referenced(%L, %L, tuno.id, %L, %L, %L)',
                      schema_name, schema_name, schema_name, tunts_id,
                      'tunnel_open_to_them_srf', 'tunnel_opening_id', 'tunnel_thematic_surface_id', tunts_id, schema_name);

  -- delete reference to opening
  EXECUTE format('DELETE FROM %I.tunnel_open_to_them_srf WHERE tunnel_thematic_surface_id = %L', schema_name, tunts_id);

  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod2_multi_surface_id, lod3_multi_surface_id, lod4_multi_surface_id 
                    FROM %I.tunnel_thematic_surface WHERE id = %L', schema_name, tunts_id)
                    INTO tunts_lod2_id, tunts_lod3_id, tunts_lod4_id;

  --// DELETE TUNNEL THEMATIC SURFACE //--
  EXECUTE format('DELETE FROM %I.tunnel_thematic_surface WHERE id = %L RETURNING id', schema_name, tunts_id) INTO deleted_id;

  --// POST DELETE TUNNEL THEMATIC SURFACE //--
  -- delete geometry
  IF tunts_lod2_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tunts_lod2_id, schema_name;
  END IF;
  IF tunts_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tunts_lod3_id, schema_name;
  END IF;
  IF tunts_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tunts_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tunts_id, schema_name;

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
BEGIN
  --// PRE DELETE TUNNEL OPENING //--
  -- delete reference to tunnel thematic surface
  EXECUTE format('DELETE FROM %I.tunnel_open_to_them_srf WHERE tunnel_opening_id = %L', schema_name, tuno_id);

  -- get reference ids to surface_geometry table 
  EXECUTE format('SELECT lod3_multi_surface_id, lod4_multi_surface_id 
                    FROM %I.tunnel_opening WHERE id = %L', schema_name, tuno_id)
                    INTO tuno_lod3_id, tuno_lod4_id;

  --// DELETE TUNNEL OPENING //--
  EXECUTE format('DELETE FROM %I.tunnel_opening WHERE id = %L RETURNING id', schema_name, tuno_id) INTO deleted_id;

  --// POST DELETE TUNNEL OPENING //--
  -- delete geometry
  IF tuno_lod3_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry(tuno_lod3_id, 0, $2)' USING tuno_lod3_id, schema_name;
  END IF;
  IF tuno_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry(tuno_lod4_id, 0, $2)' USING tuno_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tuno_id, schema_name;

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
BEGIN
  --// PRE DELETE TUNNEL FURNITURE //--
  -- get reference id to surface_geometry table 
  EXECUTE format('SELECT lod4_brep_id FROM %I.tunnel_furniture WHERE id = %L', schema_name, tunf_id) INTO tunf_lod4_id;

  --// DELETE TUNNEL FURNITURE //--
  EXECUTE format('DELETE FROM %I.tunnel_furniture WHERE id = %L RETURNING id', schema_name, tunf_id) INTO deleted_id;

  --// POST DELETE TUNNEL FURNITURE //--
  -- delete geometry
  IF tunf_lod4_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tunf_lod4_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tunf_id, schema_name;

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
BEGIN
  --// PRE DELETE TUNNEL HOLLOW SPACE //--
  -- delete referenced tunnel installation(s)
  EXECUTE format('SELECT citydb_pkg.delete_tunnel_installation(id, %L) FROM %I.tunnel_installation WHERE tunnel_hollow_space_id = %L', 
                    schema_name, schema_name, tunhs_id);

  -- delete referenced tunnel thematic surfaces
  EXECUTE format('SELECT citydb_pkg.delete_tunnel_them_srf(id, %L) FROM %I.tunnel_thematic_surface WHERE tunnel_hollow_space_id = %L', 
                    schema_name, schema_name, tunhs_id);
  
  -- delete referenced tunnel furniture
  EXECUTE format('SELECT citydb_pkg.delete_tunnel_furniture(id, %L) FROM %I.tunnel_furniture WHERE tunnel_hollow_space_id = %L', 
                    schema_name, schema_name, tunhs_id);

  -- get reference id to surface_geometry table 
  EXECUTE format('SELECT lod4_multi_surface_id, lod4_solid_id FROM %I.tunnel_hollow_space WHERE id = %L', schema_name, tunhs_id)  
                    INTO tunhs_lod4_msrf_id, tunhs_lod4_solid_id;
 
  --// DELETE TUNNEL HOLLOW SPACE //--
  EXECUTE format('DELETE FROM %I.tunnel_hollow_space WHERE id = %L RETURNING id', schema_name, tunhs_id) INTO deleted_id;

  --// POST DELETE TUNNEL HOLLOW SPACE //--
  -- delete geometry
  IF tunhs_lod4_msrf_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tunhs_lod4_msrf_id, schema_name;
  END IF;
  IF tunhs_lod4_solid_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING tunhs_lod4_solid_id, schema_name;
  END IF;

  -- delete city object
  EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tunhs_id, schema_name;

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
BEGIN
  FOR ig_id IN EXECUTE format(
    'SELECT ig.id FROM %I.implicit_geometry ig
       LEFT JOIN %I.bridge_furniture brdf ON brdf.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_constr_element brdce1 ON brdce1.lod1_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_constr_element brdce2 ON brdce1.lod2_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_constr_element brdce3 ON brdce1.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_constr_element brdce4 ON brdce1.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_installation brdi1 ON brdi1.lod2_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_installation brdi2 ON brdi2.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_installation brdi3 ON brdi3.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_opening brdo1 ON brdo1.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.bridge_opening brdo2 ON brdo2.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.building_furniture bf ON bf.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.building_installation bi1 ON bi1.lod2_implicit_rep_id = ig.id
       LEFT JOIN %I.building_installation bi2 ON bi2.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.building_installation bi3 ON bi3.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.city_furniture cf1 ON cf1.lod1_implicit_rep_id = ig.id
       LEFT JOIN %I.city_furniture cf2 ON cf2.lod2_implicit_rep_id = ig.id
       LEFT JOIN %I.city_furniture cf3 ON cf3.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.city_furniture cf4 ON cf4.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.generic_cityobject gco0 ON gco0.lod0_implicit_rep_id = ig.id
       LEFT JOIN %I.generic_cityobject gco1 ON gco1.lod1_implicit_rep_id = ig.id
       LEFT JOIN %I.generic_cityobject gco2 ON gco2.lod2_implicit_rep_id = ig.id
       LEFT JOIN %I.generic_cityobject gco3 ON gco3.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.generic_cityobject gco4 ON gco4.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.opening o1 ON o1.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.opening o2 ON o2.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.solitary_vegetat_object svo1 ON svo1.lod1_implicit_rep_id = ig.id
       LEFT JOIN %I.solitary_vegetat_object svo2 ON svo2.lod2_implicit_rep_id = ig.id
       LEFT JOIN %I.solitary_vegetat_object svo3 ON svo3.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.solitary_vegetat_object svo4 ON svo4.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.tunnel_furniture tunf ON tunf.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.tunnel_installation tuni1 ON tuni1.lod2_implicit_rep_id = ig.id
       LEFT JOIN %I.tunnel_installation tuni2 ON tuni2.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.tunnel_installation tuni3 ON tuni3.lod4_implicit_rep_id = ig.id
       LEFT JOIN %I.tunnel_opening tuno1 ON tuno1.lod3_implicit_rep_id = ig.id
       LEFT JOIN %I.tunnel_opening tuno2 ON tuno2.lod4_implicit_rep_id = ig.id
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
          AND (tuno2.lod4_implicit_rep_id IS NULL)', schema_name,
          schema_name, schema_name, schema_name, schema_name, schema_name,
          schema_name, schema_name, schema_name, schema_name, schema_name,
          schema_name, schema_name, schema_name, schema_name, schema_name,
          schema_name, schema_name, schema_name, schema_name, schema_name,
          schema_name, schema_name, schema_name, schema_name, schema_name,
          schema_name, schema_name, schema_name, schema_name, schema_name,
          schema_name, schema_name, schema_name, schema_name, schema_name) LOOP
    deleted_id := citydb_pkg.delete_implicit_geometry(ig_id, 0, schema_name);
    RETURN NEXT deleted_id;
  END LOOP;

  IF clean_apps <> 0 THEN
    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(0, $1)' USING schema_name;
  END IF;

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
  deleted_id INTEGER;
  gc_id INTEGER;
BEGIN
  FOR gc_id IN EXECUTE format('SELECT gc.id FROM %I.grid_coverage gc
                                 LEFT JOIN %I.raster_relief rr ON rr.grid_coverage_id = gc.id
                                 WHERE sd.grid_coverage_id IS NULL', schema_name, schema_name) LOOP
    --// DELETE GRID COVERAGE //--
    EXECUTE format('DELETE FROM %I.grid_coverage WHERE id = %L RETURNING id', schema_name, gc_id) INTO deleted_id;
    RETURN NEXT deleted_id;
  END LOOP;

  RETURN;

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
BEGIN
  FOR ti_id IN EXECUTE format('SELECT ti.id FROM %I.tex_image ti
                                 LEFT JOIN %I.surface_data sd ON sd.tex_image_id = ti.id
                                 WHERE sd.tex_image_id IS NULL', schema_name, schema_name) LOOP
    --// DELETE TEX IMAGE //--
    EXECUTE format('DELETE FROM %I.tex_image WHERE id = %L RETURNING id', schema_name, ti_id) INTO deleted_id;
    RETURN NEXT deleted_id;
  END LOOP;

  RETURN;

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
BEGIN
  -- global appearances are not related to a cityobject.
  -- however, we assume that all surface geometries of a cityobject
  -- have been deleted at this stage. thus, we can check and delete
  -- surface data which does not have a valid texture parameterization
  -- any more.
  EXECUTE format('SELECT citydb_pkg.delete_surface_data(s.id, %L) FROM %I.surface_data s 
                    LEFT OUTER JOIN %I.textureparam t ON s.id = t.surface_data_id 
                    WHERE t.surface_data_id IS NULL', schema_name, schema_name, schema_name);

  -- delete appearances which does not have surface data any more
  IF only_global=1 THEN
    FOR app_id IN EXECUTE format(
      'SELECT a.id FROM %I.appearance a 
         LEFT OUTER JOIN %I.appear_to_surface_data asd ON a.id=asd.appearance_id 
           WHERE a.cityobject_id IS NULL AND asd.appearance_id IS NULL', schema_name, schema_name) LOOP
      deleted_id := citydb_pkg.delete_appearance(app_id, schema_name);
      RETURN NEXT deleted_id;
    END LOOP;
  ELSE
    FOR app_id IN EXECUTE format(
      'SELECT a.id FROM %I.appearance a 
         LEFT OUTER JOIN %I.appear_to_surface_data asd ON a.id=asd.appearance_id 
           WHERE asd.appearance_id IS NULL', schema_name, schema_name) LOOP
      deleted_id := citydb_pkg.delete_appearance(app_id, schema_name);
      RETURN NEXT deleted_id;
    END LOOP;
  END IF;

  -- delete tex images not referenced by surface data any more
  EXECUTE 'SELECT citydb_pkg.cleanup_tex_images($1)' USING schema_name;

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
  deleted_id INTEGER;
  ad_id INTEGER;
BEGIN
  FOR ad_id IN EXECUTE format(
    'SELECT ad.id FROM %I.address ad
       LEFT OUTER JOIN %I.address_to_building ad2b ON ad2b.address_id = ad.id
       LEFT OUTER JOIN %I.address_to_bridge ad2brd ON ad2brd.address_id = ad.id
       LEFT OUTER JOIN %I.opening o ON o.address_id = ad.id
       LEFT OUTER JOIN %I.bridge_opening brdo ON brdo.address_id = ad.id
       WHERE ad2b.building_id IS NULL
         AND ad2brd.bridge_id IS NULL
         AND o.address_id IS NULL
         AND brdo.address_id IS NULL',
         schema_name, schema_name, schema_name, schema_name, schema_name) LOOP
    deleted_id := citydb_pkg.delete_address(ad_id, schema_name);
    RETURN NEXT deleted_id;
  END LOOP;

  RETURN;

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_addresses: %', SQLERRM;
END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_cityobjectgroups(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  cog_id INTEGER;
BEGIN
  FOR cog_id IN EXECUTE format(
    'SELECT g.id FROM %I.cityobjectgroup g 
       LEFT OUTER JOIN %I.group_to_cityobject gtc ON g.id=gtc.cityobjectgroup_id 
       WHERE gtc.cityobject_id IS NULL', schema_name, schema_name) LOOP
    deleted_id := citydb_pkg.delete_cityobjectgroup(cog_id, 0, schema_name);
    RETURN NEXT deleted_id;
  END LOOP;

  RETURN;

  EXCEPTION  
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_cityobjectgroups: %', SQLERRM;
END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_citymodels(schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  cm_id INTEGER;
BEGIN
  FOR cm_id IN EXECUTE format(
    'SELECT c.id FROM %I.citymodel c 
       LEFT OUTER JOIN %I.cityobject_member cm ON c.id=cm.citymodel_id 
       WHERE cm.cityobject_id IS NULL', schema_name, schema_name) LOOP
    deleted_id := citydb_pkg.delete_citymodel(cm_id, 0, schema_name);
    RETURN NEXT deleted_id;
  END LOOP;

  RETURN;

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
BEGIN
  EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;

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
      WHEN class_id = 57 THEN deleted_id := citydb_pkg.delete_citymodel(co_id, delete_members, schema_name);
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
    EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_citymodels($1)' USING schema_name;
  END IF;

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
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
BEGIN  
  -- delete city object and all entries from other tables referencing the cityobject_id
  EXECUTE format('DELETE FROM %I.cityobject WHERE id = %L RETURNING id', schema_name, co_id) INTO deleted_id;
  
  -- cleanup
  EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
  EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
  EXECUTE 'SELECT citydb_pkg.cleanup_grid_coverages($1)' USING schema_name;
  EXECUTE 'SELECT citydb_pkg.cleanup_addresses($1)' USING schema_name;
  EXECUTE 'SELECT citydb_pkg.cleanup_cityobjectgroups($1)' USING schema_name;
  EXECUTE 'SELECT citydb_pkg.cleanup_citymodels($1)' USING schema_name;

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
BEGIN
  -- clear tables
  EXECUTE format('TRUNCATE TABLE %I.cityobject CASCADE', schema_name);
  EXECUTE format('TRUNCATE TABLE %I.tex_image CASCADE', schema_name);
  EXECUTE format('TRUNCATE TABLE %I.grid_coverage CASCADE', schema_name);
  EXECUTE format('TRUNCATE TABLE %I.address CASCADE', schema_name);
  EXECUTE format('TRUNCATE TABLE %I.citymodel CASCADE', schema_name);

  -- restart sequences
  EXECUTE format('ALTER SEQUENCE %I.address_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.appearance_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.citymodel_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.cityobject_genericatt_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.cityobject_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.external_ref_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.grid_coverage_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.implicit_geometry_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.surface_data_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.surface_geometry_seq RESTART', schema_name);
  EXECUTE format('ALTER SEQUENCE %I.tex_image_seq RESTART', schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'cleanup_schema: %', SQLERRM;
END; 
$$ 
LANGUAGE plpgsql;