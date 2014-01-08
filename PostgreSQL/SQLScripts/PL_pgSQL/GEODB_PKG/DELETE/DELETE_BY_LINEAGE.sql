-- DELETE_BY_LINEAGE.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
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
-- Delete multiple objects refereced by a lineage value.
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.0.0     2014-01-08   minor changes for 3DCityDB V3               FKun
-- 1.3.0     2013-08-08   extended to all thematic classes            GHud
--                                                                    FKun
-- 1.2.0     2012-02-22   minor changes                               CNag
-- 1.1.0     2011-02-11   moved to new DELETE functionality           CNag
-- 1.0.0     2008-09-10   release version                             ASta
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   delete_bridges(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_buildings(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_city_furnitures(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_cityobjects(lineage_value VARCHAR, affect_rel_objs INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_cityobjectgroups(lineage_value VARCHAR, affect_rel_objs INTEGER DEFAULT 0, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_generic_cityobjects(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_land_uses(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_plant_covers(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_relief_features(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_soltary_veg_objs(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_transport_complexes(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_tunnels(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   delete_waterbodies(lineage_value VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
******************************************************************/

CREATE OR REPLACE FUNCTION geodb_pkg.delete_buildings(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  building_id INTEGER;
BEGIN
  FOR building_id IN EXECUTE 
    format('WITH RECURSIVE complex_building(id, parent_id, level) AS (
              SELECT id, building_parent_id, 1 AS level FROM %I.building WHERE building_parent_id IS NULL AND id IN
	            (SELECT b.id FROM %I.building b, %I.cityobject c WHERE b.id = c.id AND c.lineage = %L)
              UNION ALL
                SELECT b.id, b.building_parent_id, cb.level + 1 AS level FROM %I.building b, complex_building cb WHERE b.building_parent_id = cb.id
            ) SELECT id FROM complex_building ORDER BY level DESC',
            schema_name, schema_name, schema_name, lineage_value, schema_name) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_building(building_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_buildings: deletion of building with ID % threw %', building_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_buildings: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_city_furnitures(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  city_furniture_id INTEGER;
BEGIN
  FOR city_furniture_id IN EXECUTE 
    format('SELECT cf.id FROM %I.city_furniture cf, %I.cityobject co 
              WHERE cf.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_city_furniture(city_furniture_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_city_furnitures: deletion of city_furniture with ID % threw %', city_furniture_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'city_furnitures: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_generic_cityobjects(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  generic_cityobject_id INTEGER;
BEGIN
  FOR generic_cityobject_id IN EXECUTE 
    format('SELECT gco.id FROM %I.generic_cityobject gco, %I.cityobject co 
              WHERE gco.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_generic_cityobject(generic_cityobject_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_generic_cityobjects: deletion of generic_cityobject with ID % threw %', generic_cityobject_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_generic_cityobjects: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_land_uses(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  land_use_id INTEGER;
BEGIN
  FOR land_use_id IN EXECUTE 
    format('SELECT lu.id FROM %I.land_use lu, %I.cityobject co 
              WHERE lu.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_land_use(land_use_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_land_uses: deletion of land_use with ID % threw %', land_use_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_land_uses: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_plant_covers(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  plant_cover_id INTEGER;
BEGIN
  FOR plant_cover_id IN EXECUTE 
    format('SELECT pc.id FROM %I.plant_cover pc, %I.cityobject co 
              WHERE pc.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_plant_cover(plant_cover_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_plant_covers: deletion of plant_cover with ID % threw %', plant_cover_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_plant_covers: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_soltary_veg_objs(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  soltary_veg_obj_id INTEGER;
BEGIN
  FOR soltary_veg_obj_id IN EXECUTE 
    format('SELECT svo.id FROM %I.soltary_vegegetat_object svo, %I.cityobject co 
              WHERE svo.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_soltary_veg_obj(soltary_veg_obj_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_soltary_veg_objs: deletion of soltary_vegetation_object with ID % threw %', soltary_veg_obj_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_soltary_veg_objs: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_transport_complexes(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  transport_complex_id INTEGER;
BEGIN
  FOR transport_complex_id IN EXECUTE 
    format('SELECT tc.id FROM %I.transportation_complex tc, %I.cityobject co 
              WHERE tc.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_transport_complex(transport_complex_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_transport_complexes: deletion of transportation_complexe with ID % threw %', transport_complex_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_transport_complexes: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_waterbodies(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  waterbody_id INTEGER;
BEGIN
  FOR waterbody_id IN EXECUTE 
    format('SELECT wb.id FROM %I.waterbody wb, %I.cityobject co  
              WHERE wb.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_waterbody(waterbody_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_city_waterbodies: deletion of waterbody with ID % threw %', waterbody_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_waterbodies: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_relief_features(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  relief_feature_id INTEGER;
BEGIN
  FOR relief_feature_id IN EXECUTE 
    format('SELECT rf.id FROM %I.relief_feature rf, %I.cityobject co 
              WHERE rf.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_relief_feature(relief_feature_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_relief_features: deletion of relief_feature with ID % threw %', relief_feature_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_relief_features: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_bridges(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  bridge_id INTEGER;
BEGIN
  FOR bridge_id IN EXECUTE 
    format('WITH RECURSIVE complex_bridge(id, parent_id, level) AS (
              SELECT id, bridge_parent_id, 1 AS level FROM %I.bridge WHERE bridge_parent_id IS NULL AND id IN
	            (SELECT brd.id FROM %I.bridge brd, %I.cityobject c WHERE brd.id = c.id AND c.lineage = %L)
              UNION ALL
                SELECT brd.id, brd.bridge_parent_id, cbrd.level + 1 AS level FROM %I.bridge brd, complex_bridge cbrd WHERE brd.bridge_parent_id = cbrd.id
            ) SELECT id FROM complex_bridge ORDER BY level DESC', 
            schema_name, schema_name, schema_name, lineage_value, schema_name) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_bridge(bridge_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_bridges: deletion of bridge with ID % threw %', bridge_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridges: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_tunnels(
  lineage_value VARCHAR, 
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  tunnel_id INTEGER;
BEGIN
  FOR tunnel_id IN EXECUTE 
    format('WITH RECURSIVE complex_tunnel(id, parent_id, level) AS (
              SELECT id, tunnel_parent_id, 1 AS level FROM %I.tunnel WHERE tunnel_parent_id IS NULL AND id IN
	            (SELECT tun.id FROM %I.tunnel tun, %I.cityobject c WHERE tun.id = c.id AND c.lineage = %L)
              UNION ALL
                SELECT tun.id, tun.tunnel_parent_id, cb.level + 1 AS level FROM %I.tunnel tun, complex_tunnel cb WHERE tun.tunnel_parent_id = cb.id
            ) SELECT id FROM complex_tunnel ORDER BY level DESC', schema_name, schema_name, schema_name, lineage_value, schema_name) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_tunnel(tunnel_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_tunnels: deletion of tunnel with ID % threw %', tunnel_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnels: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_cityobjectgroups(
  lineage_value VARCHAR,
  affect_rel_objs INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  cityobjectgroup_id INTEGER;
BEGIN
  FOR cityobjectgroup_id IN EXECUTE 
    format('SELECT cog.id FROM %I.cityobjectgroup cog, %I.cityobject co 
              WHERE cog.id = co.id AND co.lineage = %L', schema_name, schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_cityobjectgroup(cityobjectgroup_id, affect_rel_objs, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_cityobjectgroups: deletion of cityobjectgroup with ID % threw %', cityobjectgroup_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobjectgroups: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_cityobjects(
  lineage_value VARCHAR,
  affect_rel_objs INTEGER DEFAULT 0,
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  cityobject_id INTEGER;
BEGIN
  FOR cityobject_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_cityobject(cityobject_id, affect_rel_objs, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_cityobjects: deletion of cityobject with ID % threw %', cityobject_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1);
  PERFORM geodb_pkg.cleanup_citymodels();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobjects: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;