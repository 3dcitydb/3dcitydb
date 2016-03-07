-- MIGRATE_DB_V2_V3.sql
--
-- Author:     Arda Muftuoglu <amueftueoglu@moss.de>
--             Felix Kunde <felix-kunde@gmx.de>
--             Gyoergy Hudra <ghudra@moss.de>
--             Richard Redweik <rredweik@virtualcitysystems.de>
--
-- Copyright:  (c) 2012-2016  Chair of Geoinformatics,
--                            Technische Universität München, Germany
--                            http://www.gis.bv.tum.de
--
--              This script is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates an PL/SQL package 'CITYDB_MIGRATE_V2_V3' that contains functions
-- and procedures to perform migration process
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2015-01-22   release version                             AM
--                                                                    FKun
--           2015-03-11   locator/spatial                             GHud
-- 1.0.1     2015-07-07   optimization                                AM
-- 1.0.2     2016-01-21   optimization with create table              AM
-- 1.0.3     2016-02-24   Fix: Fix: Replace spaces around             RRed
--                        seperation string (--/\--)

CREATE OR REPLACE PACKAGE citydb_migrate_v2_v3
AS
  FUNCTION convertPolygonToSdoForm(polygon IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION convertVarcharToSDOGeom(polygon IN VARCHAR2) RETURN SDO_GEOMETRY;
  PROCEDURE fillSurfaceGeometryTable;
  PROCEDURE fillCityObjectTable;
  PROCEDURE fillCityModelTable;
  PROCEDURE fillAddressTable;
  PROCEDURE fillBuildingTable;
  PROCEDURE fillAddressToBuildingTable;
  PROCEDURE fillAppearanceTable;
  PROCEDURE fillSurfaceDataTable(op CHAR);
  PROCEDURE fillAppearToSurfaceDataTable;
  PROCEDURE fillBreaklineReliefTable;
  PROCEDURE fillRoomTable;
  PROCEDURE fillBuildingFurnitureTable;
  PROCEDURE fillBuildingInstallationTable;
  PROCEDURE fillImplicitGeometryTable;
  PROCEDURE fillCityFurnitureTable;
  PROCEDURE fillCityObjectGenAttrTable;
  PROCEDURE fillCityObjectMemberTable;
  PROCEDURE fillCityObjectGroupTable;
  PROCEDURE fillExternalReferenceTable;
  PROCEDURE fillGeneralizationTable;
  PROCEDURE fillGenericCityObjectTable;
  PROCEDURE fillGroupToCityObject;
  PROCEDURE fillLandUseTable;
  PROCEDURE fillMassPointReliefTable;
  PROCEDURE fillOpeningTable;
  PROCEDURE fillThematicSurfaceTable;
  PROCEDURE fillOpeningToThemSurfaceTable;
  PROCEDURE fillPlantCoverTable;
  PROCEDURE fillReliefComponentTable;
  PROCEDURE fillReliefFeatToRelCompTable;
  PROCEDURE fillReliefFeatureTable;
  PROCEDURE fillSolitaryVegetatObjectTable;
  PROCEDURE fillTextureParamTable;
  PROCEDURE fillTinReliefTable;
  PROCEDURE fillTrafficAreaTable;
  PROCEDURE fillTransportationComplex;
  PROCEDURE fillWaterBodyTable;
  PROCEDURE fillWaterBoundarySurfaceTable;
  PROCEDURE fillWaterbodToWaterbndSrfTable;
  PROCEDURE updateSurfaceGeoTableCityObj;
  PROCEDURE updateSolidGeometry;
  PROCEDURE updateSequences;
END citydb_migrate_v2_v3;
/

CREATE OR REPLACE PACKAGE BODY citydb_migrate_v2_v3
AS
  type ref_cursor is ref cursor;

  FUNCTION convertPolygonToSdoForm(polygon IN VARCHAR2) RETURN VARCHAR2
  IS
    polygon_sdo VARCHAR2(4000);
    polygon_temp VARCHAR2(4000);
  BEGIN
    IF (polygon IS NULL) THEN
      RETURN NULL;
    END IF;

    FOR i IN 1 .. length(polygon) - length(REPLACE(polygon, ' ', '')) + 1 LOOP
      polygon_temp := regexp_substr(polygon, '[^ ]+', 1, i);
      -- When the number is exponential, convert it to decimal form
      IF (INSTR(polygon_temp, 'E')) > 0 THEN
        EXECUTE IMMEDIATE 'select to_char('||polygon_temp||',''9.999999999999999999999999999999999999999999999999'') from dual' INTO polygon_temp;
        polygon_temp := REPLACE(polygon_temp,'.','0.');
      END IF;
      IF MOD(i,2) = 1 THEN
          polygon_sdo := polygon_sdo || polygon_temp || ' ';
      ELSE
          polygon_sdo := polygon_sdo || polygon_temp || ',';
      END IF;
    END LOOP;
    polygon_sdo := SUBSTR(polygon_sdo, 0, length(polygon_sdo) - 1);
    RETURN polygon_sdo;
  END;

  FUNCTION convertVarcharToSDOGeom(polygon IN VARCHAR2) RETURN SDO_GEOMETRY
  IS
    polygon_converted CLOB;
    polygon_temp VARCHAR2(4000);
    counter NUMBER;
    texture_coordinates SDO_GEOMETRY := NULL;
  BEGIN
    IF (polygon IS NULL) THEN
      RETURN NULL;
    END IF;

    polygon_converted := TO_CLOB('POLYGON(');
    -- dbms_output.put_line('polygon: '||polygon);
    -- If semicolon exists, it means that more than one polygon exists
    IF (INSTR(polygon, ';')) > 0 THEN
      counter := length(polygon) - length(REPLACE(polygon, ';', '')) + 1;
      FOR i IN 1 .. counter LOOP
        polygon_temp := trim(regexp_substr(replace(polygon, ';', '; '), '[^;]+', 1, i));
        IF polygon_temp IS NOT NULL THEN
          IF (i = counter) THEN
            polygon_converted := polygon_converted || TO_CLOB('(') ||
                               TO_CLOB(convertPolygonToSdoForm(polygon_temp)) || TO_CLOB(')');
          ELSE
            polygon_converted := polygon_converted || TO_CLOB('(') ||
                               TO_CLOB(convertPolygonToSdoForm(polygon_temp)) || TO_CLOB('),');
          END IF;
        END IF;
      END LOOP;
    ELSE
      polygon_converted := polygon_converted || TO_CLOB('(');
      polygon_converted := polygon_converted ||
                           TO_CLOB(convertPolygonToSdoForm(polygon));
      polygon_converted := polygon_converted || TO_CLOB(')');
    END IF;
    polygon_converted := polygon_converted || TO_CLOB(')');
    select SDO_GEOMETRY(polygon_converted) into texture_coordinates from dual;
    RETURN texture_coordinates;

    EXCEPTION
      WHEN others THEN
        RETURN NULL;
  END;

  PROCEDURE fillSurfaceGeometryTable
  IS
  BEGIN
    dbms_output.put_line('Surface_Geometry table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE surface_geometry CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
      CREATE TABLE surface_geometry
      AS SELECT
        id,
        gmlid,
        gmlid_codespace,
        parent_id,
        root_id,
        is_solid,
        is_composite,
        is_triangulated,
        is_xlink,
        is_reverse,
        case when exists (
              select 1 from surface_geometry_v2 s2
              where
              (s2.ID = s.ID and s2.is_solid = 1)
              OR
              (s.parent_id is not null and s2.ID = s.parent_id and s2.is_xlink = 1)
        ) then null else s.geometry end as geometry,
        CAST(null AS SDO_GEOMETRY) as solid_geometry,
        case when exists (
              select 1 from surface_geometry_v2 s2
              where s.parent_id is not null and s2.ID = s.parent_id and s2.is_xlink = 1
        ) then s.geometry else null end as implicit_geometry,
        CAST(null AS NUMBER) as cityobject_id
      FROM surface_geometry_v2 s';
      EXECUTE IMMEDIATE 'ALTER TABLE surface_geometry ADD CONSTRAINT SURFACE_GEOMETRY_PK PRIMARY KEY (ID) ENABLE';
      dbms_output.put_line('Surface_Geometry table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityObjectTable
  IS
  BEGIN
    dbms_output.put_line('CityObject table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE cityobject CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE cityobject
	AS SELECT
		ID, CLASS_ID AS OBJECTCLASS_ID, GMLID, CAST(null AS VARCHAR2(1000)) as GMLID_CODESPACE,
		CAST(null AS VARCHAR2(1000)) as NAME, CAST(null AS VARCHAR2(4000)) as NAME_CODESPACE,
		CAST(null AS VARCHAR2(4000)) as DESCRIPTION, ENVELOPE, CAST(CREATION_DATE AS TIMESTAMP WITH TIME ZONE) AS CREATION_DATE,
		CAST(TERMINATION_DATE AS TIMESTAMP WITH TIME ZONE) AS TERMINATION_DATE, CAST(null AS VARCHAR2(256)) as RELATIVE_TO_TERRAIN,
		CAST(null AS VARCHAR2(256)) as RELATIVE_TO_WATER, CAST(LAST_MODIFICATION_DATE AS TIMESTAMP WITH TIME ZONE) AS LAST_MODIFICATION_DATE,
		UPDATING_PERSON, REASON_FOR_UPDATE, LINEAGE, XML_SOURCE
	   FROM cityobject_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE cityobject ADD CONSTRAINT CITYOBJECT_PK PRIMARY KEY (ID) ENABLE';
    dbms_output.put_line('CityObject table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityModelTable
  IS
  BEGIN
    dbms_output.put_line('CityModel table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE citymodel CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE citymodel
      AS SELECT
        ID, GMLID, GMLID_CODESPACE,
	 REPLACE(NAME, '' --/\-- '', ''--/\--'') AS NAME,
	 REPLACE(NAME_CODESPACE, '' --/\-- '', ''--/\--'') AS NAME_CODESPACE,
	 DESCRIPTION, ENVELOPE,
	 CAST(CREATION_DATE AS TIMESTAMP WITH TIME ZONE) AS CREATION_DATE,
	 CAST(TERMINATION_DATE AS TIMESTAMP WITH TIME ZONE) AS TERMINATION_DATE,
	 CAST(LAST_MODIFICATION_DATE AS TIMESTAMP WITH TIME ZONE) AS LAST_MODIFICATION_DATE,
	 UPDATING_PERSON, REASON_FOR_UPDATE, LINEAGE
      FROM citymodel_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE citymodel ADD CONSTRAINT CITYMODEL_PK PRIMARY KEY (ID) ENABLE';
    dbms_output.put_line('CityModel table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillAddressTable
  IS
  BEGIN
    dbms_output.put_line('Address table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE address CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE address
	AS SELECT ID, CAST(null AS VARCHAR2(256)) as GMLID,
                 CAST(null AS VARCHAR2(1000)) as GMLID_CODESPACE,
                 STREET, HOUSE_NUMBER, PO_BOX, ZIP_CODE, CITY,
                 STATE, COUNTRY, MULTI_POINT, XAL_SOURCE
       FROM address_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE address ADD CONSTRAINT ADDRESS_PK PRIMARY KEY (ID) ENABLE';
    EXECUTE IMMEDIATE 'UPDATE ADDRESS SET GMLID = (''ID_''||ID)';
    dbms_output.put_line('Address table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillBuildingTable
  IS
  BEGIN
    dbms_output.put_line('Building table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE building CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE building
	  AS
	  SELECT
	    ID, BUILDING_PARENT_ID, BUILDING_ROOT_ID, replace(trim(CLASS),'' '',''--/\--'') as CLASS,
	    CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE, replace(trim(FUNCTION),'' '',''--/\--'') as FUNCTION,
	    CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE, replace(trim(USAGE),'' '',''--/\--'') AS USAGE,
	    CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE, YEAR_OF_CONSTRUCTION, YEAR_OF_DEMOLITION, ROOF_TYPE,
	    CAST(null AS VARCHAR2(4000)) as ROOF_TYPE_CODESPACE, MEASURED_HEIGHT, CAST(null AS VARCHAR2(4000)) as MEASURED_HEIGHT_UNIT,
	    STOREYS_ABOVE_GROUND, STOREYS_BELOW_GROUND, STOREY_HEIGHTS_ABOVE_GROUND,
	    CAST(null AS VARCHAR2(4000)) as STOREY_HEIGHTS_AG_UNIT, STOREY_HEIGHTS_BELOW_GROUND,
	    CAST(null AS VARCHAR2(4000)) as STOREY_HEIGHTS_BG_UNIT, LOD1_TERRAIN_INTERSECTION,
	    LOD2_TERRAIN_INTERSECTION, LOD3_TERRAIN_INTERSECTION, LOD4_TERRAIN_INTERSECTION,
	    LOD2_MULTI_CURVE, LOD3_MULTI_CURVE, LOD4_MULTI_CURVE, CAST(null AS NUMBER) as LOD0_FOOTPRINT_ID,
	    CAST(null AS NUMBER) as LOD0_ROOFPRINT_ID,
	    case when exists (
	      select 1 from surface_geometry_v2 s2
	      where
	      (s2.ID = b.lod1_geometry_id and s2.is_solid = 1)
	    ) then null else b.lod1_geometry_id end as LOD1_MULTI_SURFACE_ID,
	    case when exists (
	      select 1 from surface_geometry_v2 s2
	      where
	      (s2.ID = b.lod2_geometry_id and s2.is_solid = 1)
	    ) then null else b.lod2_geometry_id end as LOD2_MULTI_SURFACE_ID,
	    case when exists (
	      select 1 from surface_geometry_v2 s2
	      where
	      (s2.ID = b.lod3_geometry_id and s2.is_solid = 1)
	    ) then null else b.lod3_geometry_id end as LOD3_MULTI_SURFACE_ID,
	    case when exists (
	      select 1 from surface_geometry_v2 s2
	      where
	      (s2.ID = b.lod4_geometry_id and s2.is_solid = 1)
	    ) then null else b.lod4_geometry_id end as LOD4_MULTI_SURFACE_ID,
	    case when exists (
	      select 1 from surface_geometry_v2 s2
	      where
	      (s2.ID = b.lod1_geometry_id and s2.is_solid = 1)
	    ) then b.lod1_geometry_id else null end as LOD1_SOLID_ID,
	    case when exists (
	      select 1 from surface_geometry_v2 s2
	      where
	      (s2.ID = b.lod2_geometry_id and s2.is_solid = 1)
	    ) then b.lod2_geometry_id else null end as LOD2_SOLID_ID,
	    case when exists (
	      select 1 from surface_geometry_v2 s2
	      where
	      (s2.ID = b.lod3_geometry_id and s2.is_solid = 1)
	    ) then b.lod3_geometry_id else null end as LOD3_SOLID_ID,
	    case when exists (
	      select 1 from surface_geometry_v2 s2
	      where
	      (s2.ID = b.lod4_geometry_id and s2.is_solid = 1)
	    ) then b.lod4_geometry_id else null end as LOD4_SOLID_ID
	  FROM building_v2 b';
    EXECUTE IMMEDIATE 'ALTER TABLE building ADD CONSTRAINT BUILDING_PK PRIMARY KEY (ID) ENABLE';
    -- Check if the lod1-lod4 geometry ids are solid and/or multi surface
    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from building_v2 b
			 where b.LOD1_GEOMETRY_ID = s.id)
			where exists
			(select * from building_v2 b
			 where b.LOD1_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from building_v2 b
			 where b.LOD2_GEOMETRY_ID = s.id)
			where exists
			(select * from building_v2 b
			 where b.LOD2_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from building_v2 b
			 where b.LOD3_GEOMETRY_ID = s.id)
			where exists
			(select * from building_v2 b
			 where b.LOD3_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from building_v2 b
			 where b.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from building_v2 b
			 where b.LOD4_GEOMETRY_ID = s.id)';
    -- Insert the name and the description of the building
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(b.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(b.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace,
				b.description
				from building_v2 b
			 where b.id = c.id)
			where exists
			(select * from building_v2 b
			 where b.id = c.id)';
    dbms_output.put_line('Building table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillAddressToBuildingTable
  IS
  BEGIN
    dbms_output.put_line('Address_to_Building table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE address_to_building CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE address_to_building
	AS SELECT * FROM address_to_building_v2';
    dbms_output.put_line('Address_to_Building table copy is completed.' || SYSTIMESTAMP);
    EXECUTE IMMEDIATE 'ALTER TABLE address_to_building ADD CONSTRAINT ADDRESS_TO_BUILDING_PK PRIMARY KEY (BUILDING_ID,ADDRESS_ID) ENABLE';
  END;

  PROCEDURE fillAppearanceTable
  IS
  BEGIN
    dbms_output.put_line('Appearance table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE appearance CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE appearance
	AS SELECT * FROM appearance_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE appearance ADD CONSTRAINT APPEARANCE_PK PRIMARY KEY (ID) ENABLE';
    dbms_output.put_line('Appearance table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillSurfaceDataTable(op CHAR)
  IS
    -- variables --
    CURSOR surface_data_v2 IS select * from surface_data_v2 order by id;
    CURSOR tex_image_v2 IS select sd_v2.tex_image_uri, sd_v2.tex_image, sd_v2.tex_mime_type
      FROM surface_data_v2 sd_v2, (SELECT min(id) AS sample_id FROM surface_data_v2 WHERE tex_image_uri IS NOT NULL GROUP BY tex_image_uri) sample
        WHERE sd_v2.id = sample.sample_id;
    classID NUMBER(10);
    texID NUMBER(10);
  BEGIN
    dbms_output.put_line('Surface_data table is being copied...');

    FOR surface_data IN surface_data_v2 LOOP
        -- Check Type
        IF surface_data.type IS NOT NULL THEN
           select id into classID from OBJECTCLASS_v2 where classname = surface_data.type;
        END IF;

        IF upper(op) <> 'YES' AND upper(op) <> 'Y' THEN
            -- Add the Tex into the Tex Table
            -- ORDIMAGE to BLOB conversion via ordsys.ordimage.getContent
            IF (surface_data.tex_image_uri IS NOT NULL
                OR surface_data.tex_image IS NOT NULL
                OR surface_data.tex_mime_type IS NOT NULL) THEN
                texID := TEX_IMAGE_SEQ.NEXTVAL;
                insert into tex_image
                (ID, TEX_IMAGE_URI, TEX_IMAGE_DATA, TEX_MIME_TYPE)
                values
                (texID,surface_data.TEX_IMAGE_URI,
                ordsys.ordimage.getContent(surface_data.TEX_IMAGE),surface_data.TEX_MIME_TYPE) ;
            END IF;
        END IF;

        -- Insert into with objectclass_id, tex id and without gmlid_codespace
        insert into surface_data
        (ID,GMLID,NAME,NAME_CODESPACE,DESCRIPTION,IS_FRONT,OBJECTCLASS_ID,
        X3D_SHININESS,X3D_TRANSPARENCY,X3D_AMBIENT_INTENSITY,X3D_SPECULAR_COLOR,
        X3D_DIFFUSE_COLOR,X3D_EMISSIVE_COLOR,X3D_IS_SMOOTH, TEX_IMAGE_ID,
        TEX_TEXTURE_TYPE,TEX_WRAP_MODE,TEX_BORDER_COLOR,GT_PREFER_WORLDFILE,
        GT_ORIENTATION,GT_REFERENCE_POINT)
        values
        (surface_data.ID,surface_data.GMLID,
		surface_data.NAME, surface_data.NAME_CODESPACE,
		surface_data.DESCRIPTION,surface_data.IS_FRONT,
        classID,surface_data.X3D_SHININESS,surface_data.X3D_TRANSPARENCY,
        surface_data.X3D_AMBIENT_INTENSITY,surface_data.X3D_SPECULAR_COLOR,
        surface_data.X3D_DIFFUSE_COLOR,surface_data.X3D_EMISSIVE_COLOR,
        surface_data.X3D_IS_SMOOTH,texID,surface_data.TEX_TEXTURE_TYPE,
        surface_data.TEX_WRAP_MODE,surface_data.TEX_BORDER_COLOR,
        surface_data.GT_PREFER_WORLDFILE, surface_data.GT_ORIENTATION,
        surface_data.GT_REFERENCE_POINT);
    END LOOP;

    IF upper(op) = 'YES' OR upper(op) = 'Y' THEN
        FOR sd_tex_image IN tex_image_v2 LOOP
            texID := TEX_IMAGE_SEQ.NEXTVAL;
            insert into tex_image
            (ID, TEX_IMAGE_URI, TEX_IMAGE_DATA, TEX_MIME_TYPE)
            values
            (texID,sd_tex_image.TEX_IMAGE_URI,
            ordsys.ordimage.getContent(sd_tex_image.TEX_IMAGE),sd_tex_image.TEX_MIME_TYPE) ;
        END LOOP;

        UPDATE surface_data sd_v3 SET tex_image_id = (
            SELECT t.id FROM tex_image t, surface_data_v2 sd_v2
                WHERE sd_v3.id = sd_v2.id AND sd_v2.tex_image_uri = t.tex_image_uri
        );
    END IF;
    dbms_output.put_line('Surface_data table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillAppearToSurfaceDataTable
  IS
  BEGIN
    dbms_output.put_line('Appear_to_Surface_Data table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE appear_to_surface_data CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE appear_to_surface_data
	AS SELECT * FROM appear_to_surface_data_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE appear_to_surface_data ADD CONSTRAINT APPEAR_TO_SURFACE_DATA_PK PRIMARY KEY (SURFACE_DATA_ID,APPEARANCE_ID) ENABLE';
    dbms_output.put_line('Appear_to_Surface_Data table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillBreaklineReliefTable
  IS
  BEGIN
    dbms_output.put_line('Breakline_Relief table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE breakline_relief CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE breakline_relief
	AS SELECT * FROM breakline_relief_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE breakline_relief ADD CONSTRAINT BREAKLINE_RELIEF_PK PRIMARY KEY (ID) ENABLE';
    dbms_output.put_line('Breakline_Relief table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillRoomTable
  IS
  BEGIN
    dbms_output.put_line('Room table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE room CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE room
	AS
	SELECT ID, CAST(replace(trim(r.CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
	      CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
	      CAST(replace(trim(r.FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
	      CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
	      CAST(replace(trim(r.USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
	      CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
	      r.BUILDING_ID,
	      case when exists (
		      select 1 from surface_geometry_v2 s
		      where
		      (s.ID = r.lod4_geometry_id and s.is_solid = 1)
		    ) then null else r.lod4_geometry_id end as LOD4_MULTI_SURFACE_ID,
	      case when exists (
		      select 1 from surface_geometry_v2 s
		      where
		      (s.ID = r.lod4_geometry_id and s.is_solid = 1)
		    ) then r.lod4_geometry_id else null end as LOD4_SOLID_ID
	FROM room_v2 r';
    EXECUTE IMMEDIATE 'ALTER TABLE room ADD CONSTRAINT ROOM_PK PRIMARY KEY (ID) ENABLE';

    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select r.id from room_v2 r
			 where r.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from room_v2 r
			 where r.LOD4_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(r.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(r.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, r.description from room_v2 r
			 where r.id = c.id)
			where exists
			(select * from room_v2 r
			 where r.id = c.id)';
    dbms_output.put_line('Room table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillBuildingFurnitureTable
  IS
  BEGIN
    dbms_output.put_line('Building_Furniture table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE building_furniture CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE building_furniture
	AS
	SELECT ID, CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
		CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
		CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
		CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
		CAST(replace(trim(USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
		CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
		ROOM_ID, LOD4_GEOMETRY_ID AS LOD4_BREP_ID,
		CAST(null AS SDO_GEOMETRY) as LOD4_OTHER_GEOM,
		LOD4_IMPLICIT_REP_ID, LOD4_IMPLICIT_REF_POINT,
		LOD4_IMPLICIT_TRANSFORMATION
	FROM building_furniture_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE building_furniture ADD CONSTRAINT BUILDING_FURNITURE_PK PRIMARY KEY (ID) ENABLE';

    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from building_furniture_v2 b
			 where b.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from building_furniture_v2 b
			 where b.LOD4_GEOMETRY_ID = s.id)';
    -- Insert the name and the description of the building furniture
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(b.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(b.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, b.description from building_furniture_v2 b
			 where b.id = c.id)
			where exists
			(select * from building_furniture_v2 b
			 where b.id = c.id)';
    dbms_output.put_line('Building_Furniture table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillBuildingInstallationTable
  IS
  BEGIN
    dbms_output.put_line('Building_Installation table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE building_installation CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
	CREATE TABLE building_installation
	  AS
	  SELECT ID,
	    CASE is_external
	      WHEN 1 THEN (select id from OBJECTCLASS_v2 where classname = ''BuildingInstallation'')
	      ELSE (select id from OBJECTCLASS_v2 where classname = ''IntBuildingInstallation'')
	    END AS OBJECTCLASS_ID,
	    CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
	    CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
	    CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
	    CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
	    CAST(replace(trim(USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
	    CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
	    BUILDING_ID, ROOM_ID, LOD2_GEOMETRY_ID AS LOD2_BREP_ID,
	    LOD3_GEOMETRY_ID AS LOD3_BREP_ID, LOD4_GEOMETRY_ID AS LOD4_BREP_ID,
	    CAST(null AS SDO_GEOMETRY) as LOD2_OTHER_GEOM,
	    CAST(null AS SDO_GEOMETRY) as LOD3_OTHER_GEOM,
	    CAST(null AS SDO_GEOMETRY) as LOD4_OTHER_GEOM,
	    CAST(null AS NUMBER) as LOD2_IMPLICIT_REP_ID,
	    CAST(null AS NUMBER) as LOD3_IMPLICIT_REP_ID,
	    CAST(null AS NUMBER) as LOD4_IMPLICIT_REP_ID,
	    CAST(null AS SDO_GEOMETRY) as LOD2_IMPLICIT_REF_POINT,
	    CAST(null AS SDO_GEOMETRY) as LOD3_IMPLICIT_REF_POINT,
	    CAST(null AS SDO_GEOMETRY) as LOD4_IMPLICIT_REF_POINT,
	    CAST(null AS VARCHAR2(1000)) as LOD2_IMPLICIT_TRANSFORMATION,
	    CAST(null AS VARCHAR2(1000)) as LOD3_IMPLICIT_TRANSFORMATION,
	    CAST(null AS VARCHAR2(1000)) as LOD4_IMPLICIT_TRANSFORMATION
	  FROM building_installation_v2';

    EXECUTE IMMEDIATE 'ALTER TABLE building_installation MODIFY OBJECTCLASS_ID NUMBER NOT NULL';
    EXECUTE IMMEDIATE 'ALTER TABLE building_installation ADD CONSTRAINT BUILDING_INSTALLATION_PK PRIMARY KEY (ID) ENABLE';

    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from building_installation_v2 b
			 where b.LOD2_GEOMETRY_ID = s.id)
			where exists
			(select * from building_installation_v2 b
			 where b.LOD2_GEOMETRY_ID = s.id)';

    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from building_installation_v2 b
			 where b.LOD3_GEOMETRY_ID = s.id)
			where exists
			(select * from building_installation_v2 b
			 where b.LOD3_GEOMETRY_ID = s.id)';

    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from building_installation_v2 b
			 where b.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from building_installation_v2 b
			 where b.LOD4_GEOMETRY_ID = s.id)';

    -- Insert the name and the description of the building installation
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(b.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(b.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, b.description from building_installation_v2 b
			 where b.id = c.id)
			where exists
			(select * from building_installation_v2 b
			 where b.id = c.id)';
    dbms_output.put_line('Building_Installation table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillImplicitGeometryTable
  IS
  BEGIN
    dbms_output.put_line('Implicit_Geometry table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE implicit_geometry CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE '
    CREATE TABLE implicit_geometry
	AS
	SELECT ID, MIME_TYPE, REFERENCE_TO_LIBRARY,
		LIBRARY_OBJECT, RELATIVE_GEOMETRY_ID AS RELATIVE_BREP_ID,
		CAST(null AS SDO_GEOMETRY) as RELATIVE_OTHER_GEOM
	FROM implicit_geometry_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE implicit_geometry ADD CONSTRAINT IMPLICIT_GEOMETRY_PK PRIMARY KEY (ID) ENABLE';
    dbms_output.put_line('Implicit_Geometry table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityFurnitureTable
  IS
  BEGIN
    dbms_output.put_line('City_Furniture table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE city_furniture CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE city_furniture
			  AS
			  SELECT ID, 	CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
					CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
					CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
					CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
					CAST(null AS VARCHAR2(1000)) AS USAGE,
					CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
					LOD1_TERRAIN_INTERSECTION, LOD2_TERRAIN_INTERSECTION,
					LOD3_TERRAIN_INTERSECTION, LOD4_TERRAIN_INTERSECTION,
					LOD1_GEOMETRY_ID AS LOD1_BREP_ID, LOD2_GEOMETRY_ID AS LOD2_BREP_ID,
					LOD3_GEOMETRY_ID AS LOD3_BREP_ID, LOD4_GEOMETRY_ID AS LOD4_BREP_ID,
					CAST(null AS SDO_GEOMETRY) as LOD1_OTHER_GEOM,
					CAST(null AS SDO_GEOMETRY) as LOD2_OTHER_GEOM,
					CAST(null AS SDO_GEOMETRY) as LOD3_OTHER_GEOM,
					CAST(null AS SDO_GEOMETRY) as LOD4_OTHER_GEOM,
					LOD1_IMPLICIT_REP_ID, LOD2_IMPLICIT_REP_ID, LOD3_IMPLICIT_REP_ID,
					LOD4_IMPLICIT_REP_ID, LOD1_IMPLICIT_REF_POINT, LOD2_IMPLICIT_REF_POINT,
					LOD3_IMPLICIT_REF_POINT, LOD4_IMPLICIT_REF_POINT,
					LOD1_IMPLICIT_TRANSFORMATION, LOD2_IMPLICIT_TRANSFORMATION,
					LOD3_IMPLICIT_TRANSFORMATION, LOD4_IMPLICIT_TRANSFORMATION
			  FROM city_furniture_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE city_furniture ADD CONSTRAINT CITY_FURNITURE_PK PRIMARY KEY (ID) ENABLE';

    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from city_furniture_v2 c
			 where c.LOD1_GEOMETRY_ID = s.id)
			where exists
			(select * from city_furniture_v2 c
			 where c.LOD1_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from city_furniture_v2 c
			 where c.LOD2_GEOMETRY_ID = s.id)
			where exists
			(select * from city_furniture_v2 c
			 where c.LOD2_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from city_furniture_v2 c
			 where c.LOD3_GEOMETRY_ID = s.id)
			where exists
			(select * from city_furniture_v2 c
			 where c.LOD3_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from city_furniture_v2 c
			 where c.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from city_furniture_v2 c
			 where c.LOD4_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(cf.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(cf.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, cf.description from city_furniture_v2 cf
			 where cf.id = c.id)
			where exists
			(select * from city_furniture_v2 cf
			 where cf.id = c.id)';
    dbms_output.put_line('City_Furniture table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityObjectGenAttrTable
  IS
  BEGIN
    dbms_output.put_line('CityObject_GenericAttrib table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE cityobject_genericattrib CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE cityobject_genericattrib
			  AS
			    SELECT ID, CAST(null AS NUMBER) as PARENT_GENATTRIB_ID,
				    CAST(ID AS NUMBER) AS ROOT_GENATTRIB_ID, ATTRNAME, DATATYPE,
				    STRVAL, INTVAL, REALVAL, URIVAL,
				    CAST(DATEVAL AS TIMESTAMP WITH TIME ZONE) AS DATEVAL,
				    CAST(null AS VARCHAR2(4000)) as UNIT,
				    CAST(null AS VARCHAR2(4000)) as GENATTRIBSET_CODESPACE,
				    BLOBVAL, GEOMVAL, SURFACE_GEOMETRY_ID, CITYOBJECT_ID
			    FROM cityobject_genericattrib_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE cityobject_genericattrib ADD CONSTRAINT CITYOBJ_GENERICATTRIB_PK PRIMARY KEY (ID) ENABLE';
    dbms_output.put_line('CityObject_GenericAttrib table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityObjectMemberTable
  IS
  BEGIN
    dbms_output.put_line('CityObject_Member table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE cityobject_member CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE cityobject_member
			  AS SELECT * FROM cityobject_member_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE cityobject_member ADD CONSTRAINT CITYOBJECT_MEMBER_PK PRIMARY KEY (CITYMODEL_ID,CITYOBJECT_ID) ENABLE';
    dbms_output.put_line('CityObject_Member table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityObjectGroupTable
  IS
  BEGIN
    dbms_output.put_line('CityObjectGroup table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE cityobjectgroup CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE cityobjectgroup
			  AS
			  SELECT ID, CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
				  CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
				  CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
				  CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
				  CAST(null AS VARCHAR2(1000)) AS USAGE,
				  CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
				  SURFACE_GEOMETRY_ID AS BREP_ID,
				  GEOMETRY AS OTHER_GEOM, PARENT_CITYOBJECT_ID
			  FROM cityobjectgroup_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE cityobjectgroup ADD CONSTRAINT CITYOBJECTGROUP_PK PRIMARY KEY (ID) ENABLE';
    -- Insert the name and the description of the city furniture
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(co.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(co.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, co.description from cityobjectgroup_v2 co
			 where co.id = c.id)
			where exists
			(select * from cityobjectgroup_v2 co
			 where co.id = c.id)';
    dbms_output.put_line('CityObjectGroup table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillExternalReferenceTable
  IS
  BEGIN
    dbms_output.put_line('External_Reference table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE external_reference CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE external_reference
			  AS SELECT * FROM external_reference_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE external_reference ADD CONSTRAINT EXTERNAL_REFERENCE_PK PRIMARY KEY (ID) ENABLE';
    dbms_output.put_line('External_Reference table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillGeneralizationTable
  IS
  BEGIN
    dbms_output.put_line('Generalization table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE generalization CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE generalization
			  AS SELECT * FROM generalization_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE generalization ADD CONSTRAINT GENERALIZATION_PK PRIMARY KEY (CITYOBJECT_ID,GENERALIZES_TO_ID) ENABLE';
    dbms_output.put_line('Generalization table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillGenericCityObjectTable
  IS
  BEGIN
    dbms_output.put_line('Generic_CityObject table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE generic_cityobject CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE generic_cityobject
			  AS
			  SELECT ID, CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
				   CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
				   CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
				   CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
				   CAST(null AS VARCHAR2(1000)) AS USAGE,
				   CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
				   LOD0_TERRAIN_INTERSECTION, LOD1_TERRAIN_INTERSECTION,
				   LOD2_TERRAIN_INTERSECTION, LOD3_TERRAIN_INTERSECTION,
				   LOD4_TERRAIN_INTERSECTION, LOD0_GEOMETRY_ID AS LOD0_BREP_ID,
				   LOD1_GEOMETRY_ID AS LOD1_BREP_ID, LOD2_GEOMETRY_ID AS LOD2_BREP_ID,
				   LOD3_GEOMETRY_ID AS LOD3_BREP_ID, LOD4_GEOMETRY_ID AS LOD4_BREP_ID,
				   CAST(null AS SDO_GEOMETRY) as LOD0_OTHER_GEOM,
				   CAST(null AS SDO_GEOMETRY) as LOD1_OTHER_GEOM,
				   CAST(null AS SDO_GEOMETRY) as LOD2_OTHER_GEOM,
				   CAST(null AS SDO_GEOMETRY) as LOD3_OTHER_GEOM,
				   CAST(null AS SDO_GEOMETRY) as LOD4_OTHER_GEOM,
				   LOD0_IMPLICIT_REP_ID, LOD1_IMPLICIT_REP_ID, LOD2_IMPLICIT_REP_ID,
				   LOD3_IMPLICIT_REP_ID, LOD4_IMPLICIT_REP_ID, LOD0_IMPLICIT_REF_POINT,
				   LOD1_IMPLICIT_REF_POINT, LOD2_IMPLICIT_REF_POINT,
				   LOD3_IMPLICIT_REF_POINT, LOD4_IMPLICIT_REF_POINT,
				   LOD0_IMPLICIT_TRANSFORMATION, LOD1_IMPLICIT_TRANSFORMATION,
				   LOD2_IMPLICIT_TRANSFORMATION, LOD3_IMPLICIT_TRANSFORMATION,
				   LOD4_IMPLICIT_TRANSFORMATION
				 FROM generic_cityobject_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE generic_cityobject ADD CONSTRAINT GENERIC_CITYOBJECT_PK PRIMARY KEY (ID) ENABLE';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from generic_cityobject_v2 g
			 where g.LOD0_GEOMETRY_ID = s.id)
			where exists
			(select * from generic_cityobject_v2 g
			 where g.LOD0_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from generic_cityobject_v2 g
			 where g.LOD1_GEOMETRY_ID = s.id)
			where exists
			(select * from generic_cityobject_v2 g
			 where g.LOD1_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from generic_cityobject_v2 g
			 where g.LOD2_GEOMETRY_ID = s.id)
			where exists
			(select * from generic_cityobject_v2 g
			 where g.LOD2_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from generic_cityobject_v2 g
			 where g.LOD3_GEOMETRY_ID = s.id)
			where exists
			(select * from generic_cityobject_v2 g
			 where g.LOD3_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from generic_cityobject_v2 g
			 where g.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from generic_cityobject_v2 g
			 where g.LOD4_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(g.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(g.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, g.description from generic_cityobject_v2 g
			 where g.id = c.id)
			where exists
			(select * from generic_cityobject_v2 g
			 where g.id = c.id)';
    dbms_output.put_line('Generic_CityObject table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillGroupToCityObject
  IS
  BEGIN
    dbms_output.put_line('Group_To_CityObject table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE group_to_cityobject CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE group_to_cityobject
			  AS SELECT * FROM group_to_cityobject_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE group_to_cityobject ADD CONSTRAINT GROUP_TO_CITYOBJECT_PK PRIMARY KEY (CITYOBJECT_ID,CITYOBJECTGROUP_ID) ENABLE';
    dbms_output.put_line('Group_To_CityObject table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillLandUseTable
  IS
  BEGIN
    dbms_output.put_line('Land_Use table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE land_use CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE land_use
			  AS
			  SELECT ID, CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
			   CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			   CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			   CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			   CAST(null AS VARCHAR2(1000)) AS USAGE,
			   CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			   LOD0_MULTI_SURFACE_ID, LOD1_MULTI_SURFACE_ID,
			   LOD2_MULTI_SURFACE_ID, LOD3_MULTI_SURFACE_ID, LOD4_MULTI_SURFACE_ID
			 FROM land_use_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE land_use ADD CONSTRAINT LAND_USE_PK PRIMARY KEY (ID) ENABLE';
    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from land_use_v2 l
			 where l.LOD0_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from land_use_v2 l
			 where l.LOD0_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from land_use_v2 l
			 where l.LOD1_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from land_use_v2 l
			 where l.LOD1_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from land_use_v2 l
			 where l.LOD2_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from land_use_v2 l
			 where l.LOD2_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from land_use_v2 l
			 where l.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from land_use_v2 l
			 where l.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from land_use_v2 l
			 where l.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from land_use_v2 l
			 where l.LOD4_MULTI_SURFACE_ID = s.id)';
    -- Insert the name and the description of the land use
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(l.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(l.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, l.description from land_use_v2 l
			 where l.id = c.id)
			where exists
			(select * from land_use_v2 l
			 where l.id = c.id)';
    dbms_output.put_line('Land_Use table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillMassPointReliefTable
  IS
  BEGIN
    dbms_output.put_line('MassPoint_Relief table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE masspoint_relief CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE masspoint_relief
			  AS SELECT * FROM masspoint_relief_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE masspoint_relief ADD CONSTRAINT MASSPOINT_RELIEF_PK PRIMARY KEY (ID) ENABLE';
    dbms_output.put_line('MassPoint_Relief table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillOpeningTable
  IS
  BEGIN
    dbms_output.put_line('Opening table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE opening CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE opening
			  AS
			      SELECT o.ID,
			      (select oc.id from OBJECTCLASS_v2 oc where oc.classname = o.type) AS OBJECTCLASS_ID,
			      o.ADDRESS_ID, o.LOD3_MULTI_SURFACE_ID, o.LOD4_MULTI_SURFACE_ID,
			      CAST(null AS NUMBER) as LOD3_IMPLICIT_REP_ID,
			      CAST(null AS NUMBER) as LOD4_IMPLICIT_REP_ID,
			      CAST(null AS SDO_GEOMETRY) as LOD3_IMPLICIT_REF_POINT,
			      CAST(null AS SDO_GEOMETRY) as LOD4_IMPLICIT_REF_POINT,
			      CAST(null AS VARCHAR2(1000)) as LOD3_IMPLICIT_TRANSFORMATION,
			      CAST(null AS VARCHAR2(1000)) as LOD4_IMPLICIT_TRANSFORMATION
			      FROM opening_v2 o';
    EXECUTE IMMEDIATE 'ALTER TABLE opening ADD CONSTRAINT OPENING_PK PRIMARY KEY (ID) ENABLE';
    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select o.id from opening_v2 o
			 where o.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from opening_v2 o
			 where o.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select o.id from opening_v2 o
			 where o.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from opening_v2 o
			 where o.LOD4_MULTI_SURFACE_ID = s.id)';
    -- Insert the name and the description of the opening
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(o.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(o.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, o.description from opening_v2 o
			 where o.id = c.id)
			where exists
			(select * from opening_v2 o
			 where o.id = c.id)';
    dbms_output.put_line('Opening table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillThematicSurfaceTable
  IS
  BEGIN
    dbms_output.put_line('Thematic_Surface table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE thematic_surface CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE thematic_surface
			  AS
			  SELECT t.ID,
			      (select oc.id from OBJECTCLASS_v2 oc where oc.classname = t.type) AS OBJECTCLASS_ID,
			      BUILDING_ID, ROOM_ID,
			      CAST(null AS NUMBER) as BUILDING_INSTALLATION_ID,
			      LOD2_MULTI_SURFACE_ID, LOD3_MULTI_SURFACE_ID, LOD4_MULTI_SURFACE_ID
			  FROM thematic_surface_v2 t';
    EXECUTE IMMEDIATE 'ALTER TABLE thematic_surface ADD CONSTRAINT THEMATIC_SURFACE_PK PRIMARY KEY (ID) ENABLE';
    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from thematic_surface_v2 t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from thematic_surface_v2 t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from thematic_surface_v2 t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from thematic_surface_v2 t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from thematic_surface_v2 t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from thematic_surface_v2 t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)';
    -- Insert the name and the description of the thematic surface
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(t.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(t.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, t.description from thematic_surface_v2 t
			 where t.id = c.id)
			where exists
			(select * from thematic_surface_v2 t
			 where t.id = c.id)';
    dbms_output.put_line('Thematic_Surface table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillOpeningToThemSurfaceTable
  IS
  BEGIN
    dbms_output.put_line('Opening_To_Them_Surface table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE opening_to_them_surface CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE opening_to_them_surface
			  AS SELECT * FROM opening_to_them_surface_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE opening_to_them_surface ADD CONSTRAINT OPENING_TO_THEM_SURFACE_PK PRIMARY KEY (OPENING_ID,THEMATIC_SURFACE_ID) ENABLE';
    dbms_output.put_line('Opening_To_Them_Surface table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillPlantCoverTable
  IS
  BEGIN
    dbms_output.put_line('Plant_Cover table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE plant_cover CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE plant_cover
			  AS
			  SELECT ID, CAST(null AS VARCHAR2(1000)) AS USAGE,
			  CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			  CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
			  CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			  CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			  CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			  AVERAGE_HEIGHT, CAST(null AS VARCHAR2(4000)) as AVERAGE_HEIGHT_UNIT,
			  case when exists (
			   select 1 from surface_geometry_v2 s
			   where
			   (s.ID = p.lod1_geometry_id and s.is_solid = 1)
			  ) then null else p.lod1_geometry_id end as LOD1_MULTI_SURFACE_ID,
			  case when exists (
			   select 1 from surface_geometry_v2 s
			   where
			   (s.ID = p.lod2_geometry_id and s.is_solid = 1)
			  ) then null else p.lod2_geometry_id end as LOD2_MULTI_SURFACE_ID,
			  case when exists (
			   select 1 from surface_geometry_v2 s
			   where
			   (s.ID = p.lod3_geometry_id and s.is_solid = 1)
			  ) then null else p.lod3_geometry_id end as LOD3_MULTI_SURFACE_ID,
			  case when exists (
			   select 1 from surface_geometry_v2 s
			   where
			   (s.ID = p.lod4_geometry_id and s.is_solid = 1)
			  ) then null else p.lod4_geometry_id end as LOD4_MULTI_SURFACE_ID,
			  case when exists (
			   select 1 from surface_geometry_v2 s
			   where
			   (s.ID = p.lod1_geometry_id and s.is_solid = 1)
			  ) then p.lod1_geometry_id else null end as LOD1_MULTI_SOLID_ID,
			  case when exists (
			   select 1 from surface_geometry_v2 s
			   where
			   (s.ID = p.lod2_geometry_id and s.is_solid = 1)
			  ) then p.lod2_geometry_id else null end as LOD2_MULTI_SOLID_ID,
			  case when exists (
			   select 1 from surface_geometry_v2 s
			   where
			   (s.ID = p.lod3_geometry_id and s.is_solid = 1)
			  ) then p.lod3_geometry_id else null end as LOD3_MULTI_SOLID_ID,
			  case when exists (
			   select 1 from surface_geometry_v2 s
			   where
			   (s.ID = p.lod4_geometry_id and s.is_solid = 1)
			  ) then p.lod4_geometry_id else null end as LOD4_MULTI_SOLID_ID
			  FROM plant_cover_v2 p';
    EXECUTE IMMEDIATE 'ALTER TABLE plant_cover ADD CONSTRAINT PLANT_COVER_PK PRIMARY KEY (ID) ENABLE';
    -- Check if the lod1-lod4 geometry ids are solid and/or multi surface
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select p.id from plant_cover_v2 p
			 where p.lod1_geometry_id = s.id)
			where exists
			(select * from plant_cover_v2 p
			 where p.lod1_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select p.id from plant_cover_v2 p
			 where p.lod2_geometry_id = s.id)
			where exists
			(select * from plant_cover_v2 p
			 where p.lod2_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select p.id from plant_cover_v2 p
			 where p.lod3_geometry_id = s.id)
			where exists
			(select * from plant_cover_v2 p
			 where p.lod3_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select p.id from plant_cover_v2 p
			 where p.lod4_geometry_id = s.id)
			where exists
			(select * from plant_cover_v2 p
			 where p.lod4_geometry_id = s.id)';
    -- Insert the name and the description of the plant cover
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(p.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(p.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, p.description from plant_cover_v2 p
			 where p.id = c.id)
			where exists
			(select * from plant_cover_v2 p
			 where p.id = c.id)';
    dbms_output.put_line('Plant_Cover table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillReliefComponentTable
  IS
  BEGIN
    dbms_output.put_line('Relief_Component table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE relief_component CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE relief_component
			  AS
			  SELECT ID,
			    (select c.OBJECTCLASS_ID from CITYOBJECT c where c.id = r.id) AS OBJECTCLASS_ID,
			    LOD, EXTENT
			  FROM relief_component_v2 r';
    EXECUTE IMMEDIATE 'ALTER TABLE relief_component ADD CONSTRAINT RELIEF_COMPONENT_PK PRIMARY KEY (ID) ENABLE';
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(r.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(r.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, r.description from relief_component_v2 r
			 where r.id = c.id)
			where exists
			(select * from relief_component_v2 r
			 where r.id = c.id)';
    dbms_output.put_line('Relief_Component table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillReliefFeatToRelCompTable
  IS
  BEGIN
    dbms_output.put_line('Relief_Feat_To_Rel_Comp table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE relief_feat_to_rel_comp CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE relief_feat_to_rel_comp
			  AS SELECT * FROM relief_feat_to_rel_comp_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE relief_feat_to_rel_comp ADD CONSTRAINT RELIEF_FEAT_TO_REL_COMP_PK PRIMARY KEY (RELIEF_COMPONENT_ID,RELIEF_FEATURE_ID) ENABLE';
    dbms_output.put_line('Relief_Feat_To_Rel_Comp table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillReliefFeatureTable
  IS
  BEGIN
    dbms_output.put_line('Relief_Feature table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE relief_feature CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE relief_feature
			  AS SELECT ID, LOD FROM relief_feature_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE relief_feature ADD CONSTRAINT RELIEF_FEATURE_PK PRIMARY KEY (ID) ENABLE';
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(r.name, '' --/\-- '', ''--/\--'') AS,
				REPLACE(r.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, r.description from relief_feature_v2 r
			 where r.id = c.id)
			where exists
			(select * from relief_feature_v2 r
			 where r.id = c.id)';
    dbms_output.put_line('Relief_Feature table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillSolitaryVegetatObjectTable
  IS
  BEGIN
    dbms_output.put_line('Solitary_Vegetat_Object table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE solitary_vegetat_object CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE solitary_vegetat_object
				AS
				SELECT ID, CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
				CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
				CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
				CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
				CAST(null AS VARCHAR2(1000)) AS USAGE,
				CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
				CAST(replace(SPECIES,'' '',''--/\--'') AS VARCHAR2(1000)) AS SPECIES,
				CAST(null AS VARCHAR2(4000)) as SPECIES_CODESPACE,
				HEIGHT, CAST(null AS VARCHAR2(4000)) as HEIGHT_UNIT,
				TRUNC_DIAMETER AS TRUNK_DIAMETER,
				CAST(null AS VARCHAR2(4000)) as TRUNK_DIAMETER_UNIT,
				CROWN_DIAMETER, CAST(null AS VARCHAR2(4000)) as CROWN_DIAMETER_UNIT,
				LOD1_GEOMETRY_ID AS LOD1_BREP_ID, LOD2_GEOMETRY_ID AS LOD2_BREP_ID,
				LOD3_GEOMETRY_ID AS LOD3_BREP_ID, LOD4_GEOMETRY_ID AS LOD4_BREP_ID,
				CAST(null AS SDO_GEOMETRY) as LOD1_OTHER_GEOM,
				CAST(null AS SDO_GEOMETRY) as LOD2_OTHER_GEOM,
				CAST(null AS SDO_GEOMETRY) as LOD3_OTHER_GEOM,
				CAST(null AS SDO_GEOMETRY) as LOD4_OTHER_GEOM,
				LOD1_IMPLICIT_REP_ID, LOD2_IMPLICIT_REP_ID, LOD3_IMPLICIT_REP_ID,
				LOD4_IMPLICIT_REP_ID, LOD1_IMPLICIT_REF_POINT, LOD2_IMPLICIT_REF_POINT,
				LOD3_IMPLICIT_REF_POINT, LOD4_IMPLICIT_REF_POINT,
				LOD1_IMPLICIT_TRANSFORMATION, LOD2_IMPLICIT_TRANSFORMATION,
				LOD3_IMPLICIT_TRANSFORMATION, LOD4_IMPLICIT_TRANSFORMATION
				FROM solitary_vegetat_object_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE solitary_vegetat_object ADD CONSTRAINT SOLITARY_VEG_OBJECT_PK PRIMARY KEY (ID) ENABLE';
    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.id from solitary_vegetat_object_v2 sv
			 where sv.lod1_geometry_id = s.id)
			where exists
			(select * from solitary_vegetat_object_v2 sv
			 where sv.lod1_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.id from solitary_vegetat_object_v2 sv
			 where sv.lod2_geometry_id = s.id)
			where exists
			(select * from solitary_vegetat_object_v2 sv
			 where sv.lod2_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.id from solitary_vegetat_object_v2 sv
			 where sv.lod3_geometry_id = s.id)
			where exists
			(select * from solitary_vegetat_object_v2 sv
			 where sv.lod3_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.id from solitary_vegetat_object_v2 sv
			 where sv.lod4_geometry_id = s.id)
			where exists
			(select * from solitary_vegetat_object_v2 sv
			 where sv.lod4_geometry_id = s.id)';
    -- Insert the name and the description of the solitary vegetation object
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(sv.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(sv.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, sv.description from solitary_vegetat_object_v2 sv
			 where sv.id = c.id)
			where exists
			(select * from solitary_vegetat_object_v2 sv
			 where sv.id = c.id)';
    dbms_output.put_line('Solitary_Vegetat_Object table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTextureParamTable
  IS
  BEGIN
    dbms_output.put_line('TextureParam table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE textureparam CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE textureparam
			  AS
			  SELECT SURFACE_GEOMETRY_ID, SURFACE_DATA_ID,
			  IS_TEXTURE_PARAMETRIZATION, WORLD_TO_TEXTURE,
			  citydb_migrate_v2_v3.convertVarcharToSDOGeom(TEXTURE_COORDINATES) AS TEXTURE_COORDINATES
			  FROM textureparam_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE textureparam ADD CONSTRAINT TEXTUREPARAM_PK PRIMARY KEY (SURFACE_GEOMETRY_ID,SURFACE_DATA_ID) ENABLE';
    dbms_output.put_line('TextureParam table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTinReliefTable
  IS
    CURSOR tin_relief_v2 IS select * from tin_relief_v2 order by id;
  BEGIN
    dbms_output.put_line('Tin Relief table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE tin_relief CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE tin_relief
			  AS
				SELECT ID, MAX_LENGTH,
				CAST(null AS VARCHAR2(4000)) as MAX_LENGTH_UNIT,
				STOP_LINES, BREAK_LINES, CONTROL_POINTS, SURFACE_GEOMETRY_ID
			  FROM tin_relief_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE tin_relief ADD CONSTRAINT TIN_RELIEF_PK PRIMARY KEY (ID) ENABLE';
    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from tin_relief t
			 where t.SURFACE_GEOMETRY_ID = s.id)
			where exists
			(select * from tin_relief t
			 where t.SURFACE_GEOMETRY_ID = s.id)';
    dbms_output.put_line('Tin Relief table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTrafficAreaTable
  IS
    -- variables --
    CURSOR traffic_area_v2 IS select * from traffic_area_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('Traffic_Area table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE traffic_area CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE traffic_area
			  AS
			  SELECT ID,
			   CASE is_auxiliary
			   WHEN 1 THEN (select id from OBJECTCLASS_v2 where classname = ''AuxiliaryTrafficArea'')
			   ELSE (select id from OBJECTCLASS_v2 where classname = ''TrafficArea'')
			   END AS OBJECTCLASS_ID,
			   CAST(null AS VARCHAR2(256)) AS CLASS,
			   CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			   CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			   CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			   CAST(replace(trim(USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
			   CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			   SURFACE_MATERIAL,
			   CAST(null AS VARCHAR2(4000)) as SURFACE_MATERIAL_CODESPACE,
			   LOD2_MULTI_SURFACE_ID, LOD3_MULTI_SURFACE_ID,
			   LOD4_MULTI_SURFACE_ID, TRANSPORTATION_COMPLEX_ID
			  FROM traffic_area_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE traffic_area ADD CONSTRAINT TRAFFIC_AREA_PK PRIMARY KEY (ID) ENABLE';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from traffic_area_v2 t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from traffic_area_v2 t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from traffic_area_v2 t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from traffic_area_v2 t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from traffic_area_v2 t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from traffic_area_v2 t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(t.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(t.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, t.description from traffic_area_v2 t
			 where t.id = c.id)
			where exists
			(select * from traffic_area_v2 t
			 where t.id = c.id)';
    dbms_output.put_line('Traffic_Area table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTransportationComplex
  IS
  BEGIN
    dbms_output.put_line('Transportation_Complex table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE transportation_complex CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE transportation_complex
			  AS
			  SELECT ID,
			   (select o.id from OBJECTCLASS_v2 o where o.classname = t.type) AS OBJECTCLASS_ID,
			   CAST(null AS VARCHAR2(256)) AS CLASS,
			   CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			   CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			   CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			   CAST(replace(trim(USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
			   CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			   LOD0_NETWORK, LOD1_MULTI_SURFACE_ID, LOD2_MULTI_SURFACE_ID,
			   LOD3_MULTI_SURFACE_ID, LOD4_MULTI_SURFACE_ID
			  FROM transportation_complex_v2 t';
    EXECUTE IMMEDIATE 'ALTER TABLE transportation_complex ADD CONSTRAINT TRANSPORTATION_COMPLEX_PK PRIMARY KEY (ID) ENABLE';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from transportation_complex_v2 t
			 where t.LOD1_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from transportation_complex_v2 t
			 where t.LOD1_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from transportation_complex_v2 t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from transportation_complex_v2 t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from transportation_complex_v2 t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from transportation_complex_v2 t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from transportation_complex_v2 t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from transportation_complex_v2 t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(t.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(t.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, t.description from transportation_complex_v2 t
			 where t.id = c.id)
			where exists
			(select * from transportation_complex_v2 t
			 where t.id = c.id)';
    dbms_output.put_line('Transportation_Complex table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillWaterBodyTable
  IS
  BEGIN
    dbms_output.put_line('WaterBody table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE waterbody CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE waterbody
			  AS
			  SELECT ID,
			   CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
			   CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			   CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			   CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			   CAST(replace(trim(USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
			   CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			   LOD0_MULTI_CURVE, LOD1_MULTI_CURVE, LOD0_MULTI_SURFACE_ID,
			   LOD1_MULTI_SURFACE_ID, LOD1_SOLID_ID, LOD2_SOLID_ID,
			   LOD3_SOLID_ID, LOD4_SOLID_ID
			  FROM waterbody_v2 t';
    EXECUTE IMMEDIATE 'ALTER TABLE waterbody ADD CONSTRAINT WATERBODY_PK PRIMARY KEY (ID) ENABLE';
    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterbody_v2 w
			 where w.LOD0_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from waterbody_v2 w
			 where w.LOD0_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterbody_v2 w
			 where w.LOD1_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from waterbody_v2 w
			 where w.LOD1_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterbody_v2 w
			 where w.LOD1_SOLID_ID = s.id)
			where exists
			(select * from waterbody_v2 w
			 where w.LOD1_SOLID_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterbody_v2 w
			 where w.LOD2_SOLID_ID = s.id)
			where exists
			(select * from waterbody_v2 w
			 where w.LOD2_SOLID_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterbody_v2 w
			 where w.LOD3_SOLID_ID = s.id)
			where exists
			(select * from waterbody_v2 w
			 where w.LOD3_SOLID_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterbody_v2 w
			 where w.LOD4_SOLID_ID = s.id)
			where exists
			(select * from waterbody_v2 w
			 where w.LOD4_SOLID_ID = s.id)';
    -- Insert the name and the description of the waterbody
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(w.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(w.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, w.description from waterbody_v2 w
			 where w.id = c.id)
			where exists
			(select * from waterbody_v2 w
			 where w.id = c.id)';
    dbms_output.put_line('WaterBody table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillWaterBoundarySurfaceTable
  IS
    -- variables --
    CURSOR waterboundary_surface_v2 IS select * from waterboundary_surface_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('WaterBoundary_Surface table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE waterboundary_surface CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE waterboundary_surface
			  AS
			  SELECT ID,
			   (select o.id from OBJECTCLASS_v2 o where o.classname = w.type) AS OBJECTCLASS_ID,
			   WATER_LEVEL, CAST(null AS VARCHAR2(4000)) as WATER_LEVEL_CODESPACE,
			   LOD2_SURFACE_ID, LOD3_SURFACE_ID, LOD4_SURFACE_ID
			  FROM waterboundary_surface_v2 w';
    EXECUTE IMMEDIATE 'ALTER TABLE waterboundary_surface ADD CONSTRAINT WATERBOUNDARY_SURFACE_PK PRIMARY KEY (ID) ENABLE';
    -- Update the cityobject_id entry in surface_geometry table
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterboundary_surface_v2 w
			 where w.LOD2_SURFACE_ID = s.id)
			where exists
			(select * from waterboundary_surface_v2 w
			 where w.LOD2_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterboundary_surface_v2 w
			 where w.LOD3_SURFACE_ID = s.id)
			where exists
			(select * from waterboundary_surface_v2 w
			 where w.LOD3_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from waterboundary_surface_v2 w
			 where w.LOD4_SURFACE_ID = s.id)
			where exists
			(select * from waterboundary_surface_v2 w
			 where w.LOD4_SURFACE_ID = s.id)';
    -- Insert the name and the description of the water boundary surface
    -- into the cityobject table
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(w.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(w.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, w.description from waterboundary_surface_v2 w
			 where w.id = c.id)
			where exists
			(select * from waterboundary_surface_v2 w
			 where w.id = c.id)';
    dbms_output.put_line('WaterBoundary_Surface table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillWaterbodToWaterbndSrfTable
  IS
  BEGIN
    dbms_output.put_line('Waterbod_To_Waterbnd_Srf table is being copied...');
    EXECUTE IMMEDIATE 'DROP TABLE waterbod_to_waterbnd_srf CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'CREATE TABLE waterbod_to_waterbnd_srf
			  AS SELECT * FROM waterbod_to_waterbnd_srf_v2';
    EXECUTE IMMEDIATE 'ALTER TABLE waterbod_to_waterbnd_srf ADD CONSTRAINT WATERBOD_TO_WATERBND_PK PRIMARY KEY (WATERBOUNDARY_SURFACE_ID,WATERBODY_ID) ENABLE';
    dbms_output.put_line('Waterbod_To_Waterbnd_Srf table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE updateSurfaceGeoTableCityObj
  IS
  BEGIN
    dbms_output.put_line('Surface_Geometry table is being updated...');
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.CITYOBJECT_ID from surface_geometry sv
			 where sv.id = s.parent_id)
			where exists
			(select * from surface_geometry sv
			 where sv.id = s.parent_id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.CITYOBJECT_ID from surface_geometry sv
			 where sv.id = s.root_id and sv.is_solid = 1)
			where exists
			(select * from surface_geometry sv
			 where sv.id = s.root_id and sv.is_solid = 1)';
    EXECUTE IMMEDIATE 'update surface_geometry sg
			set sg.implicit_geometry = sg.geometry,
			sg.geometry = null
			where sg.parent_id IN
			(select sg2.id from
			implicit_geometry i, surface_geometry sg2
			where i.relative_brep_id = sg2.id
			and sg2.is_xlink = 0)';
    dbms_output.put_line('Surface_Geometry table is updated.' || SYSTIMESTAMP);
  END;

  PROCEDURE updateSolidGeometry
  IS
    column_srid NUMBER;
    surface_geometry_cur ref_cursor;
    sg_rec surface_geometry%ROWTYPE;
    solid_geom SDO_GEOMETRY;
    root_element NUMBER := 0;
    elem_count NUMBER := 1;
    solid_offset NUMBER := 0;
  BEGIN
    select srid into column_srid from user_sdo_geom_metadata where table_name = 'SURFACE_GEOMETRY' and column_name = 'SOLID_GEOMETRY';

    OPEN surface_geometry_cur FOR
      'WITH get_roots AS (
        SELECT root_id FROM surface_geometry WHERE is_solid = 1
      )
      SELECT sg.* FROM surface_geometry sg, get_roots r
        WHERE sg.root_id = r.root_id AND sg.geometry IS NOT NULL ORDER BY sg.root_id';
    LOOP
      FETCH surface_geometry_cur INTO sg_rec;
      EXIT WHEN surface_geometry_cur%NOTFOUND;

      -- create a new solid when root_id changes
      IF root_element <> sg_rec.root_id THEN

        -- check if a solid has already been constructed
        IF solid_geom IS NOT NULL THEN
          -- update solid_geometry column
          -- EXCEPTION is catched in order to insert correct solids
          BEGIN
            UPDATE surface_geometry
              SET solid_geometry = solid_geom
              WHERE id = root_element;

            EXCEPTION
              WHEN OTHERS THEN
                dbms_output.put_line('Could not create solid for root_id ' || root_element || '. Error: ' || SQLERRM);
          END;

          -- reset variables that help construction the solid
          solid_offset := 0;
          solid_geom := NULL;
        END IF;

        -- construct an empty solid
        root_element := sg_rec.root_id;
        solid_geom := mdsys.sdo_geometry(
                      3008, column_srid, null,
                      mdsys.sdo_elem_info_array (), mdsys.sdo_ordinate_array ()
                      );

        solid_geom.sdo_elem_info.extend(6);
        solid_geom.sdo_elem_info(1) := 1;
        solid_geom.sdo_elem_info(2) := 1007;
        solid_geom.sdo_elem_info(3) := 1;
        solid_geom.sdo_elem_info(4) := 1;
        solid_geom.sdo_elem_info(5) := 1006;
        solid_geom.sdo_elem_info(6) := 0;
      END IF;

      IF (sg_rec.geometry.sdo_elem_info IS NOT NULL) THEN
        -- fill elem_info_array
        FOR i IN sg_rec.geometry.sdo_elem_info.FIRST .. sg_rec.geometry.sdo_elem_info.LAST LOOP
          solid_geom.sdo_elem_info.extend;

          -- set correct offset
          -- the following equation will always be 0 for the first position of one or more ELEM_INFO_ARRAYs
          IF (elem_count - (i + 2) / 3) = 0 THEN
            solid_geom.sdo_elem_info(solid_geom.sdo_elem_info.count) := solid_offset + sg_rec.geometry.sdo_elem_info(i);
            elem_count := elem_count + 1;
          ELSE
            solid_geom.sdo_elem_info(solid_geom.sdo_elem_info.count) := sg_rec.geometry.sdo_elem_info(i);
          END IF;
        END LOOP;

        -- fill ordinates_array
        IF (sg_rec.geometry.sdo_ordinates IS NOT NULL) THEN
          FOR i IN sg_rec.geometry.sdo_ordinates.FIRST .. sg_rec.geometry.sdo_ordinates.LAST LOOP
            solid_geom.sdo_ordinates.extend;
            solid_geom.sdo_ordinates(solid_geom.sdo_ordinates.count) := sg_rec.geometry.sdo_ordinates(i);
          END LOOP;
          -- update offset
          solid_offset := solid_geom.sdo_ordinates.count;
        END IF;

        -- update sdo_elem_info of solid and reset elem_count
        solid_geom.sdo_elem_info(6) := solid_geom.sdo_elem_info(6) + sg_rec.geometry.sdo_elem_info.count / 3;
        elem_count := 1;
      END IF;
    END LOOP;
    CLOSE surface_geometry_cur;

    -- loop stops when last solid is complete but before the corresponding update is commited
    -- therefore it has to be done here
    IF solid_geom IS NOT NULL THEN
      BEGIN
        UPDATE surface_geometry
          SET solid_geometry = solid_geom
          WHERE id = root_element;

          EXCEPTION
            WHEN OTHERS THEN
              dbms_output.put_line('Could not create solid for root_id ' || root_element || '. Error: ' || SQLERRM);
      END;
    END IF;
  END;

  PROCEDURE updateSequences
  IS
    -- variables --
    CURSOR user_sequences_cursor IS
      select SUBSTR(sequence_name, 0,
      INSTR(sequence_name, '_SEQ')-1) as sequencename
      from user_sequences order by sequence_name;
    sequence_val NUMBER(10) := 0;
    corrected_table_name VARCHAR2(100);
    query_str VARCHAR2(1000);
    table_exists NUMBER(1) := 0;
    column_exists NUMBER(10) := 0;
  BEGIN
    FOR user_sequences IN user_sequences_cursor LOOP
      IF (user_sequences.sequencename IS NOT NULL) THEN
        select count(table_name) into table_exists
        from user_tables where table_name = user_sequences.sequencename;

        select COUNT(*) INTO column_exists
        from all_tab_cols
        where table_name = user_sequences.sequencename and
        column_name = 'ID';

        IF (column_exists != 0) THEN
          IF (table_exists = 1) THEN
            query_str := 'select max(id) from '|| user_sequences.sequencename;
            EXECUTE IMMEDIATE query_str into sequence_val;
            -- dbms_output.put_line(user_sequences.sequencename || ':' || sequence_val);
            IF (sequence_val IS NOT NULL) THEN
              -- dbms_output.put_line('DROP SEQUENCE ' || user_sequences.sequencename || '_SEQ');
              -- dbms_output.put_line('CREATE SEQUENCE ' || user_sequences.sequencename || '_SEQ START WITH ' || (sequence_val + 1));
              EXECUTE IMMEDIATE 'DROP SEQUENCE ' || user_sequences.sequencename || '_SEQ';
              EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || user_sequences.sequencename || '_SEQ START WITH ' || (sequence_val + 1);
            END IF;
          ELSE
             query_str := 'select table_name from user_tables where table_name
              like ''%'
              || user_sequences.sequencename ||
              '%''';
              -- dbms_output.put_line(query_str);

             EXECUTE IMMEDIATE query_str into corrected_table_name;
             query_str := 'select max(id) from '|| corrected_table_name;
             EXECUTE IMMEDIATE query_str into sequence_val;
             -- dbms_output.put_line(user_sequences.sequencename || ':' || sequence_val);
             IF (sequence_val IS NOT NULL) THEN
              -- dbms_output.put_line('DROP SEQUENCE ' || user_sequences.sequencename || '_SEQ');
              -- dbms_output.put_line('CREATE SEQUENCE ' || user_sequences.sequencename || '_SEQ START WITH ' || (sequence_val + 1));
              EXECUTE IMMEDIATE 'DROP SEQUENCE ' || user_sequences.sequencename || '_SEQ';
              EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || user_sequences.sequencename || '_SEQ START WITH ' || (sequence_val + 1);
             END IF;
          END IF;
        END IF;
      END IF;
      sequence_val := 0;
      query_str := 0;
      table_exists := 0;
      corrected_table_name := '';
    END LOOP;
  END;
END citydb_migrate_v2_v3;
/
