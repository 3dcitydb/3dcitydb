-- MIGRATE_DB_V2_V3.sql
--
-- Author:     Arda Muftuoglu <amueftueoglu@moss.de>
--             Felix Kunde <fkunde@virtualcitysystems.de>
--             Gyoergy Hudra <ghudra@moss.de>
--
-- Copyright:  (c) 2012-2015  Chair of Geoinformatics,
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
--

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
    -- variables --
    CURSOR surface_geometry_v2 IS select * from surface_geometry_v2 order by id;
    has_xlink NUMBER(1,0) := 0;
    is_solid NUMBER(1,0) := 0;
  BEGIN
    dbms_output.put_line('Surface_Geometry table is being copied...');
    FOR surface_geometry IN surface_geometry_v2 LOOP
        --  if the parent has xlink = 1,
        -- then insert the geometry into the implicit geometry column
        IF (surface_geometry.PARENT_ID IS NOT NULL) THEN
          EXECUTE IMMEDIATE 'select IS_XLINK from surface_geometry_v2 where
                             ID = '||surface_geometry.PARENT_ID INTO has_xlink;
        END IF;
        EXECUTE IMMEDIATE 'select IS_SOLID from surface_geometry_v2 where
                             ID = '||surface_geometry.ID INTO is_solid;
        IF (has_xlink = 1) THEN
          insert into surface_geometry
          (ID, GMLID, PARENT_ID, ROOT_ID, IS_SOLID, IS_COMPOSITE,
          IS_TRIANGULATED, IS_XLINK, IS_REVERSE, IMPLICIT_GEOMETRY)
          values
          (surface_geometry.ID, surface_geometry.GMLID, surface_geometry.PARENT_ID,
          surface_geometry.ROOT_ID, surface_geometry.IS_SOLID, surface_geometry.IS_COMPOSITE,
          surface_geometry.IS_TRIANGULATED, surface_geometry.IS_XLINK,
          surface_geometry.IS_REVERSE, surface_geometry.GEOMETRY);
        ELSIF (is_solid = 1) THEN
          insert into surface_geometry
          (ID, GMLID, PARENT_ID, ROOT_ID, IS_SOLID, IS_COMPOSITE,
          IS_TRIANGULATED, IS_XLINK, IS_REVERSE)
          values
          (surface_geometry.ID, surface_geometry.GMLID, surface_geometry.PARENT_ID,
          surface_geometry.ROOT_ID, surface_geometry.IS_SOLID, surface_geometry.IS_COMPOSITE,
          surface_geometry.IS_TRIANGULATED, surface_geometry.IS_XLINK,
          surface_geometry.IS_REVERSE);
        ELSE
          insert into surface_geometry
          (ID, GMLID, PARENT_ID, ROOT_ID, IS_SOLID, IS_COMPOSITE,
          IS_TRIANGULATED, IS_XLINK, IS_REVERSE, GEOMETRY)
          values
          (surface_geometry.ID, surface_geometry.GMLID, surface_geometry.PARENT_ID,
          surface_geometry.ROOT_ID, surface_geometry.IS_SOLID, surface_geometry.IS_COMPOSITE,
          surface_geometry.IS_TRIANGULATED, surface_geometry.IS_XLINK,
          surface_geometry.IS_REVERSE, surface_geometry.GEOMETRY);
        END IF;
        has_xlink := 0;
        is_solid := 0;
      END LOOP;
      dbms_output.put_line('Surface_Geometry table copy is completed.');
  END;

  PROCEDURE fillCityObjectTable
  IS
    -- variables --
    CURSOR city_object_v2 IS select * from cityobject_v2 order by id;
  BEGIN
    dbms_output.put_line('CityObject table is being copied...');
    FOR city_object IN city_object_v2 LOOP
        insert into cityobject
        (ID, OBJECTCLASS_ID, GMLID, ENVELOPE, CREATION_DATE,
        TERMINATION_DATE, LAST_MODIFICATION_DATE, UPDATING_PERSON,
        REASON_FOR_UPDATE, LINEAGE, XML_SOURCE)
        values
        (city_object.ID, city_object.CLASS_ID, city_object.GMLID,
        city_object.ENVELOPE, city_object.CREATION_DATE, city_object.TERMINATION_DATE,
        city_object.LAST_MODIFICATION_DATE, city_object.UPDATING_PERSON,
        city_object.REASON_FOR_UPDATE, city_object.LINEAGE, city_object.XML_SOURCE);
    END LOOP;
    dbms_output.put_line('CityObject table copy is completed.');
  END;

  PROCEDURE fillCityModelTable
  IS
  BEGIN
    dbms_output.put_line('CityModel table is being copied...');
    insert into citymodel
    (ID, GMLID, NAME, NAME_CODESPACE, DESCRIPTION, ENVELOPE, CREATION_DATE,
    TERMINATION_DATE, LAST_MODIFICATION_DATE, UPDATING_PERSON, REASON_FOR_UPDATE,
    LINEAGE)
    select ID, GMLID, NAME, NAME_CODESPACE, DESCRIPTION, ENVELOPE, CREATION_DATE,
    TERMINATION_DATE, LAST_MODIFICATION_DATE, UPDATING_PERSON, REASON_FOR_UPDATE,
    LINEAGE from citymodel_v2;
    dbms_output.put_line('CityModel table copy is completed.');
  END;

  PROCEDURE fillAddressTable
  IS
  BEGIN
    dbms_output.put_line('Address table is being copied...');
    insert into address select * from address_v2;
    dbms_output.put_line('Address table copy is completed.');
  END;

  PROCEDURE fillBuildingTable
  IS
    -- variables --
    CURSOR buildings_v2 IS select * from building_v2 order by id;
    isSolidLOD1 NUMBER(1);
    isSolidLOD2 NUMBER(1);
    isSolidLOD3 NUMBER(1);
    isSolidLOD4 NUMBER(1);
    lod1MultiSurfaceID NUMBER(10);
    lod2MultiSurfaceID NUMBER(10);
    lod3MultiSurfaceID NUMBER(10);
    lod4MultiSurfaceID NUMBER(10);
    lod1SolidID NUMBER(10);
    lod2SolidID NUMBER(10);
    lod3SolidID NUMBER(10);
    lod4SolidID NUMBER(10);
  BEGIN
    dbms_output.put_line('Building table is being copied...');
    FOR building IN buildings_v2 LOOP
        -- Check if the lod1-lod4 geometry ids are solid and/or multi surface
        -- Update the cityobject_id entry in surface_geometry table
        IF building.lod1_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD1 from surface_geometry_v2 where id = building.lod1_geometry_id;
           IF isSolidLOD1 = 1 THEN
              lod1SolidID := building.lod1_geometry_id;
           ELSE
              lod1MultiSurfaceID := building.lod1_geometry_id;
           END IF;           
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||building.ID||' 
                              where ID = ' || building.lod1_geometry_id;
        END IF;
        IF building.lod2_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD2 from surface_geometry_v2 where id = building.lod2_geometry_id;
           IF isSolidLOD2 = 1 THEN
              lod2SolidID := building.lod2_geometry_id;
           ELSE
              lod2MultiSurfaceID := building.lod2_geometry_id;
           END IF;
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||building.ID||' 
                              where ID = ' || building.lod2_geometry_id;
        END IF;
        IF building.lod3_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD3 from surface_geometry_v2 where id = building.lod3_geometry_id;
           IF isSolidLOD3 = 1 THEN
              lod3SolidID := building.lod3_geometry_id;
           ELSE
              lod3MultiSurfaceID := building.lod3_geometry_id;
           END IF;
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||building.ID||' 
                              where ID = ' || building.lod3_geometry_id;
        END IF;
        IF building.lod4_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD4 from surface_geometry_v2 where id = building.lod4_geometry_id;
           IF isSolidLOD4 = 1 THEN
              lod4SolidID := building.lod4_geometry_id;
           ELSE
              lod4MultiSurfaceID := building.lod4_geometry_id;
           END IF;
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||building.ID||' 
                              where ID = ' || building.lod4_geometry_id;
        END IF;           

        -- Fill the building table
        insert into building
        (ID, BUILDING_PARENT_ID, BUILDING_ROOT_ID, CLASS, FUNCTION, USAGE, YEAR_OF_CONSTRUCTION,
        YEAR_OF_DEMOLITION, ROOF_TYPE, MEASURED_HEIGHT, STOREYS_ABOVE_GROUND, STOREYS_BELOW_GROUND,
        STOREY_HEIGHTS_ABOVE_GROUND, STOREY_HEIGHTS_BELOW_GROUND, LOD1_TERRAIN_INTERSECTION,
        LOD2_TERRAIN_INTERSECTION, LOD3_TERRAIN_INTERSECTION, LOD4_TERRAIN_INTERSECTION,
        LOD2_MULTI_CURVE, LOD3_MULTI_CURVE, LOD4_MULTI_CURVE, LOD1_MULTI_SURFACE_ID, LOD2_MULTI_SURFACE_ID,
        LOD3_MULTI_SURFACE_ID, LOD4_MULTI_SURFACE_ID, LOD1_SOLID_ID, LOD2_SOLID_ID, LOD3_SOLID_ID,
        LOD4_SOLID_ID)
        values
        (building.ID, building.BUILDING_PARENT_ID, building.BUILDING_ROOT_ID,
        replace(building.CLASS,' ','--/\--'), replace(building.FUNCTION,' ','--/\--'), replace(building.USAGE,' ','--/\--'), building.YEAR_OF_CONSTRUCTION,
        building.YEAR_OF_DEMOLITION, building.ROOF_TYPE, building.MEASURED_HEIGHT, building.STOREYS_ABOVE_GROUND,
        building.STOREYS_BELOW_GROUND, building.STOREY_HEIGHTS_ABOVE_GROUND, building.STOREY_HEIGHTS_BELOW_GROUND,
        building.LOD1_TERRAIN_INTERSECTION, building.LOD2_TERRAIN_INTERSECTION, building.LOD3_TERRAIN_INTERSECTION,
        building.LOD4_TERRAIN_INTERSECTION, building.LOD2_MULTI_CURVE, building.LOD3_MULTI_CURVE,
        building.LOD4_MULTI_CURVE, lod1MultiSurfaceID, lod2MultiSurfaceID, lod3MultiSurfaceID, lod4MultiSurfaceID,
        lod1SolidID, lod2SolidID, lod3SolidID, lod4SolidID);

        -- Insert the name and the description of the building
        -- into the cityobject table
        update cityobject
        set name = building.name,
        name_codespace = building.name_codespace,
        description = building.description
        where id = building.id;

        -- Reset the variables
        isSolidLOD1 := NULL;
        isSolidLOD2 := NULL;
        isSolidLOD3 := NULL;
        isSolidLOD4 := NULL;
        lod1MultiSurfaceID := NULL;
        lod2MultiSurfaceID := NULL;
        lod3MultiSurfaceID := NULL;
        lod4MultiSurfaceID := NULL;
        lod1SolidID := NULL;
        lod2SolidID := NULL;
        lod3SolidID := NULL;
        lod4SolidID := NULL;
    END LOOP;
    dbms_output.put_line('Building table copy is completed.');
  END;

  PROCEDURE fillAddressToBuildingTable
  IS
  BEGIN
    dbms_output.put_line('Address_to_Building table is being copied...');
    insert into address_to_building select * from address_to_building_v2;
    dbms_output.put_line('Address_to_Building table copy is completed.');
  END;

  PROCEDURE fillAppearanceTable
  IS
  BEGIN
    dbms_output.put_line('Appearance table is being copied...');
    insert into appearance
    (ID, GMLID, NAME, NAME_CODESPACE, DESCRIPTION, THEME,
    CITYMODEL_ID, CITYOBJECT_ID)
    select ID, GMLID, NAME, NAME_CODESPACE, DESCRIPTION, THEME,
    CITYMODEL_ID, CITYOBJECT_ID from appearance_v2;
    dbms_output.put_line('Appearance table copy is completed.');
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
           select id into classID from OBJECTCLASS where classname = surface_data.type;
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
        (surface_data.ID,surface_data.GMLID,surface_data.NAME,
        surface_data.NAME_CODESPACE,surface_data.DESCRIPTION,surface_data.IS_FRONT,
        classID,surface_data.X3D_SHININESS,surface_data.X3D_TRANSPARENCY,
        surface_data.X3D_AMBIENT_INTENSITY,surface_data.X3D_SPECULAR_COLOR,
        surface_data.X3D_DIFFUSE_COLOR,surface_data.X3D_EMISSIVE_COLOR,
        surface_data.X3D_IS_SMOOTH,texID,surface_data.TEX_TEXTURE_TYPE,
        surface_data.TEX_WRAP_MODE,surface_data.TEX_BORDER_COLOR,
        surface_data.GT_PREFER_WORLDFILE, surface_data.GT_ORIENTATION,
        surface_data.GT_REFERENCE_POINT);
    END LOOP;
    dbms_output.put_line('Surface_data table copy is completed.');

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
  END;

  PROCEDURE fillAppearToSurfaceDataTable
  IS
  BEGIN
    dbms_output.put_line('Appear_to_Surface_Data table is being copied...');
    insert into appear_to_surface_data select * from appear_to_surface_data_v2;
    dbms_output.put_line('Appear_to_Surface_Data table copy is completed.');
  END;

  PROCEDURE fillBreaklineReliefTable
  IS
  BEGIN
    dbms_output.put_line('Breakline_Relief table is being copied...');
    insert into breakline_relief select * from breakline_relief_v2;
    dbms_output.put_line('Breakline_Relief table copy is completed.');
  END;

  PROCEDURE fillRoomTable
  IS
    -- variables --
    CURSOR rooms_v2 IS select * from room_v2 order by id;
    isSolidLOD4 NUMBER(1);
    lod4MultiSurfaceID NUMBER(10);
    lod4SolidID NUMBER(10);
  BEGIN
    dbms_output.put_line('Room table is being copied...');
    FOR room IN rooms_v2 LOOP
        -- Check if the lod4 geometry id is solid and/or multi surface
        -- Update the cityobject_id entry in surface_geometry table
        IF room.lod4_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD4 from surface_geometry_v2
           where id = room.lod4_geometry_id;

           IF isSolidLOD4 = 1 THEN
              lod4SolidID := room.lod4_geometry_id;
           ELSE
              lod4MultiSurfaceID := room.lod4_geometry_id;
           END IF;
           
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||room.ID||' 
                              where ID = ' || room.lod4_geometry_id;
        END IF;

        -- Fill the room table
        insert into room
        (ID,CLASS,FUNCTION,USAGE,BUILDING_ID,LOD4_MULTI_SURFACE_ID,
        LOD4_SOLID_ID)
        values
        (room.ID,replace(room.CLASS,' ','--/\--'),replace(room.FUNCTION,' ','--/\--'),replace(room.USAGE,' ','--/\--'),room.BUILDING_ID,
        lod4MultiSurfaceID, lod4SolidID);

        -- Insert the name and the description of the room
        -- into the cityobject table
        update cityobject
        set name = room.name,
        name_codespace = room.name_codespace,
        description = room.description
        where id = room.id;

        -- Reset the variables
        isSolidLOD4 := NULL;
        lod4MultiSurfaceID := NULL;
        lod4SolidID := NULL;
    END LOOP;
    dbms_output.put_line('Room table copy is completed.');
  END;

  PROCEDURE fillBuildingFurnitureTable
  IS
    -- variables --
    CURSOR building_furniture_v2 IS select * from building_furniture_v2 order by id;
  BEGIN
    dbms_output.put_line('Building_Furniture table is being copied...');
    FOR building_furniture IN building_furniture_v2 LOOP
    
        -- Update the cityobject_id entry in surface_geometry table
        IF building_furniture.LOD4_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||building_furniture.ID||' 
                              where ID = ' || building_furniture.LOD4_GEOMETRY_ID;
        END IF;
    
        insert into building_furniture
        (ID,CLASS,FUNCTION,USAGE,ROOM_ID,LOD4_BREP_ID,LOD4_IMPLICIT_REP_ID,
        LOD4_IMPLICIT_REF_POINT,LOD4_IMPLICIT_TRANSFORMATION)
        values
        (building_furniture.ID,replace(building_furniture.CLASS,' ','--/\--'),replace(building_furniture.FUNCTION,' ','--/\--'),
        replace(building_furniture.USAGE,' ','--/\--'),building_furniture.ROOM_ID,
        building_furniture.LOD4_GEOMETRY_ID,building_furniture.LOD4_IMPLICIT_REP_ID,
        building_furniture.LOD4_IMPLICIT_REF_POINT,
        building_furniture.LOD4_IMPLICIT_TRANSFORMATION);

        -- Insert the name and the description of the building furniture
        -- into the cityobject table

        update cityobject
        set
        name = building_furniture.name,
        name_codespace = building_furniture.name_codespace,
        description = building_furniture.description
        where id = building_furniture.id;
    END LOOP;
    dbms_output.put_line('Building_Furniture table copy is completed.');
  END;

  PROCEDURE fillBuildingInstallationTable
  IS
    -- variables --
    CURSOR building_installation_v2 IS select * from building_installation_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('Building_Installation table is being copied...');
    FOR building_installation IN building_installation_v2 LOOP
        -- Check the id of the is_external type
        IF building_installation.is_external IS NOT NULL THEN
          IF building_installation.is_external = 1 THEN
              select id into classID from OBJECTCLASS where classname = 'BuildingInstallation';
          ELSE
              select id into classID from OBJECTCLASS where classname = 'IntBuildingInstallation';
          END IF;
        END IF;
        
        -- Update the cityobject_id entry in surface_geometry table
        IF building_installation.LOD2_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||building_installation.ID||' 
                              where ID = ' || building_installation.LOD2_GEOMETRY_ID;
        END IF;
        IF building_installation.LOD3_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||building_installation.ID||' 
                              where ID = ' || building_installation.LOD3_GEOMETRY_ID;
        END IF;
        IF building_installation.LOD4_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||building_installation.ID||' 
                              where ID = ' || building_installation.LOD4_GEOMETRY_ID;
        END IF;              

        insert into building_installation
        (ID,OBJECTCLASS_ID,CLASS,FUNCTION,USAGE,BUILDING_ID,ROOM_ID,
        LOD2_BREP_ID,LOD3_BREP_ID,LOD4_BREP_ID)
        values
        (building_installation.ID,classID,replace(building_installation.CLASS,' ','--/\--'),
        replace(building_installation.FUNCTION,' ','--/\--'),replace(building_installation.USAGE,' ','--/\--'),
        building_installation.BUILDING_ID,building_installation.ROOM_ID,
        building_installation.LOD2_GEOMETRY_ID,building_installation.LOD3_GEOMETRY_ID,
        building_installation.LOD4_GEOMETRY_ID);

        -- Insert the name and the description of the building installation
        -- into the cityobject table
        update cityobject
        set
        name = building_installation.name,
        name_codespace = building_installation.name_codespace,
        description = building_installation.description
        where id = building_installation.id;
    END LOOP;
    dbms_output.put_line('Building_Installation table copy is completed.');
  END;

  PROCEDURE fillImplicitGeometryTable
  IS
    -- variables --
    CURSOR implicit_geometry_v2 IS select * from implicit_geometry_v2 order by id;
  BEGIN
    dbms_output.put_line('Implicit_Geometry table is being copied...');
    FOR implicit_geometry IN implicit_geometry_v2 LOOP
        insert into implicit_geometry
        (ID,MIME_TYPE,REFERENCE_TO_LIBRARY,LIBRARY_OBJECT,RELATIVE_BREP_ID)
        values
        (implicit_geometry.ID,implicit_geometry.MIME_TYPE,
        implicit_geometry.REFERENCE_TO_LIBRARY,implicit_geometry.LIBRARY_OBJECT,
        implicit_geometry.RELATIVE_GEOMETRY_ID);
    END LOOP;
    dbms_output.put_line('Implicit_Geometry table copy is completed.');
  END;

  PROCEDURE fillCityFurnitureTable
  IS
    -- variables --
    CURSOR city_furniture_v2 IS select * from city_furniture_v2 order by id;
  BEGIN
    dbms_output.put_line('City_Furniture table is being copied...');
    FOR city_furniture IN city_furniture_v2 LOOP        
        -- Update the cityobject_id entry in surface_geometry table
        IF city_furniture.LOD1_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||city_furniture.ID||' 
                              where ID = ' || city_furniture.LOD1_GEOMETRY_ID;
        END IF;
        IF city_furniture.LOD2_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||city_furniture.ID||' 
                              where ID = ' || city_furniture.LOD2_GEOMETRY_ID;
        END IF;
        IF city_furniture.LOD3_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||city_furniture.ID||' 
                              where ID = ' || city_furniture.LOD3_GEOMETRY_ID;
        END IF;
        IF city_furniture.LOD4_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||city_furniture.ID||' 
                              where ID = ' || city_furniture.LOD4_GEOMETRY_ID;
        END IF;
        
        insert into city_furniture
        (ID,CLASS,FUNCTION,LOD1_TERRAIN_INTERSECTION,LOD2_TERRAIN_INTERSECTION,
        LOD3_TERRAIN_INTERSECTION,LOD4_TERRAIN_INTERSECTION,LOD1_BREP_ID,
        LOD2_BREP_ID,LOD3_BREP_ID,LOD4_BREP_ID,LOD1_IMPLICIT_REP_ID,
        LOD2_IMPLICIT_REP_ID,LOD3_IMPLICIT_REP_ID,LOD4_IMPLICIT_REP_ID,
        LOD1_IMPLICIT_REF_POINT,LOD2_IMPLICIT_REF_POINT,LOD3_IMPLICIT_REF_POINT,
        LOD4_IMPLICIT_REF_POINT,LOD1_IMPLICIT_TRANSFORMATION,
        LOD2_IMPLICIT_TRANSFORMATION,LOD3_IMPLICIT_TRANSFORMATION,
        LOD4_IMPLICIT_TRANSFORMATION)
        values
        (city_furniture.ID,replace(city_furniture.CLASS,' ','--/\--'),replace(city_furniture.FUNCTION,' ','--/\--'),
        city_furniture.LOD1_TERRAIN_INTERSECTION,city_furniture.LOD2_TERRAIN_INTERSECTION,
        city_furniture.LOD3_TERRAIN_INTERSECTION,city_furniture.LOD4_TERRAIN_INTERSECTION,
        city_furniture.LOD1_GEOMETRY_ID,city_furniture.LOD2_GEOMETRY_ID,
        city_furniture.LOD3_GEOMETRY_ID,city_furniture.LOD4_GEOMETRY_ID,
        city_furniture.LOD1_IMPLICIT_REP_ID,city_furniture.LOD2_IMPLICIT_REP_ID,
        city_furniture.LOD3_IMPLICIT_REP_ID,city_furniture.LOD4_IMPLICIT_REP_ID,
        city_furniture.LOD1_IMPLICIT_REF_POINT,city_furniture.LOD2_IMPLICIT_REF_POINT,
        city_furniture.LOD3_IMPLICIT_REF_POINT,city_furniture.LOD4_IMPLICIT_REF_POINT,
        city_furniture.LOD1_IMPLICIT_TRANSFORMATION,
        city_furniture.LOD2_IMPLICIT_TRANSFORMATION,
        city_furniture.LOD3_IMPLICIT_TRANSFORMATION,
        city_furniture.LOD4_IMPLICIT_TRANSFORMATION);

        -- Insert the name and the description of the city furniture
        -- into the cityobject table
        update cityobject
        set
        name = city_furniture.name,
        name_codespace = city_furniture.name_codespace,
        description = city_furniture.description
        where id = city_furniture.id;
    END LOOP;
    dbms_output.put_line('City_Furniture table copy is completed.');
  END;

  PROCEDURE fillCityObjectGenAttrTable
  IS
    -- variables --
    CURSOR cityobject_genericattrib_v2 IS
           select * from cityobject_genericattrib_v2 order by id;
  BEGIN
    dbms_output.put_line('CityObject_GenericAttrib table is being copied...');
    FOR cityobject_genericattrib IN cityobject_genericattrib_v2 LOOP
        insert into cityobject_genericattrib
        (ID,ROOT_GENATTRIB_ID,ATTRNAME,DATATYPE,STRVAL,INTVAL,REALVAL,URIVAL,
        DATEVAL,GEOMVAL,BLOBVAL,CITYOBJECT_ID,SURFACE_GEOMETRY_ID)
        values
        (cityobject_genericattrib.ID,cityobject_genericattrib.ID,
        cityobject_genericattrib.ATTRNAME,cityobject_genericattrib.DATATYPE,
        cityobject_genericattrib.STRVAL,cityobject_genericattrib.INTVAL,
        cityobject_genericattrib.REALVAL,cityobject_genericattrib.URIVAL,
        cityobject_genericattrib.DATEVAL,cityobject_genericattrib.GEOMVAL,
        cityobject_genericattrib.BLOBVAL,cityobject_genericattrib.CITYOBJECT_ID,
        cityobject_genericattrib.SURFACE_GEOMETRY_ID);
    END LOOP;
    dbms_output.put_line('CityObject_GenericAttrib table copy is completed.');
  END;

  PROCEDURE fillCityObjectMemberTable
  IS
  BEGIN
    dbms_output.put_line('CityObject_Member table is being copied...');
    insert into cityobject_member select * from cityobject_member_v2;
    dbms_output.put_line('CityObject_Member table copy is completed.');
  END;

  PROCEDURE fillCityObjectGroupTable
  IS
    -- variables --
    CURSOR cityobjectgroup_v2 IS select * from cityobjectgroup_v2 order by id;
  BEGIN
    dbms_output.put_line('CityObjectGroup table is being copied...');
    FOR cityobjectgroup IN cityobjectgroup_v2 LOOP
        insert into cityobjectgroup
        (ID,CLASS,FUNCTION,USAGE,BREP_ID,OTHER_GEOM,PARENT_CITYOBJECT_ID)
        values
        (cityobjectgroup.ID,replace(cityobjectgroup.CLASS,' ','--/\--'),replace(cityobjectgroup.FUNCTION,' ','--/\--'),
        replace(cityobjectgroup.USAGE,' ','--/\--'),cityobjectgroup.SURFACE_GEOMETRY_ID,
        cityobjectgroup.GEOMETRY,cityobjectgroup.PARENT_CITYOBJECT_ID);

        -- Insert the name and the description of the city furniture
        -- into the cityobject table
        update cityobject
        set
        name = cityobjectgroup.name,
        name_codespace = cityobjectgroup.name_codespace,
        description = cityobjectgroup.description
        where id = cityobjectgroup.id;
    END LOOP;
    dbms_output.put_line('CityObjectGroup table copy is completed.');
  END;

  PROCEDURE fillExternalReferenceTable
  IS
  BEGIN
    dbms_output.put_line('External_Reference table is being copied...');
    insert into external_reference select * from external_reference_v2;
    dbms_output.put_line('External_Reference table copy is completed.');
  END;

  PROCEDURE fillGeneralizationTable
  IS
  BEGIN
    dbms_output.put_line('Generalization table is being copied...');
    insert into generalization select * from generalization_v2;
    dbms_output.put_line('Generalization table copy is completed.');
  END;

  PROCEDURE fillGenericCityObjectTable
  IS
    -- variables --
    CURSOR generic_cityobject_v2 IS select * from generic_cityobject_v2 order by id;
  BEGIN
    dbms_output.put_line('Generic_CityObject table is being copied...');
    -- Drop the invalid indexes
    EXECUTE IMMEDIATE 'DROP INDEX GEN_OBJECT_LOD3XGEOM_SPX';
    EXECUTE IMMEDIATE 'DROP INDEX GEN_OBJECT_LOD4REFPNT_SPX';
    EXECUTE IMMEDIATE 'DROP INDEX GEN_OBJECT_LOD4TERR_SPX';
    EXECUTE IMMEDIATE 'DROP INDEX GEN_OBJECT_LOD4XGEOM_SPX'; 
        
    FOR generic_cityobject IN generic_cityobject_v2 LOOP
        -- Update the cityobject_id entry in surface_geometry table
        IF generic_cityobject.LOD0_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||generic_cityobject.ID||' 
                              where ID = ' || generic_cityobject.LOD0_GEOMETRY_ID;
        END IF;
        IF generic_cityobject.LOD1_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||generic_cityobject.ID||' 
                              where ID = ' || generic_cityobject.LOD1_GEOMETRY_ID;
        END IF;
        IF generic_cityobject.LOD2_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||generic_cityobject.ID||' 
                              where ID = ' || generic_cityobject.LOD2_GEOMETRY_ID;
        END IF;
        IF generic_cityobject.LOD3_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||generic_cityobject.ID||' 
                              where ID = ' || generic_cityobject.LOD3_GEOMETRY_ID;
        END IF;
        IF generic_cityobject.LOD4_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||generic_cityobject.ID||' 
                              where ID = ' || generic_cityobject.LOD4_GEOMETRY_ID;
        END IF;
    
        insert into generic_cityobject
        (ID,CLASS,FUNCTION,USAGE,LOD0_TERRAIN_INTERSECTION,
        LOD1_TERRAIN_INTERSECTION,LOD2_TERRAIN_INTERSECTION,LOD3_TERRAIN_INTERSECTION,
        LOD4_TERRAIN_INTERSECTION,LOD0_BREP_ID,LOD1_BREP_ID,LOD2_BREP_ID,
        LOD3_BREP_ID,LOD4_BREP_ID,LOD0_IMPLICIT_REP_ID,LOD1_IMPLICIT_REP_ID,
        LOD2_IMPLICIT_REP_ID,LOD3_IMPLICIT_REP_ID,LOD4_IMPLICIT_REP_ID,
        LOD0_IMPLICIT_REF_POINT,LOD1_IMPLICIT_REF_POINT,LOD2_IMPLICIT_REF_POINT,
        LOD3_IMPLICIT_REF_POINT,LOD4_IMPLICIT_REF_POINT,LOD0_IMPLICIT_TRANSFORMATION,
        LOD1_IMPLICIT_TRANSFORMATION,LOD2_IMPLICIT_TRANSFORMATION,
        LOD3_IMPLICIT_TRANSFORMATION,LOD4_IMPLICIT_TRANSFORMATION)
        values
        (generic_cityobject.ID,replace(generic_cityobject.CLASS,' ','--/\--'),replace(generic_cityobject.FUNCTION,' ','--/\--'),
        replace(generic_cityobject.USAGE,' ','--/\--'),generic_cityobject.LOD0_TERRAIN_INTERSECTION,
        generic_cityobject.LOD1_TERRAIN_INTERSECTION,
        generic_cityobject.LOD2_TERRAIN_INTERSECTION,
        generic_cityobject.LOD3_TERRAIN_INTERSECTION,
        generic_cityobject.LOD4_TERRAIN_INTERSECTION,
        generic_cityobject.LOD0_GEOMETRY_ID, generic_cityobject.LOD1_GEOMETRY_ID,
        generic_cityobject.LOD2_GEOMETRY_ID, generic_cityobject.LOD3_GEOMETRY_ID,
        generic_cityobject.LOD4_GEOMETRY_ID, generic_cityobject.LOD0_IMPLICIT_REP_ID,
        generic_cityobject.LOD1_IMPLICIT_REP_ID,generic_cityobject.LOD2_IMPLICIT_REP_ID,
        generic_cityobject.LOD3_IMPLICIT_REP_ID,generic_cityobject.LOD4_IMPLICIT_REP_ID,
        generic_cityobject.LOD0_IMPLICIT_REF_POINT,
        generic_cityobject.LOD1_IMPLICIT_REF_POINT,
        generic_cityobject.LOD2_IMPLICIT_REF_POINT,
        generic_cityobject.LOD3_IMPLICIT_REF_POINT,
        generic_cityobject.LOD4_IMPLICIT_REF_POINT,
        generic_cityobject.LOD0_IMPLICIT_TRANSFORMATION,
        generic_cityobject.LOD1_IMPLICIT_TRANSFORMATION,
        generic_cityobject.LOD2_IMPLICIT_TRANSFORMATION,
        generic_cityobject.LOD3_IMPLICIT_TRANSFORMATION,
        generic_cityobject.LOD4_IMPLICIT_TRANSFORMATION);

        -- Insert the name and the description of the generic city object
        -- into the cityobject table
        update cityobject
        set
        name = generic_cityobject.name,
        name_codespace = generic_cityobject.name_codespace,
        description = generic_cityobject.description
        where id = generic_cityobject.id;
    END LOOP;
    -- Recreate the dropped invalid indexes
    EXECUTE IMMEDIATE 'CREATE INDEX GEN_OBJECT_LOD3XGEOM_SPX ON GENERIC_CITYOBJECT (LOD3_OTHER_GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX';
    EXECUTE IMMEDIATE 'CREATE INDEX GEN_OBJECT_LOD4REFPNT_SPX ON GENERIC_CITYOBJECT (LOD4_IMPLICIT_REF_POINT) INDEXTYPE IS MDSYS.SPATIAL_INDEX';
    EXECUTE IMMEDIATE 'CREATE INDEX GEN_OBJECT_LOD4TERR_SPX ON GENERIC_CITYOBJECT (LOD4_TERRAIN_INTERSECTION) INDEXTYPE IS MDSYS.SPATIAL_INDEX';
    EXECUTE IMMEDIATE 'CREATE INDEX GEN_OBJECT_LOD4XGEOM_SPX ON GENERIC_CITYOBJECT (LOD4_OTHER_GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX';
    dbms_output.put_line('Generic_CityObject table copy is completed.');
  END;

  PROCEDURE fillGroupToCityObject
  IS
  BEGIN
    dbms_output.put_line('Group_To_CityObject table is being copied...');
    insert into group_to_cityobject select * from group_to_cityobject_v2;
    dbms_output.put_line('Group_To_CityObject table copy is completed.');
  END;

  PROCEDURE fillLandUseTable
  IS
    -- variables --
    CURSOR land_use_v2 IS select * from land_use_v2 order by id;
  BEGIN
    dbms_output.put_line('Land_Use table is being copied...');
    FOR land_use IN land_use_v2 LOOP
        -- Update the cityobject_id entry in surface_geometry table
        IF land_use.LOD0_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||land_use.ID||' 
                              where ID = ' || land_use.LOD0_MULTI_SURFACE_ID;
        END IF;            
        IF land_use.LOD1_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||land_use.ID||' 
                              where ID = ' || land_use.LOD1_MULTI_SURFACE_ID;
        END IF;
        IF land_use.LOD2_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||land_use.ID||' 
                              where ID = ' || land_use.LOD2_MULTI_SURFACE_ID;
        END IF;
        IF land_use.LOD3_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||land_use.ID||' 
                              where ID = ' || land_use.LOD3_MULTI_SURFACE_ID;
        END IF;
        IF land_use.LOD4_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||land_use.ID||' 
                              where ID = ' || land_use.LOD4_MULTI_SURFACE_ID;
        END IF;
    
        insert into land_use
        (ID,CLASS,FUNCTION,USAGE,LOD0_MULTI_SURFACE_ID,LOD1_MULTI_SURFACE_ID,
        LOD2_MULTI_SURFACE_ID,LOD3_MULTI_SURFACE_ID,LOD4_MULTI_SURFACE_ID)
        values
        (land_use.ID,replace(land_use.CLASS,' ','--/\--'),replace(land_use.FUNCTION,' ','--/\--'),replace(land_use.USAGE,' ','--/\--'),
        land_use.LOD0_MULTI_SURFACE_ID,land_use.LOD1_MULTI_SURFACE_ID,
        land_use.LOD2_MULTI_SURFACE_ID,land_use.LOD3_MULTI_SURFACE_ID,
        land_use.LOD4_MULTI_SURFACE_ID);

        -- Insert the name and the description of the land use
        -- into the cityobject table
        update cityobject
        set
        name = land_use.name,
        name_codespace = land_use.name_codespace,
        description = land_use.description
        where id = land_use.id;
    END LOOP;
    dbms_output.put_line('Land_Use table copy is completed.');
  END;

  PROCEDURE fillMassPointReliefTable
  IS
  BEGIN
    dbms_output.put_line('MassPoint_Relief table is being copied...');
    insert into masspoint_relief select * from masspoint_relief_v2;
    dbms_output.put_line('MassPoint_Relief table copy is completed.');
  END;

  PROCEDURE fillOpeningTable
  IS
    -- variables --
    CURSOR opening_v2 IS select * from opening_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('Opening table is being copied...');
    FOR opening IN opening_v2 LOOP
        -- Check Type
        IF opening.type IS NOT NULL THEN
           select id into classID from OBJECTCLASS where classname = opening.type;
        END IF;
        
        -- Update the cityobject_id entry in surface_geometry table
        IF opening.LOD3_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||opening.ID||' 
                              where ID = ' || opening.LOD3_MULTI_SURFACE_ID;
        END IF;
        IF opening.LOD4_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||opening.ID||' 
                              where ID = ' || opening.LOD4_MULTI_SURFACE_ID;
        END IF;

        insert into opening
        (ID,OBJECTCLASS_ID,ADDRESS_ID,LOD3_MULTI_SURFACE_ID,LOD4_MULTI_SURFACE_ID)
        values
        (opening.ID,classID,opening.ADDRESS_ID,
        opening.LOD3_MULTI_SURFACE_ID,opening.LOD4_MULTI_SURFACE_ID);

        -- Insert the name and the description of the opening
        -- into the cityobject table
        update cityobject
        set
        name = opening.name,
        name_codespace = opening.name_codespace,
        description = opening.description
        where id = opening.id;
    END LOOP;
    dbms_output.put_line('Opening table copy is completed.');
  END;

  PROCEDURE fillThematicSurfaceTable
  IS
    -- variables --
    CURSOR thematic_surface_v2 IS select * from thematic_surface_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('Thematic_Surface table is being copied...');
    FOR thematic_surface IN thematic_surface_v2 LOOP
        -- Check Type
        IF thematic_surface.type IS NOT NULL THEN
           select id into classID from OBJECTCLASS where classname = thematic_surface.type;
        END IF;
        
        -- Update the cityobject_id entry in surface_geometry table
        IF thematic_surface.LOD2_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||thematic_surface.ID||' 
                              where ID = ' || thematic_surface.LOD2_MULTI_SURFACE_ID;
        END IF;
        IF thematic_surface.LOD3_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||thematic_surface.ID||' 
                              where ID = ' || thematic_surface.LOD3_MULTI_SURFACE_ID;
        END IF;
        IF thematic_surface.LOD4_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||thematic_surface.ID||' 
                              where ID = ' || thematic_surface.LOD4_MULTI_SURFACE_ID;
        END IF;

        insert into thematic_surface
        (ID,OBJECTCLASS_ID,BUILDING_ID,ROOM_ID,LOD2_MULTI_SURFACE_ID,
        LOD3_MULTI_SURFACE_ID,LOD4_MULTI_SURFACE_ID)
        values
        (thematic_surface.ID,classID,thematic_surface.BUILDING_ID,
        thematic_surface.ROOM_ID,thematic_surface.LOD2_MULTI_SURFACE_ID,
        thematic_surface.LOD3_MULTI_SURFACE_ID,
        thematic_surface.LOD4_MULTI_SURFACE_ID);

        -- Insert the name and the description of the thematic surface
        -- into the cityobject table
        update cityobject
        set
        name = thematic_surface.name,
        name_codespace = thematic_surface.name_codespace,
        description = thematic_surface.description
        where id = thematic_surface.id;
    END LOOP;
    dbms_output.put_line('Thematic_Surface table copy is completed.');
  END;

  PROCEDURE fillOpeningToThemSurfaceTable
  IS
  BEGIN
    dbms_output.put_line('Opening_To_Them_Surface table is being copied...');
    insert into opening_to_them_surface select * from opening_to_them_surface_v2;
    dbms_output.put_line('Opening_To_Them_Surface table copy is completed.');
  END;

  PROCEDURE fillPlantCoverTable
  IS
    -- variables --
    CURSOR plant_cover_v2 IS select * from plant_cover_v2 order by id;
    isSolidLOD1 NUMBER(1);
    isSolidLOD2 NUMBER(1);
    isSolidLOD3 NUMBER(1);
    isSolidLOD4 NUMBER(1);
    lod1MultiSurfaceID NUMBER(10);
    lod2MultiSurfaceID NUMBER(10);
    lod3MultiSurfaceID NUMBER(10);
    lod4MultiSurfaceID NUMBER(10);
    lod1SolidID NUMBER(10);
    lod2SolidID NUMBER(10);
    lod3SolidID NUMBER(10);
    lod4SolidID NUMBER(10);
  BEGIN
    dbms_output.put_line('Plant_Cover table is being copied...');
    FOR plant_cover IN plant_cover_v2 LOOP
        -- Check if the lod1-lod4 geometry ids are solid and/or multi surface
        IF plant_cover.lod1_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD1 from surface_geometry_v2 where id = plant_cover.lod1_geometry_id;
           IF isSolidLOD1 = 1 THEN
              lod1SolidID := plant_cover.lod1_geometry_id;
           ELSE
              lod1MultiSurfaceID := plant_cover.lod1_geometry_id;
           END IF;
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||plant_cover.ID||' 
                              where ID = ' || plant_cover.lod1_geometry_id;
        END IF;
        IF plant_cover.lod2_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD2 from surface_geometry_v2 where id = plant_cover.lod2_geometry_id;
           IF isSolidLOD2 = 1 THEN
              lod2SolidID := plant_cover.lod2_geometry_id;
           ELSE
              lod2MultiSurfaceID := plant_cover.lod2_geometry_id;
           END IF;
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||plant_cover.ID||' 
                              where ID = ' || plant_cover.lod2_geometry_id;
        END IF;
        IF plant_cover.lod3_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD3 from surface_geometry_v2 where id = plant_cover.lod3_geometry_id;
           IF isSolidLOD3 = 1 THEN
              lod3SolidID := plant_cover.lod3_geometry_id;
           ELSE
              lod3MultiSurfaceID := plant_cover.lod3_geometry_id;
           END IF;
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||plant_cover.ID||' 
                              where ID = ' || plant_cover.lod3_geometry_id;
        END IF;
        IF plant_cover.lod4_geometry_id IS NOT NULL THEN
           select is_solid into isSolidLOD4 from surface_geometry_v2 where id = plant_cover.lod4_geometry_id;
           IF isSolidLOD4 = 1 THEN
              lod4SolidID := plant_cover.lod4_geometry_id;
           ELSE
              lod4MultiSurfaceID := plant_cover.lod4_geometry_id;
           END IF;
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||plant_cover.ID||' 
                              where ID = ' || plant_cover.lod4_geometry_id;
        END IF;

        -- Fill the building table
        insert into plant_cover
        (ID,CLASS,FUNCTION,AVERAGE_HEIGHT,LOD1_MULTI_SURFACE_ID,
        LOD2_MULTI_SURFACE_ID,LOD3_MULTI_SURFACE_ID,LOD4_MULTI_SURFACE_ID,
        LOD1_MULTI_SOLID_ID, LOD2_MULTI_SOLID_ID, LOD3_MULTI_SOLID_ID,
        LOD4_MULTI_SOLID_ID)
        values
        (plant_cover.ID,replace(plant_cover.CLASS,' ','--/\--'),replace(plant_cover.FUNCTION,' ','--/\--'),
        plant_cover.AVERAGE_HEIGHT,lod1MultiSurfaceID,lod2MultiSurfaceID,
        lod3MultiSurfaceID,lod4MultiSurfaceID,lod1SolidID,lod2SolidID,
        lod3SolidID, lod4SolidID);

        -- Insert the name and the description of the plant cover
        -- into the cityobject table
        update cityobject
        set name = plant_cover.name,
        name_codespace = plant_cover.name_codespace,
        description = plant_cover.description
        where id = plant_cover.id;

        -- Reset the variables
        isSolidLOD1 := NULL;
        isSolidLOD2 := NULL;
        isSolidLOD3 := NULL;
        isSolidLOD4 := NULL;
        lod1MultiSurfaceID := NULL;
        lod2MultiSurfaceID := NULL;
        lod3MultiSurfaceID := NULL;
        lod4MultiSurfaceID := NULL;
        lod1SolidID := NULL;
        lod2SolidID := NULL;
        lod3SolidID := NULL;
        lod4SolidID := NULL;
    END LOOP;
    dbms_output.put_line('Plant_Cover table copy is completed.');
  END;

  PROCEDURE fillReliefComponentTable
  IS
    -- variables --
    CURSOR relief_component_v2 IS select * from relief_component_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('Relief_Component table is being copied...');
    FOR relief_component IN relief_component_v2 LOOP
        -- Fetch the objectclass id
        IF relief_component.id IS NOT NULL THEN
           select OBJECTCLASS_ID into classID from CITYOBJECT
           where id = relief_component.id;
        END IF;

        insert into relief_component
        (ID,OBJECTCLASS_ID,LOD,EXTENT)
        values
        (relief_component.ID,classID,relief_component.LOD,
        relief_component.EXTENT);

        -- Insert the name and the description of the relief component
        -- into the cityobject table
        update cityobject
        set
        name = relief_component.name,
        name_codespace = relief_component.name_codespace,
        description = relief_component.description
        where id = relief_component.id;
    END LOOP;
    dbms_output.put_line('Relief_Component table copy is completed.');
  END;

  PROCEDURE fillReliefFeatToRelCompTable
  IS
  BEGIN
    dbms_output.put_line('Relief_Feat_To_Rel_Comp table is being copied...');
    insert into relief_feat_to_rel_comp select * from relief_feat_to_rel_comp_v2;
    dbms_output.put_line('Relief_Feat_To_Rel_Comp table copy is completed.');
  END;

  PROCEDURE fillReliefFeatureTable
  IS
    -- variables --
    CURSOR relief_feature_v2 IS select * from relief_feature_v2 order by id;
  BEGIN
    dbms_output.put_line('Relief_Feature table is being copied...');
    FOR relief_feature IN relief_feature_v2 LOOP

        insert into relief_feature
        (ID,LOD)
        values
        (relief_feature.ID,relief_feature.LOD);

        -- Insert the name and the description of the relief feature
        -- into the cityobject table
        update cityobject
        set
        name = relief_feature.name,
        name_codespace = relief_feature.name_codespace,
        description = relief_feature.description
        where id = relief_feature.id;
    END LOOP;
    dbms_output.put_line('Relief_Feature table copy is completed.');
  END;

  PROCEDURE fillSolitaryVegetatObjectTable
  IS
    -- variables --
    CURSOR solitary_vegetat_object_v2 IS select * from solitary_vegetat_object_v2 order by id;
  BEGIN
    dbms_output.put_line('Solitary_Vegetat_Object table is being copied...');
    FOR solitary_vegetat_object IN solitary_vegetat_object_v2 LOOP
    
        -- Update the cityobject_id entry in surface_geometry table
        IF solitary_vegetat_object.LOD1_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||solitary_vegetat_object.ID||' 
                              where ID = ' || solitary_vegetat_object.LOD1_GEOMETRY_ID;
        END IF;
        IF solitary_vegetat_object.LOD2_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||solitary_vegetat_object.ID||' 
                              where ID = ' || solitary_vegetat_object.LOD2_GEOMETRY_ID;
        END IF;
        IF solitary_vegetat_object.LOD3_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||solitary_vegetat_object.ID||' 
                              where ID = ' || solitary_vegetat_object.LOD3_GEOMETRY_ID;
        END IF;
        IF solitary_vegetat_object.LOD4_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||solitary_vegetat_object.ID||' 
                              where ID = ' || solitary_vegetat_object.LOD4_GEOMETRY_ID;
        END IF;

        insert into solitary_vegetat_object
        (ID,CLASS,SPECIES,FUNCTION,HEIGHT,TRUNK_DIAMETER,CROWN_DIAMETER,
        LOD1_BREP_ID,LOD2_BREP_ID,LOD3_BREP_ID,LOD4_BREP_ID,
        LOD1_IMPLICIT_REP_ID,LOD2_IMPLICIT_REP_ID,LOD3_IMPLICIT_REP_ID,
        LOD4_IMPLICIT_REP_ID,LOD1_IMPLICIT_REF_POINT,LOD2_IMPLICIT_REF_POINT,
        LOD3_IMPLICIT_REF_POINT,LOD4_IMPLICIT_REF_POINT,
        LOD1_IMPLICIT_TRANSFORMATION,LOD2_IMPLICIT_TRANSFORMATION,
        LOD3_IMPLICIT_TRANSFORMATION,LOD4_IMPLICIT_TRANSFORMATION)
        values
        (solitary_vegetat_object.ID,replace(solitary_vegetat_object.CLASS,' ','--/\--'),
        solitary_vegetat_object.SPECIES,replace(solitary_vegetat_object.FUNCTION,' ','--/\--'),
        solitary_vegetat_object.HEIGHT,solitary_vegetat_object.TRUNC_DIAMETER,
        solitary_vegetat_object.CROWN_DIAMETER, solitary_vegetat_object.LOD1_GEOMETRY_ID,
        solitary_vegetat_object.LOD2_GEOMETRY_ID,
        solitary_vegetat_object.LOD3_GEOMETRY_ID,
        solitary_vegetat_object.LOD4_GEOMETRY_ID,
        solitary_vegetat_object.LOD1_IMPLICIT_REP_ID,
        solitary_vegetat_object.LOD2_IMPLICIT_REP_ID,
        solitary_vegetat_object.LOD3_IMPLICIT_REP_ID,
        solitary_vegetat_object.LOD4_IMPLICIT_REP_ID,
        solitary_vegetat_object.LOD1_IMPLICIT_REF_POINT,
        solitary_vegetat_object.LOD2_IMPLICIT_REF_POINT,
        solitary_vegetat_object.LOD3_IMPLICIT_REF_POINT,
        solitary_vegetat_object.LOD4_IMPLICIT_REF_POINT,
        solitary_vegetat_object.LOD1_IMPLICIT_TRANSFORMATION,
        solitary_vegetat_object.LOD2_IMPLICIT_TRANSFORMATION,
        solitary_vegetat_object.LOD3_IMPLICIT_TRANSFORMATION,
        solitary_vegetat_object.LOD4_IMPLICIT_TRANSFORMATION);

        -- Insert the name and the description of the solitary vegetation object
        -- into the cityobject table
        update cityobject
        set name = solitary_vegetat_object.name,
        name_codespace = solitary_vegetat_object.name_codespace,
        description = solitary_vegetat_object.description
        where id = solitary_vegetat_object.id;
    END LOOP;
    dbms_output.put_line('Solitary_Vegetat_Object table copy is completed.');
  END;

  PROCEDURE fillTextureParamTable
  IS
    -- variables --
    CURSOR textureparam_v2 IS select * from textureparam_v2 order by surface_geometry_id;
  BEGIN
    dbms_output.put_line('TextureParam table is being copied...');
    FOR textureparam IN textureparam_v2 LOOP
        insert into textureparam
        (SURFACE_GEOMETRY_ID,IS_TEXTURE_PARAMETRIZATION,WORLD_TO_TEXTURE,
        TEXTURE_COORDINATES,SURFACE_DATA_ID)
        values
        (textureparam.SURFACE_GEOMETRY_ID,textureparam.IS_TEXTURE_PARAMETRIZATION,
        textureparam.WORLD_TO_TEXTURE,
        convertVarcharToSDOGeom(textureparam.TEXTURE_COORDINATES),
        textureparam.SURFACE_DATA_ID);
    END LOOP;
    dbms_output.put_line('TextureParam table copy is completed.');
  END;

  PROCEDURE fillTinReliefTable
  IS
    CURSOR tin_relief_v2 IS select * from tin_relief_v2 order by id;
  BEGIN
    dbms_output.put_line('Tin Relief table is being copied...');
    FOR tin_relief IN tin_relief_v2 LOOP
        -- Update the cityobject_id entry in surface_geometry table
        IF tin_relief.SURFACE_GEOMETRY_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||tin_relief.ID||' 
                              where ID = ' || tin_relief.SURFACE_GEOMETRY_ID;
        END IF;
        
        insert into tin_relief
        (ID,MAX_LENGTH,STOP_LINES,BREAK_LINES,CONTROL_POINTS, 
        SURFACE_GEOMETRY_ID)
        values
        (tin_relief.ID,tin_relief.MAX_LENGTH,tin_relief.STOP_LINES, 
        tin_relief.BREAK_LINES,tin_relief.CONTROL_POINTS,
        tin_relief.SURFACE_GEOMETRY_ID);
    END LOOP;
    dbms_output.put_line('Tin Relief table copy is completed.');
  END;

  PROCEDURE fillTrafficAreaTable
  IS
    -- variables --
    CURSOR traffic_area_v2 IS select * from traffic_area_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('Traffic_Area table is being copied...');
    FOR traffic_area IN traffic_area_v2 LOOP
        -- Fetch the objectclass id
        IF traffic_area.is_auxiliary IS NOT NULL THEN
          IF traffic_area.is_auxiliary = 1 THEN
              select id into classID from OBJECTCLASS where classname = 'AuxiliaryTrafficArea';
          ELSE
              select id into classID from OBJECTCLASS where classname = 'TrafficArea';
          END IF;
        END IF;
        
        -- Update the cityobject_id entry in surface_geometry table
        IF traffic_area.LOD2_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||traffic_area.ID||' 
                              where ID = ' || traffic_area.LOD2_MULTI_SURFACE_ID;
        END IF;
        IF traffic_area.LOD3_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||traffic_area.ID||' 
                              where ID = ' || traffic_area.LOD3_MULTI_SURFACE_ID;
        END IF;
        IF traffic_area.LOD4_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||traffic_area.ID||' 
                              where ID = ' || traffic_area.LOD4_MULTI_SURFACE_ID;
        END IF;

        insert into traffic_area
        (ID,OBJECTCLASS_ID,FUNCTION,USAGE,SURFACE_MATERIAL,LOD2_MULTI_SURFACE_ID,
        LOD3_MULTI_SURFACE_ID,LOD4_MULTI_SURFACE_ID,TRANSPORTATION_COMPLEX_ID)
        values
        (traffic_area.ID,classID,replace(traffic_area.FUNCTION,' ','--/\--'),replace(traffic_area.USAGE,' ','--/\--'),
        traffic_area.SURFACE_MATERIAL,traffic_area.LOD2_MULTI_SURFACE_ID,
        traffic_area.LOD3_MULTI_SURFACE_ID,traffic_area.LOD4_MULTI_SURFACE_ID,
        traffic_area.TRANSPORTATION_COMPLEX_ID);

        -- Insert the name and the description of the traffic area
        -- into the cityobject table
        update cityobject
        set
        name = traffic_area.name,
        name_codespace = traffic_area.name_codespace,
        description = traffic_area.description
        where id = traffic_area.id;
    END LOOP;
    dbms_output.put_line('Traffic_Area table copy is completed.');
  END;

  PROCEDURE fillTransportationComplex
  IS
    -- variables --
    CURSOR transportation_complex_v2 IS select * from transportation_complex_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('Transportation_Complex table is being copied...');
    FOR transportation_complex IN transportation_complex_v2 LOOP
        -- Check Type
        IF transportation_complex.type IS NOT NULL THEN
           select id into classID from OBJECTCLASS where classname = transportation_complex.type;
        END IF;
        
        -- Update the cityobject_id entry in surface_geometry table
        IF transportation_complex.LOD1_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||transportation_complex.ID||' 
                              where ID = ' || transportation_complex.LOD1_MULTI_SURFACE_ID;
        END IF;
        IF transportation_complex.LOD2_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||transportation_complex.ID||' 
                              where ID = ' || transportation_complex.LOD2_MULTI_SURFACE_ID;
        END IF;
        IF transportation_complex.LOD3_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||transportation_complex.ID||' 
                              where ID = ' || transportation_complex.LOD3_MULTI_SURFACE_ID;
        END IF;
        IF transportation_complex.LOD4_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||transportation_complex.ID||' 
                              where ID = ' || transportation_complex.LOD4_MULTI_SURFACE_ID;
        END IF;

        insert into transportation_complex
        (ID,OBJECTCLASS_ID,FUNCTION,USAGE,LOD0_NETWORK,
        LOD1_MULTI_SURFACE_ID,LOD2_MULTI_SURFACE_ID,LOD3_MULTI_SURFACE_ID,
        LOD4_MULTI_SURFACE_ID)
        values
        (transportation_complex.ID,classID,replace(transportation_complex.FUNCTION,' ','--/\--'),
        replace(transportation_complex.USAGE,' ','--/\--'),transportation_complex.LOD0_NETWORK,
        transportation_complex.LOD1_MULTI_SURFACE_ID,
        transportation_complex.LOD2_MULTI_SURFACE_ID,
        transportation_complex.LOD3_MULTI_SURFACE_ID,
        transportation_complex.LOD4_MULTI_SURFACE_ID);

        -- Insert the name and the description of the transportation complex
        -- into the cityobject table
        update cityobject
        set
        name = transportation_complex.name,
        name_codespace = transportation_complex.name_codespace,
        description = transportation_complex.description
        where id = transportation_complex.id;
    END LOOP;
    dbms_output.put_line('Transportation_Complex table copy is completed.');
  END;

  PROCEDURE fillWaterBodyTable
  IS
    -- variables --
    CURSOR waterbody_v2 IS select * from waterbody_v2 order by id;
  BEGIN
    dbms_output.put_line('WaterBody table is being copied...');
    FOR waterbody IN waterbody_v2 LOOP
        -- Update the cityobject_id entry in surface_geometry table
        IF waterbody.LOD0_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterbody.ID||' 
                              where ID = ' || waterbody.LOD0_MULTI_SURFACE_ID;
        END IF;     
        IF waterbody.LOD1_MULTI_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterbody.ID||' 
                              where ID = ' || waterbody.LOD1_MULTI_SURFACE_ID;
        END IF;
        IF waterbody.LOD1_SOLID_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterbody.ID||' 
                              where ID = ' || waterbody.LOD1_SOLID_ID;
        END IF;
        IF waterbody.LOD2_SOLID_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterbody.ID||' 
                              where ID = ' || waterbody.LOD2_SOLID_ID;
        END IF;
        IF waterbody.LOD3_SOLID_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterbody.ID||' 
                              where ID = ' || waterbody.LOD3_SOLID_ID;
        END IF;
        IF waterbody.LOD4_SOLID_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterbody.ID||' 
                              where ID = ' || waterbody.LOD4_SOLID_ID;
        END IF;
      
        insert into waterbody
        (ID,CLASS,FUNCTION,USAGE,LOD0_MULTI_CURVE,LOD1_MULTI_CURVE,
        LOD0_MULTI_SURFACE_ID,LOD1_MULTI_SURFACE_ID,LOD1_SOLID_ID,
        LOD2_SOLID_ID,LOD3_SOLID_ID,LOD4_SOLID_ID)
        values
        (waterbody.ID,replace(waterbody.CLASS,' ','--/\--'),replace(waterbody.FUNCTION,' ','--/\--'),replace(waterbody.USAGE,' ','--/\--'),
        waterbody.LOD0_MULTI_CURVE,waterbody.LOD1_MULTI_CURVE,
        waterbody.LOD0_MULTI_SURFACE_ID,waterbody.LOD1_MULTI_SURFACE_ID,
        waterbody.LOD1_SOLID_ID,waterbody.LOD2_SOLID_ID,
        waterbody.LOD3_SOLID_ID,waterbody.LOD4_SOLID_ID);

        -- Insert the name and the description of the waterbody
        -- into the cityobject table
        update cityobject
        set
        name = waterbody.name,
        name_codespace = waterbody.name_codespace,
        description = waterbody.description
        where id = waterbody.id;
    END LOOP;
    dbms_output.put_line('WaterBody table copy is completed.');
  END;

  PROCEDURE fillWaterBoundarySurfaceTable
  IS
    -- variables --
    CURSOR waterboundary_surface_v2 IS select * from waterboundary_surface_v2 order by id;
    classID NUMBER(10);
  BEGIN
    dbms_output.put_line('WaterBoundary_Surface table is being copied...');
    FOR waterboundary_surface IN waterboundary_surface_v2 LOOP
        -- Check Type
        IF waterboundary_surface.type IS NOT NULL THEN
           select id into classID from OBJECTCLASS where classname = waterboundary_surface.type;
        END IF;
        
        -- Update the cityobject_id entry in surface_geometry table
        IF waterboundary_surface.LOD2_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterboundary_surface.ID||' 
                              where ID = ' || waterboundary_surface.LOD2_SURFACE_ID;
        END IF;
        IF waterboundary_surface.LOD3_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterboundary_surface.ID||' 
                              where ID = ' || waterboundary_surface.LOD3_SURFACE_ID;
        END IF;
        IF waterboundary_surface.LOD4_SURFACE_ID IS NOT NULL THEN         
           EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = '||waterboundary_surface.ID||' 
                              where ID = ' || waterboundary_surface.LOD4_SURFACE_ID;
        END IF;

        insert into waterboundary_surface
        (ID,OBJECTCLASS_ID,WATER_LEVEL,LOD2_SURFACE_ID,LOD3_SURFACE_ID,
        LOD4_SURFACE_ID)
        values
        (waterboundary_surface.ID,classID,waterboundary_surface.WATER_LEVEL,
        waterboundary_surface.LOD2_SURFACE_ID,waterboundary_surface.LOD3_SURFACE_ID,
        waterboundary_surface.LOD4_SURFACE_ID);

        -- Insert the name and the description of the water boundary surface
        -- into the cityobject table
        update cityobject
        set
        name = waterboundary_surface.name,
        name_codespace = waterboundary_surface.name_codespace,
        description = waterboundary_surface.description
        where id = waterboundary_surface.id;
    END LOOP;
    dbms_output.put_line('WaterBoundary_Surface table copy is completed.');
  END;

  PROCEDURE fillWaterbodToWaterbndSrfTable
  IS
  BEGIN
    dbms_output.put_line('Waterbod_To_Waterbnd_Srf table is being copied...');
    insert into waterbod_to_waterbnd_srf select * from waterbod_to_waterbnd_srf_v2;
    dbms_output.put_line('Waterbod_To_Waterbnd_Srf table copy is completed.');
  END;

  PROCEDURE updateSurfaceGeoTableCityObj
  IS
    -- variables --    
    CURSOR surface_geometry_v3 IS select * from surface_geometry order by id;
    CURSOR surface_geometry_xv3 IS select * from surface_geometry where parent_id IN 
                                  (select s.id from 
                                  implicit_geometry i, surface_geometry s
                                  where i.relative_brep_id = s.id 
                                  and s.is_xlink = 0);
  BEGIN
    dbms_output.put_line('Surface_Geometry table is being updated...');
    FOR surface_geometry IN surface_geometry_v3 LOOP        
        IF (surface_geometry.CITYOBJECT_ID IS NOT NULL) THEN
        EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = :1 where PARENT_ID = :2'
                              USING surface_geometry.CITYOBJECT_ID, 
                              surface_geometry.ID;
        END IF;
      IF (surface_geometry.IS_SOLID = 1) THEN
         EXECUTE IMMEDIATE 'update surface_geometry set 
                              CITYOBJECT_ID = :1 where ROOT_ID = :2'
                              USING surface_geometry.CITYOBJECT_ID, 
                              surface_geometry.ID;
	 END IF;
    END LOOP;
    FOR surface_geometry_x IN surface_geometry_xv3 LOOP        
        IF (surface_geometry_x.GEOMETRY IS NOT NULL) THEN
          EXECUTE IMMEDIATE 'update surface_geometry set IMPLICIT_GEOMETRY = :1, 
          GEOMETRY = null where ID = :2' 
          USING surface_geometry_x.GEOMETRY, surface_geometry_x.ID;
        END IF;
    END LOOP;
    dbms_output.put_line('Surface_Geometry table is updated.');
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