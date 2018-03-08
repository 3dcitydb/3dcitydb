-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2017
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

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   batch_delete_genericattribs(int[]) RETURNS int[]
*   batch_delete_geometry(int[]) RETURNS int[]
*   cleanup_appearances(only_global int DEFAULT 1) RETURNS SETOF int
*   cleanup_citymodels() RETURNS SETOF int
*   delete_address(int) RETURNS int
*   delete_addresses(int[]) RETURNS int[]
*   delete_appearance(int) RETURNS int
*   delete_appearances(int[]) RETURNS int[]
*   delete_bridge(int) RETURNS int
*   delete_bridges(int[]) RETURNS int[]
*   delete_bridge_constr_element(int) RETURNS int
*   delete_bridge_constr_elements(int[]) RETURNS int[]
*   delete_bridge_furniture(int) RETURNS int
*   delete_bridge_furnitures(int[]) RETURNS int[]
*   delete_bridge_installation(int) RETURNS int
*   delete_bridge_installations(int[]) RETURNS int[]
*   delete_bridge_opening(int) RETURNS int
*   delete_bridge_openings(int[]) RETURNS int[]
*   delete_bridge_room(int) RETURNS int
*   delete_bridge_rooms(int[]) RETURNS int[]
*   delete_bridge_them_srf(int) RETURNS int
*   delete_bridge_them_srfs(int[]) RETURNS int[]
*   delete_building(int) RETURNS int
*   delete_buildings(int[]) RETURNS int[]
*   delete_building_furniture(int) RETURNS int
*   delete_building_furnitures(int[]) RETURNS int[]
*   delete_building_installation(int) RETURNS int
*   delete_building_installations(int[]) RETURNS int[]
*   delete_city_furniture(int) RETURNS int
*   delete_city_furnitures(int[]) RETURNS int[]
*   delete_citymodel(cm_id INTEGER, delete_members INTEGER DEFAULT 0) RETURNS int 
*   delete_cityobject(co_id INTEGER, delete_members INTEGER DEFAULT 0, cleanup INTEGER DEFAULT 0) RETURNS int
*   delete_cityobjects(int[]) RETURNS int[]
*   delete_cityobjectgroup(cog_id INTEGER, delete_members INTEGER DEFAULT 0) RETURNS int
*   delete_cityobjectgroups(int[]) RETURNS int[]
*   delete_cityobject_geometries(int[]) RETURNS int[]
*   delete_cityobject_geometry(int, clean_apps int DEFAULT 0) RETURNS int
*   delete_external_reference(int) RETURNS int
*   delete_external_references(int[]) RETURNS int[]
*   delete_grid_coverage(int) RETURNS int
*   delete_grid_coverages(int[]) RETURNS int[]
*   delete_genericattrib(genattrib_id int, delete_members int DEFAULT 0) RETURNS int
*   delete_genericattribs(int[]) RETURNS int[]
*   delete_generic_cityobject(int) RETURNS int
*   delete_generic_cityobjects(int[]) RETURNS int[]
*   delete_implicit_geometries(int[]) RETURNS int[]
*   delete_implicit_geometry(ig_id INTEGER, clean_apps int DEFAULT 0) RETURNS int
*   delete_land_use(int) RETURNS int
*   delete_land_uses(int[]) RETURNS int[]
*   delete_opening(int) RETURNS int
*   delete_openings(int[]) RETURNS int[]
*   delete_plant_cover(int) RETURNS int
*   delete_plant_covers(int[]) RETURNS int[]
*   delete_relief_component(int) RETURNS int
*   delete_relief_components(int[]) RETURNS int[]
*   delete_relief_feature(int) RETURNS int
*   delete_relief_features(int[]) RETURNS int[]
*   delete_room(int) RETURNS int
*   delete_rooms(int[]) RETURNS int[]
*   delete_solitary_veg_obj(int) RETURNS int
*   delete_solitary_veg_objs(int[]) RETURNS int[]
*   delete_surface_data(int) RETURNS int
*   delete_surface_datas(int[]) RETURNS int[]
*   delete_surface_geometries(int[]) RETURNS int[]
*   delete_surface_geometry(sg_id INTEGER, clean_apps int DEFAULT 0) RETURNS int
*   delete_thematic_surface(int) RETURNS int
*   delete_thematic_surfaces(int[]) RETURNS int[]
*   delete_traffic_area(int) RETURNS int
*   delete_traffic_areas(int[]) RETURNS int[]
*   delete_transport_complex(int) RETURNS int
*   delete_transport_complexes(int[]) RETURNS int[]
*   delete_tunnel(int) RETURNS int
*   delete_tunnels(int[]) RETURNS int[]
*   delete_tunnel_furniture(int) RETURNS int
*   delete_tunnel_furnitures(int[]) RETURNS int[]
*   delete_tunnel_hollow_space(int) RETURNS int
*   delete_tunnel_hollow_spaces(int[]) RETURNS int[]
*   delete_tunnel_installation(int) RETURNS int
*   delete_tunnel_installations(int[]) RETURNS int[]
*   delete_tunnel_opening(int)RETURNS int
*   delete_tunnel_openings(int[]) RETURNS int
*   delete_tunnel_them_srf(int) RETURNS int
*   delete_tunnel_them_srfs(int[]) RETURNS int[]
*   delete_waterbnd_surface(int) RETURNS int
*   delete_waterbnd_surfaces(int[]) RETURNS int[]
*   delete_waterbody(int) RETURNS int
*   delete_waterbodies(int[]) RETURNS int[]
*   intern_delete_cityobject(int) RETURNS int
*   intern_delete_cityobjects(int[]) RETURNS int[]
*
* AGGREGATE FUNCTIONS:
*   batch_delete_genericattribs(int)
*   batch_delete_geometry(int)
*   delete_addresses(int)
*   delete_appearances(int)
*   delete_bridges(int)
*   delete_bridge_constr_elements(int)
*   delete_bridge_furnitures(int)
*   delete_bridge_installations(int)
*   delete_bridge_openings(int)
*   delete_bridge_rooms(int)
*   delete_bridge_them_srfs(int)
*   delete_buildings(int)
*   delete_building_furnitures(int)
*   delete_building_installations(int)
*   delete_city_furnitures(int)
*   delete_cityobjectgroups(int)
*   delete_cityobjects(int)
*   delete_cityobject_geometries(int)
*   delete_external_references(int)
*   delete_grid_coverages(int)
*   delete_genericattribs(int)
*   delete_generic_cityobjects(int)
*   delete_implicit_geometries(int)
*   delete_land_uses(int)
*   delete_openings(int)
*   delete_plant_covers(int)
*   delete_relief_components(int)
*   delete_relief_features(int)
*   delete_rooms(int)
*   delete_solitary_veg_objs(int)
*   delete_surface_datas(int)
*   delete_surface_geometries(int)
*   delete_thematic_surfaces(int)
*   delete_traffic_areas(int)
*   delete_transport_complexes(int)
*   delete_tunnels(int)
*   delete_tunnel_furnitures(int)
*   delete_tunnel_hollow_spaces(int)
*   delete_tunnel_installations(int)
*   delete_tunnel_openings(int)
*   delete_tunnel_them_srfs(int)
*   delete_waterbnd_surfaces(int)
*   delete_waterbodies(int)
*   intern_delete_cityobjects(int)
*
******************************************************************/

-- DELETE ADDRESS

/*****************************************************************
* delete_addresses
*
* Aggregate function to delete multiple addresses at once.
* Selected IDs are collected in an array an passed to a final
* delete_addresses function that performs the delete process.
*
* @param        @description
* integer       id of addresses
*
* @return
* array of IDs from deleted addresses
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_addresses(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete references to buildings
  DELETE FROM address_to_building a2b USING (
    SELECT unnest($1) AS ad_id
  ) a
  WHERE a2b.address_id = a.ad_id;

  -- delete references to bridges
  DELETE FROM address_to_bridge a2b USING (
    SELECT unnest($1) AS ad_id
  ) a
  WHERE a2b.address_id = a.ad_id;

  -- delete references to openings
  UPDATE opening SET address_id = NULL FROM (
    SELECT unnest($1) AS ad_id
  ) a
  WHERE address_id = a.ad_id;

  -- delete references to bridge openings
  UPDATE bridge_opening SET address_id = NULL FROM (
    SELECT unnest($1) AS ad_id
  ) a
  WHERE address_id = a.ad_id;

  -- delete addresses
  WITH delete_objects AS (
    DELETE FROM address ad USING (
      SELECT unnest($1) AS ad_id
    ) a  
    WHERE ad.id = a.ad_id
    RETURNING ad.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  RETURN result_array;
END;
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_addresses(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_addresses
);

/*****************************************************************
* delete_address
*
* Function to delete a single address
*
* @param        @description
* integer       id of address
*
* @return
* ID of deleted address
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_address(int[]) RETURNS int[] AS
$$
DECLARE
  deleted_id INTEGER;
BEGIN
  -- delete reference to buildings
  DELETE FROM address_to_building WHERE address_id = $1;

  -- delete reference to bridges
  DELETE FROM address_to_bridge WHERE address_id = $1;

  -- delete reference to openings
  UPDATE opening SET address_id = NULL WHERE address_id = $1;

  -- delete reference to bridge openings
  UPDATE bridge_opening SET address_id = NULL WHERE address_id = $1;

  -- delete address
  DELETE FROM address WHERE id = $1
    RETURNING id INTO deleted_id;

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE EXTERNAL REFERENCE

/*****************************************************************
* delete_external_references
*
* Aggregate function to delete multiple external references at once.
* Selected IDs are collected in an array an passed to a final
* delete_external_references function that performs the delete process.
*
* @param        @description
* integer       id of external references
*
* @return
* array of IDs from deleted external references
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_external_references(int[]) RETURNS int[] AS
$$
WITH delete_ext_refs AS (
  DELETE FROM external_reference er USING (
    SELECT unnest($1) AS ref_id
  ) a  
  WHERE er.id = a.ref_id
  RETURNING er.id
)
SELECT array_agg(id) FROM delete_ext_refs;
$$ 
LANGUAGE sql STRICT;

CREATE AGGREGATE citydb_pkg.delete_external_references(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_external_references
);

/*****************************************************************
* delete_tex_image
*
* Function to delete a single tex image
*
* @param        @description
* integer       id of tex image
*
* @return
* ID of deleted tex image
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_external_reference(int) RETURNS int AS
$$
DELETE FROM external_reference WHERE id = $1 RETURNING id;
$$ 
LANGUAGE sql STRICT;


-- DELETE GENERIC ATTRIBUTES

/*****************************************************************
* batch_delete_genericattribs
*
* Aggregate function to delete multiple generic attributes at once.
* Selected IDs are collected in an array an passed to a final
* batch_delete_genericattribs function that performs the delete process.
* Acts as a helper funtcion to delete_genericattrib/s and 
* intern_delete_cityobject/s.
*
* @param        @description
* integer       id of generic attributes
*
* @return
* array of IDs from deleted generic attributes
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.batch_delete_genericattribs(int[]) RETURNS int[] AS
$$
WITH delete_genattrib AS (
  DELETE FROM cityobject_genericattrib cga USING (
    SELECT cga_id, idx FROM unnest($1) WITH ORDINALITY AS arr(cga_id, idx)
  ) a
  WHERE cga.id = a.cga_id
  RETURNING cga.id
)
SELECT array_agg(id) FROM delete_genattrib;
$$
LANGUAGE sql;

CREATE AGGREGATE citydb_pkg.batch_delete_genericattribs(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.batch_delete_genericattribs
);

/*****************************************************************
* delete_genericattribs
*
* Aggregate function to delete multiple generic attributes at once.
* Selected IDs are collected in an array an passed to a final
* delete_genericattribs function that deletes the different layers
* of attribute hierarchies in batches. To keep members of generic
* attribute sets use delete_genericattrib function.
*
* @param        @description
* integer       id of city objects
*
* @return
* array of IDs from deleted entries from surface_geometry table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_genericattribs(int[]) RETURNS int[] AS
$$
-- delete levels of generic attribute tree in batches
WITH RECURSIVE genattrib(id, parent_genattrib_id, level) AS (
  SELECT cga.id, cga.parent_genattrib_id, 1 AS level 
    FROM cityobject_genericattrib cga, (
      SELECT unnest($1) AS cga_id
    ) a
    WHERE cga.id = a.cga_id
  UNION ALL
    SELECT cga.id, cga.parent_genattrib_id, g.level + 1 AS level 
      FROM cityobject_genericattrib cga, genattrib g
      WHERE cga.parent_genattrib_id = g.id
)
SELECT citydb_pkg.batch_delete_genericattribs(g.id ORDER BY g.level DESC) AS result_array FROM (
  SELECT DISTINCT ON (id) id, level
    FROM genattrib
    ORDER BY id DESC, level DESC
) g;
$$
LANGUAGE sql STRICT;

CREATE AGGREGATE citydb_pkg.delete_genericattribs(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_genericattribs
);

/*****************************************************************
* delete_genericattrib
*
* Function to delete a single generic attribute
*
* @param           @description
* genattrib_id     id of generic attribute
* delete_members   1 for deleting members of a set
*                  0 to keep member attributes and turn them into
*                    regular generic attributes 
*
* @return
* ID of deleted generic attribute
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_genericattrib(
  genattrib_id int,
  delete_members int DEFAULT 0
  ) RETURNS int AS
$$
DECLARE
  deleted_id int;
  genattrib_parent_id int;
  data_type int;
  dummy_array int[] := '{}';
  member_id int;
  member_rec RECORD;
BEGIN
  -- get parent_id and data type
  SELECT parent_genattrib_id, datatype INTO genattrib_parent_id, data_type
    FROM cityobject_genericattrib WHERE id = $1;

  -- if the attribute to be deleted is a set, first handle nested attributes
  IF data_type = 7 THEN
    IF delete_members <> 0 THEN
      -- recursive delete of nested attributes
      WITH RECURSIVE genattrib(id, parent_genattrib_id, level) AS (
        SELECT id, parent_genattrib_id, 1 AS level 
          FROM cityobject_genericattrib
          WHERE parent_genattrib_id = $1
        UNION ALL
          SELECT cga.id, cga.parent_genattrib_id, g.level + 1 AS level 
            FROM cityobject_genericattrib cga, genattrib g
            WHERE cga.parent_genattrib_id = g.id
      )
      SELECT citydb_pkg.batch_delete_genericattribs(id ORDER BY level DESC) INTO dummy_array
        FROM genattrib;
    ELSE
      -- recursive update of nested attributes
      FOR member_rec IN
        WITH RECURSIVE parts (id, parent_id, root_id) AS (
          SELECT id, genattrib_parent_id::integer AS parent_id, 
            CASE WHEN root_genattrib_id = $1 THEN id ELSE root_genattrib_id END AS root_id
            FROM cityobject_genericattrib
            WHERE parent_genattrib_id = $1
          UNION ALL
            SELECT part.id, part.parent_genattrib_id AS parent_id, p.root_id
              FROM cityobject_genericattrib part, parts p 
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

  -- delete generic attribute
  DELETE FROM cityobject_genericattrib WHERE id = $1
    RETURNING id INTO deleted_id;

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE TEX IMAGE

/*****************************************************************
* delete_tex_images
*
* Aggregate function to delete multiple tex images at once.
* Selected IDs are collected in an array an passed to a final
* delete_tex_images function that performs the delete process.
*
* @param        @description
* integer       id of tex images
*
* @return
* array of IDs from deleted tex images
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tex_images(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- update referenced surface data objects
  UPDATE surface_data SET tex_image_id = NULL FROM (
    SELECT unnest($1) AS ti_id
  ) a
  WHERE tex_image_id = a.ti_id;

  -- delete tex images
  WITH delete_objects AS (
    DELETE FROM tex_image ti USING (
      SELECT unnest($1) AS ti_id
    ) a  
    WHERE ti.id = a.ti_id
    RETURNING ti.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  RETURN result_array;
END;  
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_tex_images(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_tex_images
);

/*****************************************************************
* delete_tex_image
*
* Function to delete a single tex image
*
* @param        @description
* integer       id of tex image
*
* @return
* ID of deleted tex image
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tex_image(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- update referenced surface data objects
  UPDATE surface_data SET tex_image_id = NULL WHERE tex_image_id = $1;

  -- delete tex image
  DELETE FROM tex_image WHERE id = $1
    RETURNING id INTO deleted_id;

  RETURN deleted_id;
END;  
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE SURFACE DATA

/*****************************************************************
* delete_surface_datas
*
* Aggregate function to delete multiple surface data objects at once.
* Selected IDs are collected in an array an passed to a final
* delete_surface_datas function that performs the delete process.
*
* @param        @description
* integer       id of surface data objects
*
* @return
* array of IDs from deleted surface data objects
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_datas(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  tex_image_array int[] := '{}';
BEGIN
  -- delete references to textureparam
  DELETE FROM textureparam tp USING (
    SELECT unnest($1) AS sd_id
  ) a
  WHERE tp.surface_data_id = a.sd_id;

  -- delete references to appearances
  DELETE FROM appear_to_surface_data a2sd USING (
    SELECT unnest($1) AS sd_id
  ) a
  WHERE a2sd.surface_data_id = a.sd_id;

  -- delete surface data objects
  -- remember tex_image_ids for deletion
  WITH delete_objects AS (
    DELETE FROM surface_data sd USING (
      SELECT unnest($1) AS sd_id
    ) a  
    WHERE sd.id = a.sd_id
    RETURNING sd.id, sd.tex_image_id
  )
  SELECT array_agg(id), array_agg(tex_image_id) INTO result_array, tex_image_array
    FROM delete_objects;

  -- delete tex images not being referenced by a surface data object any more
  IF -1 = ALL(tex_image_array) IS NOT NULL THEN
    DELETE FROM tex_image ti USING (
        SELECT DISTINCT unnest(tex_image_array) AS ti_id
      ) a
      LEFT JOIN surface_data sd ON sd.tex_image_id = a.ti_id
      WHERE ti.id = a.ti_id
        AND sd.tex_image_id IS NULL;
  END IF;

  RETURN result_array;
END;
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_surface_datas(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_surface_datas
);

/*****************************************************************
* delete_surface_data
*
* Function to delete a single surface data object
*
* @param        @description
* integer       id of surface data object
*
* @return
* ID of deleted surface data object
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_data(int) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  tex_id INTEGER;
BEGIN
  -- delete references to textureparam
  DELETE FROM textureparam WHERE surface_data_id = $1;

  -- delete references to appearances
  DELETE FROM appear_to_surface_data WHERE surface_data_id = $1;

  -- delete surface data object
  -- remember tex_image_id for deletion
  DELETE FROM surface_data WHERE id = $1
    RETURNING id, tex_image_id INTO deleted_id, tex_id;

  -- delete tex image not being referenced by a surface data object any more
  IF tex_id IS NOT NULL THEN
    DELETE FROM tex_image ti USING (
        SELECT tex_id
      ) t
      LEFT JOIN surface_data sd ON sd.tex_image_id = t.tex_id
      WHERE ti.id = t.tex_id
        AND sd.tex_image_id IS NULL;
  END IF;

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE APPEARANCE

/*****************************************************************
* delete_appearances
*
* Aggregate function to delete multiple appearances at once.
* Selected IDs are collected in an array an passed to a final
* delete_appearances function that performs the delete process.
*
* @param        @description
* integer       id of appearances
*
* @return
* array of IDs from deleted appearances
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearances(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  surface_data_array int[] := '{}';
BEGIN
  -- delete references to surface data
  WITH delete_surface_data_refs AS (
    DELETE FROM appear_to_surface_data a2sd USING (
      SELECT unnest($1) AS a_id
    ) a
    WHERE a2sd.appearance_id = a.a_id
    RETURNING a2sd.surface_data_id
  )
  SELECT array_agg(surface_data_id) INTO surface_data_array
    FROM delete_surface_data_refs;

  -- delete surface data not being referenced by an appearance any more
  IF -1 = ALL(surface_data_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_datas(a.sd_id)
      FROM (
        SELECT DISTINCT unnest(surface_data_array) AS sd_id
      ) a
      LEFT JOIN appear_to_surface_data a2sd
      ON a2sd.surface_data_id = a.sd_id
      WHERE a2sd.surface_data_id IS NULL;
  END IF;

  -- delete appearances
  WITH delete_objects AS (
    DELETE FROM appearance ap USING (
      SELECT unnest($1) AS a_id
    ) a 
    WHERE ap.id = a.a_id
    RETURNING ap.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  RETURN result_array;
END;
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_appearances(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_appearances
);

/*****************************************************************
* delete_appearance
*
* Function to delete a single appearance
*
* @param           @description
* integer          id of appearance
*
* @return
* ID of deleted appearance
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_appearance(int) RETURNS INTEGER AS
$$
DECLARE
  deleted_id int;
  surface_data_array int[] := '{}';
BEGIN
  -- delete references to surface data
  WITH delete_surface_data_refs AS (
    DELETE FROM appear_to_surface_data
      WHERE appearance_id = $1
      RETURNING surface_data_id
  )
  SELECT array_agg(surface_data_id)
    INTO surface_data_array FROM delete_surface_data_refs;

  -- delete surface data not being referenced by an appearance any more
  IF -1 = ALL(surface_data_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_datas(a.sd_id)
      FROM (
        SELECT unnest(surface_data_array) AS sd_id
      ) a
      LEFT JOIN appear_to_surface_data a2sd
      ON a2sd.surface_data_id = a.sd_id
      WHERE a2sd.surface_data_id IS NULL;
  END IF;

  -- delete appearance
  DELETE FROM appearance WHERE id = $1
    RETURNING id INTO deleted_id;

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;

/*****************************************************************
* cleanup_appearances
*
* Function to delete a single appearance
*
* @param           @description
* integer          id of appearance
*
* @return
* ID of deleted appearance
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_appearances(
  only_global int DEFAULT 1
  ) RETURNS SETOF int AS
$$
DECLARE
  deleted_id int;
  app_id int;
BEGIN
  -- global appearances are not related to a cityobject.
  -- however, we assume that all surface geometries of a cityobject
  -- have been deleted at this stage. thus, we can check and delete
  -- surface data which does not have a valid texture parameterization
  -- any more.
  PERFORM citydb_pkg.delete_surface_datas(s.id)
    FROM surface_data s 
    LEFT OUTER JOIN textureparam t ON s.id = t.surface_data_id 
    WHERE t.surface_data_id IS NULL;

  -- delete appearances which does not have surface data any more
  IF only_global=1 THEN
    FOR app_id IN 
      SELECT a.id FROM appearance a 
        LEFT OUTER JOIN appear_to_surface_data asd ON a.id=asd.appearance_id 
          WHERE a.cityobject_id IS NULL AND asd.appearance_id IS NULL
    LOOP
      DELETE FROM appearance WHERE id = app_id RETURNING id INTO deleted_id;
      RETURN NEXT deleted_id;
    END LOOP;
  ELSE
    FOR app_id IN 
      SELECT a.id FROM appearance a 
        LEFT OUTER JOIN appear_to_surface_data asd ON a.id=asd.appearance_id 
          WHERE asd.appearance_id IS NULL
    LOOP
      DELETE FROM appearance WHERE id = app_id RETURNING id INTO deleted_id;
      RETURN NEXT deleted_id;
    END LOOP;
  END IF;

  RETURN;
END; 
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE CITY OBJECT

/*****************************************************************
* intern_delete_cityobjects
*
* Aggregate function to delete multiple city objects at once.
* Selected IDs are collected in an array an passed to a final
* intern_delete_cityobjects function that performs the delete process. 
*
* @param        @description
* integer       id of city objects
*
* @return
* array of IDs from deleted city objects
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.intern_delete_cityobjects(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  dummy_array int[] := '{}';
BEGIN
  -- delete references to city models
  DELETE FROM cityobject_member com USING (
    SELECT unnest($1) AS co_id
  ) a
  WHERE com.cityobject_id = a.co_id;

  -- delete references to city object groups
  DELETE FROM group_to_cityobject g2co USING (
    SELECT unnest($1) AS co_id
  ) a
  WHERE g2co.cityobject_id = a.co_id;

  -- update hierarchies in cityobjectgroup table
  UPDATE cityobjectgroup cog SET parent_cityobject_id = NULL 
    FROM (
      SELECT unnest($1) AS co_id
    ) a 
    WHERE cog.parent_cityobject_id = a.co_id;

  -- delete self references
  DELETE FROM generalization g USING (
    SELECT unnest($1) AS co_id
  ) a 
  WHERE g.generalizes_to_id = a.co_id
     OR g.cityobject_id = a.co_id;

  -- delete external references
  DELETE FROM external_reference er USING (
    SELECT unnest($1) AS co_id
  ) a  
  WHERE er.cityobject_id = a.co_id;

  -- delete levels of generic attributes sets in batches
  WITH RECURSIVE genattrib(id, parent_genattrib_id, level) AS (
    SELECT cga.id, cga.parent_genattrib_id, 1 AS level 
      FROM cityobject_genericattrib cga, (
        SELECT unnest($1) AS co_id
      ) a
      WHERE cga.cityobject_id = a.co_id
        AND cga.parent_genattrib_id IS NULL
    UNION ALL
      SELECT cga.id, cga.parent_genattrib_id, g.level + 1 AS level 
        FROM cityobject_genericattrib cga, genattrib g
        WHERE cga.parent_genattrib_id = g.id
  )
  SELECT citydb_pkg.batch_delete_genericattribs(id ORDER BY level DESC) INTO dummy_array
    FROM genattrib;

  -- delete local appearances
  PERFORM citydb_pkg.delete_appearances(id)
    FROM appearance ap, (
      SELECT unnest($1) AS co_id
    ) a  
    WHERE ap.cityobject_id = a.co_id;

  -- delete city objects
  WITH delete_objects AS (
    DELETE FROM cityobject co USING (
      SELECT unnest($1) AS co_id
    ) a  
    WHERE co.id = a.co_id
    RETURNING co.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects; 

  RETURN result_array;
END;
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.intern_delete_cityobjects(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.intern_delete_cityobjects
);

/*****************************************************************
* intern_delete_cityobject
*
* Function to delete a single city object
*
* @param        @description
* integer       id of city object
*
* @return
* ID of deleted city objects
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.intern_delete_cityobject(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  dummy_array int[] := '{}';
BEGIN
  -- delete references to city models
  DELETE FROM cityobject_member WHERE cityobject_id = $1;

  -- delete references to city object groups
  DELETE FROM group_to_cityobject WHERE cityobject_id = $1;

  -- update hierarchies in cityobjectgroup table
  UPDATE cityobjectgroup SET parent_cityobject_id = NULL
    WHERE parent_cityobject_id = $1;

  -- delete self references
  DELETE FROM generalization
    WHERE generalizes_to_id = $1
       OR cityobject_id = $1;

  -- delete self references
  DELETE FROM external_reference WHERE cityobject_id = $1;

  -- delete levels of generic attributes sets in batches
  WITH RECURSIVE genattrib(id, parent_genattrib_id, level) AS (
    SELECT id, parent_genattrib_id, 1 AS level 
      FROM cityobject_genericattrib
      WHERE cityobject_id = $1
        AND parent_genattrib_id IS NULL
    UNION ALL
      SELECT cga.id, cga.parent_genattrib_id, g.level + 1 AS level 
        FROM cityobject_genericattrib cga, genattrib g
        WHERE cga.parent_genattrib_id = g.id
  )
  SELECT citydb_pkg.batch_delete_genericattribs(id ORDER BY level DESC) INTO dummy_array
    FROM genattrib;

  -- delete local appearances
  PERFORM citydb_pkg.delete_appearances(id)
    FROM appearance WHERE cityobject_id = $1;

  -- delete city object
  DELETE FROM cityobject WHERE id = $1
    RETURNING id INTO deleted_id;

  RETURN deleted_id;
END;
$$ 
LANGUAGE plpgsql STRICT;

-- dummy for correct compilation of following functions
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobjects(int[]) RETURNS int[] AS
$$
SELECT '{}'::int[] AS result_array;
$$
LANGUAGE sql STRICT;

CREATE AGGREGATE citydb_pkg.delete_cityobjects(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_cityobjects
);


-- DELETE GEOMETRY

/*****************************************************************
* batch_delete_geometry
*
* Aggregate function to delete multiple entries from surface_geometry
* at once. Selected IDs are collected in an array an passed to a final
* batch_delete_geometry function that performs the delete process.
* Acts as a helper funtcion to delete_surface_geometry/ies and
* delete_cityobject_geometry/ies.
*
* @param        @description
* integer       id of entries in surface_geometry table
*
* @return
* array of IDs from deleted entries from surface_geometry table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.batch_delete_geometry(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete references to textureparam table
  DELETE FROM textureparam tp USING (
    SELECT unnest($1) AS sg_id
  ) a
  WHERE tp.surface_geometry_id = a.sg_id;

  -- delete entries from surface_geometry table
  WITH delete_geometry AS (
    DELETE FROM surface_geometry sg USING (
      SELECT sg_id, idx FROM unnest($1) WITH ORDINALITY AS arr(sg_id, idx)
    ) a
    WHERE sg.id = a.sg_id
    RETURNING sg.id
  )
  SELECT array_agg(id) INTO result_array FROM delete_geometry;

  RETURN result_array;
END
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.batch_delete_geometry(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.batch_delete_geometry
);

/*****************************************************************
* delete_surface_geometries
*
* Aggregate function to delete multiple entries from surface_geometry
* at once. Selected IDs are collected in an array an passed to a final
* delete_surface_geometries function that deletes the different layers
* of geometric hierarchies in batches. To clean up appearances after
* deleting geometry call delete_surface_geometry function and use the
* second argument.
*
* @param        @description
* integer       id of city objects
*
* @return
* array of IDs from deleted entries from surface_geometry table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_geometries(int[]) RETURNS int[] AS
$$
-- delete levels of geometry tree in batches
WITH RECURSIVE geometry(id, parent_id, level) AS (
  SELECT sg.id, sg.parent_id, 1 AS level 
    FROM surface_geometry sg, (
      SELECT unnest($1) AS sg_id
    ) a
    WHERE sg.id = a.sg_id
  UNION ALL
    SELECT sg.id, sg.parent_id, g.level + 1 AS level 
      FROM surface_geometry sg, geometry g
      WHERE sg.parent_id = g.id
)
SELECT citydb_pkg.batch_delete_geometry(g.id ORDER BY g.level DESC) AS result_array FROM (
  SELECT DISTINCT ON (id) id, level
    FROM geometry
    ORDER BY id DESC, level DESC
) g;
$$
LANGUAGE sql STRICT;

CREATE AGGREGATE citydb_pkg.delete_surface_geometries(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_surface_geometries
);

/*****************************************************************
* delete_surface_geometry
*
* Function to delete a single entry from surface geometry table
* incl. depending entries in the geometry tree
*
* @param        @description
* sg_id         id of surface_geometry entry
* clean_apps    1 for deleting orphaned appearances right away
*               0 do not clean up appearances (default)
*
* @return
* array of IDs from deleted entries from surface_geometry table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_surface_geometry(
  sg_id int,
  clean_apps int DEFAULT 0
  ) RETURNS int[] AS
$$
DECLARE
  result_array int := '{}';
BEGIN
  -- delete levels of geometry tree in batches
  WITH RECURSIVE geometry(id, parent_id, level) AS (
    SELECT sg.id, sg.parent_id, 1 AS level 
      FROM surface_geometry
      WHERE id = $1
    UNION ALL
      SELECT sg.id, sg.parent_id, g.level + 1 AS level 
        FROM surface_geometry sg, geometry g
        WHERE sg.parent_id = g.id
  )
  SELECT citydb_pkg.batch_delete_geometry(id ORDER BY level DESC) INTO result_array
    FROM geometry;

  -- delete appearances not being referenced by geometry any more
  IF clean_apps <> 0 THEN
    PERFORM citydb_pkg.cleanup_appearances(0);
  END IF;

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* delete_cityobject_geometries
*
* Aggregate function to delete the geometry of multiple city objects
* at once. Selected IDs are collected in an array an passed to a final
* delete_cityobject_geometries function that deletes the different layers
* of geometric hierarchies in batches. To clean up appearances after
* deleting geometry call delete_cityobject_geometry function and use the
* second argument.
*
* @param        @description
* integer       id of city objects
*
* @return
* array of IDs from deleted entries from surface_geometry table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject_geometries(int[]) RETURNS int[] AS
$$
-- delete levels of referenced geometry tree in batches
WITH RECURSIVE geometry(id, parent_id, level) AS (
  SELECT sg.id, sg.parent_id, 1 AS level 
    FROM surface_geometry sg, (
      SELECT unnest($1) AS co_id
    ) a
    WHERE sg.cityobject_id = a.co_id
      AND sg.parent_id IS NULL
  UNION ALL
    SELECT sg.id, sg.parent_id, g.level + 1 AS level 
      FROM surface_geometry sg, geometry g
      WHERE sg.parent_id = g.id
)
SELECT citydb_pkg.batch_delete_geometry(id ORDER BY level DESC) AS result_array
  FROM geometry;
$$
LANGUAGE sql STRICT;

CREATE AGGREGATE citydb_pkg.delete_cityobject_geometries(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_cityobject_geometries
);

/*****************************************************************
* delete_cityobject_geometry
*
* Function to delete the geometry of a single city object
*
* @param        @description
* co_id         id of cityobject
* clean_apps    1 for deleting orphaned appearances right away
*               0 do not clean up appearances (default)
*
* @return
* array of IDs from deleted entries from surface_geometry table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject_geometry(
  co_id int,
  clean_apps int DEFAULT 0
  ) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete levels of referenced geometry tree in batches
  WITH RECURSIVE geometry(id, parent_id, level) AS (
    SELECT id, parent_id, 1 AS level 
      FROM surface_geometry
      WHERE cityobject_id = $1
        AND parent_id IS NULL
    UNION ALL
      SELECT sg.id, sg.parent_id, g.level + 1 AS level 
        FROM surface_geometry sg, geometry g
        WHERE sg.parent_id = g.id
  )
  SELECT citydb_pkg.batch_delete_geometry(id ORDER BY level DESC) INTO result_array
    FROM geometry;

  -- delete appearances not being referenced by geometry any more
  IF clean_apps <> 0 THEN
    PERFORM citydb_pkg.cleanup_appearances(0);
  END IF;

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE IMPLICIT GEOMETRY

/*****************************************************************
* delete_implicit_geometries
*
* Aggregate function to delete the geometry of multiple city objects
* at once. Selected IDs are collected in an array an passed to a final
* delete_implicit_geometries function that performs the delete process.
* To clean up appearances after deleting implicit geometry call 
* delete_implicit_geometry function and use the second argument.
*
* @param        @description
* integer       id of city objects
*
* @return
* array of IDs from deleted entries from surface_geometry table
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometries(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  rel_brep_array int[] := '{}';
BEGIN
  -- delete implicit geometry
  -- remember references to surface geometry
  WITH delete_objects AS (
    DELETE FROM implicit_geometry ig USING (
      SELECT unnest($1) AS ig_id
    ) a  
    WHERE ig.id = a.ig_id
    RETURNING ig.id, ig.relative_brep_id
  )
  SELECT array_agg(id), array_agg(relative_brep_id) INTO result_array, rel_brep_array
    FROM delete_objects;

  -- delete surface geometry not being referenced by an implicit geometry any more
  PERFORM citydb_pkg.delete_surface_geometries(a.rel_brep_id) 
    FROM (
      SELECT DISTINCT unnest(rel_brep_array) AS rel_brep_id
    ) a
    LEFT JOIN implicit_geometry ig ON ig.relative_brep_id = a.rel_brep_id
    WHERE ig.relative_brep_id IS NULL;

  RETURN result_array;
END; 
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_implicit_geometries(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_implicit_geometries
);

/*****************************************************************
* delete_implicit_geometry
*
* Function to delete an implicit geometry
*
* @param        @description
* ig_id         id of implicit geometry
* clean_apps    1 for deleting orphaned appearances right away
*               0 do not clean up appearances (default)
*
* @return
* ID of deleted implicit geometry
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_implicit_geometry(
  ig_id int,
  clean_apps int DEFAULT 0
  ) RETURNS int AS
$$
DECLARE
  deleted_id int;
  rel_brep_id int;
BEGIN
  -- delete implicit geometry
  -- remember references to surface geometry
  DELETE FROM implicit_geometry WHERE id = $1 
    RETURNING id, relative_brep_id INTO deleted_id, rel_brep_id;

  -- delete surface geometry not being referenced by an implicit geometry any more
  IF rel_brep_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_surface_geometry(a.rel_brep_id, $2) 
      FROM (
        SELECT rel_brep_id
      ) a
      LEFT JOIN implicit_geometry ig ON ig.relative_brep_id = a.rel_brep_id
      WHERE ig.relative_brep_id IS NULL;
  END IF;

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE GRID COVERAGE

/*****************************************************************
* delete_grid_coverages
*
* Aggregate function to delete multiple grid coverages at once.
* Selected IDs are collected in an array an passed to a final
* delete_grid_coverages function that performs the delete process.
*
* @param        @description
* integer       id of grid coverages
*
* @return
* array of IDs from deleted grid coverages
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_grid_coverages(int[]) RETURNS int[] AS
$$
WITH delete_grid_covs AS (
  DELETE FROM grid_coverage gc USING (
    SELECT unnest($1) AS gc_id
  ) a  
  WHERE gc.id = a.gc_id
  RETURNING gc.id
)
SELECT array_agg(id) FROM delete_grid_covs;
$$ 
LANGUAGE sql STRICT;

CREATE AGGREGATE citydb_pkg.delete_grid_coverages(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_grid_coverages
);

/*****************************************************************
* delete_grid_coverage
*
* Function to delete a single grid coverage
*
* @param           @description
* integer          id of grid coverage
*
* @return
* ID of deleted grid coverage
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_grid_coverage(int) RETURNS int AS
$$
DELETE FROM grid_coverage WHERE id = $1 RETURNING id; 
$$ 
LANGUAGE sql STRICT;


-- DELETE BUILDING FURNITURE

/*****************************************************************
* delete_building_furnitures
*
* Aggregate function to delete multiple building furniture at once.
* Selected IDs are collected in an array an passed to a final
* delete_building_furnitures function that performs the delete process. 
*
* @param        @description
* integer       id of building furniture
*
* @return
* array of IDs from deleted building furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_building_furnitures(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete building furniture
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM building_furniture bf USING (
      SELECT unnest($1) AS bf_id
    ) a
    WHERE bf.id = a.bf_id 
    RETURNING bf.id, bf.lod4_implicit_rep_id
  )
  SELECT array_agg(id), array_agg(lod4_implicit_rep_id) INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other building furniture any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN building_furniture bf ON bf.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE bf.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_building_furnitures(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_building_furnitures
);

/*****************************************************************
* delete_building_furniture
*
* Function to delete a single building furniture
*
* @param        @description
* integer       id of building furniture
*
* @return
* ID of deleted building furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_building_furniture(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  implicit_rep_id int;
BEGIN
  -- delete building furniture
  -- remember ID of implicit geometry
  DELETE FROM building_furniture WHERE id = $1
    RETURNING id, lod4_implicit_rep_id INTO deleted_id, implicit_rep_id;

  -- delete implicit geometry not being referenced by other building furniture any more  
  IF implicit_rep_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometry(a.implicit_rep_id) 
      FROM (
        SELECT implicit_rep_id
      ) a
      LEFT JOIN building_furniture bf ON bf.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE bf.lod4_implicit_rep_id IS NULL;	
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE OPENING

/*****************************************************************
* delete_openings
*
* Aggregate function to delete multiple openings at once.
* Selected IDs are collected in an array an passed to a final
* delete_openings function that performs the delete process. 
*
* @param        @description
* integer       id of openings
*
* @return
* array of IDs from deleted openings
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_openings(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  address_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete references to thematic surfaces
  DELETE FROM opening_to_them_surface o2ts USING (
    SELECT unnest($1) AS o_id
  ) a
  WHERE o2ts.opening_id = a.o_id;

  -- delete openings
  -- remember IDs of addresses and implicit geometry
  WITH delete_objects AS (
    DELETE FROM opening o USING (
      SELECT unnest($1) AS o_id
    ) a
    WHERE o.id = a.o_id
    RETURNING o.id, o.address_id, o.lod3_implicit_rep_id, o.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(address_id),
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, address_array, implicit_rep_array
    FROM delete_objects;

  -- delete address(es) not being referenced by a building or an opening any more
  IF -1 = ALL(address_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_addresses(a.ad_id)
      FROM (
        SELECT DISTINCT unnest(address_array) AS ad_id
      ) a
      LEFT JOIN opening o
      ON o.address_id = a.ad_id
      LEFT JOIN address_to_building a2b
      ON a2b.address_id = a.ad_id
      WHERE o.address_id IS NULL
        AND a2b.address_id IS NULL;
  END IF;

  -- delete implicit geometry not being referenced by other openings any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN opening o3 ON o3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN opening o4 ON o4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND o3.lod3_implicit_rep_id IS NULL
        AND o4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_openings(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_openings
);

/*****************************************************************
* delete_opening
*
* Function to delete a single opening
*
* @param        @description
* integer       id of opening
*
* @return
* ID of deleted opening
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_opening(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  ad_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete references to thematic surfaces
  DELETE FROM opening_to_them_surface WHERE opening_id = $1;

  -- delete opening
  -- remember IDs of address and implicit geometry
  DELETE FROM opening WHERE id = $1
    RETURNING id, address_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, ad_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete address(es) not being referenced by a building or an opening any more
  IF ad_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_address(a.ad_id)
      FROM (
        SELECT ad_id
      ) a
      LEFT JOIN opening o
      ON o.address_id = a.ad_id
      LEFT JOIN address_to_building a2b
      ON a2b.address_id = a.ad_id
      WHERE o.address_id IS NULL
        AND a2b.address_id IS NULL;
  END IF;

  -- delete implicit geometry not being referenced by other openings any more
  IF COALESCE(lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN opening o3 ON o3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN opening o4 ON o4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND o3.lod3_implicit_rep_id IS NULL
        AND o4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE THEMATIC SURFACE

/*****************************************************************
* delete_thematic_surfaces
*
* Aggregate function to delete multiple thematic surfaces at once.
* Selected IDs are collected in an array an passed to a final
* delete_thematic_surfaces function that performs the delete process. 
*
* @param        @description
* integer       id of thematic surfaces
*
* @return
* array of IDs from deleted thematic surfaces
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_thematic_surfaces(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  opening_array int[] := '{}';
BEGIN
  -- delete references to openings
  WITH delete_opening_refs AS (
    DELETE FROM opening_to_them_surface o2ts USING (
      SELECT unnest($1) AS ts_id
    ) a
    WHERE o2ts.thematic_surface_id = a.ts_id
    RETURNING o2ts.opening_id
  )
  SELECT array_agg(opening_id) INTO opening_array
    FROM delete_opening_refs;

  -- delete openings not being referenced by a thematic surface any more
  PERFORM citydb_pkg.delete_openings(a.o_id) 
    FROM (
      SELECT DISTINCT unnest(opening_array) AS o_id
    ) a
    LEFT JOIN opening_to_them_surface o2ts
    ON o2ts.opening_id = a.o_id
    WHERE o2ts.opening_id IS NULL;

  -- delete thematic surfaces
  WITH delete_objects AS (
    DELETE FROM thematic_surface ts USING (
      SELECT unnest($1) AS ts_id
    ) a 
    WHERE ts.id = a.ts_id RETURNING ts.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_thematic_surfaces(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_thematic_surfaces
);

/*****************************************************************
* delete_thematic_surface
*
* Function to delete a single thematic surface
*
* @param        @description
* integer       id of thematic surface
*
* @return
* ID of deleted thematic surface
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_thematic_surface(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  opening_array int[] := '{}';
BEGIN
  -- delete references to openings
  WITH delete_opening_refs AS (
    DELETE FROM opening_to_them_surface
      WHERE thematic_surface_id = $1
      RETURNING opening_id
  )
  SELECT array_agg(opening_id) INTO opening_array
    FROM delete_opening_refs;

  -- delete openings not being referenced by a thematic surface any more
  PERFORM citydb_pkg.delete_openings(a.o_id)
    FROM (
      SELECT unnest(opening_array) AS o_id
    ) a
    LEFT JOIN opening_to_them_surface o2ts
    ON o2ts.opening_id = a.o_id
    WHERE o2ts.opening_id IS NULL;

  -- delete thematic surface
  DELETE FROM thematic_surface WHERE id = $1 RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BUILDING INSTALLATION

/*****************************************************************
* delete_building_installations
*
* Aggregate function to delete multiple building installations at once.
* Selected IDs are collected in an array an passed to a final
* delete_building_installations function that performs the delete process. 
*
* @param        @description
* integer       id of building installations
*
* @return
* array of IDs from deleted building installations
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_building_installations(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surfaces(ts.id)
    FROM thematic_surface ts, (
      SELECT unnest($1) AS bi_id
    ) a 
    WHERE ts.building_installation_id = a.bi_id;

  -- delete building installations
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM building_installation bi USING (
      SELECT unnest($1) AS bi_id
    ) a
    WHERE bi.id = a.bi_id
    RETURNING bi.id, bi.lod2_implicit_rep_id, bi.lod3_implicit_rep_id, bi.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(lod2_implicit_rep_id) || 
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other building installations any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN building_installation bi2 ON bi2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN building_installation bi3 ON bi3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN building_installation bi4 ON bi4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND bi2.lod2_implicit_rep_id IS NULL
        AND bi3.lod3_implicit_rep_id IS NULL
        AND bi4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_building_installations(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_building_installations
);

/*****************************************************************
* delete_building_installation
*
* Function to delete a single building installation
*
* @param        @description
* integer       id of building installation
*
* @return
* ID of deleted building installation
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_building_installation(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  lod2_impl_rep_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surfaces(id)
    FROM thematic_surface
    WHERE building_installation_id = $1;

  -- delete building installation
  -- remember IDs of implicit geometry
  DELETE FROM building_installation WHERE id = $1
    RETURNING id, lod2_implicit_rep_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete implicit geometry not being referenced by other building installations any more
  IF COALESCE(lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod2_impl_rep_id), (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN building_installation bi2 ON bi2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN building_installation bi3 ON bi3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN building_installation bi4 ON bi4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND bi2.lod2_implicit_rep_id IS NULL
        AND bi3.lod3_implicit_rep_id IS NULL
        AND bi4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE ROOM

/*****************************************************************
* delete_rooms
*
* Aggregate function to delete multiple rooms at once.
* Selected IDs are collected in an array an passed to a final
* delete_rooms function that performs the delete process. 
*
* @param        @description
* integer       id of rooms
*
* @return
* array of IDs from deleted rooms
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_rooms(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete building furniture
  PERFORM citydb_pkg.delete_building_furnitures(bf.id)
    FROM building_furniture bf, (
      SELECT unnest($1) AS r_id
    ) a 
    WHERE bf.room_id = a.r_id;

  -- delete room installations
  PERFORM citydb_pkg.delete_building_installations(bi.id)
    FROM building_installation bi, (
      SELECT unnest($1) AS r_id
    ) a 
    WHERE bi.room_id = a.r_id;

  -- delete interior thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surfaces(ts.id)
    FROM thematic_surface ts, (
      SELECT unnest($1) AS r_id
    ) a 
    WHERE ts.room_id = a.r_id;

  -- delete rooms
  WITH delete_objects AS (
    DELETE FROM room r USING (
      SELECT unnest($1) AS r_id
    ) a
    WHERE r.id = a.r_id
    RETURNING r.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_rooms(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_rooms
);

/*****************************************************************
* delete_room
*
* Function to delete a single room
*
* @param        @description
* integer       id of room
*
* @return
* ID of deleted room
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_room(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete building furniture
  PERFORM citydb_pkg.delete_building_furnitures(id)
    FROM building_furniture
    WHERE room_id = $1;

  -- delete room installations
  PERFORM citydb_pkg.delete_building_installations(id)
    FROM building_installation
    WHERE room_id = $1;

  -- delete interior thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surfaces(id)
    FROM thematic_surface
    WHERE room_id = $1;

  -- delete room
  DELETE FROM room WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BUILDING

/*****************************************************************
* delete_buildings
*
* Aggregate function to delete multiple buildings at once.
* Selected IDs are collected in an array an passed to a final
* delete_buildings function that performs the delete process. 
*
* @param        @description
* integer       id of buildings
*
* @return
* array of IDs from deleted buildings (incl. parts)
******************************************************************/
-- dummy for correct compilation of following functions
CREATE OR REPLACE FUNCTION citydb_pkg.delete_buildings(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_buildings(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_buildings
);

CREATE OR REPLACE FUNCTION citydb_pkg.delete_buildings(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  parts_array int[] := '{}';
  address_array int[] := '{}';
BEGIN
  -- delete building parts
  PERFORM citydb_pkg.delete_buildings(b.id) INTO parts_array
    FROM building b, (
      SELECT unnest($1) AS b_id
    ) a   
    WHERE b.building_parent_id = b_id
      AND b.id != b_id;

  -- delete rooms
  PERFORM citydb_pkg.delete_rooms(r.id)
    FROM room r, (
      SELECT unnest($1) AS b_id
    ) a   
    WHERE r.building_id = b_id;

  -- delete building installations
  PERFORM citydb_pkg.delete_building_installations(bi.id)
    FROM building_installation bi, (
      SELECT unnest($1) AS b_id
    ) a 
    WHERE bi.building_id = a.b_id;

  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surfaces(ts.id)
    FROM thematic_surface ts, (
      SELECT unnest($1) AS b_id
    ) a 
    WHERE ts.building_id = a.b_id;

  -- delete references to addresses
  WITH delete_address_refs AS (
    DELETE FROM address_to_building a2b USING (
      SELECT unnest($1) AS b_id
    ) a
    WHERE a2b.building_id = a.b_id
    RETURNING a2b.address_id
  )
  SELECT array_agg(address_id) INTO address_array
    FROM delete_address_refs;

  -- delete address(es) not being referenced by a building or an opening any more
  IF -1 = ALL(address_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_addresses(a.ad_id)
      FROM (
        SELECT DISTINCT unnest(address_array) AS ad_id
      ) a
      LEFT JOIN opening o
      ON o.address_id = a.ad_id
      LEFT JOIN address_to_building a2b
      ON a2b.address_id = a.ad_id
      WHERE o.address_id IS NULL
        AND a2b.address_id IS NULL;
  END IF;

  -- delete buildings
  WITH delete_objects AS (
    DELETE FROM building b USING (
      SELECT unnest($1) AS b_id
    ) a
    WHERE b.id = a.b_id
    RETURNING b.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN array_cat(result_array, parts_array);
END;
$$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* delete_building
*
* Function to delete a single building
*
* @param        @description
* integer       id of building
*
* @return
* ID of deleted building
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_building(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  address_array int[] := '{}';
BEGIN
  -- delete building parts
  PERFORM citydb_pkg.delete_buildings(id)
    FROM building
    WHERE building_parent_id = $1
      AND id != $1;

  -- delete rooms
  PERFORM citydb_pkg.delete_rooms(id)
    FROM room
    WHERE building_id = $1;

  -- delete building installations
  PERFORM citydb_pkg.delete_building_installations(id)
    FROM building_installation
    WHERE building_id = $1;

  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_thematic_surfaces(id)
    FROM thematic_surface
    WHERE building_id = $1;

  -- delete references to addresses
  WITH delete_address_refs AS (
    DELETE FROM address_to_building
    WHERE building_id = $1
    RETURNING address_id
  )
  SELECT array_agg(address_id) INTO address_array
    FROM delete_address_refs;

  -- delete address(es) not being referenced by a building or an opening any more
  IF -1 = ALL(address_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_addresses(a.ad_id)
      FROM (
        SELECT unnest(address_array) AS ad_id
      ) a
      LEFT JOIN opening o
      ON o.address_id = a.ad_id
      LEFT JOIN address_to_building a2b
      ON a2b.address_id = a.ad_id
      WHERE o.address_id IS NULL
        AND a2b.address_id IS NULL;
  END IF;

  -- delete building
  DELETE FROM building WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BRIDGE FURNITURE

/*****************************************************************
* delete_bridge_furnitures
*
* Aggregate function to delete multiple bridge furniture at once.
* Selected IDs are collected in an array an passed to a final
* delete_bridge_furnitures function that performs the delete process. 
*
* @param        @description
* integer       id of bridge furniture
*
* @return
* array of IDs from deleted bridge furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_furnitures(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete bridge furniture
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM bridge_furniture bf USING (
      SELECT unnest($1) AS bf_id
    ) a
    WHERE bf.id = a.bf_id
    RETURNING bf.id, bf.lod4_implicit_rep_id
  )
  SELECT array_agg(id), array_agg(lod4_implicit_rep_id) INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other bridge furniture any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN bridge_furniture bf ON bf.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE bf.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_bridge_furnitures(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_bridge_furnitures
);

/*****************************************************************
* delete_bridge_furniture
*
* Function to delete a single bridge furniture
*
* @param        @description
* integer       id of bridge furniture
*
* @return
* ID of deleted bridge furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_furniture(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  implicit_rep_id int;
BEGIN
  -- delete bridge furniture
  -- remember ID of implicit geometry
  DELETE FROM bridge_furniture WHERE id = $1
    RETURNING id, lod4_implicit_rep_id INTO deleted_id, implicit_rep_id;

  -- delete implicit geometry not being referenced by other bridge furniture any more  
  IF implicit_rep_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometry(a.implicit_rep_id) 
      FROM (
        SELECT implicit_rep_id
      ) a
      LEFT JOIN bridge_furniture bf ON bf.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE bf.lod4_implicit_rep_id IS NULL;	
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BRIDGE OPENING

/*****************************************************************
* delete_bridge_openings
*
* Aggregate function to delete multiple bridge openings at once.
* Selected IDs are collected in an array an passed to a final
* delete_bridge_openings function that performs the delete process. 
*
* @param        @description
* integer       id of bridge openings
*
* @return
* array of IDs from deleted bridge openings
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_openings(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  address_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete references to thematic surfaces
  DELETE FROM bridge_open_to_them_srf o2ts USING (
    SELECT unnest($1) AS o_id
  ) a
  WHERE o2ts.bridge_opening_id = a.o_id;

  -- delete openings
  -- remember IDs of addresses and implicit geometry
  WITH delete_objects AS (
    DELETE FROM bridge_opening o USING (
      SELECT unnest($1) AS o_id
    ) a
    WHERE o.id = a.o_id
    RETURNING o.id, o.address_id, o.lod3_implicit_rep_id, o.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(address_id),
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, address_array, implicit_rep_array
    FROM delete_objects;

  -- delete address(es) not being referenced by a bridge or an opening any more
  IF -1 = ALL(address_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_addresses(a.ad_id)
      FROM (
        SELECT DISTINCT unnest(address_array) AS ad_id
      ) a
      LEFT JOIN bridge_opening o
      ON o.address_id = a.ad_id
      LEFT JOIN address_to_bridge a2b
      ON a2b.address_id = a.ad_id
      WHERE o.address_id IS NULL
        AND a2b.address_id IS NULL;
  END IF;

  -- delete implicit geometry not being referenced by other openings any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN bridge_opening o3 ON o3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_opening o4 ON o4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND o3.lod3_implicit_rep_id IS NULL
        AND o4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_bridge_openings(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_bridge_openings
);

/*****************************************************************
* delete_opening
*
* Function to delete a single opening
*
* @param        @description
* integer       id of opening
*
* @return
* ID of deleted opening
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_opening(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  ad_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete references to thematic surfaces
  DELETE FROM bridge_open_to_them_srf WHERE bridge_opening_id = $1;

  -- delete opening
  -- remember IDs of address and implicit geometry
  DELETE FROM bridge_opening WHERE id = $1
    RETURNING id, address_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, ad_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete address(es) not being referenced by a bridge or an opening any more
  IF ad_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_address(a.ad_id)
      FROM (
        SELECT ad_id
      ) a
      LEFT JOIN bridge_opening o
      ON o.address_id = a.ad_id
      LEFT JOIN address_to_bridge a2b
      ON a2b.address_id = a.ad_id
      WHERE o.address_id IS NULL
        AND a2b.address_id IS NULL;
  END IF;

  -- delete implicit geometry not being referenced by other openings any more
  IF COALESCE(lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN bridge_opening o3 ON o3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_opening o4 ON o4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND o3.lod3_implicit_rep_id IS NULL
        AND o4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BRIDGE THEMATIC SURFACE

/*****************************************************************
* delete_bridge_them_srfs
*
* Aggregate function to delete multiple thematic surfaces at once.
* Selected IDs are collected in an array an passed to a final
* delete_bridge_them_srfs function that performs the delete process. 
*
* @param        @description
* integer       id of thematic surfaces
*
* @return
* array of IDs from deleted thematic surfaces
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_them_srfs(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  opening_array int[] := '{}';
BEGIN
  -- delete references to openings
  WITH delete_opening_refs AS (
    DELETE FROM bridge_open_to_them_srf o2ts USING (
      SELECT unnest($1) AS ts_id
    ) a
    WHERE o2ts.bridge_thematic_surface_id = a.ts_id
    RETURNING o2ts.bridge_opening_id
  )
  SELECT array_agg(bridge_opening_id) INTO opening_array
    FROM delete_opening_refs;

  -- delete openings not being referenced by a thematic surface any more
  PERFORM citydb_pkg.delete_bridge_openings(a.o_id) 
    FROM (
      SELECT DISTINCT unnest(opening_array) AS o_id
    ) a
    LEFT JOIN bridge_open_to_them_srf o2ts
    ON o2ts.bridge_opening_id = a.o_id
    WHERE o2ts.bridge_opening_id IS NULL;

  -- delete thematic surfaces
  WITH delete_objects AS (
    DELETE FROM bridge_thematic_surface ts USING (
      SELECT unnest($1) AS ts_id
    ) a 
    WHERE ts.id = a.ts_id
    RETURNING ts.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_bridge_them_srfs(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_bridge_them_srfs
);

/*****************************************************************
* delete_bridge_them_srf
*
* Function to delete a single thematic surface
*
* @param        @description
* integer       id of thematic surface
*
* @return
* ID of deleted thematic surface
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_them_srf(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  opening_array int[] := '{}';
BEGIN
  -- delete references to openings
  WITH delete_opening_refs AS (
    DELETE FROM bridge_open_to_them_srf
      WHERE bridge_thematic_surface_id = $1 
      RETURNING bridge_opening_id
  )
  SELECT array_agg(bridge_opening_id) INTO opening_array
    FROM delete_opening_refs;

  -- delete openings not being referenced by a thematic surface any more
  PERFORM citydb_pkg.delete_bridge_openings(a.o_id) 
    FROM (
      SELECT unnest(opening_array) AS o_id
    ) a
    LEFT JOIN bridge_open_to_them_srf o2ts
    ON o2ts.bridge_opening_id = a.o_id
    WHERE o2ts.bridge_opening_id IS NULL;

  -- delete thematic surface
  DELETE FROM bridge_thematic_surface WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BRIDGE INSTALLATION

/*****************************************************************
* delete_bridge_installations
*
* Aggregate function to delete multiple bridge installations at once.
* Selected IDs are collected in an array an passed to a final
* delete_bridge_installations function that performs the delete process. 
*
* @param        @description
* integer       id of bridge installations
*
* @return
* array of IDs from deleted bridge installations
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_installations(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srfs(ts.id)
    FROM bridge_thematic_surface ts, (
      SELECT unnest($1) AS bi_id
    ) a 
    WHERE ts.bridge_installation_id = a.bi_id;

  -- delete bridge installations
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM bridge_installation bi USING (
      SELECT unnest($1) AS bi_id
    ) a
    WHERE bi.id = a.bi_id
    RETURNING bi.id, bi.lod2_implicit_rep_id, bi.lod3_implicit_rep_id, bi.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(lod2_implicit_rep_id) || 
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other bridge installations any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN bridge_installation bi2 ON bi2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_installation bi3 ON bi3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_installation bi4 ON bi4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND bi2.lod2_implicit_rep_id IS NULL
        AND bi3.lod3_implicit_rep_id IS NULL
        AND bi4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_bridge_installations(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_bridge_installations
);

/*****************************************************************
* delete_bridge_installation
*
* Function to delete a single bridge installation
*
* @param        @description
* integer       id of bridge installation
*
* @return
* ID of deleted bridge installation
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_installation(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  lod2_impl_rep_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srfs(id)
    FROM bridge_thematic_surface
    WHERE bridge_installation_id = $1;

  -- delete bridge installation
  -- remember IDs of implicit geometry
  DELETE FROM bridge_installation WHERE id = $1
    RETURNING id, lod2_implicit_rep_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete implicit geometry not being referenced by other bridge installations any more
  IF COALESCE(lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod2_impl_rep_id), (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN bridge_installation bi2 ON bi2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_installation bi3 ON bi3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_installation bi4 ON bi4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND bi2.lod2_implicit_rep_id IS NULL
        AND bi3.lod3_implicit_rep_id IS NULL
        AND bi4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BRIDGE CONSTRUCTION ELEMENT

/*****************************************************************
* delete_bridge_constr_elements
*
* Aggregate function to delete multiple bridge construction elements
* at once. Selected IDs are collected in an array an passed to a final
* delete_bridge_constr_elements function that performs the delete process. 
*
* @param        @description
* integer       id of bridge construction elements
*
* @return
* array of IDs from deleted bridge construction elements
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_constr_elements(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srfs(ts.id)
    FROM bridge_thematic_surface ts, (
      SELECT unnest($1) AS bce_id
    ) a 
    WHERE ts.bridge_constr_element_id = a.bce_id;

  -- delete bridge construction elements
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM bridge_constr_element bce USING (
      SELECT unnest($1) AS bce_id
    ) a
    WHERE bce.id = a.bce_id
    RETURNING bce.id, bce.lod1_implicit_rep_id, bce.lod2_implicit_rep_id, bce.lod3_implicit_rep_id, bce.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
	array_agg(lod1_implicit_rep_id) || 
    array_agg(lod2_implicit_rep_id) || 
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other bridge construction elements any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN bridge_constr_element bce1 ON bce1.lod1_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_constr_element bce2 ON bce2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_constr_element bce3 ON bce3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_constr_element bce4 ON bce4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND bce1.lod1_implicit_rep_id IS NULL
        AND bce2.lod2_implicit_rep_id IS NULL
        AND bce3.lod3_implicit_rep_id IS NULL
        AND bce4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_bridge_constr_elements(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_bridge_constr_elements
);

/*****************************************************************
* delete_bridge_constr_element
*
* Function to delete a single bridge construction element
*
* @param        @description
* integer       id of bridge construction element
*
* @return
* ID of deleted bridge construction element
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_constr_element(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  lod1_impl_rep_id int;
  lod2_impl_rep_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srfs(id)
    FROM bridge_thematic_surface
    WHERE bridge_constr_element_id = $1;

  -- delete bridge construction element
  -- remember IDs of implicit geometry
  DELETE FROM bridge_constr_element WHERE id = $1
    RETURNING id, lod1_implicit_rep_id, lod2_implicit_rep_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, lod1_impl_rep_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete implicit geometry not being referenced by other bridge construction elements any more
  IF COALESCE(lod1_impl_rep_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod1_impl_rep_id), (lod2_impl_rep_id), (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN bridge_constr_element bce1 ON bce1.lod1_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_constr_element bce2 ON bce2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_constr_element bce3 ON bce3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN bridge_constr_element bce4 ON bce4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND bce1.lod1_implicit_rep_id IS NULL
        AND bce2.lod2_implicit_rep_id IS NULL
        AND bce3.lod3_implicit_rep_id IS NULL
        AND bce4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BRIDGE ROOM

/*****************************************************************
* delete_bridge_rooms
*
* Aggregate function to delete multiple bridge rooms at once.
* Selected IDs are collected in an array an passed to a final
* delete_bridge_rooms function that performs the delete process. 
*
* @param        @description
* integer       id of bridge rooms
*
* @return
* array of IDs from deleted bridge rooms
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_rooms(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete bridge furniture
  PERFORM citydb_pkg.delete_bridge_furnitures(bf.id)
    FROM bridge_furniture bf, (
      SELECT unnest($1) AS r_id
    ) a 
    WHERE bf.bridge_room_id = a.r_id;

  -- delete room installations
  PERFORM citydb_pkg.delete_bridge_installations(bi.id)
    FROM bridge_installation bi, (
      SELECT unnest($1) AS r_id
    ) a 
    WHERE bi.bridge_room_id = a.r_id;

  -- delete interior thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srfs(ts.id)
    FROM bridge_thematic_surface ts, (
      SELECT unnest($1) AS r_id
    ) a 
    WHERE ts.bridge_room_id = a.r_id;

  -- delete bridge rooms
  WITH delete_objects AS (
    DELETE FROM bridge_room r USING (
      SELECT unnest($1) AS r_id
    ) a
    WHERE r.id = a.r_id
    RETURNING r.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_bridge_rooms(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_bridge_rooms
);

/*****************************************************************
* delete_bridge_room
*
* Function to delete a single bridge room
*
* @param        @description
* integer       id of bridge room
*
* @return
* ID of deleted bridge room
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge_room(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete bridge furniture
  PERFORM citydb_pkg.delete_bridge_furnitures(id)
    FROM bridge_furniture
    WHERE bridge_room_id = $1;

  -- delete room installations
  PERFORM citydb_pkg.delete_bridge_installations(id)
    FROM bridge_installation
    WHERE bridge_room_id = $1;

  -- delete interior thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srfs(id)
    FROM bridge_thematic_surface
    WHERE bridge_room_id = $1;

  -- delete room
  DELETE FROM bridge_room WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE BRIDGE

/*****************************************************************
* delete_bridges
*
* Aggregate function to delete multiple bridges at once.
* Selected IDs are collected in an array an passed to a final
* delete_bridges function that performs the delete process. 
*
* @param        @description
* integer       id of bridges
*
* @return
* array of IDs from deleted bridges (incl. parts)
******************************************************************/
-- dummy for correct compilation of following functions
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridges(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_bridges(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_bridges
);

CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridges(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  parts_array int[] := '{}';
  address_array int[] := '{}';
BEGIN
  -- delete bridge parts
  PERFORM citydb_pkg.delete_bridges(b.id) INTO parts_array
    FROM bridge b, (
      SELECT unnest($1) AS b_id
    ) a   
    WHERE b.bridge_parent_id = b_id
      AND b.id != b_id;

  -- delete bridge rooms
  PERFORM citydb_pkg.delete_bridge_rooms(r.id)
    FROM bridge_room r, (
      SELECT unnest($1) AS b_id
    ) a   
    WHERE r.bridge_id = b_id;

  -- delete bridge installations
  PERFORM citydb_pkg.delete_bridge_installations(bi.id)
    FROM bridge_installation bi, (
      SELECT unnest($1) AS b_id
    ) a 
    WHERE bi.bridge_id = a.b_id;

  -- delete bridge construction elements
  PERFORM citydb_pkg.delete_bridge_constr_elements(bce.id)
    FROM bridge_constr_element bce, (
      SELECT unnest($1) AS b_id
    ) a 
    WHERE bce.bridge_id = a.b_id;

  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srfs(ts.id)
    FROM bridge_thematic_surface ts, (
      SELECT unnest($1) AS b_id
    ) a 
    WHERE ts.bridge_id = a.b_id;

  -- delete references to addresses
  WITH delete_address_refs AS (
    DELETE FROM address_to_bridge a2b USING (
      SELECT unnest($1) AS b_id
    ) a
    WHERE a2b.bridge_id = a.b_id
    RETURNING a2b.address_id
  )
  SELECT array_agg(address_id) INTO address_array
    FROM delete_address_refs;

  -- delete address(es) not being referenced by a bridge or an opening any more
  IF -1 = ALL(address_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_addresses(a.ad_id)
      FROM (
        SELECT DISTINCT unnest(address_array) AS ad_id
      ) a
      LEFT JOIN bridge_opening o
      ON o.address_id = a.ad_id
      LEFT JOIN address_to_bridge a2b
      ON a2b.address_id = a.ad_id
      WHERE o.address_id IS NULL
        AND a2b.address_id IS NULL;
  END IF;

  -- delete bridges
  WITH delete_objects AS (
    DELETE FROM bridge b USING (
      SELECT unnest($1) AS b_id
    ) a
    WHERE b.id = a.b_id
    RETURNING b.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN array_cat(result_array, parts_array);
END;
$$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* delete_bridge
*
* Function to delete a single bridge
*
* @param        @description
* integer       id of bridge
*
* @return
* ID of deleted bridge
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_bridge(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  address_array int[] := '{}';
BEGIN
  -- delete bridge parts
  PERFORM citydb_pkg.delete_bridges(id)
    FROM bridge
    WHERE bridge_parent_id = $1
      AND id != $1;

  -- delete rooms
  PERFORM citydb_pkg.delete_bridge_rooms(id)
    FROM bridge_room
    WHERE bridge_id = $1;

  -- delete bridge installations
  PERFORM citydb_pkg.delete_bridge_installations(id)
    FROM bridge_installation
    WHERE bridge_id = $1;

  -- delete bridge installations
  PERFORM citydb_pkg.delete_bridge_constr_elements(id)
    FROM bridge_constr_element
    WHERE bridge_id = $1;

  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_bridge_them_srfs(id)
    FROM bridge_thematic_surface
    WHERE bridge_id = $1;

  -- delete references to addresses
  WITH delete_address_refs AS (
    DELETE FROM address_to_bridge
    WHERE bridge_id = $1
    RETURNING address_id
  )
  SELECT array_agg(address_id) INTO address_array
    FROM delete_address_refs;

  -- delete address(es) not being referenced by a bridge or an opening any more
  IF -1 = ALL(address_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_addresses(a.ad_id)
      FROM (
        SELECT unnest(address_array) AS ad_id
      ) a
      LEFT JOIN bridge_opening o
      ON o.address_id = a.ad_id
      LEFT JOIN address_to_bridge a2b
      ON a2b.address_id = a.ad_id
      WHERE o.address_id IS NULL
        AND a2b.address_id IS NULL;
  END IF;

  -- delete bridge
  DELETE FROM bridge WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE TUNNEL FURNITURE

/*****************************************************************
* delete_tunnel_furnitures
*
* Aggregate function to delete multiple tunnel furniture at once.
* Selected IDs are collected in an array an passed to a final
* delete_tunnel_furnitures function that performs the delete process. 
*
* @param        @description
* integer       id of tunnel furniture
*
* @return
* array of IDs from deleted tunnel furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_furnitures(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete tunnel furniture
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM tunnel_furniture tf USING (
      SELECT unnest($1) AS tf_id
    ) a
    WHERE tf.id = a.tf_id
    RETURNING tf.id, tf.lod4_implicit_rep_id
  )
  SELECT array_agg(id), array_agg(lod4_implicit_rep_id) INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other tunnel furniture any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN tunnel_furniture tf ON tf.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE tf.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_tunnel_furnitures(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_tunnel_furnitures
);

/*****************************************************************
* delete_tunnel_furniture
*
* Function to delete a single tunnel furniture
*
* @param        @description
* integer       id of tunnel furniture
*
* @return
* ID of deleted tunnel furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_furniture(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  implicit_rep_id int;
BEGIN
  -- delete tunnel furniture
  -- remember ID of implicit geometry
  DELETE FROM tunnel_furniture WHERE id = $1
    RETURNING id, lod4_implicit_rep_id INTO deleted_id, implicit_rep_id;

  -- delete implicit geometry not being referenced by other tunnel furniture any more  
  IF implicit_rep_id IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometry(a.implicit_rep_id) 
      FROM (
        SELECT implicit_rep_id
      ) a
      LEFT JOIN tunnel_furniture tf ON tf.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE tf.lod4_implicit_rep_id IS NULL;	
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE TUNNEL OPENING

/*****************************************************************
* delete_tunnel_openings
*
* Aggregate function to delete multiple tunnel openings at once.
* Selected IDs are collected in an array an passed to a final
* delete_tunnel_openings function that performs the delete process. 
*
* @param        @description
* integer       id of tunnel openings
*
* @return
* array of IDs from deleted tunnel openings
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_openings(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete references to thematic surfaces
  DELETE FROM tunnel_open_to_them_srf o2ts USING (
    SELECT unnest($1) AS o_id
  ) a
  WHERE o2ts.tunnel_opening_id = a.o_id;

  -- delete openings
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM tunnel_opening o USING (
      SELECT unnest($1) AS o_id
    ) a
    WHERE o.id = a.o_id
    RETURNING o.id, o.lod3_implicit_rep_id, o.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other openings any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN tunnel_opening o3 ON o3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN tunnel_opening o4 ON o4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND o3.lod3_implicit_rep_id IS NULL
        AND o4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_tunnel_openings(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_tunnel_openings
);

/*****************************************************************
* delete_opening
*
* Function to delete a single opening
*
* @param        @description
* integer       id of opening
*
* @return
* ID of deleted opening
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_opening(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete references to thematic surfaces
  DELETE FROM tunnel_open_to_them_srf WHERE tunnel_opening_id = $1;

  -- delete opening
  -- remember IDs of implicit geometry
  DELETE FROM tunnel_opening WHERE id = $1
    RETURNING id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete implicit geometry not being referenced by other openings any more
  IF COALESCE(lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN tunnel_opening o3 ON o3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN tunnel_opening o4 ON o4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND o3.lod3_implicit_rep_id IS NULL
        AND o4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE TUNNEL THEMATIC SURFACE

/*****************************************************************
* delete_tunnel_them_srfs
*
* Aggregate function to delete multiple thematic surfaces at once.
* Selected IDs are collected in an array an passed to a final
* delete_tunnel_them_srfs function that performs the delete process. 
*
* @param        @description
* integer       id of thematic surfaces
*
* @return
* array of IDs from deleted thematic surfaces
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_them_srfs(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  opening_array int[] := '{}';
BEGIN
  -- delete references to openings
  WITH delete_opening_refs AS (
    DELETE FROM tunnel_open_to_them_srf o2ts USING (
      SELECT unnest($1) AS ts_id
    ) a
    WHERE o2ts.tunnel_thematic_surface_id = a.ts_id
    RETURNING o2ts.tunnel_opening_id
  )
  SELECT array_agg(tunnel_opening_id) INTO opening_array
    FROM delete_opening_refs;

  -- delete openings not being referenced by a thematic surface any more
  PERFORM citydb_pkg.delete_tunnel_openings(a.o_id) 
    FROM (
      SELECT DISTINCT unnest(opening_array) AS o_id
    ) a
    LEFT JOIN tunnel_open_to_them_srf o2ts
    ON o2ts.tunnel_opening_id = a.o_id
    WHERE o2ts.tunnel_opening_id IS NULL;

  -- delete thematic surfaces
  WITH delete_objects AS (
    DELETE FROM tunnel_thematic_surface ts USING (
      SELECT unnest($1) AS ts_id
    ) a 
    WHERE ts.id = a.ts_id
    RETURNING ts.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_tunnel_them_srfs(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_tunnel_them_srfs
);

/*****************************************************************
* delete_tunnel_them_srf
*
* Function to delete a single thematic surface
*
* @param        @description
* integer       id of thematic surface
*
* @return
* ID of deleted thematic surface
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_them_srf(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  opening_array int[] := '{}';
BEGIN
  -- delete references to openings
  WITH delete_opening_refs AS (
    DELETE FROM tunnel_open_to_them_srf
      WHERE tunnel_thematic_surface_id = $1 
      RETURNING tunnel_opening_id
  )
  SELECT array_agg(tunnel_opening_id) INTO opening_array
    FROM delete_opening_refs;

  -- delete openings not being referenced by a thematic surface any more
  PERFORM citydb_pkg.delete_tunnel_openings(a.o_id) 
    FROM (
      SELECT unnest(opening_array) AS o_id
    ) a
    LEFT JOIN tunnel_open_to_them_srf o2ts
    ON o2ts.tunnel_opening_id = a.o_id
    WHERE o2ts.tunnel_opening_id IS NULL;

  -- delete thematic surface
  DELETE FROM tunnel_thematic_surface WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE TUNNEL INSTALLATION

/*****************************************************************
* delete_tunnel_installations
*
* Aggregate function to delete multiple tunnel installations at once.
* Selected IDs are collected in an array an passed to a final
* delete_tunnel_installations function that performs the delete process. 
*
* @param        @description
* integer       id of tunnel installations
*
* @return
* array of IDs from deleted tunnel installations
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_installations(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srfs(ts.id)
    FROM tunnel_thematic_surface ts, (
      SELECT unnest($1) AS ti_id
    ) a 
    WHERE ts.tunnel_installation_id = a.ti_id;

  -- delete tunnel installations
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM tunnel_installation ti USING (
      SELECT unnest($1) AS ti_id
    ) a
    WHERE ti.id = a.ti_id
    RETURNING ti.id, ti.lod2_implicit_rep_id, ti.lod3_implicit_rep_id, ti.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(lod2_implicit_rep_id) || 
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other tunnel installations any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN tunnel_installation ti2 ON ti2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN tunnel_installation ti3 ON ti3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN tunnel_installation ti4 ON ti4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND ti2.lod2_implicit_rep_id IS NULL
        AND ti3.lod3_implicit_rep_id IS NULL
        AND ti4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_tunnel_installations(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_tunnel_installations
);

/*****************************************************************
* delete_tunnel_installation
*
* Function to delete a single tunnel installation
*
* @param        @description
* integer       id of tunnel installation
*
* @return
* ID of deleted tunnel installation
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_installation(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  lod2_impl_rep_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srfs(id)
    FROM tunnel_thematic_surface
    WHERE tunnel_installation_id = $1;

  -- delete tunnel installation
  -- remember IDs of implicit geometry
  DELETE FROM tunnel_installation WHERE id = $1
    RETURNING id, lod2_implicit_rep_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete implicit geometry not being referenced by other tunnel installations any more
  IF COALESCE(lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod2_impl_rep_id), (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN tunnel_installation ti2 ON ti2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN tunnel_installation ti3 ON ti3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN tunnel_installation ti4 ON ti4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND ti2.lod2_implicit_rep_id IS NULL
        AND ti3.lod3_implicit_rep_id IS NULL
        AND ti4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE TUNNEL HOLLOW SPACE

/*****************************************************************
* delete_tunnel_hollow_spaces
*
* Aggregate function to delete multiple tunnel hollow spaces at once.
* Selected IDs are collected in an array an passed to a final
* delete_tunnel_hollow_spaces function that performs the delete process. 
*
* @param        @description
* integer       id of tunnel hollow spaces
*
* @return
* array of IDs from deleted tunnel hollow spaces
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_hollow_spaces(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete tunnel furniture
  PERFORM citydb_pkg.delete_tunnel_furnitures(tf.id)
    FROM tunnel_furniture tf, (
      SELECT unnest($1) AS hs_id
    ) a 
    WHERE tf.tunnel_hollow_space_id = a.hs_id;

  -- delete hollow space installations
  PERFORM citydb_pkg.delete_tunnel_installations(ti.id)
    FROM tunnel_installation ti, (
      SELECT unnest($1) AS hs_id
    ) a 
    WHERE ti.tunnel_hollow_space_id = a.hs_id;

  -- delete interior thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srfs(ts.id)
    FROM tunnel_thematic_surface ts, (
      SELECT unnest($1) AS hs_id
    ) a 
    WHERE ts.tunnel_hollow_space_id = a.hs_id;

  -- delete hollow spaces
  WITH delete_objects AS (
    DELETE FROM tunnel_hollow_space hs USING (
      SELECT unnest($1) AS hs_id
    ) a
    WHERE hs.id = a.hs_id
    RETURNING hs.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_tunnel_hollow_spaces(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_tunnel_hollow_spaces
);

/*****************************************************************
* delete_tunnel_hollow_space
*
* Function to delete a single tunnel hollow space
*
* @param        @description
* integer       id of tunnel hollow space
*
* @return
* ID of deleted tunnel hollow space
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel_hollow_space(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete tunnel furniture
  PERFORM citydb_pkg.delete_tunnel_furnitures(id)
    FROM tunnel_furniture
    WHERE tunnel_hollow_space_id = $1;

  -- delete hollow space installations
  PERFORM citydb_pkg.delete_tunnel_installations(id)
    FROM tunnel_installation
    WHERE tunnel_hollow_space_id = $1;

  -- delete interior thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srfs(id)
    FROM tunnel_thematic_surface
    WHERE tunnel_hollow_space_id = $1;

  -- delete hollow space
  DELETE FROM tunnel_hollow_space WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE TUNNEL

/*****************************************************************
* delete_tunnels
*
* Aggregate function to delete multiple tunnels at once.
* Selected IDs are collected in an array an passed to a final
* delete_tunnels function that performs the delete process. 
*
* @param        @description
* integer       id of tunnels
*
* @return
* array of IDs from deleted tunnels (incl. parts)
******************************************************************/
-- dummy for correct compilation of following functions
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnels(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_tunnels(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_tunnels
);

CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnels(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  parts_array int[] := '{}';
BEGIN
  -- delete tunnel parts
  SELECT citydb_pkg.delete_tunnels(t.id) INTO parts_array
    FROM tunnel t, (
      SELECT unnest($1) AS t_id
    ) a   
    WHERE t.tunnel_parent_id = t_id
      AND t.id != t_id;

  -- delete hollow spaces
  PERFORM citydb_pkg.delete_tunnel_hollow_spaces(hs.id)
    FROM tunnel_hollow_space hs, (
      SELECT unnest($1) AS t_id
    ) a   
    WHERE hs.tunnel_id = t_id;

  -- delete tunnel installations
  PERFORM citydb_pkg.delete_tunnel_installations(ti.id)
    FROM tunnel_installation ti, (
      SELECT unnest($1) AS t_id
    ) a 
    WHERE ti.tunnel_id = a.t_id;

  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srfs(ts.id)
    FROM tunnel_thematic_surface ts, (
      SELECT unnest($1) AS t_id
    ) a 
    WHERE ts.tunnel_id = a.t_id;

  -- delete tunnels
  WITH delete_objects AS (
    DELETE FROM tunnel t USING (
      SELECT unnest($1) AS t_id
    ) a
    WHERE t.id = a.t_id
    RETURNING t.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN array_cat(result_array, parts_array);
END;
$$
LANGUAGE plpgsql STRICT;

/*****************************************************************
* delete_tunnel
*
* Function to delete a single tunnel
*
* @param        @description
* integer       id of tunnel
*
* @return
* ID of deleted tunnel
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_tunnel(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete tunnel parts
  PERFORM citydb_pkg.delete_tunnels(id)
    FROM tunnel
    WHERE tunnel_parent_id = $1
      AND id != $1;

  -- delete hollow spaces
  PERFORM citydb_pkg.delete_tunnel_hollow_spaces(id)
    FROM tunnel_hollow_space
    WHERE tunnel_id = $1;

  -- delete tunnel installations
  PERFORM citydb_pkg.delete_tunnel_installations(id)
    FROM tunnel_installation
    WHERE tunnel_id = $1;

  -- delete thematic surfaces
  PERFORM citydb_pkg.delete_tunnel_them_srfs(id)
    FROM tunnel_thematic_surface
    WHERE tunnel_id = $1;

  -- delete tunnel
  DELETE FROM tunnel WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE LAND USE

/*****************************************************************
* delete_land_uses
*
* Aggregate function to delete multiple land uses at once.
* Selected IDs are collected in an array an passed to a final
* delete_land_uses function that performs the delete process. 
*
* @param        @description
* integer       id of land uses
*
* @return
* array of IDs from deleted land uses
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_land_uses(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete land uses
  WITH delete_objects AS (
    DELETE FROM land_use lu USING (
      SELECT unnest($1) AS lu_id
    ) a
    WHERE lu.id = a.lu_id
    RETURNING lu.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_land_uses(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_land_uses
);

/*****************************************************************
* delete_land_use
*
* Function to delete a single land use
*
* @param        @description
* integer       id of land use
*
* @return
* ID of deleted land use
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_land_use(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete land use
  DELETE FROM land_use WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE GENERIC CITY OBJECT

/*****************************************************************
* delete_generic_cityobjects
*
* Aggregate function to delete multiple generic city objects
* at once. Selected IDs are collected in an array an passed to a final
* delete_generic_cityobjects function that performs the delete process. 
*
* @param        @description
* integer       id of generic city objects
*
* @return
* array of IDs from deleted generic city objects
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_generic_cityobjects(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete generic city objects
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM generic_cityobject gco USING (
      SELECT unnest($1) AS gco_id
    ) a  
    WHERE gco.id = a.gco_id 
    RETURNING gco.id, gco.lod0_implicit_rep_id, gco.lod1_implicit_rep_id,
              gco.lod2_implicit_rep_id, gco.lod3_implicit_rep_id, gco.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(lod0_implicit_rep_id) ||
    array_agg(lod1_implicit_rep_id) || 
    array_agg(lod2_implicit_rep_id) || 
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other generic city objects any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN generic_cityobject gco ON gco.lod0_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN generic_cityobject gco1 ON gco1.lod1_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN generic_cityobject gco2 ON gco2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN generic_cityobject gco3 ON gco3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN generic_cityobject gco4 ON gco4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND gco.lod1_implicit_rep_id IS NULL
        AND gco1.lod1_implicit_rep_id IS NULL
        AND gco2.lod2_implicit_rep_id IS NULL
        AND gco3.lod3_implicit_rep_id IS NULL
        AND gco4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END; 
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_generic_cityobjects(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_generic_cityobjects
);

/*****************************************************************
* delete_generic_cityobject
*
* Function to delete a single generic city object
*
* @param        @description
* integer       id of generic city object
*
* @return
* ID of deleted generic city object
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_generic_cityobject(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  lod0_impl_rep_id int;
  lod1_impl_rep_id int;
  lod2_impl_rep_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete solitary vegetation objects
  -- remember IDs of implicit geometry
  DELETE FROM generic_cityobject WHERE id = $1
    RETURNING id, lod0_implicit_rep_id, lod1_implicit_rep_id, lod2_implicit_rep_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, lod0_impl_rep_id, lod1_impl_rep_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete implicit geometry not being referenced by other solitary vegetation objects any more
  IF COALESCE(lod0_impl_rep_id, lod1_impl_rep_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod0_impl_rep_id), (lod1_impl_rep_id), (lod2_impl_rep_id), (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN generic_cityobject gco ON gco.lod0_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN generic_cityobject gco1 ON gco1.lod1_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN generic_cityobject gco2 ON gco2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN generic_cityobject gco3 ON gco3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN generic_cityobject gco4 ON gco4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND gco.lod1_implicit_rep_id IS NULL
        AND gco1.lod1_implicit_rep_id IS NULL
        AND gco2.lod2_implicit_rep_id IS NULL
        AND gco3.lod3_implicit_rep_id IS NULL
        AND gco4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE SOLITARY VEGETATION OBJECT

/*****************************************************************
* delete_solitary_veg_objs
*
* Aggregate function to delete multiple solitary vegetation objects
* at once. Selected IDs are collected in an array an passed to a final
* delete_solitary_veg_objs function that performs the delete process. 
*
* @param        @description
* integer       id of solitary vegetation objects
*
* @return
* array of IDs from deleted solitary vegetation objects
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_solitary_veg_objs(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete solitary vegetation objects
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM solitary_vegetat_object svo USING (
      SELECT unnest($1) AS svo_id
    ) a  
    WHERE svo.id = a.svo_id 
    RETURNING svo.id, svo.lod1_implicit_rep_id, svo.lod2_implicit_rep_id, svo.lod3_implicit_rep_id, svo.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(lod1_implicit_rep_id) || 
    array_agg(lod2_implicit_rep_id) || 
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other solitary vegetation objects any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN solitary_vegetat_object svo1 ON svo1.lod1_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN solitary_vegetat_object svo2 ON svo2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN solitary_vegetat_object svo3 ON svo3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN solitary_vegetat_object svo4 ON svo4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND svo1.lod1_implicit_rep_id IS NULL
        AND svo2.lod2_implicit_rep_id IS NULL
        AND svo3.lod3_implicit_rep_id IS NULL
        AND svo4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END; 
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_solitary_veg_objs(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_solitary_veg_objs
);

/*****************************************************************
* delete_solitary_veg_obj
*
* Function to delete a single solitary vegetation object
*
* @param        @description
* integer       id of solitary vegetation object
*
* @return
* ID of deleted solitary vegetation object
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_solitary_veg_obj(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  lod1_impl_rep_id int;
  lod2_impl_rep_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete solitary vegetation objects
  -- remember IDs of implicit geometry
  DELETE FROM solitary_vegetat_object WHERE id = $1
    RETURNING id, lod1_implicit_rep_id, lod2_implicit_rep_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, lod1_impl_rep_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete implicit geometry not being referenced by other solitary vegetation objects any more
  IF COALESCE(lod1_impl_rep_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod1_impl_rep_id), (lod2_impl_rep_id), (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN solitary_vegetat_object svo1 ON svo1.lod1_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN solitary_vegetat_object svo2 ON svo2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN solitary_vegetat_object svo3 ON svo3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN solitary_vegetat_object svo4 ON svo4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND svo1.lod1_implicit_rep_id IS NULL
        AND svo2.lod2_implicit_rep_id IS NULL
        AND svo3.lod3_implicit_rep_id IS NULL
        AND svo4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE PLANT COVER

/*****************************************************************
* delete_plant_covers
*
* Aggregate function to delete multiple plant covers at once.
* Selected IDs are collected in an array an passed to a final
* delete_plant_covers function that performs the delete process. 
*
* @param        @description
* integer       id of plant covers
*
* @return
* array of IDs from deleted plant covers
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_plant_covers(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete plant covers
  WITH delete_objects AS (
    DELETE FROM plant_cover pc USING (
      SELECT unnest($1) AS pc_id
    ) a
    WHERE pc.id = a.pc_id
    RETURNING pc.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_plant_covers(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_plant_covers
);

/*****************************************************************
* delete_plant_cover
*
* Function to delete a single plant cover
*
* @param        @description
* integer       id of plant cover
*
* @return
* ID of deleted plant cover
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_plant_cover(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete plant cover
  DELETE FROM plant_cover WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE WATER BOUNDARY SURFACE

/*****************************************************************
* delete_waterbnd_surfaces
*
* Aggregate function to delete multiple water boundary surfaces at once.
* Selected IDs are collected in an array an passed to a final
* delete_waterbnd_surfaces function that performs the delete process. 
*
* @param        @description
* integer       id of water boundary surfaces
*
* @return
* array of IDs from deleted water boundary surfaces
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_waterbnd_surfaces(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete references to waterbodies
  DELETE FROM waterbod_to_waterbnd_srf wb2wbs USING (
    SELECT unnest($1) AS wbs_id
  ) a
  WHERE wb2wbs.waterboundary_surface_id = a.wbs_id;

  -- delete water boundary surfaces
  WITH delete_objects AS (
    DELETE FROM waterboundary_surface wbs USING (
      SELECT unnest($1) AS wbs_id
    ) a
    WHERE wbs.id = a.wbs_id
    RETURNING wbs.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_waterbnd_surfaces(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_waterbnd_surfaces
);

/*****************************************************************
* delete_waterbnd_surface
*
* Function to delete a single water boundary surface
*
* @param        @description
* integer       id of water boundary surface
*
* @return
* ID of deleted water boundary surface
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_waterbnd_surface(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete references to waterbodies
  DELETE FROM waterbod_to_waterbnd_srf WHERE waterboundary_surface_id = $1;

  -- delete water boundary surface
  DELETE FROM waterboundary_surface WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE WATER BODY

/*****************************************************************
* delete_waterbodies
*
* Aggregate function to delete multiple thematic surfaces at once.
* Selected IDs are collected in an array an passed to a final
* delete_waterbodies function that performs the delete process. 
*
* @param        @description
* integer       id of thematic surfaces
*
* @return
* array of IDs from deleted thematic surfaces
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_waterbodies(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  surface_array int[] := '{}';
BEGIN
  -- delete references to water boundary surfaces
  WITH delete_surface_refs AS (
    DELETE FROM waterbod_to_waterbnd_srf wb2wbs USING (
      SELECT unnest($1) AS wb_id
    ) a
    WHERE wb2wbs.waterbody_id = a.wb_id
    RETURNING wb2wbs.waterboundary_surface_id
  )
  SELECT array_agg(waterboundary_surface_id) INTO surface_array
    FROM delete_surface_refs;

  -- delete water boundary surfaces not being referenced by a water body any more
  PERFORM citydb_pkg.delete_waterbnd_surfaces(a.wbs_id) 
    FROM (
      SELECT DISTINCT unnest(surface_array) AS wbs_id
    ) a
    LEFT JOIN waterbod_to_waterbnd_srf wb2wbs
    ON wb2wbs.waterboundary_surface_id = a.wbs_id
    WHERE wb2wbs.waterboundary_surface_id IS NULL;

  -- delete water bodies
  WITH delete_objects AS (
    DELETE FROM waterbody wb USING (
      SELECT unnest($1) AS wb_id
    ) a 
    WHERE wb.id = a.wb_id RETURNING wb.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_waterbodies(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_waterbodies
);

/*****************************************************************
* delete_waterbody
*
* Function to delete a single water body
*
* @param        @description
* integer       id of water body
*
* @return
* ID of deleted water body
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_waterbody(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  surface_array int[] := '{}';
BEGIN
  -- delete references to water boundary surfaces
  WITH delete_surface_refs AS (
    DELETE FROM waterbod_to_waterbnd_srf
      WHERE waterbody_id = $1
      RETURNING waterboundary_surface_id
  )
  SELECT array_agg(waterboundary_surface_id) INTO surface_array
    FROM delete_surface_refs;

  -- delete water boundary surfaces not being referenced by a water body any more
  PERFORM citydb_pkg.delete_waterbnd_surfaces(a.wbs_id) 
    FROM (
      SELECT unnest(surface_array) AS wbs_id
    ) a
    LEFT JOIN waterbod_to_waterbnd_srf wb2wbs
    ON wb2wbs.waterboundary_surface_id = a.wbs_id
    WHERE wb2wbs.waterboundary_surface_id IS NULL;

  -- delete water body
  DELETE FROM waterbody WHERE id = $1 RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE RELIEF COMPONENT

/*****************************************************************
* delete_relief_components
*
* Aggregate function to delete multiple relief components at once.
* Selected IDs are collected in an array an passed to a final
* delete_relief_components function that performs the delete process. 
*
* @param        @description
* integer       id of relief components
*
* @return
* array of IDs from deleted relief components
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_relief_components(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  tin_geom_array int[] := '{}';
  relief_coverage_array int[] := '{}';
BEGIN
  -- delete references to relief features
  DELETE FROM relief_feat_to_rel_comp rf2rc USING (
    SELECT unnest($1) AS rc_id
  ) a
  WHERE rf2rc.relief_component_id = a.rc_id;

  -- delete tin relief
  WITH delete_objects AS (
    DELETE FROM tin_relief tr USING (
      SELECT unnest($1) AS tr_id
    ) a
    WHERE tr.id = a.tr_id
    RETURNING tr.surface_geometry_id
  )
  SELECT array_agg(DISTINCT surface_geometry_id) INTO tin_geom_array
    FROM delete_objects;

  PERFORM citydb_pkg.delete_surface_geometries(tin_geom_array);

  -- delete mass point relief
  DELETE FROM masspoint_relief mpr USING (
    SELECT unnest($1) AS mpr_id
  ) a
  WHERE mpr.id = a.mpr_id;

  -- delete break line relief
  DELETE FROM breakline_relief blr USING (
    SELECT unnest($1) AS blr_id
  ) a
  WHERE blr.id = a.blr_id;

  -- delete raster relief
  WITH delete_objects AS (
    DELETE FROM raster_relief rr USING (
      SELECT unnest($1) AS rr_id
    ) a
    WHERE rr.id = a.rr_id
    RETURNING rr.coverage_id
  )
  SELECT array_agg(DISTINCT coverage_id) INTO relief_coverage_array
    FROM delete_objects;

  PERFORM citydb_pkg.delete_grid_coverages(relief_coverage_array);

  -- delete relief components
  WITH delete_objects AS (
    DELETE FROM relief_component rc USING (
      SELECT unnest($1) AS rc_id
    ) a
    WHERE rc.id = a.rc_id
    RETURNING rc.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete cityobjects
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE AGGREGATE citydb_pkg.delete_relief_components(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_relief_components
);

/*****************************************************************
* delete_relief_component
*
* Function to delete a single relief component
*
* @param        @description
* integer       id of relief component
*
* @return
* ID of deleted relief component
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_relief_component(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  tin_geom_id int;
  relief_coverage_id int;
BEGIN
  -- delete references to relief features
  DELETE FROM relief_feat_to_rel_comp WHERE relief_component_id = $1;

  -- delete tin relief
  DELETE FROM tin_relief WHERE id = $1
    RETURNING surface_geometry_id INTO tin_geom_id;

  PERFORM citydb_pkg.delete_surface_geometry(tin_geom_id,0);

  -- delete mass point relief
  DELETE FROM masspoint_relief WHERE id = $1;

  -- delete break line relief
  DELETE FROM breakline_relief WHERE id = $1;

  -- delete raster relief
  DELETE FROM raster_relief WHERE id = $1
    RETURNING coverage_id INTO relief_coverage_id;

  PERFORM citydb_pkg.delete_grid_coverage(relief_coverage_id);

  -- delete relief components
  DELETE FROM relief_component WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete cityobject
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE RELIEF FEATURE

/*****************************************************************
* delete_relief_features
*
* Aggregate function to delete multiple relief features at once.
* Selected IDs are collected in an array an passed to a final
* delete_relief_features function that performs the delete process. 
*
* @param        @description
* integer       id of relief features
*
* @return
* array of IDs from deleted relief features
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_relief_features(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  component_array int[] := '{}';
BEGIN
  -- delete references to relief components
  WITH delete_component_refs AS (
    DELETE FROM relief_feat_to_rel_comp rf2rc USING (
      SELECT unnest($1) AS rf_id
    ) a
    WHERE rf2rc.relief_feature_id = a.rf_id
    RETURNING rf2rc.relief_component_id
  )
  SELECT array_agg(relief_component_id) INTO component_array
    FROM delete_component_refs;

  -- delete relief components not being referenced by a relief feature any more
  PERFORM citydb_pkg.delete_relief_components(a.rc_id) 
    FROM (
      SELECT DISTINCT unnest(component_array) AS rc_id
    ) a
    LEFT JOIN relief_feat_to_rel_comp rf2rc
    ON rf2rc.relief_component_id = a.rc_id
    WHERE rf2rc.relief_component_id IS NULL;

  -- delete relief features
  WITH delete_objects AS (
    DELETE FROM relief_feature rf USING (
      SELECT unnest($1) AS rf_id
    ) a 
    WHERE rf.id = a.rf_id RETURNING rf.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete cityobjects
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_relief_features(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_relief_features
);

/*****************************************************************
* delete_relief_feature
*
* Function to delete a single relief feature
*
* @param        @description
* integer       id of relief feature
*
* @return
* ID of deleted relief feature
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_relief_feature(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  component_array int[] := '{}';
BEGIN
  -- delete references to relief components
  WITH delete_component_refs AS (
    DELETE FROM relief_feat_to_rel_comp
      WHERE relief_feature_id = $1
      RETURNING relief_component_id
  )
  SELECT array_agg(relief_component_id) INTO component_array
    FROM delete_component_refs;

  -- delete relief components not being referenced by a relief feature any more
  PERFORM citydb_pkg.delete_relief_components(a.rc_id) 
    FROM (
      SELECT unnest(component_array) AS rc_id
    ) a
    LEFT JOIN relief_feat_to_rel_comp rf2rc
    ON rf2rc.relief_component_id = a.rc_id
    WHERE rf2rc.relief_component_id IS NULL;

  -- delete relief feature
  DELETE FROM relief_feature WHERE id = $1 RETURNING id INTO deleted_id;

  -- delete cityobject
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE CITY FURNITURE

/*****************************************************************
* delete_city_furnitures
*
* Aggregate function to delete multiple city furniture at once.
* Selected IDs are collected in an array an passed to a final
* delete_city_furnitures function that performs the delete process. 
*
* @param        @description
* integer       id of city furniture
*
* @return
* array of IDs from deleted city furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_city_furnitures(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  implicit_rep_array int[] := '{}';
BEGIN
  -- delete city furniture
  -- remember IDs of implicit geometry
  WITH delete_objects AS (
    DELETE FROM city_furniture cf USING (
      SELECT unnest($1) AS cf_id
    ) a  
    WHERE cf.id = a.cf_id 
    RETURNING cf.id, cf.lod1_implicit_rep_id, cf.lod2_implicit_rep_id, cf.lod3_implicit_rep_id, cf.lod4_implicit_rep_id
  )
  SELECT array_agg(id),
    array_agg(lod1_implicit_rep_id) || 
    array_agg(lod2_implicit_rep_id) || 
    array_agg(lod3_implicit_rep_id) || 
    array_agg(lod4_implicit_rep_id)
    INTO result_array, implicit_rep_array
    FROM delete_objects;

  -- delete implicit geometry not being referenced by other city furniture any more
  IF -1 = ALL(implicit_rep_array) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        SELECT DISTINCT unnest(implicit_rep_array) AS implicit_rep_id
      ) a
      LEFT JOIN city_furniture cf1 ON cf1.lod1_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN city_furniture cf2 ON cf2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN city_furniture cf3 ON cf3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN city_furniture cf4 ON cf4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND cf1.lod1_implicit_rep_id IS NULL
        AND cf2.lod2_implicit_rep_id IS NULL
        AND cf3.lod3_implicit_rep_id IS NULL
        AND cf4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END; 
$$ 
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_city_furnitures(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_city_furnitures
);

/*****************************************************************
* delete_city_furniture
*
* Function to delete a single city furniture
*
* @param        @description
* integer       id of city furniture
*
* @return
* ID of deleted city furniture
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_city_furniture(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
  lod1_impl_rep_id int;
  lod2_impl_rep_id int;
  lod3_impl_rep_id int;
  lod4_impl_rep_id int;
BEGIN
  -- delete city furniture
  -- remember IDs of implicit geometry
  DELETE FROM city_furniture WHERE id = $1
    RETURNING id, lod1_implicit_rep_id, lod2_implicit_rep_id, lod3_implicit_rep_id, lod4_implicit_rep_id
    INTO deleted_id, lod1_impl_rep_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id;

  -- delete implicit geometry not being referenced by other city furniture any more
  IF COALESCE(lod1_impl_rep_id, lod2_impl_rep_id, lod3_impl_rep_id, lod4_impl_rep_id) IS NOT NULL THEN
    PERFORM citydb_pkg.delete_implicit_geometries(a.implicit_rep_id) 
      FROM (
        VALUES (lod1_impl_rep_id), (lod2_impl_rep_id), (lod3_impl_rep_id), (lod4_impl_rep_id)
      ) AS a (implicit_rep_id)
      LEFT JOIN city_furniture cf1 ON cf1.lod1_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN city_furniture cf2 ON cf2.lod2_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN city_furniture cf3 ON cf3.lod3_implicit_rep_id = a.implicit_rep_id
      LEFT JOIN city_furniture cf4 ON cf4.lod4_implicit_rep_id = a.implicit_rep_id
      WHERE a.implicit_rep_id IS NOT NULL
        AND cf1.lod1_implicit_rep_id IS NULL
        AND cf2.lod2_implicit_rep_id IS NULL
        AND cf3.lod3_implicit_rep_id IS NULL
        AND cf4.lod4_implicit_rep_id IS NULL;
  END IF;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;


-- DELETE TRAFFIC AREA

/*****************************************************************
* delete_traffic_areas
*
* Aggregate function to delete multiple traffic areas at once.
* Selected IDs are collected in an array an passed to a final
* delete_traffic_areas function that performs the delete process. 
*
* @param        @description
* integer       id of traffic areas
*
* @return
* array of IDs from deleted traffic areas
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_traffic_areas(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
BEGIN
  -- delete traffic areas
  WITH delete_objects AS (
    DELETE FROM traffic_area ta USING (
      SELECT unnest($1) AS ta_id
    ) a
    WHERE ta.id = a.ta_id
    RETURNING ta.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_traffic_areas(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_traffic_areas
);

/*****************************************************************
* delete_traffic_area
*
* Function to delete a single traffic area
*
* @param        @description
* integer       id of traffic area
*
* @return
* ID of deleted traffic area
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_traffic_area(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete traffic areas
  DELETE FROM traffic_area WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE TRANSPORTATION COMPLEX

/*****************************************************************
* delete_transport_complexes
*
* Aggregate function to delete multiple transportation complexes at
* once. Selected IDs are collected in an array an passed to a final
* delete_transport_complexes function that performs the delete process. 
*
* @param        @description
* integer       id of transportation complexes
*
* @return
* array of IDs from deleted transportation complexes
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_transport_complexes(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  parts_array int[] := '{}';
BEGIN
  -- delete traffic areas
  PERFORM citydb_pkg.delete_traffic_areas(ta.id)
    FROM traffic_area ta, (
      SELECT unnest($1) AS tc_id
    ) a   
    WHERE ta.transportation_complex_id = tc_id;

  -- delete transportation complexes
  WITH delete_objects AS (
    DELETE FROM transportation_complex tc USING (
      SELECT unnest($1) AS tc_id
    ) a
    WHERE tc.id = a.tc_id
    RETURNING tc.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_cityobject_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_transport_complexes(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_transport_complexes
);

/*****************************************************************
* delete_transport_complex
*
* Function to delete a single transportation complex
*
* @param        @description
* integer       id of transportation complex
*
* @return
* ID of deleted transportation complex
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_transport_complex(int) RETURNS int AS
$$
DECLARE
  deleted_id int;
BEGIN
  -- delete traffic areas
  PERFORM citydb_pkg.delete_traffic_areas(id)
    FROM traffic_area
    WHERE transportation_complex_id = $1;

  -- delete transportation complex
  DELETE FROM transportation_complex WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE CITY OBJECT GROUP

/*****************************************************************
* delete_cityobjectgroups
*
* Aggregate function to delete multiple city object groups at once.
* Selected IDs are collected in an array an passed to a final
* delete_cityobjectgroups function that performs the delete process.
* If you do not wish to delete group members as well call the 
* delete_cityobjectgroup function with 0 as second argument (default). 
*
* @param        @description
* integer       id of city object groups
*
* @return
* array of IDs from deleted city object groups
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobjectgroups(int[]) RETURNS int[] AS
$$
DECLARE
  result_array int[] := '{}';
  cityobject_array int[] := '{}';
BEGIN
  -- delete references to members
  WITH delete_member_refs AS (
    DELETE FROM group_to_cityobject g2c USING (
      SELECT unnest($1) AS grp_id
    ) a
    WHERE g2c.cityobjectgroup_id = a.grp_id
    RETURNING g2c.cityobject_id
  )
  SELECT array_agg(cityobject_id) INTO cityobject_array
    FROM delete_member_refs;

  -- delete cityobjects not being referenced by a city object group any more
  PERFORM citydb_pkg.delete_cityobject(a.c_id, 1, 0) 
    FROM (
      SELECT DISTINCT unnest(cityobject_array) AS c_id
    ) a
    LEFT JOIN group_to_cityobject g2c
    ON g2c.cityobject_id = a.c_id
    WHERE g2c.cityobject_id IS NULL;

  -- delete city object groups
  WITH delete_objects AS (
    DELETE FROM cityobjectgroup cog USING (
      SELECT unnest($1) AS cog_id
    ) a
    WHERE cog.id = a.cog_id
    RETURNING cog.id
  )
  SELECT array_agg(id) INTO result_array
    FROM delete_objects;

  -- delete geometries and cityobjects
  PERFORM citydb_pkg.delete_surface_geometries(result_array);
  PERFORM citydb_pkg.intern_delete_cityobjects(result_array);

  RETURN result_array;
END;
$$
LANGUAGE plpgsql STRICT;

CREATE AGGREGATE citydb_pkg.delete_cityobjectgroups(int)
(
    sfunc = array_append,
    stype = int[],
    finalfunc = citydb_pkg.delete_cityobjectgroups
);

/*****************************************************************
* delete_cityobjectgroup
*
* Function to delete a single city object group
*
* @param           @description
* cog_id           id of city object group
* delete_members   1 for cascading delete of members
*                  0 to delete the group element but not its members (default)
*
* @return
* ID of deleted city object group
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobjectgroup(
  cog_id int,
  delete_members int DEFAULT 0
  ) RETURNS int AS
$$
DECLARE
  deleted_id int;
  cityobject_array int[] := '{}';
BEGIN
  -- delete references to members
  WITH delete_member_refs AS (
    DELETE FROM group_to_cityobject
    WHERE cityobjectgroup_id = $1
    RETURNING cityobject_id
  )
  SELECT array_agg(cityobject_id) INTO cityobject_array
    FROM delete_member_refs;

  IF delete_members <> 0 THEN
    -- delete cityobjects not being referenced by a city object group any more
    PERFORM citydb_pkg.delete_cityobject(a.c_id, 1, 0) 
      FROM (
        SELECT unnest(cityobject_array) AS c_id
      ) a
      LEFT JOIN group_to_cityobject g2c
      ON g2c.cityobject_id = a.c_id
      WHERE g2c.cityobject_id IS NULL;
  ELSE
    -- free memory
    cityobject_array := NULL;
  END IF;

  -- delete city object group
  DELETE FROM cityobjectgroup WHERE id = $1
    RETURNING id INTO deleted_id;

  -- delete geometries and cityobject
  PERFORM citydb_pkg.delete_cityobject_geometry(deleted_id);
  PERFORM citydb_pkg.intern_delete_cityobject(deleted_id);

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


-- DELETE CITY MODEL

/*****************************************************************
* delete_citymodel
*
* Function to delete a single city model
*
* @param           @description
* cm_id            id of city object group
* delete_members   1 for cascading delete of members
*                  0 to delete the group element but not its members (default)
*
* @return
* ID of deleted city model
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_citymodel(
  cm_id int,
  delete_members int DEFAULT 0
  ) RETURNS int AS
$$
DECLARE
  deleted_id int;
  cityobject_array int[] := '{}';
BEGIN
  -- delete references to members
  WITH delete_member_refs AS (
    DELETE FROM cityobject_member
    WHERE citymodel_id = $1
    RETURNING cityobject_id
  )
  SELECT array_agg(cityobject_id) INTO cityobject_array
    FROM delete_member_refs;

  IF delete_members <> 0 THEN
    -- delete cityobjects not being referenced by a city model any more
    PERFORM citydb_pkg.delete_cityobjects(a.c_id) 
      FROM (
        SELECT unnest(cityobject_array) AS c_id
      ) a
      LEFT JOIN cityobject_member com
      ON com.cityobject_id = a.c_id
      WHERE com.cityobject_id IS NULL;
  ELSE
    -- free memory
    cityobject_array := NULL;
  END IF;

  -- delete appearances assigned to the city model
  PERFORM citydb_pkg.delete_appearances(id) FROM appearance WHERE citymodel_id = $1;

  -- delete city model
  DELETE FROM citymodel WHERE id = $1
    RETURNING id INTO deleted_id;

  RETURN deleted_id;
END;
$$
LANGUAGE plpgsql STRICT;


CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_citymodels() RETURNS SETOF INTEGER AS
$$
SELECT citydb_pkg.delete_citymodel(c.id, 0) AS deleted_id
  FROM citymodel c 
  LEFT OUTER JOIN cityobject_member cm ON c.id=cm.citymodel_id 
  WHERE cm.cityobject_id IS NULL;
$$ 
LANGUAGE sql STRICT;


-- DELETE CITY OBJECT (High-Level API)

/*****************************************************************
* delete_cityobjects
*
* Aggregate function to delete multiple city objects at once.
* Selected IDs are collected in an array an passed to a final
* delete_cityobjects function that performs the delete process.
* If you do not wish to delete group members as well call the 
* delete_cityobject function with 0 as second argument (default). 
*
* @param        @description
* integer       id of city objects
*
* @return
* array of IDs from deleted city objects
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobjects(int[]) RETURNS int[] AS
$$
SELECT
  citydb_pkg.delete_land_uses(id) FILTER (WHERE objectclass_id = 4) ||
  citydb_pkg.delete_generic_cityobjects(id) FILTER (WHERE objectclass_id = 5) ||
  citydb_pkg.delete_solitary_veg_objs(id) FILTER (WHERE objectclass_id = 7) ||
  citydb_pkg.delete_plant_covers(id) FILTER (WHERE objectclass_id = 8) ||
  citydb_pkg.delete_waterbodies(id) FILTER (WHERE objectclass_id = 9) ||
  citydb_pkg.delete_waterbnd_surfaces(id) FILTER (WHERE objectclass_id IN (11,12,13)) ||
  citydb_pkg.delete_relief_features(id) FILTER (WHERE objectclass_id = 14) ||
  citydb_pkg.delete_relief_components(id) FILTER (WHERE objectclass_id IN (16,17,18,19)) ||
  citydb_pkg.delete_city_furnitures(id) FILTER (WHERE objectclass_id = 21) ||
  citydb_pkg.delete_cityobjectgroups(id) FILTER (WHERE objectclass_id = 23) ||
  citydb_pkg.delete_buildings(id) FILTER (WHERE objectclass_id IN (25,26)) ||
  citydb_pkg.delete_building_installations(id) FILTER (WHERE objectclass_id IN (27,28)) ||
  citydb_pkg.delete_thematic_surfaces(id) FILTER (WHERE objectclass_id IN (30,31,32,33,34,35,36,60,61)) ||
  citydb_pkg.delete_openings(id) FILTER (WHERE objectclass_id IN (38,39)) ||
  citydb_pkg.delete_building_furnitures(id) FILTER (WHERE objectclass_id = 40) ||
  citydb_pkg.delete_rooms(id) FILTER (WHERE objectclass_id = 41) ||
  citydb_pkg.delete_transport_complexes(id) FILTER (WHERE objectclass_id IN (43,44,45,46)) ||
  citydb_pkg.delete_traffic_areas(id) FILTER (WHERE objectclass_id IN (47,48)) ||
  citydb_pkg.delete_bridges(id) FILTER (WHERE objectclass_id IN (63,64)) ||
  citydb_pkg.delete_bridge_installations(id) FILTER (WHERE objectclass_id IN (65,66)) ||
  citydb_pkg.delete_bridge_them_srfs(id) FILTER (WHERE objectclass_id IN (68,69,70,71,72,73,74,75,76)) ||
  citydb_pkg.delete_bridge_openings(id) FILTER (WHERE objectclass_id IN (78,79)) ||
  citydb_pkg.delete_bridge_furnitures(id) FILTER (WHERE objectclass_id = 80) ||
  citydb_pkg.delete_bridge_rooms(id) FILTER (WHERE objectclass_id = 81) ||
  citydb_pkg.delete_bridge_constr_elements(id) FILTER (WHERE objectclass_id = 82) ||
  citydb_pkg.delete_tunnels(id) FILTER (WHERE objectclass_id IN (84,85)) ||
  citydb_pkg.delete_tunnel_installations(id) FILTER (WHERE objectclass_id IN (86,87)) ||
  citydb_pkg.delete_tunnel_them_srfs(id) FILTER (WHERE objectclass_id IN (88,89,90,91,92,93,94,95,96)) ||
  citydb_pkg.delete_tunnel_openings(id) FILTER (WHERE objectclass_id IN (99,100)) ||
  citydb_pkg.delete_tunnel_furnitures(id) FILTER (WHERE objectclass_id = 101) ||
  citydb_pkg.delete_tunnel_hollow_spaces(id) FILTER (WHERE objectclass_id = 102) AS result_array
FROM cityobject c, (
  SELECT unnest($1) AS c_id
) a
WHERE c.id = a.c_id;
$$
LANGUAGE sql STRICT;

/*****************************************************************
* delete_cityobject
*
* Function to delete a single city object
*
* @param           @description
* cm_id            id of city object
* delete_members   1 for cascading delete of members
*                  0 to delete the group element but not its members (default)
* cleanup          1 to check for orphaned appearances and citymodels
*                  0 do not clean up appearances and citymodels (default)
*
* @return
* ID of deleted city model
******************************************************************/
-- generic function to delete any cityobject
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject(
  co_id INTEGER,
  delete_members INTEGER DEFAULT 0,
  cleanup INTEGER DEFAULT 0
  ) RETURNS INTEGER AS
$$
DECLARE
  deleted_id INTEGER;
  class_id INTEGER;
BEGIN
  SELECT objectclass_id INTO class_id FROM cityobject WHERE id = $1;

  -- class_id can be NULL if object has already been deleted
  IF class_id IS NOT NULL THEN
    CASE
      WHEN class_id = 4 THEN deleted_id := citydb_pkg.delete_land_use($1);
      WHEN class_id = 5 THEN deleted_id := citydb_pkg.delete_generic_cityobject($1);
      WHEN class_id = 7 THEN deleted_id := citydb_pkg.delete_solitary_veg_obj($1);
      WHEN class_id = 8 THEN deleted_id := citydb_pkg.delete_plant_cover($1);
      WHEN class_id = 9 THEN deleted_id := citydb_pkg.delete_waterbody($1);
      WHEN class_id = 11 OR 
           class_id = 12 OR 
           class_id = 13 THEN deleted_id := citydb_pkg.delete_waterbnd_surface($1);
      WHEN class_id = 14 THEN deleted_id := citydb_pkg.delete_relief_feature($1);
      WHEN class_id = 16 OR 
           class_id = 17 OR 
           class_id = 18 OR 
           class_id = 19 THEN deleted_id := citydb_pkg.delete_relief_component($1);
      WHEN class_id = 21 THEN deleted_id := citydb_pkg.delete_city_furniture($1);
      WHEN class_id = 23 THEN deleted_id := citydb_pkg.delete_cityobjectgroup($1, $2);
      WHEN class_id = 25 OR 
           class_id = 26 THEN deleted_id := citydb_pkg.delete_building($1);
      WHEN class_id = 27 OR 
           class_id = 28 THEN deleted_id := citydb_pkg.delete_building_installation($1);
      WHEN class_id = 30 OR 
           class_id = 31 OR 
           class_id = 32 OR 
           class_id = 33 OR 
           class_id = 34 OR 
           class_id = 35 OR 
           class_id = 36 OR 
           class_id = 60 OR 
           class_id = 61 THEN deleted_id := citydb_pkg.delete_thematic_surface($1);
      WHEN class_id = 38 OR 
           class_id = 39 THEN deleted_id := citydb_pkg.delete_opening($1);
      WHEN class_id = 40 THEN deleted_id := citydb_pkg.delete_building_furniture($1);
      WHEN class_id = 41 THEN deleted_id := citydb_pkg.delete_room($1);
      WHEN class_id = 43 OR 
           class_id = 44 OR 
           class_id = 45 OR 
           class_id = 46 THEN deleted_id := citydb_pkg.delete_transport_complex($1);
      WHEN class_id = 47 OR 
           class_id = 48 THEN deleted_id := citydb_pkg.delete_traffic_area($1);
      WHEN class_id = 63 OR 
           class_id = 64 THEN deleted_id := citydb_pkg.delete_bridge($1);
      WHEN class_id = 65 OR 
           class_id = 66 THEN deleted_id := citydb_pkg.delete_bridge_installation($1);
      WHEN class_id = 68 OR 
           class_id = 69 OR 
           class_id = 70 OR 
           class_id = 71 OR 
           class_id = 72 OR 
           class_id = 73 OR 
           class_id = 74 OR 
           class_id = 75 OR 
           class_id = 76 THEN deleted_id := citydb_pkg.delete_bridge_them_srf($1);
      WHEN class_id = 78 OR 
           class_id = 79 THEN deleted_id := citydb_pkg.delete_bridge_opening($1);		 
      WHEN class_id = 80 THEN deleted_id := citydb_pkg.delete_bridge_furniture($1);
      WHEN class_id = 81 THEN deleted_id := citydb_pkg.delete_bridge_room($1);
      WHEN class_id = 82 THEN deleted_id := citydb_pkg.delete_bridge_constr_element($1);
      WHEN class_id = 84 OR 
           class_id = 85 THEN deleted_id := citydb_pkg.delete_tunnel($1);
      WHEN class_id = 86 OR 
           class_id = 87 THEN deleted_id := citydb_pkg.delete_tunnel_installation($1);
      WHEN class_id = 88 OR 
           class_id = 89 OR 
           class_id = 90 OR 
           class_id = 91 OR 
           class_id = 92 OR 
           class_id = 93 OR 
           class_id = 94 OR 
           class_id = 95 OR 
           class_id = 96 THEN deleted_id := citydb_pkg.delete_tunnel_them_srf($1);
      WHEN class_id = 99 OR 
           class_id = 100 THEN deleted_id := citydb_pkg.delete_tunnel_opening($1);
      WHEN class_id = 101 THEN deleted_id := citydb_pkg.delete_tunnel_furniture($1);
      WHEN class_id = 102 THEN deleted_id := citydb_pkg.delete_tunnel_hollow_space($1);
      ELSE
        RAISE NOTICE 'Can not delete chosen object with ID % and objectclass_id %.', $1, class_id;
    END CASE;
  END IF;

  IF cleanup <> 0 THEN
    PERFORM citydb_pkg.cleanup_appearances(1);
    PERFORM citydb_pkg.cleanup_citymodels();
  END IF;

  RETURN deleted_id;
END; 
$$ 
LANGUAGE plpgsql STRICT;



-- truncates all tables
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_schema() RETURNS SETOF VOID AS
$$
BEGIN
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
END; 
$$ 
LANGUAGE plpgsql;