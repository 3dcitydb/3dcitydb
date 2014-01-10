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
-- Creates package "geodb_util" containing utility methods for applications
-- and further subpackges. Therefore, "geodb_util" might be a dependency
-- for other packages and/or methods.
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.0.0     2014-01-09   new version for 3DCityDB V3                 FKun
-- 1.2.0     2013-08-29   added change_db_srid procedure              FKun
-- 1.1.0     2011-07-28   update to 2.0.6                             CNag
-- 1.0.0     2008-09-10   release version                             CNag
--

/*****************************************************************
* TYPE STRARRAY
*
* global type for arrays of strings, e.g. used for log messages
* and reports
******************************************************************/
SET term OFF;
SET serveroutput OFF;

CREATE OR REPLACE TYPE STRARRAY IS TABLE OF VARCHAR2(32767);
/

CREATE OR REPLACE TYPE SEQ_TABLE IS TABLE OF NUMBER;
/

DROP TYPE DB_INFO_TABLE;
CREATE OR REPLACE TYPE DB_INFO_OBJ AS OBJECT(
  SRID NUMBER,
  GML_SRS_NAME VARCHAR2(1000),
  COORD_REF_SYS_NAME VARCHAR2(80),
  COORD_REF_SYS_KIND VARCHAR2(24),
  VERSIONING VARCHAR2(100)
);
/

CREATE OR REPLACE TYPE DB_INFO_TABLE IS TABLE OF DB_INFO_OBJ;
/

/*****************************************************************
* PACKAGE geodb_util
* 
* utility methods for applications and subpackages
******************************************************************/
CREATE OR REPLACE PACKAGE geodb_util
AS
  FUNCTION versioning_table(table_name VARCHAR2) RETURN VARCHAR2;
  FUNCTION versioning_db RETURN VARCHAR2;
  PROCEDURE db_info(srid OUT DATABASE_SRS.SRID%TYPE, srs OUT DATABASE_SRS.GML_SRS_NAME%TYPE, versioning OUT VARCHAR2);
  FUNCTION db_metadata RETURN DB_INFO_TABLE;
  FUNCTION split(list VARCHAR2, delim VARCHAR2 := ',') RETURN STRARRAY;
  FUNCTION min(a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION transform_or_null(geom MDSYS.SDO_GEOMETRY, srid NUMBER) RETURN MDSYS.SDO_GEOMETRY;
  FUNCTION is_coord_ref_sys_3d(srid NUMBER) RETURN NUMBER;
  FUNCTION is_db_coord_ref_sys_3d RETURN NUMBER;
  PROCEDURE update_schema_constraints(on_delete_param VARCHAR2 := 'CASCADE');
  PROCEDURE update_table_constraint(fkey_name VARCHAR2, table_name VARCHAR2, column_name VARCHAR2, ref_table VARCHAR2, ref_column VARCHAR2, on_delete_param VARCHAR2, deferrable_param VARCHAR2);
  PROCEDURE change_db_srid(db_srid NUMBER, db_gml_srs_name VARCHAR2);
  FUNCTION get_dim(t_name VARCHAR, c_name VARCHAR) RETURN NUMBER;
  PROCEDURE change_column_srid(t_name VARCHAR2, c_name VARCHAR2, dim NUMBER, db_srid NUMBER);
  FUNCTION get_seq_values(seq_name VARCHAR2, seq_count NUMBER) RETURN SEQ_TABLE;
  FUNCTION objectclass_id_to_table_name(class_id NUMBER) RETURN VARCHAR2;
END geodb_util;
/

CREATE OR REPLACE PACKAGE BODY geodb_util
AS

  /*****************************************************************
  * versioning_table
  *
  * @param table_name name of the unversioned table, i.e., omit
  *                   suffixes such as _LT
  * @RETURN VARCHAR2 'ON' for version-enabled, 'OFF' otherwise
  ******************************************************************/
  FUNCTION versioning_table(table_name VARCHAR2) RETURN VARCHAR2
  IS
    status USER_TABLES.STATUS%TYPE;
  BEGIN
    EXECUTE IMMEDIATE 'SELECT STATUS FROM USER_TABLES WHERE TABLE_NAME=:1' INTO status USING table_name || '_LT';
    RETURN 'ON';
  EXCEPTION
    WHEN others THEN
      RETURN 'OFF';
  END; 

  /*****************************************************************
  * versioning_db
  *
  * @RETURN VARCHAR2 'ON' for version-enabled, 'PARTLY' and 'OFF'
  ******************************************************************/
  FUNCTION versioning_db RETURN VARCHAR2
  IS
    table_names STRARRAY;
    is_versioned BOOLEAN := FALSE;
    not_versioned BOOLEAN := FALSE;
  BEGIN
    table_names := split('ADDRESS,ADDRESS_TO_BUILDING,APPEAR_TO_SURFACE_DATA,APPEARANCE,BREAKLINE_RELIEF,BUILDING,BUILDING_FURNITURE,BUILDING_INSTALLATION,CITY_FURNITURE,CITYMODEL,CITYOBJECT,CITYOBJECT_GENERICATTRIB,CITYOBJECT_MEMBER,CITYOBJECTGROUP,EXTERNAL_REFERENCE,GENERALIZATION,GENERIC_CITYOBJECT,GROUP_TO_CITYOBJECT,IMPLICIT_GEOMETRY,LAND_USE,MASSPOINT_RELIEF,OPENING,OPENING_TO_THEM_SURFACE,PLANT_COVER,RELIEF_COMPONENT,RELIEF_FEAT_TO_REL_COMP,RELIEF_FEATURE,ROOM,SOLITARY_VEGETAT_OBJECT,SURFACE_DATA,SURFACE_GEOMETRY,TEXTUREPARAM,THEMATIC_SURFACE,TIN_RELIEF,TRAFFIC_AREA,TRANSPORTATION_COMPLEX,WATERBOD_TO_WATERBND_SRF,WATERBODY,WATERBOUNDARY_SURFACE');

    FOR i IN table_names.first .. table_names.last LOOP
      IF versioning_table(table_names(i)) = 'ON' THEN
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
  * @param srid database srid
  * @param srs database srs name
  * @param versioning database versioning
  ******************************************************************/
  PROCEDURE db_info(srid OUT DATABASE_SRS.SRID%TYPE, srs OUT DATABASE_SRS.GML_SRS_NAME%TYPE, versioning OUT VARCHAR2) 
  IS
  BEGIN
    EXECUTE IMMEDIATE 'SELECT SRID, GML_SRS_NAME from DATABASE_SRS' INTO srid, srs;
    versioning := versioning_db;
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

    info_tmp := DB_INFO_OBJ(0, NULL, NULL, 0, NULL);

    EXECUTE IMMEDIATE 'SELECT SRID, GML_SRS_NAME from DATABASE_SRS' INTO info_tmp.srid, info_tmp.gml_srs_name;   
    EXECUTE IMMEDIATE 'SELECT COORD_REF_SYS_NAME, COORD_REF_SYS_KIND from SDO_COORD_REF_SYS where SRID=:1' INTO info_tmp.coord_ref_sys_name, info_tmp.coord_ref_sys_kind USING  info_tmp.srid;
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

  /*****************************************************************
  * transform_or_null
  *
  * @param geom the geometry whose representation is to be transformed USING  another coordinate system 
  * @param srid the SRID of the coordinate system to be used for the transformation.
  * @RETURN MDSYS.SDO_GEOMETRY the transformed geometry representation                
  ******************************************************************/
  FUNCTION transform_or_null(geom MDSYS.SDO_GEOMETRY, srid NUMBER) RETURN MDSYS.SDO_GEOMETRY
  IS
  BEGIN
    IF geom IS NOT NULL THEN
      RETURN SDO_CS.TRANSFORM(geom, srid);
    ELSE
      RETURN NULL;
    END IF;
  END;  

  /*****************************************************************
  * is_coord_ref_sys_3d
  *
  * @param srid the SRID of the coordinate system to be checked
  * @RETURN NUMBER the boolean result encoded as number: 0 = false, 1 = true                
  ******************************************************************/
  FUNCTION is_coord_ref_sys_3d(srid NUMBER) RETURN NUMBER
  IS
    is_3d NUMBER := 0;
  BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) from SDO_CRS_COMPOUND where SRID=:1' INTO is_3d USING srid;
    IF is_3d = 0 THEN
      EXECUTE IMMEDIATE 'SELECT COUNT(*) from SDO_CRS_GEOGRAPHIC3D where SRID=:1' INTO is_3d USING srid;
    END IF;

    RETURN is_3d;
  END;

  /*****************************************************************
  * is_db_coord_ref_sys_3d
  *
  * @RETURN NUMBER the boolean result encoded as number: 0 = false, 1 = true                
  ******************************************************************/
  FUNCTION is_db_coord_ref_sys_3d RETURN NUMBER
  IS
    srid NUMBER;
  BEGIN
    EXECUTE IMMEDIATE 'SELECT srid from DATABASE_SRS' INTO srid;
    RETURN is_coord_ref_sys_3d(srid);
  END;

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
  * @param on_delete_param whether CASCADE or RESTRICT
  * @param deferrable_param whether set or not
  ******************************************************************/
  PROCEDURE update_table_constraint(
    fkey_name VARCHAR2,
    table_name VARCHAR2,
    column_name VARCHAR2,
    ref_table VARCHAR2,
    ref_column VARCHAR2,
    on_delete_param VARCHAR2,
    deferrable_param VARCHAR2
    )
  IS
  BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || fkey_name;
    EXECUTE IMMEDIATE 'ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || fkey_name || 
                         ' FOREIGN KEY (' || column_name || ') REFERENCES ' || ref_table || '(' || ref_column || ')'
                         || on_delete_param || ' ' || deferrable_param;

    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('Error on constraint ' || fkey_name || ': ' || SQLERRM);
  END;

  /******************************************************************
  * update_schema_constraints
  *
  * calls update_table_constraint for updating all the contraints
  * in the user schema
  *
  * @param on_delete_param whether CASCADE (default) or RESTRICT
  ******************************************************************/
  PROCEDURE update_schema_constraints(on_delete_param VARCHAR2 := 'CASCADE')
  IS
    delete_param VARCHAR2(30) := 'ON DELETE CASCADE';
    deferrable_param VARCHAR2(30);
  BEGIN
    IF on_delete_param <> 'CASCADE' THEN
      delete_param := '';
      deferrable_param := '';
      dbms_output.put_line('Constraints are set to ON DELETE RESTRICT');
    ELSE
      deferrable_param := 'INITIALLY DEFERRED';
      dbms_output.put_line('Constraints are set to ON DELETE CASCADE');
    END IF;

    FOR rec IN (SELECT ucc1.constraint_name AS fkey, ucc1.table_name AS t, ucc1.column_name AS c, 
                  uc2.table_name AS ref_t, ucc2.column_name AS ref_c
                FROM user_cons_columns ucc1
                JOIN user_constraints uc1 ON ucc1.owner = uc1.owner 
                  AND ucc1.constraint_name = uc1.constraint_name
                JOIN user_constraints uc2 ON uc1.r_owner = uc2.owner 
                  AND uc1.r_constraint_name = uc2.constraint_name
                JOIN user_cons_columns ucc2 ON uc2.owner = ucc2.owner 
                  AND uc2.constraint_name = ucc2.constraint_name 
                  AND ucc2.position = ucc1.position     
                WHERE uc1.constraint_type = 'R') LOOP
      update_table_constraint(rec.fkey, rec.t, rec.c, rec.ref_t, rec.ref_c, delete_param, deferrable_param);
    END LOOP;
  END;

  /*****************************************************************
  * change_db_srid
  *
  * @param db_srid the SRID of the coordinate system to be further used in the database
  * @param db_gml_srs_name the GML_SRS_NAME of the coordinate system to be further used in the database
  ******************************************************************/
  PROCEDURE change_db_srid(db_srid NUMBER, db_gml_srs_name VARCHAR2)
  IS
  BEGIN
    -- update entry in DATABASE_SRS table first
    UPDATE DATABASE_SRS SET SRID=db_srid, GML_SRS_NAME=db_gml_srs_name;
    COMMIT;

    -- change srid of each spatially enabled table
    FOR rec IN (SELECT table_name AS t, column_name AS c, geodb_util.get_dim(table_name, column_name) AS dim
                 FROM user_sdo_geom_metadata) LOOP
      change_column_srid(rec.t, rec.c, rec.dim, db_srid);
    END LOOP;
  END;

  /*****************************************************************
  * get_dim
  *
  * @param t_name name of the table
  * @param c_name name of the column
  * @RETURN NUMBER number of dimension
  ******************************************************************/
  FUNCTION get_dim(t_name VARCHAR, c_name VARCHAR) RETURN NUMBER
  IS
    is_3d NUMBER(1,0);
  BEGIN
    EXECUTE IMMEDIATE 'SELECT 3 FROM user_sdo_geom_metadata m, TABLE(m.diminfo) dim
                         WHERE table_name = :1 AND column_name = :2 AND dim.sdo_dimname = ''Z'''
                         INTO is_3d USING t_name, c_name;

    RETURN is_3d;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 2;
  END;
  
  /*****************************************************************
  * change_column_srid
  *
  * @param t_name name of the table
  * @param c_name name of the column
  * @param dim dimension of spatial index
  * @param db_srid the SRID of the coordinate system to be further used in the database
  ******************************************************************/
  PROCEDURE change_column_srid( 
    t_name VARCHAR2, 
    c_name VARCHAR2,
    dim NUMBER,
    db_srid NUMBER)
  IS
    is_versioned BOOLEAN;
    is_valid BOOLEAN;
    idx_name VARCHAR2(30);
    idx INDEX_OBJ;
    sql_err_code VARCHAR2(20);
  BEGIN
    is_versioned := versioning_table(t_name) = 'ON';

    is_valid := geodb_idx.index_status(t_name, c_name) = 'VALID';

    IF NOT is_valid THEN
      -- only update metadata as the index was switched off before transaction
      EXECUTE IMMEDIATE 'UPDATE USER_SDO_GEOM_METADATA SET srid = :1 WHERE table_name = :2 AND column_name = :3'
                           USING db_srid, t_name, c_name;
      COMMIT;
    ELSE
      -- get name of spatial index
      EXECUTE IMMEDIATE 'SELECT index_name FROM user_ind_columns 
                           WHERE table_name = upper(:1) AND column_name = upper(:2)'
                           INTO idx_name USING t_name, c_name;

      -- create INDEX_OBJ
      IF dim = 3 THEN
        idx := INDEX_OBJ.construct_spatial_3d(idx_name, t_name, c_name);
      ELSE
        idx := INDEX_OBJ.construct_spatial_2d(idx_name, t_name, c_name);
      END IF;

      -- drop spatial index
      sql_err_code := geodb_idx.drop_index(idx, is_versioned);

      -- create spatial index (incl. new spatial metadata)
      sql_err_code := geodb_idx.create_index(idx, is_versioned);
    END IF;
  END;
  
  /*****************************************************************
  * get_seq_values
  *
  * @param seq_name name of the sequence
  * @param count number of values to be queried from the sequence
  ******************************************************************/
  FUNCTION get_seq_values(seq_name VARCHAR2, seq_count NUMBER) RETURN SEQ_TABLE
  IS
    seq_tbl SEQ_TABLE;
  BEGIN
    EXECUTE IMMEDIATE 'SELECT ' || seq_name || '.nextval FROM dual CONNECT BY level <= :1' 
                         BULK COLLECT INTO seq_tbl USING seq_count;
    RETURN seq_tbl;
  END;

  /*****************************************************************
  * objectclass_id_to_table_name
  *
  * @param class_id objectclass_id identifier
  * @RETURN VARCHAR name of table that stores objects referred 
  *                 to the given objectclass_id
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
      dbms_output.put_line('Table name unknown.');
      NULL;
    END CASE;

    RETURN table_name;
  END;

END geodb_util;
/