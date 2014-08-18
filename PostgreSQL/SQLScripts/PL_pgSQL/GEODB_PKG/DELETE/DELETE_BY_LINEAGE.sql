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
-- 2.0.0     2014-07-30   minor changes for 3DCityDB V3               FKun
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
*   delete_bridges(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_buildings(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_city_furnitures(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_cityobjects(lineage_value TEXT, delete_members INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_cityobjectgroups(lineage_value TEXT, delete_members INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_generic_cityobjects(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_land_uses(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_plant_covers(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_relief_features(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_soltary_veg_objs(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_transport_complexes(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_tunnels(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
*   delete_waterbodies(lineage_value TEXT, schema_name TEXT DEFAULT 'public') RETURNS SETOF VOID
******************************************************************/

CREATE OR REPLACE FUNCTION geodb_pkg.delete_buildings(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  building_id INTEGER;
BEGIN
  FOR building_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 26 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_building(building_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_buildings: deletion of building with ID % threw %', building_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_buildings: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_bridges(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  bridge_id INTEGER;
BEGIN
  FOR bridge_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 64 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_bridge(bridge_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_bridges: deletion of bridge with ID % threw %', bridge_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridges: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_tunnels(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  tunnel_id INTEGER;
BEGIN
  FOR tunnel_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 85 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_tunnel(tunnel_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_tunnels: deletion of tunnel with ID % threw %', tunnel_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnels: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_city_furnitures(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  city_furniture_id INTEGER;
BEGIN
  FOR city_furniture_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 21 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_city_furniture(city_furniture_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_city_furnitures: deletion of city_furniture with ID % threw %', city_furniture_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'city_furnitures: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_generic_cityobjects(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  generic_cityobject_id INTEGER;
BEGIN
  FOR generic_cityobject_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 5 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_generic_cityobject(generic_cityobject_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_generic_cityobjects: deletion of generic_cityobject with ID % threw %', generic_cityobject_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_generic_cityobjects: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_land_uses(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  land_use_id INTEGER;
BEGIN
  FOR land_use_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 4 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_land_use(land_use_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_land_uses: deletion of land_use with ID % threw %', land_use_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_land_uses: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_plant_covers(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  plant_cover_id INTEGER;
BEGIN
  FOR plant_cover_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 8 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_plant_cover(plant_cover_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_plant_covers: deletion of plant_cover with ID % threw %', plant_cover_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_plant_covers: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_soltary_veg_objs(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  soltary_veg_obj_id INTEGER;
BEGIN
  FOR soltary_veg_obj_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 8 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_soltary_veg_obj(soltary_veg_obj_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_soltary_veg_objs: deletion of soltary_vegetation_object with ID % threw %', soltary_veg_obj_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_soltary_veg_objs: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_transport_complexes(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  transport_complex_id INTEGER;
BEGIN
  FOR transport_complex_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 42 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_transport_complex(transport_complex_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_transport_complexes: deletion of transportation_complexe with ID % threw %', transport_complex_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_transport_complexes: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_waterbodies(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  waterbody_id INTEGER;
BEGIN
  FOR waterbody_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 9 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_waterbody(waterbody_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_city_waterbodies: deletion of waterbody with ID % threw %', waterbody_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_waterbodies: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_cityobjectgroups(
  lineage_value TEXT,
  delete_members INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  cityobjectgroup_id INTEGER;
BEGIN
  FOR cityobjectgroup_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 23 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_cityobjectgroup(cityobjectgroup_id, delete_members, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_cityobjectgroups: deletion of cityobjectgroup with ID % threw %', cityobjectgroup_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobjectgroups: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_relief_features(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  relief_feature_id INTEGER;
BEGIN
  FOR relief_feature_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE objectclass_id = 14 AND lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_relief_feature(relief_feature_id, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_relief_features: deletion of relief_feature with ID % threw %', relief_feature_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_relief_features: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.delete_cityobjects(
  lineage_value TEXT,
  delete_members INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'public'
  ) RETURNS SETOF VOID AS
$$
DECLARE
  cityobject_id INTEGER;
BEGIN
  FOR cityobject_id IN EXECUTE format('SELECT id FROM %I.cityobject WHERE lineage = %L', schema_name, lineage_value) LOOP
    BEGIN
      PERFORM geodb_pkg.delete_cityobject(cityobject_id, delete_members, 0, schema_name);

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_cityobjects: deletion of cityobject with ID % threw %', cityobject_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM geodb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM geodb_pkg.cleanup_appearances(1, schema_name);
  PERFORM geodb_pkg.cleanup_citymodels(schema_name);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobjects: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;