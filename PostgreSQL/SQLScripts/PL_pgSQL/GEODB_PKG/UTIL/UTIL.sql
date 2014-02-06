-- UTIL.sql
--
-- Authors:     Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates package utility methods for applications.
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                                | Author
-- 2.0.0     2014-01-09   revision for 3DCityDB V3                     FKun
-- 1.2.0     2013-08-29   minor changes to change_db_srid function     FKun
-- 1.1.0     2013-02-22   PostGIS version                              FKun
--                                                                     CNag
-- 1.0.0     2008-09-10   release version                              CNag
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   db_metadata() RETURNS TABLE(
*     srid INTEGER, 
*     gml_srs_name VARCHAR(1000), 
*     coord_ref_sys_name VARCHAR(2048), 
*     coord_ref_sys_kind VARCHAR(2048), 
*     versioning VARCHAR(100)
*     )
*   get_seq_values(seq_name VARCHAR, seq_count INTEGER) RETURNS SETOF INTEGER
*   min(a NUMERIC, b NUMERIC) RETURNS NUMERIC
*   objectclass_id_to_table_name(class_id INTEGER) RETURNS VARCHAR
*   db_info(OUT schema_srid INTEGER, OUT schema_gml_srs_name VARCHAR, OUT versioning VARCHAR) RETURNS RECORD AS 
*   update_schema_constraints(on_delete_param VARCHAR DEFAULT 'CASCADE', schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   update_table_constraint(fkey_name VARCHAR, table_name VARCHAR, column_name VARCHAR, ref_table VARCHAR, ref_column VARCHAR, 
*     delete_param VARCHAR, deferrable_param VARCHAR, schema_name VARCHAR DEFAULT 'public') RETURNS SETOF VOID
*   versioning_db() RETURNS VARCHAR
*   versioning_table(table_name VARCHAR) RETURNS VARCHAR
******************************************************************/

/*****************************************************************
* versioning_table
*
* @param table_name name of table
* @param schema_name name of schema
* @RETURN VARCHAR 'ON' for version-enabled, 'OFF' otherwise
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.versioning_table(
  table_name VARCHAR,
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS VARCHAR AS 
$$
BEGIN
  EXECUTE format('SELECT audit_id FROM %I.%I LIMIT 1', schema_name, table_name);
  RETURN 'ON';

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'OFF';
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* versioning_db
*
* @RETURN VARCHAR 'ON' for version-enabled, 'OFF' for version-disabled
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.versioning_db() RETURNS VARCHAR AS 
$$
BEGIN
  RETURN 'OFF';
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* db_info
*
* @param schema_srid database srid
* @param schema_srs database srs name
* @param versioning database versioning
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.db_info(
  OUT schema_srid INTEGER, 
  OUT schema_gml_srs_name VARCHAR,
  OUT versioning VARCHAR
  ) RETURNS RECORD AS 
$$
BEGIN
  EXECUTE 'SELECT srid, gml_srs_name FROM database_srs' INTO schema_srid, schema_gml_srs_name;
  versioning := geodb_pkg.util_versioning_db();
END;
$$ 
LANGUAGE plpgsql;


/******************************************************************
* db_metadata
*
* @RETURN TABLE with columns SRID, GML_SRS_NAME, COORD_REF_SYS_NAME, 
*               COORD_REF_SYS_KIND, VERSIONING
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.db_metadata() RETURNS TABLE(
  schema_srid INTEGER, 
  schema_gml_srs_name VARCHAR(1000), 
  coord_ref_sys_name VARCHAR(2048), 
  coord_ref_sys_kind VARCHAR(2048), 
  versioning VARCHAR(10)
  ) AS 
$$
BEGIN
  EXECUTE 'SELECT SRID, GML_SRS_NAME FROM DATABASE_SRS' INTO schema_srid, schema_gml_srs_name;
  EXECUTE 'SELECT srtext, srtext FROM spatial_ref_sys WHERE SRID=$1' INTO coord_ref_sys_name, coord_ref_sys_kind USING schema_srid;
  coord_ref_sys_name := split_part(coord_ref_sys_name, '"', 2);
  coord_ref_sys_kind := split_part(coord_ref_sys_kind, '[', 1);
  versioning := geodb_pkg.versioning_db();
  RETURN NEXT;
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* min
*
* @param a first NUMERIC value
* @param b second NUMERIC value
* @RETURN NUMERIC the smaller of the two input NUMERIC values                
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.min(
  a NUMERIC, 
  b NUMERIC
  ) RETURNS NUMERIC AS 
$$
BEGIN
  IF a < b THEN
    RETURN a;
  ELSE
    RETURN b;
  END IF;
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* update_table_constraint
*
* Removes a contraint to add it again with parameters
* ON UPDATE CASCADE ON DELETE CASCADE or RESTRICT
*
* @param fkey_name name of the foreign key that is updated 
* @param table_name defines the table to which the constraint belongs to
* @param column_name defines the column the constraint is relying on
* @param ref_table name of referenced table
* @param ref_column name of referencing column of referenced table
* @param delete_param whether CASCADE or RESTRICT
* @param deferrable_param whether set or not
* @param schema_name name of schema
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.update_table_constraint(
  fkey_name VARCHAR,
  table_name VARCHAR,
  column_name VARCHAR,
  ref_table VARCHAR,
  ref_column VARCHAR,
  delete_param VARCHAR,
  deferrable_param VARCHAR,
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS 
$$
BEGIN
  EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I, ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES %I.%I (%I)
                    ON UPDATE CASCADE ON DELETE ' || delete_param || ' ' || deferrable_param,
                    schema_name, table_name, fkey_name, fkey_name, column_name, schema_name, ref_table, ref_column);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'Error on constraint %: %', fkey_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;


/******************************************************************
* update_schema_constraints
*
* calls update_table_constraint for updating all the contraints
* in the specified schema
*
* @param on_delete_param whether CASCADE (default) or RESTRICT
* @param schema_name name of schema
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.update_schema_constraints(
  on_delete_param VARCHAR DEFAULT 'CASCADE',
  schema_name VARCHAR DEFAULT 'public'
  ) RETURNS SETOF VOID AS 
$$
DECLARE
  delete_param VARCHAR(30) := 'CASCADE';
  deferrable_param VARCHAR(30);
BEGIN
  IF on_delete_param <> 'CASCADE' THEN
    delete_param := 'RESTRICT';
	deferrable_param := '';
    RAISE NOTICE 'Constraints are set to ON DELETE RESTRICT';
  ELSE
    deferrable_param := 'INITIALLY DEFERRED';
    RAISE NOTICE 'Constraints are set to ON DELETE CASCADE';
  END IF;

  EXECUTE 'SELECT geodb_pkg.update_table_constraint(tc.constraint_name, tc.table_name, kcu.column_name, ccu.table_name, ccu.column_name, $2, $3, tc.table_schema)
             FROM information_schema.table_constraints AS tc
             JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
             JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
               WHERE constraint_type = ''FOREIGN KEY'' AND tc.table_schema = $1'
               USING schema_name, delete_param, deferrable_param;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_sequence_values
*
* @param seq_name name of the sequence
* @param count number of values to be queried from the sequence
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.get_seq_values(
  seq_name VARCHAR,
  seq_count INTEGER
  ) RETURNS SETOF INTEGER AS $$
BEGIN
  RETURN QUERY EXECUTE 'SELECT nextval($1)::int FROM generate_series(1, $2)' USING seq_name, seq_count;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* objectclass_id_to_table_name
*
* @param class_id objectclass_id identifier
* @RETURN VARCHAR name of table that stores objects referred 
*                 to the given objectclass_id
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.objectclass_id_to_table_name(class_id INTEGER) RETURNS VARCHAR AS
$$
DECLARE
  table_name VARCHAR(30) := '';
BEGIN
  CASE 
    WHEN class_id = 4 THEN table_name := 'land_use';
    WHEN class_id = 5 THEN table_name := 'generic_cityobject';
    WHEN class_id = 7 THEN table_name := 'solitary_vegetat_object';
    WHEN class_id = 8 THEN table_name := 'plant_cover';
    WHEN class_id = 9 THEN table_name := 'waterbody';
    WHEN class_id = 11 OR 
         class_id = 12 OR 
         class_id = 13 THEN table_name := 'waterboundary_surface';
    WHEN class_id = 14 THEN table_name := 'relief_feature';
    WHEN class_id = 16 OR 
         class_id = 17 OR 
         class_id = 18 OR 
         class_id = 19 THEN table_name := 'relief_component';
    WHEN class_id = 21 THEN table_name := 'city_furniture';
    WHEN class_id = 23 THEN table_name := 'cityobjectgroup';
    WHEN class_id = 25 OR 
         class_id = 26 THEN table_name := 'building';
    WHEN class_id = 27 OR 
         class_id = 28 THEN table_name := 'building_installation';
    WHEN class_id = 30 OR 
         class_id = 31 OR 
         class_id = 32 OR 
         class_id = 33 OR 
         class_id = 34 OR 
         class_id = 35 OR
         class_id = 36 OR
         class_id = 60 OR
         class_id = 61 THEN table_name := 'thematic_surface';
    WHEN class_id = 38 OR 
         class_id = 39 THEN table_name := 'opening';
    WHEN class_id = 40 THEN table_name := 'building_furniture';
    WHEN class_id = 41 THEN table_name := 'room';
    WHEN class_id = 43 OR 
         class_id = 44 OR 
         class_id = 45 OR 
         class_id = 46 THEN table_name := 'transportion_complex';
    WHEN class_id = 47 OR 
         class_id = 48 THEN table_name := 'traffic_area';
    WHEN class_id = 57 THEN table_name := 'citymodel';
    WHEN class_id = 63 OR
         class_id = 62 THEN table_name := 'bridge';
    WHEN class_id = 65 OR
         class_id = 66 THEN table_name := 'bridge_installation';
    WHEN class_id = 68 OR 
         class_id = 69 OR 
         class_id = 70 OR 
         class_id = 71 OR 
         class_id = 72 OR
         class_id = 73 OR
         class_id = 74 OR
         class_id = 75 OR
         class_id = 76 THEN table_name := 'bridge_thematic_surface';
    WHEN class_id = 78 OR 
         class_id = 79 THEN table_name := 'bridge_opening';		 
    WHEN class_id = 80 THEN table_name := 'bridge_furniture';
    WHEN class_id = 81 THEN table_name := 'bridge_room';
    WHEN class_id = 82 THEN table_name := 'bridge_constr_element';
    WHEN class_id = 84 OR
         class_id = 85 THEN table_name := 'tunnel';
    WHEN class_id = 86 OR
         class_id = 87 THEN table_name := 'tunnel_installation';
    WHEN class_id = 88 OR 
         class_id = 89 OR 
         class_id = 90 OR 
         class_id = 91 OR 
         class_id = 92 OR
         class_id = 93 OR
         class_id = 94 OR
         class_id = 95 OR
         class_id = 96 THEN table_name := 'tunnel_thematic_surface';
    WHEN class_id = 99 OR 
         class_id = 100 THEN table_name := 'tunnel_opening';		 
    WHEN class_id = 101 THEN table_name := 'tunnel_furniture';
    WHEN class_id = 102 THEN table_name := 'tunnel_hollow_space';
  ELSE
    RAISE NOTICE 'Table name unknown.';
  END CASE;
  
  RETURN table_name;
END;
$$
LANGUAGE plpgsql;