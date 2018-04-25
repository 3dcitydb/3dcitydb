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

CREATE OR REPLACE FUNCTION geodb_pkg.migrate_cityobject(
  INOUT co_id INTEGER,
  INOUT co_objectclass_id INTEGER,
  OUT co_name VARCHAR(1000),
  OUT co_name_codespace VARCHAR(4000),
  OUT co_description VARCHAR(4000)
  ) RETURNS RECORD AS
$$
BEGIN
  EXECUTE format('SELECT replace(name, %L, %L)::varchar(1000), replace(name_codespace, %L, %L)::varchar(4000), description FROM public.%I WHERE id = %L',
      ' --/\-- ', '--/\--', ' --/\-- ', '--/\--', citydb_pkg.objectclass_id_to_table_name(co_objectclass_id), co_id)
    INTO co_name, co_name_codespace, co_description;

  RETURN;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.update_cityobject(objectclass_id INTEGER) RETURNS SETOF VOID AS
$$
BEGIN
  EXECUTE format(
    'UPDATE citydb.cityobject SET
       name = sub.c_name,
       name_codespace = sub.c_name_codespace,
       description = sub.c_description
     FROM
       (SELECT id AS c_id,
          name AS c_name,
          name_codespace AS c_name_codespace,
          description AS c_description
        FROM public.%I
       ) sub
     WHERE id = sub.c_id',
     citydb.objectclass_id_to_table_name(objectclass_id));
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.migrate_tex_image(op VARCHAR) RETURNS SETOF VOID AS
$$
BEGIN
  DROP TABLE IF EXISTS citydb.tex_image CASCADE;

  IF lower($1) <> 'yes' AND lower($1) <> 'y' THEN
    -- migrate each tex_image from surface_data 1:1
    CREATE TABLE citydb.tex_image(
      id, tex_image_uri, tex_image_data, tex_mime_type,	tex_mime_type_codespace)
    AS SELECT
	  row_number() OVER () AS tid, tex_image_uri, tex_image, tex_mime_type,	NULL::varchar(4000)
    FROM public.surface_data
      WHERE tex_image_uri IS NOT NULL
      ORDER BY id;

    WITH texture_ref AS (
      SELECT row_number() OVER () AS tid, id
        FROM public.surface_data
          WHERE tex_image_uri IS NOT NULL
          ORDER BY id
    )
    UPDATE citydb.surface_data sd SET tex_image_id = t.tid
      FROM texture_ref t WHERE sd.id = t.id;
  ELSE
    -- store same textures (= same tex_image_uri) only once in tex_image table
    CREATE TABLE citydb.tex_image(
      id, tex_image_uri, tex_image_data, tex_mime_type,	tex_mime_type_codespace)
    AS SELECT
      row_number() OVER () AS tid, sd_v2.tex_image_uri, sd_v2.tex_image, sd_v2.tex_mime_type, NULL::varchar(4000)
    FROM public.surface_data sd_v2,
      (SELECT min(id) AS sample_id FROM public.surface_data WHERE tex_image_uri IS NOT NULL GROUP BY tex_image_uri) sample
    WHERE sd_v2.id = sample.sample_id;

    UPDATE citydb.surface_data sd_v3 SET tex_image_id = t.id
      FROM citydb.tex_image t, surface_data sd_v2
      WHERE sd_v3.id = sd_v2.id AND sd_v2.tex_image_uri = t.tex_image_uri;
  END IF;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION geodb_pkg.texCoordsToGeom(texcoord VARCHAR) RETURNS GEOMETRY AS
$$
DECLARE
  ring_count INTEGER := 0;
  ring_coords FLOAT[];
  i INTEGER;
  point_list GEOMETRY[] := '{}';
  outer_ring GEOMETRY;
  inner_rings GEOMETRY[] := '{}';
BEGIN
  IF texcoord IS NOT NULL THEN
    FOR ring_coords IN SELECT string_to_array(unnest(string_to_array($1, ';')),' ')::float[] LOOP
      IF ring_coords IS NOT NULL AND array_length(ring_coords,1) > 0 THEN
        FOR i IN 0..array_length(ring_coords,1)/2-1 LOOP
          point_list := array_append(point_list, ST_MakePoint(ring_coords[i*2+1], ring_coords[i*2+2]));
        END LOOP;

        IF ring_count = 0 THEN
          outer_ring := ST_MakeLine(point_list);
        ELSE
          inner_rings := array_append(inner_rings, ST_MakeLine(point_list));
        END IF;

        ring_count := ring_count + 1;
        point_list := '{}';
      END IF;
    END LOOP;

    RETURN ST_MakePolygon(outer_ring, inner_rings);
  ELSE
    RETURN NULL;
  END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
END;
$$
LANGUAGE plpgsql;
