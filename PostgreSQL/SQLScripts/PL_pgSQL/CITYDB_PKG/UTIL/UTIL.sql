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
-- 2.0.0     2014-07-30   revision for 3DCityDB V3                     FKun
-- 1.2.0     2013-08-29   minor changes to change_db_srid function     FKun
-- 1.1.0     2013-02-22   PostGIS version                              FKun
--                                                                     CNag
-- 1.0.0     2008-09-10   release version                              CNag
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   citydb_version() RETURNS TABLE(
*     citydb_version TEXT, 
*     major_version INTEGER, 
*     minor_version INTEGER, 
*     minor_revision INTEGER
*     )
*   db_info(OUT schema_srid INTEGER, OUT schema_gml_srs_name TEXT, OUT versioning TEXT) RETURNS RECORD
*   db_metadata() RETURNS TABLE(
*     srid INTEGER, 
*     gml_srs_name TEXT, 
*     coord_ref_sys_name TEXT, 
*     coord_ref_sys_kind TEXT,
*     wktext TEXT,
*     versioning TEXT
*     )
*   get_seq_values(seq_name TEXT, seq_count INTEGER, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF INTEGER
*   min(a NUMERIC, b NUMERIC) RETURNS NUMERIC
*   objectclass_id_to_table_name(class_id INTEGER) RETURNS TEXT
*   update_schema_constraints(on_delete_param TEXT DEFAULT 'CASCADE', schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   update_table_constraint(fkey_name TEXT, table_name TEXT, column_name TEXT, ref_table TEXT, ref_column TEXT, 
*     delete_param TEXT, deferrable_param TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS SETOF VOID
*   versioning_db(schema_name TEXT DEFAULT 'citydb') RETURNS TEXT
*   versioning_table(table_name TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS TEXT
******************************************************************/

/*****************************************************************
* citydb_version
*
* @RETURN TABLE with columns
*   version - version of 3DCityDB as string
*   major_version - major version number of 3DCityDB instance
*   minor_version - minor version number of 3DCityDB instance
*   minor_revision - minor revision number of 3DCityDB instance
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.citydb_version() RETURNS TABLE( 
  version TEXT, 
  major_version INTEGER, 
  minor_version INTEGER, 
  minor_revision INTEGER
  ) AS 
$$
BEGIN
  version := '3.1.0'; 
  major_version := 3;
  minor_version := 1;
  minor_revision := 0;
  RETURN NEXT;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* versioning_table
*
* @param table_name name of table
* @param schema_name name of schema of target table
* @RETURN TEXT 'ON' for version-enabled, 'OFF' otherwise
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.versioning_table(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS TEXT AS 
$$
BEGIN
  RETURN 'OFF';
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* versioning_db
*
* @param schema_name name of schema
* @RETURN TEXT 'ON' for version-enabled, 'OFF' for version-disabled
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.versioning_db(schema_name TEXT DEFAULT 'citydb') RETURNS TEXT AS 
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
CREATE OR REPLACE FUNCTION citydb_pkg.db_info(
  OUT schema_srid INTEGER, 
  OUT schema_gml_srs_name TEXT,
  OUT versioning TEXT
  ) RETURNS RECORD AS 
$$
BEGIN
  EXECUTE 'SELECT srid, gml_srs_name FROM database_srs' INTO schema_srid, schema_gml_srs_name;
  versioning := citydb_pkg.versioning_db(current_schema());
END;
$$ 
LANGUAGE plpgsql IMMUTABLE;


/******************************************************************
* db_metadata
*
* @RETURN TABLE with columns SRID, GML_SRS_NAME, COORD_REF_SYS_NAME, 
*               COORD_REF_SYS_KIND, VERSIONING
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.db_metadata() RETURNS TABLE(
  schema_srid INTEGER, 
  schema_gml_srs_name TEXT, 
  coord_ref_sys_name TEXT, 
  coord_ref_sys_kind TEXT,
  wktext TEXT,  
  versioning TEXT
  ) AS 
$$
BEGIN
  EXECUTE 'SELECT SRID, GML_SRS_NAME FROM DATABASE_SRS' INTO schema_srid, schema_gml_srs_name;
  EXECUTE 'SELECT srtext FROM spatial_ref_sys WHERE SRID=$1' INTO wktext USING schema_srid;
  coord_ref_sys_name := split_part(wktext, '"', 2);
  coord_ref_sys_kind := split_part(wktext, '[', 1);
  versioning := citydb_pkg.versioning_db();
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
CREATE OR REPLACE FUNCTION citydb_pkg.min(
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
* Removes a constraint to add it again with parameters
* ON UPDATE CASCADE ON DELETE CASCADE or NO ACTION
*
* @param fkey_name name of the foreign key that is updated 
* @param table_name defines the table to which the constraint belongs to
* @param column_name defines the column the constraint is relying on
* @param ref_table name of referenced table
* @param ref_column name of referencing column of referenced table
* @param delete_param whether CASCADE or NO ACTION
* @param schema_name name of schema of target constraints
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.update_table_constraint(
  fkey_name TEXT,
  table_name TEXT,
  column_name TEXT,
  ref_table TEXT,
  ref_column TEXT,
  delete_param TEXT DEFAULT 'CASCADE',
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
BEGIN
  EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I, ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES %I.%I (%I)
                    ON UPDATE CASCADE ON DELETE ' || delete_param,
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
* calls update_table_constraint for updating all the constraints
* in the specified schema
*
* @param on_delete_param whether CASCADE (default) or NO ACTION
* @param schema_name name of schema of target constraints
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.update_schema_constraints(
  on_delete_param TEXT DEFAULT 'CASCADE',
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF VOID AS 
$$
DECLARE
  delete_param TEXT := 'CASCADE';
BEGIN
  IF on_delete_param <> 'CASCADE' THEN
    delete_param := 'NO ACTION';
    RAISE NOTICE 'Constraints are set to ON DELETE NO ACTION';
  ELSE
    RAISE NOTICE 'Constraints are set to ON DELETE CASCADE';
  END IF;

  EXECUTE 'SELECT citydb_pkg.update_table_constraint(tc.constraint_name, tc.table_name, kcu.column_name, ccu.table_name, ccu.column_name, $2, tc.table_schema)
             FROM information_schema.table_constraints AS tc
             JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
             JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
               WHERE constraint_type = ''FOREIGN KEY'' AND tc.table_schema = $1 AND kcu.table_schema = $1'
               USING schema_name, delete_param;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* get_sequence_values
*
* @param seq_name name of the sequence
* @param count number of values to be queried from the sequence
* @param schema_name name of schema of target sequence
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.get_seq_values(
  seq_name TEXT,
  seq_count INTEGER,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS SETOF INTEGER AS $$
BEGIN
  RETURN QUERY EXECUTE 'SELECT nextval($1)::int FROM generate_series(1, $2)' USING schema_name || '.' || seq_name, seq_count;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* objectclass_id_to_table_name
*
* @param class_id objectclass_id identifier
* @RETURN TEXT name of table that stores objects referred 
*                 to the given objectclass_id
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.objectclass_id_to_table_name(class_id INTEGER) RETURNS TEXT AS
$$
DECLARE
  table_name TEXT := '';
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
         class_id = 46 THEN table_name := 'transportation_complex';
    WHEN class_id = 47 OR 
         class_id = 48 THEN table_name := 'traffic_area';
    WHEN class_id = 57 THEN table_name := 'citymodel';
    WHEN class_id = 63 OR
         class_id = 64 THEN table_name := 'bridge';
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