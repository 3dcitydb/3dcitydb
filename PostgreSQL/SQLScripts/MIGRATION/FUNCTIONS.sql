-- FUNCTIONS.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 3.0.0     2014-12-28   release version                             FKun
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
  EXECUTE format('SELECT name, name_codespace, description FROM public.%I WHERE id = %L', 
            citydb_pkg.objectclass_id_to_table_name(co_objectclass_id), co_id)
            INTO co_name, co_name_codespace, co_description;

  RETURN;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION geodb_pkg.migrate_tex_image(surface_data_id INTEGER) RETURNS SETOF VOID AS
$$
DECLARE
  texture_uri VARCHAR(4000);
  texture BYTEA;
  texture_mime_type VARCHAR(256);
  texture_id INTEGER;
BEGIN
  EXECUTE 'SELECT tex_image_uri, tex_image, tex_mime_type FROM public.surface_data WHERE id = $1'
             INTO texture_uri, texture, texture_mime_type USING surface_data_id;

  EXECUTE 'INSERT INTO citydb.tex_image (tex_image_uri, tex_image_data, tex_mime_type)
             VALUES ($1, $2, $3) RETURNING id' INTO texture_id USING texture_uri, texture, texture_mime_type;

  EXECUTE 'WITH surface_data_ref AS (
             SELECT id FROM public.surface_data WHERE tex_image_uri = $1
           )
           UPDATE citydb.surface_data sd SET tex_image_id = $2
             FROM surface_data_ref ref WHERE sd.id = ref.id' 
           USING texture_uri, texture_id;
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
  FOR ring_coords IN SELECT string_to_array(unnest(string_to_array($1, ';')),' ')::float[] LOOP
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
  END LOOP;
	
  IF array_length(inner_rings,1) = 0 THEN
    RETURN ST_MakePolygon(outer_ring);
  ELSE
    RETURN ST_MakePolygon(outer_ring, inner_rings);
  END IF;
END;
$$
LANGUAGE plpgsql;