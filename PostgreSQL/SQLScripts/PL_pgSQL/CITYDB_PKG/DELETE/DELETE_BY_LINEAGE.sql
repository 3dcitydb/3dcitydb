-- DELETE_BY_LINEAGE.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <felix-kunde@gmx.de>
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
-- Delete multiple objects refereced by a lineage value.
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                                    | Author
-- 2.2.1     2016-03-20   reset search_path by the end of each function    FKun
-- 2.2.0     2016-01-27   removed dynamic SQL code                         FKun
-- 2.1.0     2014-11-07   delete with returning id of deleted features     FKun
-- 2.0.0     2014-10-10   minor changes for 3DCityDB V3                    FKun
-- 1.3.0     2013-08-08   extended to all thematic classes                 GHud
--                                                                         FKun
-- 1.2.0     2012-02-22   minor changes                                    CNag
-- 1.1.0     2011-02-11   moved to new DELETE functionality                CNag
-- 1.0.0     2008-09-10   release version                                  ASta
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   delete_bridges(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_buildings(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_city_furnitures(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_cityobjects(lineage_value TEXT, delete_members INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_cityobjectgroups(lineage_value TEXT, delete_members INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_generic_cityobjects(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_land_uses(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_plant_covers(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_relief_features(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_solitary_veg_objs(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_transport_complexes(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_tunnels(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   delete_waterbodies(lineage_value TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
******************************************************************/

CREATE OR REPLACE FUNCTION citydb_pkg.delete_buildings(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  building_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR building_id IN SELECT id FROM cityobject WHERE objectclass_id = 26 AND lineage = lineage_value
  LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_building(building_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_buildings: deletion of building with ID % threw %', building_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_buildings: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridges(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  bridge_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR bridge_id IN SELECT id FROM cityobject WHERE objectclass_id = 64 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_bridge(bridge_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_bridges: deletion of bridge with ID % threw %', bridge_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_bridges: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnels(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tunnel_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR tunnel_id IN SELECT id FROM cityobject WHERE objectclass_id = 85 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_tunnel(tunnel_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_tunnels: deletion of tunnel with ID % threw %', tunnel_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_tunnels: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_city_furnitures(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  city_furniture_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR city_furniture_id IN SELECT id FROM cityobject WHERE objectclass_id = 21 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_city_furniture(city_furniture_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_city_furnitures: deletion of city_furniture with ID % threw %', city_furniture_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'city_furnitures: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_generic_cityobjects(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  generic_cityobject_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR generic_cityobject_id IN SELECT id FROM cityobject WHERE objectclass_id = 5 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_generic_cityobject(generic_cityobject_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_generic_cityobjects: deletion of generic_cityobject with ID % threw %', generic_cityobject_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_generic_cityobjects: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_land_uses(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  land_use_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR land_use_id IN SELECT id FROM cityobject WHERE objectclass_id = 4 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_land_use(land_use_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_land_uses: deletion of land_use with ID % threw %', land_use_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_land_uses: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_plant_covers(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  plant_cover_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR plant_cover_id IN SELECT id FROM cityobject WHERE objectclass_id = 8 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_plant_cover(plant_cover_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_plant_covers: deletion of plant_cover with ID % threw %', plant_cover_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_plant_covers: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_solitary_veg_objs(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  solitary_veg_obj_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR solitary_veg_obj_id IN SELECT id FROM cityobject WHERE objectclass_id = 7 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_solitary_veg_obj(solitary_veg_obj_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_solitary_veg_objs: deletion of solitary_vegetation_object with ID % threw %', solitary_veg_obj_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_solitary_veg_objs: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_transport_complexes(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  transport_complex_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR transport_complex_id IN SELECT id FROM cityobject WHERE objectclass_id = 42 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_transport_complex(transport_complex_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_transport_complexes: deletion of transportation_complexe with ID % threw %', transport_complex_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_transport_complexes: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_waterbodies(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  waterbody_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR waterbody_id IN SELECT id FROM cityobject WHERE objectclass_id = 9 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_waterbody(waterbody_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_city_waterbodies: deletion of waterbody with ID % threw %', waterbody_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_waterbodies: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobjectgroups(
  lineage_value TEXT,
  delete_members INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  path_setting TEXT;
  cityobjectgroup_id INTEGER;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR cityobjectgroup_id IN SELECT id FROM cityobject WHERE objectclass_id = 23 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_cityobjectgroup(cityobjectgroup_id, delete_members, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_cityobjectgroups: deletion of cityobjectgroup with ID % threw %', cityobjectgroup_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobjectgroups: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_relief_features(
  lineage_value TEXT, 
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  relief_feature_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR relief_feature_id IN SELECT id FROM cityobject WHERE objectclass_id = 14 AND lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_relief_feature(relief_feature_id, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_relief_features: deletion of relief_feature with ID % threw %', relief_feature_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_relief_features: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobjects(
  lineage_value TEXT,
  delete_members INTEGER DEFAULT 0,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  cityobject_id INTEGER;
  path_setting TEXT;
BEGIN
  -- set search_path for this session
  path_setting := current_setting('search_path');
  PERFORM set_config('search_path', schema_name, true);

  FOR cityobject_id IN SELECT id FROM cityobject WHERE lineage = lineage_value LOOP
    BEGIN
      deleted_id := citydb_pkg.delete_cityobject(cityobject_id, delete_members, 0, schema_name);
      RETURN NEXT deleted_id;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'delete_cityobjects: deletion of cityobject with ID % threw %', cityobject_id, SQLERRM;
    END;
  END LOOP;

  -- cleanup
  PERFORM citydb_pkg.cleanup_implicit_geometries(1, schema_name);
  PERFORM citydb_pkg.cleanup_appearances(1, schema_name);
  PERFORM citydb_pkg.cleanup_citymodels(schema_name);

  -- reset search_path in case auto_commit is switched off
  PERFORM set_config('search_path', path_setting, true);

  RETURN;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_cityobjects: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;