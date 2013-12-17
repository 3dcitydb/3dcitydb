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
set term off;
set serveroutput off;

CREATE OR REPLACE TYPE STRARRAY IS TABLE OF VARCHAR2(32767);
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
  FUNCTION error_msg(err_code VARCHAR2) RETURN VARCHAR2;
  FUNCTION split(list VARCHAR2, delim VARCHAR2 := ',') RETURN STRARRAY;
  FUNCTION min(a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION transform_or_null(geom MDSYS.SDO_GEOMETRY, srid NUMBER) RETURN MDSYS.SDO_GEOMETRY;
  FUNCTION is_coord_ref_sys_3d(srid NUMBER) RETURN NUMBER;
  FUNCTION is_db_coord_ref_sys_3d RETURN NUMBER;
  PROCEDURE change_db_srid(db_srid NUMBER, db_gml_srs_name VARCHAR2);
  PROCEDURE change_column_srid(i_name VARCHAR2, t_name VARCHAR2, c_name VARCHAR2, is_3d BOOLEAN, db_srid NUMBER);
  FUNCTION to_2d(geom MDSYS.SDO_GEOMETRY, srid NUMBER) RETURN MDSYS.SDO_GEOMETRY; 
END geodb_util;
/

CREATE OR REPLACE PACKAGE BODY geodb_util
AS
  
  /*****************************************************************
  * versioning_table
  *
  * @param table_name name of the unversioned table, i.e., omit
  *                   suffixes such as _LT
  * @return VARCHAR2 'ON' for version-enabled, 'OFF' otherwise
  ******************************************************************/
  FUNCTION versioning_table(table_name VARCHAR2) RETURN VARCHAR2
  IS
    status USER_TABLES.STATUS%TYPE;
  BEGIN
    execute immediate 'SELECT STATUS FROM USER_TABLES WHERE TABLE_NAME=:1' into status using table_name || '_LT';
    RETURN 'ON';
  EXCEPTION
    WHEN others THEN
      RETURN 'OFF';
  END; 

  /*****************************************************************
  * versioning_db
  *
  * @return VARCHAR2 'ON' for version-enabled, 'PARTLY' and 'OFF'
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
    execute immediate 'SELECT SRID, GML_SRS_NAME from DATABASE_SRS' into srid, srs;
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

    execute immediate 'SELECT SRID, GML_SRS_NAME from DATABASE_SRS' into info_tmp.srid, info_tmp.gml_srs_name;   
    execute immediate 'SELECT COORD_REF_SYS_NAME, COORD_REF_SYS_KIND from SDO_COORD_REF_SYS where SRID=:1' into info_tmp.coord_ref_sys_name, info_tmp.coord_ref_sys_kind using info_tmp.srid;
    info_tmp.versioning := versioning_db;     
       
    info_ret(info_ret.count) := info_tmp;
    return info_ret;
  END;
  
  /*****************************************************************
  * error_msg
  *
  * @param err_code Oracle SQL error code, usually starting with '-',
  *                 e.g. '-06404'
  * @return VARCHAR2 corresponding Oracle SQL error message                 
  ******************************************************************/
  FUNCTION error_msg(err_code VARCHAR2) RETURN VARCHAR2
  IS
  BEGIN
    RETURN SQLERRM(err_code);
  END;
  
  /*****************************************************************
  * split
  *
  * @param list string to be splitted
  * @param delim delimiter used for splitting, defaults to ','
  * @return STRARRAY array of strings containing split tokens                 
  ******************************************************************/
  FUNCTION split(list VARCHAR2, delim VARCHAR2 := ',') RETURN STRARRAY
  IS
    results STRARRAY := STRARRAY();
    idx pls_integer;
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
  * @return NUMBER the smaller of the two input number values                
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
  * @param geom the geometry whose representation is to be transformed using another coordinate system 
  * @param srid the SRID of the coordinate system to be used for the transformation.
  * @return MDSYS.SDO_GEOMETRY the transformed geometry representation                
  ******************************************************************/
  FUNCTION transform_or_null(geom MDSYS.SDO_GEOMETRY, srid number) RETURN MDSYS.SDO_GEOMETRY
  IS
  BEGIN
    IF geom is not NULL THEN
      RETURN SDO_CS.TRANSFORM(geom, srid);
    ELSE
      RETURN NULL;
    END IF;
  END;  
  
  /*****************************************************************
  * is_coord_ref_sys_3d
  *
  * @param srid the SRID of the coordinate system to be checked
  * @return NUMBER the boolean result encoded as number: 0 = false, 1 = true                
  ******************************************************************/
  FUNCTION is_coord_ref_sys_3d(srid NUMBER) RETURN NUMBER
  IS
    is_3d number := 0;
  BEGIN
    execute immediate 'SELECT COUNT(*) from SDO_CRS_COMPOUND where SRID=:1' into is_3d using srid;
    if is_3d = 0 then
      execute immediate 'SELECT COUNT(*) from SDO_CRS_GEOGRAPHIC3D where SRID=:1' into is_3d using srid;
    end if;
    
    return is_3d;
  END;
  
  /*****************************************************************
  * is_db_coord_ref_sys_3d
  *
  * @return NUMBER the boolean result encoded as number: 0 = false, 1 = true                
  ******************************************************************/
  FUNCTION is_db_coord_ref_sys_3d RETURN NUMBER
  IS
    srid number;
  BEGIN
    execute immediate 'SELECT srid from DATABASE_SRS' into srid;
    return is_coord_ref_sys_3d(srid);
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

    -- change srid of each spatially enabled table
    change_column_srid('CITYOBJECT_SPX', 'CITYOBJECT', 'ENVELOPE', TRUE, db_srid);
    change_column_srid('SURFACE_GEOM_SPX', 'SURFACE_GEOMETRY', 'GEOMETRY', TRUE, db_srid);
    change_column_srid('BREAKLINE_RID_SPX', 'BREAKLINE_RELIEF', 'RIDGE_OR_VALLEY_LINES', TRUE, db_srid);
    change_column_srid('BREAKLINE_BREAK_SPX', 'BREAKLINE_RELIEF', 'BREAK_LINES', TRUE, db_srid);
    change_column_srid('MASSPOINT_REL_SPX', 'MASSPOINT_RELIEF', 'RELIEF_POINTS', TRUE, db_srid);
    change_column_srid('ORTHOPHOTO_IMP_SPX', 'ORTHOPHOTO_IMP', 'FOOTPRINT', FALSE, db_srid);
    change_column_srid('TIN_RELF_STOP_SPX', 'TIN_RELIEF', 'STOP_LINES', TRUE, db_srid);
    change_column_srid('TIN_RELF_BREAK_SPX', 'TIN_RELIEF', 'BREAK_LINES', TRUE, db_srid);
    change_column_srid('TIN_RELF_CRTLPTS_SPX', 'TIN_RELIEF', 'CONTROL_POINTS', TRUE, db_srid);
    change_column_srid(NULL, 'CITYOBJECT_GENERICATTRIB', 'GEOMVAL', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD0TERR_SPX', 'GENERIC_CITYOBJECT', 'LOD0_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD1TERR_SPX', 'GENERIC_CITYOBJECT', 'LOD1_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD2TERR_SPX', 'GENERIC_CITYOBJECT', 'LOD2_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD3TERR_SPX', 'GENERIC_CITYOBJECT', 'LOD3_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD4TERR_SPX', 'GENERIC_CITYOBJECT', 'LOD4_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD0REFPNT_SPX', 'GENERIC_CITYOBJECT', 'LOD0_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD1REFPNT_SPX', 'GENERIC_CITYOBJECT', 'LOD1_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD2REFPNT_SPX', 'GENERIC_CITYOBJECT', 'LOD2_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD3REFPNT_SPX', 'GENERIC_CITYOBJECT', 'LOD3_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('GENERICCITY_LOD4REFPNT_SPX', 'GENERIC_CITYOBJECT', 'LOD4_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid(NULL, 'ADDRESS', 'MULTI_POINT', TRUE, db_srid);
    change_column_srid('BUILDING_LOD1TERR_SPX', 'BUILDING', 'LOD1_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('BUILDING_LOD2TERR_SPX', 'BUILDING', 'LOD2_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('BUILDING_LOD3TERR_SPX', 'BUILDING', 'LOD3_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('BUILDING_LOD4TERR_SPX', 'BUILDING', 'LOD4_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('BUILDING_LOD2MULTI_SPX', 'BUILDING', 'LOD2_MULTI_CURVE', TRUE, db_srid);
    change_column_srid('BUILDING_LOD3MULTI_SPX', 'BUILDING', 'LOD3_MULTI_CURVE', TRUE, db_srid);
    change_column_srid('BUILDING_LOD4MULTI_SPX', 'BUILDING', 'LOD4_MULTI_CURVE', TRUE, db_srid);
    change_column_srid('BLDG_FURN_LOD4REFPT_SPX', 'BUILDING_FURNITURE', 'LOD4_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('CITY_FURN_LOD1TERR_SPX', 'CITY_FURNITURE', 'LOD1_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('CITY_FURN_LOD2TERR_SPX', 'CITY_FURNITURE', 'LOD2_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('CITY_FURN_LOD3TERR_SPX', 'CITY_FURNITURE', 'LOD3_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('CITY_FURN_LOD4TERR_SPX', 'CITY_FURNITURE', 'LOD4_TERRAIN_INTERSECTION', TRUE, db_srid);
    change_column_srid('CITY_FURN_LOD1REFPNT_SPX', 'CITY_FURNITURE', 'LOD1_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('CITY_FURN_LOD2REFPNT_SPX', 'CITY_FURNITURE', 'LOD2_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('CITY_FURN_LOD3REFPNT_SPX', 'CITY_FURNITURE', 'LOD3_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('CITY_FURN_LOD4REFPNT_SPX', 'CITY_FURNITURE', 'LOD4_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('CITYMODEL_SPX', 'CITYMODEL', 'ENVELOPE', TRUE, db_srid);
    change_column_srid('CITYOBJECTGROUP_SPX', 'CITYOBJECTGROUP', 'GEOMETRY', TRUE, db_srid);
    change_column_srid('RELIEF_COMPONENT_SPX', 'RELIEF_COMPONENT', 'EXTENT', FALSE, db_srid);
    change_column_srid('SOL_VEG_OBJ_LOD1REFPT_SPX', 'SOLITARY_VEGETAT_OBJECT', 'LOD1_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('SOL_VEG_OBJ_LOD2REFPT_SPX', 'SOLITARY_VEGETAT_OBJECT', 'LOD2_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('SOL_VEG_OBJ_LOD3REFPT_SPX', 'SOLITARY_VEGETAT_OBJECT', 'LOD3_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('SOL_VEG_OBJ_LOD4REFPT_SPX', 'SOLITARY_VEGETAT_OBJECT', 'LOD4_IMPLICIT_REF_POINT', TRUE, db_srid);
    change_column_srid('SURFACE_DATA_SPX', 'SURFACE_DATA', 'GT_REFERENCE_POINT', FALSE, db_srid);
    change_column_srid('TRANSPORTATION_COMPLEX_SPX', 'TRANSPORTATION_COMPLEX', 'LOD0_NETWORK', TRUE, db_srid);
    change_column_srid('WATERBODY_LOD0MULTI_SPX', 'WATERBODY', 'LOD0_MULTI_CURVE', TRUE, db_srid);
    change_column_srid('WATERBODY_LOD1MULTI_SPX', 'WATERBODY', 'LOD1_MULTI_CURVE', TRUE, db_srid);
    change_column_srid('PLANNING_SPATIAL_EXTENT_IDX', 'PLANNING', 'SPATIAL_EXTENT', FALSE, db_srid);
  END;

  /*****************************************************************
  * change_column_srid
  *
  * @param i_name name of the spatial index
  * @param t_name name of the table
  * @param c_name name of the column
  * @param is_3d dimension of spatial index
  * @param db_srid the SRID of the coordinate system to be further used in the database
  ******************************************************************/
  PROCEDURE change_column_srid( 
    i_name VARCHAR2,
    t_name VARCHAR2, 
    c_name VARCHAR2,
    is_3d BOOLEAN,
    db_srid NUMBER)
  IS
    is_versioned BOOLEAN;
    is_valid BOOLEAN;
    idx INDEX_OBJ;
    sql_err_code VARCHAR2(20);
  BEGIN
    is_versioned := versioning_table(t_name) = 'ON';

    IF i_name IS NOT NULL THEN
      is_valid := geodb_idx.index_status(t_name, c_name) = 'VALID';

      -- drop spatial index
      IF is_3d THEN
        idx := INDEX_OBJ.construct_spatial_3d(i_name, t_name, c_name);
      ELSE
        idx := INDEX_OBJ.construct_spatial_2d(i_name, t_name, c_name);
      END IF;

      sql_err_code := geodb_idx.drop_index(idx, is_versioned);

      IF NOT is_valid THEN
        -- only update metadata as the index was switched off before transaction
        EXECUTE IMMEDIATE 'UPDATE USER_SDO_GEOM_METADATA SET srid = :1 WHERE table_name = :2 AND column_name = :3'
                             USING db_srid, t_name, c_name;
        COMMIT;
      END IF;

      -- update geometry column
      EXECUTE IMMEDIATE 'UPDATE ' || t_name || ' t  set t.' || c_name || '.SDO_SRID = :1 WHERE t.' || c_name || ' IS NOT NULL' 
                           USING db_srid;
      COMMIT;

      IF is_valid THEN
        -- create spatial index
        sql_err_code := geodb_idx.create_index(idx, is_versioned);
      END IF;
    ELSE
      -- no spatial index defined for table, only update geometry SRID
      EXECUTE IMMEDIATE 'UPDATE ' || t_name || ' t  set t.' || c_name || '.SDO_SRID = :1 WHERE t.' || c_name || ' IS NOT NULL' 
                           USING db_srid;
      COMMIT;
    END IF;
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
  
END geodb_util;
/