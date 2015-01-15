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
-- Creates package "citydb_util" containing utility methods for applications
-- and further subpackges. Therefore, "citydb_util" might be a dependency
-- for other packages and/or methods.
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.0.0     2014-10-10   new version for 3DCityDB V3                 FKun
-- 1.2.0     2013-08-29   added change_db_srid procedure              FKun
-- 1.1.0     2011-07-28   update to 2.0.6                             CNag
-- 1.0.0     2008-09-10   release version                             CNag
--

--SET term OFF;
--SET serveroutput OFF;

/*****************************************************************
* TYPE STRARRAY
*
* global type for arrays of strings, e.g. used for log messages
* and reports
******************************************************************/
CREATE OR REPLACE TYPE STRARRAY IS TABLE OF VARCHAR2(32767);
/

/*****************************************************************
* TYPE ID_ARRAY
*
* global type for arrays of number values
******************************************************************/
CREATE OR REPLACE TYPE ID_ARRAY IS TABLE OF NUMBER;
/

/*****************************************************************
* TYPE DB_VERSION_OBJ and DB_VERSION_TABLE
* 
* global type for database version information
******************************************************************/
CREATE OR REPLACE TYPE DB_VERSION_OBJ AS OBJECT(
  VERSION VARCHAR2(10),
  MAJOR_VERSION NUMBER,
  MINOR_VERSION NUMBER,
  MINOR_REVISION NUMBER
);
/

CREATE OR REPLACE TYPE DB_VERSION_TABLE IS TABLE OF DB_VERSION_OBJ;
/

/*****************************************************************
* TYPE DB_INFO_OBJ and DB_INFO_TABLE
* 
* global type for database metadata
******************************************************************/
CREATE OR REPLACE TYPE DB_INFO_OBJ AS OBJECT(
  SCHEMA_SRID NUMBER,
  SCHEMA_GML_SRS_NAME VARCHAR2(1000),
  COORD_REF_SYS_NAME VARCHAR2(80),
  COORD_REF_SYS_KIND VARCHAR2(24),
  WKTEXT VARCHAR2(4000),
  VERSIONING VARCHAR2(100)
);
/

CREATE OR REPLACE TYPE DB_INFO_TABLE IS TABLE OF DB_INFO_OBJ;
/


/*****************************************************************
* PACKAGE citydb_util
* 
* utility methods for applications and subpackages
******************************************************************/
CREATE OR REPLACE PACKAGE citydb_util
AS
  FUNCTION citydb_version RETURN DB_VERSION_TABLE;
  FUNCTION versioning_table(table_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  FUNCTION versioning_db(schema_name VARCHAR2 := USER) RETURN VARCHAR2;
  PROCEDURE db_info(schema_srid OUT DATABASE_SRS.SRID%TYPE, schema_gml_srs_name OUT DATABASE_SRS.GML_SRS_NAME%TYPE, versioning OUT VARCHAR2);
  FUNCTION db_metadata RETURN DB_INFO_TABLE;
  FUNCTION split(list VARCHAR2, delim VARCHAR2 := ',') RETURN STRARRAY;
  FUNCTION min(a NUMBER, b NUMBER) RETURN NUMBER;
  PROCEDURE update_schema_constraints(on_delete_param VARCHAR2 := 'CASCADE', schema_name VARCHAR2 := USER);
  PROCEDURE update_table_constraint(fkey_name VARCHAR2, table_name VARCHAR2, column_name VARCHAR2, ref_table VARCHAR2, ref_column VARCHAR2, on_delete_param VARCHAR2 := 'CASCADE', schema_name VARCHAR2 := USER);
  FUNCTION get_seq_values(seq_name VARCHAR2, seq_count NUMBER, schema_name VARCHAR2 := USER) RETURN ID_ARRAY;
  FUNCTION get_id_array_size(id_arr ID_ARRAY) RETURN NUMBER;
  FUNCTION objectclass_id_to_table_name(class_id NUMBER) RETURN VARCHAR2;
  FUNCTION to_2d(geom MDSYS.SDO_GEOMETRY, srid NUMBER) RETURN MDSYS.SDO_GEOMETRY;
END citydb_util;
/

CREATE OR REPLACE PACKAGE BODY citydb_util
AS

  /*****************************************************************
  * citydb_version
  *
  ******************************************************************/
  FUNCTION citydb_version RETURN DB_VERSION_TABLE
  IS
    version_ret DB_VERSION_TABLE;
    version_tmp DB_VERSION_OBJ;
  BEGIN
    version_ret := DB_VERSION_TABLE();
    version_ret.extend;

    version_tmp := DB_VERSION_OBJ('3.0.0', 3, 0, 0);

    version_ret(version_ret.count) := version_tmp;
    RETURN version_ret;
  END;

  /*****************************************************************
  * versioning_table
  *
  * @param table_name name of the unversioned table, i.e., omit
  *                   suffixes such as _LT
  * @param schema_name name of schema of target table
  * @RETURN VARCHAR2 'ON' for version-enabled, 'OFF' otherwise
  ******************************************************************/
  FUNCTION versioning_table(
    table_name VARCHAR2, 
    schema_name VARCHAR2 := USER
    ) RETURN VARCHAR2
  IS
    status USER_TABLES.STATUS%TYPE;
  BEGIN
    EXECUTE IMMEDIATE 'SELECT status FROM all_table WHERE owner=:1 AND table_name=:2' INTO status USING upper(schema_name), upper(table_name) || '_LT';
    RETURN 'ON';
  EXCEPTION
    WHEN others THEN
      RETURN 'OFF';
  END; 

  /*****************************************************************
  * versioning_db
  *
  * @param schema_name name of schema
  * @RETURN VARCHAR2 'ON' for version-enabled, 'PARTLY' and 'OFF'
  ******************************************************************/
  FUNCTION versioning_db(schema_name VARCHAR2 := USER) RETURN VARCHAR2
  IS
    table_names STRARRAY;
    is_versioned BOOLEAN := FALSE;
    not_versioned BOOLEAN := FALSE;
  BEGIN
    table_names := split('ADDRESS,ADDRESS_TO_BRIDGE,ADDRESS_TO_BUILDING,APPEAR_TO_SURFACE_DATA,APPEARANCE,BREAKLINE_RELIEF,BRIDGE,BRIDGE_CONSTR_ELEMENT,BRIDGE_FURNITURE,BRIDGE_INSTALLATION,BRIDGE_OPEN_TO_THEM_SRF,BRIDGE_OPENING,BRIDGE_ROOM,BRIDGE_THEMATIC_SURFACE,BUILDING,BUILDING_FURNITURE,BUILDING_INSTALLATION,CITY_FURNITURE,CITYMODEL,CITYOBJECT,CITYOBJECT_GENERICATTRIB,CITYOBJECT_MEMBER,CITYOBJECTGROUP,EXTERNAL_REFERENCE,GENERALIZATION,GENERIC_CITYOBJECT,GROUP_TO_CITYOBJECT,IMPLICIT_GEOMETRY,LAND_USE,MASSPOINT_RELIEF,OPENING,OPENING_TO_THEM_SURFACE,PLANT_COVER,RASTER_REL_GEORASTER_RDT,RASTER_RELIEF,RELIEF_COMPONENT,RELIEF_FEAT_TO_REL_COMP,RELIEF_FEATURE,ROOM,SOLITARY_VEGETAT_OBJECT,SURFACE_DATA,SURFACE_GEOMETRY,TEX_IMAGE,TEXTUREPARAM,THEMATIC_SURFACE,TIN_RELIEF,TRAFFIC_AREA,TRANSPORTATION_COMPLEX,TUNNEL,TUNNEL_FURNITURE,TUNNEL_HOLLOW_SPACE,TUNNEL_INSTALLATION,TUNNEL_OPEN_TO_THEM_SRF,TUNNEL_OPENING,TUNNEL_THEMATIC_SURFACE,WATERBOD_TO_WATERBND_SRF,WATERBODY,WATERBOUNDARY_SURFACE','VIEW_WO_OVERWRITE');

    FOR i IN table_names.first .. table_names.last LOOP
      IF versioning_table(table_names(i), schema_name) = 'ON' THEN
        is_versioned := TRUE;
      ELSE
        not_versioned := TRUE;
      END IF;
    END LOOP;

    IF is_versioned AND NOT not_versioned THEN
      RETURN 'ON';
    ELSIF is_versioned AND not_versioned THEN
      RETURN 'PARTLY';
    ELSE
      RETURN 'OFF';
    END IF;
  END;  

  /*****************************************************************
  * db_info
  *
  * @param schema_srid database srid
  * @param schema_gml_srs_name database srs name
  * @param versioning database versioning
  * @param schema_name name of user schema
  ******************************************************************/
  PROCEDURE db_info(schema_srid OUT DATABASE_SRS.SRID%TYPE, schema_gml_srs_name OUT DATABASE_SRS.GML_SRS_NAME%TYPE, versioning OUT VARCHAR2) 
  IS
  BEGIN
    EXECUTE IMMEDIATE 'SELECT SRID, GML_SRS_NAME from DATABASE_SRS' INTO schema_srid, schema_gml_srs_name;
    versioning := versioning_db(USER);
  END;

  /*****************************************************************
  * db_metadata
  *
  ******************************************************************/
  FUNCTION db_metadata RETURN DB_INFO_TABLE 
  IS
    info_ret DB_INFO_TABLE;
    info_tmp DB_INFO_OBJ;
  BEGIN
    info_ret := DB_INFO_TABLE();
    info_ret.extend;

    info_tmp := DB_INFO_OBJ(0, NULL, NULL, 0, NULL, NULL);

    EXECUTE IMMEDIATE 'select SRID, GML_SRS_NAME from DATABASE_SRS' INTO info_tmp.schema_srid, info_tmp.schema_gml_srs_name;
    EXECUTE IMMEDIATE 'select COORD_REF_SYS_NAME, COORD_REF_SYS_KIND from SDO_COORD_REF_SYS where SRID=:1' INTO info_tmp.coord_ref_sys_name, info_tmp.coord_ref_sys_kind USING info_tmp.schema_srid;
    EXECUTE IMMEDIATE 'select nvl(WKTEXT3D, WKTEXT) from CS_SRS where SRID=:1' INTO info_tmp.wktext USING info_tmp.schema_srid;
    info_tmp.versioning := versioning_db;
    info_ret(info_ret.count) := info_tmp;
    RETURN info_ret;
  END;

  /*****************************************************************
  * split
  *
  * @param list string to be splitted
  * @param delim delimiter used for splitting, defaults to ','
  * @RETURN STRARRAY array of strings containing split tokens                 
  ******************************************************************/
  FUNCTION split(list VARCHAR2, delim VARCHAR2 := ',') RETURN STRARRAY
  IS
    results STRARRAY := STRARRAY();
    idx PLS_INTEGER;
    tmp_list VARCHAR2(32767) := list;
  BEGIN
    LOOP
      idx := instr(tmp_list,delim);
      IF idx > 0 THEN
        results.extend;
        results(results.count) := substr(tmp_list, 1, idx-1);
        tmp_list := substr(tmp_list, idx + length(delim));
      ELSE
        results.extend;
        results(results.count) := tmp_list;
        EXIT;
      END IF;
    END LOOP;

    RETURN results;
  END;

  /*****************************************************************
  * min
  *
  * @param a first number value
  * @param b second number value
  * @RETURN NUMBER the smaller of the two input number values                
  ******************************************************************/
  FUNCTION min(a NUMBER, b NUMBER) RETURN NUMBER
  IS
  BEGIN
    IF a < b THEN
      RETURN a;
    ELSE
      RETURN b;
    END IF;
  END;

  /******************************************************************
  * update_table_constraint
  *
  * Removes a constraint to add it again with parameters
  * ON UPDATE CASCADE ON DELETE CASCADE or RESTRICT
  *
  * @param fkey_name name of the foreign key that is updated 
  * @param table_name defines the table to which the constraint belongs to
  * @param column_name defines the column the constraint is relying on
  * @param ref_table name of referenced table
  * @param ref_column name of referencing column of referenced table
  * @param on_delete_param whether CASCADE or RESTRICT
  * @param schema_name name of schema of target constraints
  ******************************************************************/
  PROCEDURE update_table_constraint(
    fkey_name VARCHAR2,
    table_name VARCHAR2,
    column_name VARCHAR2,
    ref_table VARCHAR2,
    ref_column VARCHAR2,
    on_delete_param VARCHAR2 := 'CASCADE',
    schema_name VARCHAR2 := USER
    )
  IS
  BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ' || schema_name || '.' || table_name || ' DROP CONSTRAINT ' || fkey_name;
    EXECUTE IMMEDIATE 'ALTER TABLE ' || schema_name || '.' || table_name || ' ADD CONSTRAINT ' || fkey_name || 
                         ' FOREIGN KEY (' || column_name || ') REFERENCES ' || schema_name || '.' || ref_table || '(' || ref_column || ')'
                         || on_delete_param;
    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('Error on constraint ' || fkey_name || ': ' || SQLERRM);
  END;

  /******************************************************************
  * update_schema_constraints
  *
  * calls update_table_constraint for updating all the constraints
  * in the user schema
  *
  * @param on_delete_param whether CASCADE (default) or RESTRICT
  * @param schema_name name of schema of target constraints
  ******************************************************************/
  PROCEDURE update_schema_constraints(
    on_delete_param VARCHAR2 := 'CASCADE',
    schema_name VARCHAR2 := USER
    )
  IS
    delete_param VARCHAR2(30) := 'ON DELETE CASCADE';
    deferrable_param VARCHAR2(30);
  BEGIN
    IF on_delete_param <> 'CASCADE' THEN
      delete_param := '';
      dbms_output.put_line('Constraints are set to ON DELETE RESTRICT');
    ELSE
      dbms_output.put_line('Constraints are set to ON DELETE CASCADE');
    END IF;

    FOR rec IN (SELECT acc1.constraint_name AS fkey, acc1.table_name AS t, acc1.column_name AS c, 
                  ac2.table_name AS ref_t, acc2.column_name AS ref_c, acc1.owner AS schema
                FROM all_cons_columns acc1
                JOIN all_constraints ac1 ON acc1.owner = ac1.owner 
                  AND acc1.constraint_name = ac1.constraint_name
                JOIN all_constraints ac2 ON ac1.r_owner = ac2.owner 
                  AND ac1.r_constraint_name = ac2.constraint_name
                JOIN all_cons_columns acc2 ON ac2.owner = acc2.owner 
                  AND ac2.constraint_name = acc2.constraint_name 
                  AND acc2.position = acc1.position     
                WHERE acc1.owner = upper(schema_name) AND ac1.constraint_type = 'R') LOOP
      update_table_constraint(rec.fkey, rec.t, rec.c, rec.ref_t, rec.ref_c, delete_param, schema_name);
    END LOOP;
  END;

  /*****************************************************************
  * get_seq_values
  *
  * @param seq_name name of the sequence
  * @param count number of values to be queried from the sequence
  * @param schema_name name of schema of target sequence
  ******************************************************************/
  FUNCTION get_seq_values(
    seq_name VARCHAR2, 
    seq_count NUMBER,
    schema_name VARCHAR2 := USER
    ) RETURN ID_ARRAY
  IS
    seq_tbl ID_ARRAY;
  BEGIN
    EXECUTE IMMEDIATE 'SELECT ' || upper(schema_name) || '.' || seq_name || '.nextval FROM dual CONNECT BY level <= :1' 
                         BULK COLLECT INTO seq_tbl USING seq_count;
    RETURN seq_tbl;
  END;


  /*****************************************************************
  * get_id_array_size
  *
  * RETURN the size of a given ID_ARRAY object
  *
  * @param     @description       
  * id_arr     passed ID_ARRAY object
  *
  * @return
  * size of ID_ARRAY object
  ******************************************************************/
  FUNCTION get_id_array_size(id_arr ID_ARRAY) RETURN NUMBER
  IS
    arr_count NUMBER := 0;
  BEGIN
    arr_count := id_arr.count;

    RETURN arr_count;

    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('An error occured when executing function "vcdb_util.get_id_array_size": ' || SQLERRM);
        RETURN arr_count;
  END;


  /*****************************************************************
  * objectclass_id_to_table_name
  *
  * @param class_id objectclass_id identifier
  * @RETURN VARCHAR2 name of table that stores objects referred 
  *                  to the given objectclass_id
  ******************************************************************/
  FUNCTION objectclass_id_to_table_name(class_id NUMBER) RETURN VARCHAR2
  IS
    table_name VARCHAR2(30) := '';
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
      dbms_output.put_line('Table name unknown.');
      NULL;
    END CASE;

    RETURN table_name;
  END;
  

  /*
  * code taken from http://forums.oracle.com/forums/thread.jspa?messageID=960492&#960492
  */
  function to_2d (geom mdsys.sdo_geometry, srid number)
  return mdsys.sdo_geometry
  is
    geom_2d mdsys.sdo_geometry;
    dim_count integer; -- number of dimensions in layer
    gtype integer; -- geometry type (single digit)
    n_points integer; -- number of points in ordinates array
    n_ordinates integer; -- number of ordinates
    i integer;
    j integer;
    k integer;
    offset integer;
  begin
    -- If the input geometry is null, just return null
    if geom is null then
      return (null);
    end if;
    
    -- Get the number of dimensions from the gtype
    if length (geom.sdo_gtype) = 4 then
      dim_count := substr (geom.sdo_gtype, 1, 1);
      gtype := substr (geom.sdo_gtype, 4, 1);
    else
    -- Indicate failure
      raise_application_error (-20000, 'Unable to determine dimensionality from gtype');
    end if;
    
    if dim_count = 2 then
      -- Nothing to do, geometry is already 2D
      return (geom);
    end if;
  
    -- Construct and prepare the output geometry
    geom_2d := mdsys.sdo_geometry (
                2000+gtype, srid, geom.sdo_point,
                mdsys.sdo_elem_info_array (), mdsys.sdo_ordinate_array()
                );
  
    -- Process the point structure
    if geom_2d.sdo_point is not null then
      geom_2D.sdo_point.z := null;
    else
      -- It is not a point  
      -- Process the ordinates array
  
      -- Prepare the size of the output array
      n_points := geom.sdo_ordinates.count / dim_count;
      n_ordinates := n_points * 2;
      geom_2d.sdo_ordinates.extend(n_ordinates);
  
      -- Copy the ordinates array
      j := geom.sdo_ordinates.first; -- index into input elem_info array
      k := 1; -- index into output ordinate array
      for i in 1..n_points loop
        geom_2d.sdo_ordinates (k) := geom.sdo_ordinates (j); -- copy X
        geom_2d.sdo_ordinates (k+1) := geom.sdo_ordinates (j+1); -- copy Y
        j := j + dim_count;
        k := k + 2;
      end loop;
  
      -- Process the element info array
      
      -- Copy the input array into the output array
      geom_2d.sdo_elem_info := geom.sdo_elem_info;
      
      -- Adjust the offsets
      i := geom_2d.sdo_elem_info.first;
      while i < geom_2d.sdo_elem_info.last loop
        offset := geom_2d.sdo_elem_info(i);
        geom_2d.sdo_elem_info(i) := (offset-1)/dim_count*2+1;
        i := i + 3;
      end loop;
    end if;
  
    return geom_2d;
  exception
    when others then
      dbms_output.put_line('to_2d: ' || SQLERRM);
      return null;
  end;
  
END citydb_util;
/