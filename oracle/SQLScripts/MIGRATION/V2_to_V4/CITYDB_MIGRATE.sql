-- 3D City Database - The Open Source CityGML Database
-- https://www.3dcitydb.org/
--
-- Copyright 2013 - 2021
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.lrg.tum.de/gis/
--
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
--
-- Virtual City Systems, Berlin <https://vc.systems/>
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

CREATE OR REPLACE PACKAGE citydb_migrate
AS
  FUNCTION convertPolygonToSdoForm(polygon IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION convertVarcharToSDOGeom(polygon IN VARCHAR2) RETURN SDO_GEOMETRY;
  PROCEDURE fillSurfaceGeometryTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillCityObjectTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillCityModelTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillAddressTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillBuildingTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillAddressToBuildingTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillAppearanceTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillSurfaceDataTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillTexImageTable(op CHAR, v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillAppearToSurfaceDataTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillBreaklineReliefTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillRoomTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillBuildingFurnitureTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillBuildingInstallationTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillImplicitGeometryTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillCityFurnitureTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillCityObjectGenAttrTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillCityObjectMemberTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillCityObjectGroupTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillExternalReferenceTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillGeneralizationTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillGenericCityObjectTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillGroupToCityObject(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillLandUseTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillMassPointReliefTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillOpeningTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillThematicSurfaceTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillOpeningToThemSurfaceTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillPlantCoverTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillReliefComponentTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillReliefFeatToRelCompTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillReliefFeatureTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillSolitaryVegetatObjectTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillTextureParamTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillTinReliefTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillTrafficAreaTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillTransportationComplex(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillWaterBodyTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillWaterBoundarySurfaceTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE fillWaterbodToWaterbndSrfTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE updateSurfaceDataTable(op CHAR, v2_schema_name VARCHAR2 := USER);
  PROCEDURE updateSurfaceGeometryTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE updateCityObjectTable(v2_schema_name VARCHAR2 := USER);
  PROCEDURE updateSolidGeometry;
  PROCEDURE updateSequences;
END citydb_migrate;
/

CREATE OR REPLACE PACKAGE BODY citydb_migrate
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

  PROCEDURE fillSurfaceGeometryTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Surface_Geometry table is being copied...');
    EXECUTE IMMEDIATE '
      INSERT /*+ APPEND */ INTO surface_geometry
      SELECT
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
              select 1 from '||v2_schema_name||'.surface_geometry s2
              where
              (s2.ID = s.ID and s2.is_solid = 1)
              OR
              (s.parent_id is not null and s2.ID = s.parent_id and s2.is_xlink = 1)
        ) then null else s.geometry end as geometry,
        CAST(null AS SDO_GEOMETRY) as solid_geometry,
        case when exists (
              select 1 from '||v2_schema_name||'.surface_geometry s2
              where s.parent_id is not null and s2.ID = s.parent_id and s2.is_xlink = 1
        ) then s.geometry else null end as implicit_geometry,
        CAST(null AS NUMBER) as cityobject_id
      FROM '||v2_schema_name||'.surface_geometry s';
      dbms_output.put_line('Surface_Geometry table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityObjectTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('CityObject table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO cityobject
	  SELECT
		ID, CLASS_ID AS OBJECTCLASS_ID, GMLID, GMLID_CODESPACE,
		CAST(null AS VARCHAR2(1000)) as NAME, CAST(null AS VARCHAR2(4000)) as NAME_CODESPACE,
		CAST(null AS VARCHAR2(4000)) as DESCRIPTION, ENVELOPE, CAST(CREATION_DATE AS TIMESTAMP WITH TIME ZONE) AS CREATION_DATE,
		CAST(TERMINATION_DATE AS TIMESTAMP WITH TIME ZONE) AS TERMINATION_DATE, CAST(null AS VARCHAR2(256)) as RELATIVE_TO_TERRAIN,
		CAST(null AS VARCHAR2(256)) as RELATIVE_TO_WATER, CAST(LAST_MODIFICATION_DATE AS TIMESTAMP WITH TIME ZONE) AS LAST_MODIFICATION_DATE,
		UPDATING_PERSON, REASON_FOR_UPDATE, LINEAGE, XML_SOURCE
	   FROM '||v2_schema_name||'.cityobject';
    dbms_output.put_line('CityObject table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityModelTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('CityModel table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO citymodel
      SELECT
        ID, GMLID, GMLID_CODESPACE,
	 REPLACE(NAME, '' --/\-- '', ''--/\--'') AS NAME,
	 REPLACE(NAME_CODESPACE, '' --/\-- '', ''--/\--'') AS NAME_CODESPACE,
	 DESCRIPTION, ENVELOPE,
	 CAST(CREATION_DATE AS TIMESTAMP WITH TIME ZONE) AS CREATION_DATE,
	 CAST(TERMINATION_DATE AS TIMESTAMP WITH TIME ZONE) AS TERMINATION_DATE,
	 CAST(LAST_MODIFICATION_DATE AS TIMESTAMP WITH TIME ZONE) AS LAST_MODIFICATION_DATE,
	 UPDATING_PERSON, REASON_FOR_UPDATE, LINEAGE
      FROM '||v2_schema_name||'.citymodel';
    dbms_output.put_line('CityModel table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillAddressTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Address table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO address
	  SELECT ID, ''ID_''||ID as GMLID,
                 CAST(null AS VARCHAR2(1000)) as GMLID_CODESPACE,
                 STREET, HOUSE_NUMBER, PO_BOX, ZIP_CODE, CITY,
                 STATE, COUNTRY, MULTI_POINT, XAL_SOURCE
      FROM '||v2_schema_name||'.address';
    dbms_output.put_line('Address table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillBuildingTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Building table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO building
	  SELECT
	    ID, (select class_id from '||v2_schema_name||'.cityobject c where c.id = b.ID) AS OBJECTCLASS_ID,
        BUILDING_PARENT_ID, BUILDING_ROOT_ID, replace(trim(CLASS),'' '',''--/\--'') as CLASS,
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
	      select 1 from '||v2_schema_name||'.surface_geometry s2
	      where
	      (s2.ID = b.lod1_geometry_id and s2.is_solid = 1)
	    ) then null else b.lod1_geometry_id end as LOD1_MULTI_SURFACE_ID,
	    case when exists (
	      select 1 from '||v2_schema_name||'.surface_geometry s2
	      where
	      (s2.ID = b.lod2_geometry_id and s2.is_solid = 1)
	    ) then null else b.lod2_geometry_id end as LOD2_MULTI_SURFACE_ID,
	    case when exists (
	      select 1 from '||v2_schema_name||'.surface_geometry s2
	      where
	      (s2.ID = b.lod3_geometry_id and s2.is_solid = 1)
	    ) then null else b.lod3_geometry_id end as LOD3_MULTI_SURFACE_ID,
	    case when exists (
	      select 1 from '||v2_schema_name||'.surface_geometry s2
	      where
	      (s2.ID = b.lod4_geometry_id and s2.is_solid = 1)
	    ) then null else b.lod4_geometry_id end as LOD4_MULTI_SURFACE_ID,
	    case when exists (
	      select 1 from '||v2_schema_name||'.surface_geometry s2
	      where
	      (s2.ID = b.lod1_geometry_id and s2.is_solid = 1)
	    ) then b.lod1_geometry_id else null end as LOD1_SOLID_ID,
	    case when exists (
	      select 1 from '||v2_schema_name||'.surface_geometry s2
	      where
	      (s2.ID = b.lod2_geometry_id and s2.is_solid = 1)
	    ) then b.lod2_geometry_id else null end as LOD2_SOLID_ID,
	    case when exists (
	      select 1 from '||v2_schema_name||'.surface_geometry s2
	      where
	      (s2.ID = b.lod3_geometry_id and s2.is_solid = 1)
	    ) then b.lod3_geometry_id else null end as LOD3_SOLID_ID,
	    case when exists (
	      select 1 from '||v2_schema_name||'.surface_geometry s2
	      where
	      (s2.ID = b.lod4_geometry_id and s2.is_solid = 1)
	    ) then b.lod4_geometry_id else null end as LOD4_SOLID_ID
	  FROM '||v2_schema_name||'.building b';
    dbms_output.put_line('Building table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillAddressToBuildingTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Address_to_Building table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO address_to_building
	SELECT * FROM '||v2_schema_name||'.address_to_building';
    dbms_output.put_line('Address_to_Building table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillAppearanceTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Appearance table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO appearance
	SELECT * FROM '||v2_schema_name||'.appearance';
    dbms_output.put_line('Appearance table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillSurfaceDataTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Surface_data table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO surface_data
      SELECT
        ID,GMLID,GMLID_CODESPACE, NAME, NAME_CODESPACE, DESCRIPTION,IS_FRONT,
        (select id from '||v2_schema_name||'.objectclass where classname = s.type) AS OBJECTCLASS_ID,
        X3D_SHININESS, X3D_TRANSPARENCY, X3D_AMBIENT_INTENSITY,
        X3D_SPECULAR_COLOR, X3D_DIFFUSE_COLOR, X3D_EMISSIVE_COLOR, X3D_IS_SMOOTH,
        CAST(null AS NUMBER) AS TEX_IMAGE_ID, TEX_TEXTURE_TYPE, TEX_WRAP_MODE, TEX_BORDER_COLOR,
        GT_PREFER_WORLDFILE, GT_ORIENTATION, GT_REFERENCE_POINT
      FROM '||v2_schema_name||'.surface_data s';
    dbms_output.put_line('Surface_data table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTexImageTable(op CHAR, v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Tex_Image table is copied from Surface_Data...');  
    IF upper(op) <> 'YES' AND upper(op) <> 'Y' THEN
      -- Add the Tex into the Tex Table
      -- ORDIMAGE to BLOB conversion via ordsys.ordimage.getContent
      EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO tex_image
        SELECT
          id, tex_image_uri,
          ordsys.ordimage.getContent(tex_image),
          tex_mime_type, CAST(null AS VARCHAR2(4000)) AS tex_mime_type_codespace
        FROM '||v2_schema_name||'.surface_data
        WHERE tex_image_uri IS NOT NULL
           OR tex_image IS NOT NULL
           OR tex_mime_type IS NOT NULL
        ORDER BY id';
    ELSE
      EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO tex_image
        SELECT
          TEX_IMAGE_SEQ.NEXTVAL, sd_v2.tex_image_uri,
          ordsys.ordimage.getContent(sd_v2.tex_image),
          sd_v2.tex_mime_type, CAST(null AS VARCHAR2(4000)) AS tex_mime_type_codespace
        FROM '||v2_schema_name||'.surface_data sd_v2,
          (SELECT min(id) AS sample_id FROM '||v2_schema_name||'.surface_data WHERE tex_image_uri IS NOT NULL GROUP BY tex_image_uri) sample
        WHERE sd_v2.id = sample.sample_id';
    END IF;
    dbms_output.put_line('Tex_Image copy is completed. ' || SYSTIMESTAMP);
  END;

  PROCEDURE fillAppearToSurfaceDataTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Appear_to_Surface_Data table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO appear_to_surface_data
	SELECT * FROM '||v2_schema_name||'.appear_to_surface_data';
    dbms_output.put_line('Appear_to_Surface_Data table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillBreaklineReliefTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Breakline_Relief table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO breakline_relief
	SELECT ID, 18 AS OBJECTCLASS_ID, RIDGE_OR_VALLEY_LINES, BREAK_LINES FROM '||v2_schema_name||'.breakline_relief';
    dbms_output.put_line('Breakline_Relief table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillRoomTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Room table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO room
	SELECT ID, 41 AS OBJECTCLASS_ID,
          CAST(replace(trim(r.CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
	      CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
	      CAST(replace(trim(r.FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
	      CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
	      CAST(replace(trim(r.USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
	      CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
	      r.BUILDING_ID,
	      case when exists (
		      select 1 from '||v2_schema_name||'.surface_geometry s
		      where
		      (s.ID = r.lod4_geometry_id and s.is_solid = 1)
		    ) then null else r.lod4_geometry_id end as LOD4_MULTI_SURFACE_ID,
	      case when exists (
		      select 1 from '||v2_schema_name||'.surface_geometry s
		      where
		      (s.ID = r.lod4_geometry_id and s.is_solid = 1)
		    ) then r.lod4_geometry_id else null end as LOD4_SOLID_ID
	FROM '||v2_schema_name||'.room r';

    dbms_output.put_line('Room table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillBuildingFurnitureTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Building_Furniture table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO building_furniture
	SELECT ID, 40 AS OBJECTCLASS_ID,
        CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
		CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
		CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
		CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
		CAST(replace(trim(USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
		CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
		ROOM_ID, LOD4_GEOMETRY_ID AS LOD4_BREP_ID,
		CAST(null AS SDO_GEOMETRY) as LOD4_OTHER_GEOM,
		LOD4_IMPLICIT_REP_ID, LOD4_IMPLICIT_REF_POINT,
		LOD4_IMPLICIT_TRANSFORMATION
	FROM '||v2_schema_name||'.building_furniture';

    dbms_output.put_line('Building_Furniture table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillBuildingInstallationTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Building_Installation table is being copied...');
    EXECUTE IMMEDIATE '
	INSERT /*+ APPEND */ INTO building_installation
	  SELECT ID, 
	    CASE is_external
	      WHEN 1 THEN (select id from '||v2_schema_name||'.OBJECTCLASS where classname = ''BuildingInstallation'')
	      ELSE (select id from '||v2_schema_name||'.OBJECTCLASS where classname = ''IntBuildingInstallation'')
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
	  FROM '||v2_schema_name||'.building_installation';

    dbms_output.put_line('Building_Installation table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillImplicitGeometryTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Implicit_Geometry table is being copied...');
    EXECUTE IMMEDIATE '
    INSERT /*+ APPEND */ INTO implicit_geometry
	SELECT ID, MIME_TYPE, REFERENCE_TO_LIBRARY,
		LIBRARY_OBJECT, RELATIVE_GEOMETRY_ID AS RELATIVE_BREP_ID,
		CAST(null AS SDO_GEOMETRY) as RELATIVE_OTHER_GEOM
	FROM '||v2_schema_name||'.implicit_geometry';
    dbms_output.put_line('Implicit_Geometry table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityFurnitureTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('City_Furniture table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO city_furniture
			  SELECT ID, 21 AS OBJECTCLASS_ID,
					CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
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
			  FROM '||v2_schema_name||'.city_furniture';

    dbms_output.put_line('City_Furniture table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityObjectGenAttrTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('CityObject_GenericAttrib table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO cityobject_genericattrib
			    SELECT ID, CAST(null AS NUMBER) as PARENT_GENATTRIB_ID,
				    CAST(ID AS NUMBER) AS ROOT_GENATTRIB_ID, ATTRNAME, DATATYPE,
				    STRVAL, INTVAL, REALVAL, URIVAL,
				    CAST(DATEVAL AS TIMESTAMP WITH TIME ZONE) AS DATEVAL,
				    CAST(null AS VARCHAR2(4000)) as UNIT,
				    CAST(null AS VARCHAR2(4000)) as GENATTRIBSET_CODESPACE,
				    BLOBVAL, GEOMVAL, SURFACE_GEOMETRY_ID, CITYOBJECT_ID
			    FROM '||v2_schema_name||'.cityobject_genericattrib';
    dbms_output.put_line('CityObject_GenericAttrib table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityObjectMemberTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('CityObject_Member table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO cityobject_member
			  SELECT * FROM '||v2_schema_name||'.cityobject_member';
    dbms_output.put_line('CityObject_Member table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillCityObjectGroupTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('CityObjectGroup table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO cityobjectgroup
			  SELECT ID, 23 AS OBJECTCLASS_ID,
                  CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
				  CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
				  CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
				  CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
				  CAST(null AS VARCHAR2(1000)) AS USAGE,
				  CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
				  SURFACE_GEOMETRY_ID AS BREP_ID,
				  GEOMETRY AS OTHER_GEOM, PARENT_CITYOBJECT_ID
			  FROM '||v2_schema_name||'.cityobjectgroup';
    dbms_output.put_line('CityObjectGroup table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillExternalReferenceTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('External_Reference table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO external_reference
			  SELECT * FROM '||v2_schema_name||'.external_reference';
    dbms_output.put_line('External_Reference table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillGeneralizationTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Generalization table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO generalization
			  SELECT * FROM '||v2_schema_name||'.generalization';
    dbms_output.put_line('Generalization table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillGenericCityObjectTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Generic_CityObject table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO generic_cityobject
			  SELECT ID, 5 AS OBJECTCLASS_ID,
				   CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
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
				 FROM '||v2_schema_name||'.generic_cityobject';
    dbms_output.put_line('Generic_CityObject table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillGroupToCityObject(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Group_To_CityObject table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO group_to_cityobject
			  SELECT * FROM '||v2_schema_name||'.group_to_cityobject';
    dbms_output.put_line('Group_To_CityObject table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillLandUseTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Land_Use table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO land_use
			  SELECT ID, 4 AS OBJECTCLASS_ID,
			   CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
			   CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			   CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			   CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			   CAST(null AS VARCHAR2(1000)) AS USAGE,
			   CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			   LOD0_MULTI_SURFACE_ID, LOD1_MULTI_SURFACE_ID,
			   LOD2_MULTI_SURFACE_ID, LOD3_MULTI_SURFACE_ID, LOD4_MULTI_SURFACE_ID
			 FROM '||v2_schema_name||'.land_use';
    dbms_output.put_line('Land_Use table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillMassPointReliefTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('MassPoint_Relief table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO masspoint_relief
			  SELECT ID, 17 AS OBJECTCLASS_ID, RELIEF_POINTS FROM '||v2_schema_name||'.masspoint_relief';
    dbms_output.put_line('MassPoint_Relief table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillOpeningTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Opening table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO opening
			      SELECT o.ID,
			      (select oc.id from '||v2_schema_name||'.objectclass oc where oc.classname = o.type) AS OBJECTCLASS_ID,
			      o.ADDRESS_ID, o.LOD3_MULTI_SURFACE_ID, o.LOD4_MULTI_SURFACE_ID,
			      CAST(null AS NUMBER) as LOD3_IMPLICIT_REP_ID,
			      CAST(null AS NUMBER) as LOD4_IMPLICIT_REP_ID,
			      CAST(null AS SDO_GEOMETRY) as LOD3_IMPLICIT_REF_POINT,
			      CAST(null AS SDO_GEOMETRY) as LOD4_IMPLICIT_REF_POINT,
			      CAST(null AS VARCHAR2(1000)) as LOD3_IMPLICIT_TRANSFORMATION,
			      CAST(null AS VARCHAR2(1000)) as LOD4_IMPLICIT_TRANSFORMATION
			      FROM '||v2_schema_name||'.opening o';
    dbms_output.put_line('Opening table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillThematicSurfaceTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Thematic_Surface table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO thematic_surface
			  SELECT t.ID,
			      (select oc.id from '||v2_schema_name||'.objectclass oc where oc.classname = t.type) AS OBJECTCLASS_ID,
			      BUILDING_ID, ROOM_ID,
			      CAST(null AS NUMBER) as BUILDING_INSTALLATION_ID,
			      LOD2_MULTI_SURFACE_ID, LOD3_MULTI_SURFACE_ID, LOD4_MULTI_SURFACE_ID
			  FROM '||v2_schema_name||'.thematic_surface t';
    dbms_output.put_line('Thematic_Surface table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillOpeningToThemSurfaceTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Opening_To_Them_Surface table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO opening_to_them_surface
			  SELECT * FROM '||v2_schema_name||'.opening_to_them_surface';
    dbms_output.put_line('Opening_To_Them_Surface table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillPlantCoverTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Plant_Cover table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO plant_cover
			  SELECT ID, 8 AS OBJECTCLASS_ID,
              CAST(null AS VARCHAR2(1000)) AS USAGE,
			  CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			  CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
			  CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			  CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			  CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			  AVERAGE_HEIGHT, CAST(null AS VARCHAR2(4000)) as AVERAGE_HEIGHT_UNIT,
			  case when exists (
			   select 1 from '||v2_schema_name||'.surface_geometry s
			   where
			   (s.ID = p.lod1_geometry_id and s.is_solid = 1)
			  ) then null else p.lod1_geometry_id end as LOD1_MULTI_SURFACE_ID,
			  case when exists (
			   select 1 from '||v2_schema_name||'.surface_geometry s
			   where
			   (s.ID = p.lod2_geometry_id and s.is_solid = 1)
			  ) then null else p.lod2_geometry_id end as LOD2_MULTI_SURFACE_ID,
			  case when exists (
			   select 1 from '||v2_schema_name||'.surface_geometry s
			   where
			   (s.ID = p.lod3_geometry_id and s.is_solid = 1)
			  ) then null else p.lod3_geometry_id end as LOD3_MULTI_SURFACE_ID,
			  case when exists (
			   select 1 from '||v2_schema_name||'.surface_geometry s
			   where
			   (s.ID = p.lod4_geometry_id and s.is_solid = 1)
			  ) then null else p.lod4_geometry_id end as LOD4_MULTI_SURFACE_ID,
			  case when exists (
			   select 1 from '||v2_schema_name||'.surface_geometry s
			   where
			   (s.ID = p.lod1_geometry_id and s.is_solid = 1)
			  ) then p.lod1_geometry_id else null end as LOD1_MULTI_SOLID_ID,
			  case when exists (
			   select 1 from '||v2_schema_name||'.surface_geometry s
			   where
			   (s.ID = p.lod2_geometry_id and s.is_solid = 1)
			  ) then p.lod2_geometry_id else null end as LOD2_MULTI_SOLID_ID,
			  case when exists (
			   select 1 from '||v2_schema_name||'.surface_geometry s
			   where
			   (s.ID = p.lod3_geometry_id and s.is_solid = 1)
			  ) then p.lod3_geometry_id else null end as LOD3_MULTI_SOLID_ID,
			  case when exists (
			   select 1 from '||v2_schema_name||'.surface_geometry s
			   where
			   (s.ID = p.lod4_geometry_id and s.is_solid = 1)
			  ) then p.lod4_geometry_id else null end as LOD4_MULTI_SOLID_ID
			  FROM '||v2_schema_name||'.plant_cover p';
    dbms_output.put_line('Plant_Cover table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillReliefComponentTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Relief_Component table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO relief_component
			  SELECT ID,
			    (select class_id from '||v2_schema_name||'.CITYOBJECT c where c.id = r.ID) AS OBJECTCLASS_ID,
			    LOD, EXTENT
			  FROM '||v2_schema_name||'.relief_component r';
    dbms_output.put_line('Relief_Component table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillReliefFeatToRelCompTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Relief_Feat_To_Rel_Comp table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO relief_feat_to_rel_comp
			  SELECT * FROM '||v2_schema_name||'.relief_feat_to_rel_comp';
    dbms_output.put_line('Relief_Feat_To_Rel_Comp table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillReliefFeatureTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Relief_Feature table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO relief_feature
			  SELECT ID, 14 AS OBJECTCLASS_ID, LOD FROM '||v2_schema_name||'.relief_feature';
    dbms_output.put_line('Relief_Feature table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillSolitaryVegetatObjectTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Solitary_Vegetat_Object table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO solitary_vegetat_object
				SELECT ID, 7 AS OBJECTCLASS_ID,
                CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
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
				FROM '||v2_schema_name||'.solitary_vegetat_object';
    dbms_output.put_line('Solitary_Vegetat_Object table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTextureParamTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('TextureParam table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO textureparam
			  SELECT SURFACE_GEOMETRY_ID, IS_TEXTURE_PARAMETRIZATION, WORLD_TO_TEXTURE,
			  citydb_migrate.convertVarcharToSDOGeom(TEXTURE_COORDINATES) AS TEXTURE_COORDINATES, SURFACE_DATA_ID
			  FROM '||v2_schema_name||'.textureparam';
    dbms_output.put_line('TextureParam table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTinReliefTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Tin Relief table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO tin_relief
				SELECT ID, 16 AS OBJECTCLASS_ID, MAX_LENGTH,
				CAST(null AS VARCHAR2(4000)) as MAX_LENGTH_UNIT,
				STOP_LINES, BREAK_LINES, CONTROL_POINTS, SURFACE_GEOMETRY_ID
			  FROM '||v2_schema_name||'.tin_relief';
    dbms_output.put_line('Tin Relief table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTrafficAreaTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Traffic_Area table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO traffic_area
			  SELECT ID,
			   CASE is_auxiliary
			   WHEN 1 THEN (select id from '||v2_schema_name||'.objectclass where classname = ''AuxiliaryTrafficArea'')
			   ELSE (select id from '||v2_schema_name||'.objectclass where classname = ''TrafficArea'')
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
			  FROM '||v2_schema_name||'.traffic_area';
    dbms_output.put_line('Traffic_Area table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillTransportationComplex(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Transportation_Complex table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO transportation_complex
			  SELECT ID,
			   (select o.id from '||v2_schema_name||'.objectclass o where o.classname = t.type) AS OBJECTCLASS_ID,
			   CAST(null AS VARCHAR2(256)) AS CLASS,
			   CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			   CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			   CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			   CAST(replace(trim(USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
			   CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			   LOD0_NETWORK, LOD1_MULTI_SURFACE_ID, LOD2_MULTI_SURFACE_ID,
			   LOD3_MULTI_SURFACE_ID, LOD4_MULTI_SURFACE_ID
			  FROM '||v2_schema_name||'.transportation_complex t';
    dbms_output.put_line('Transportation_Complex table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillWaterBodyTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('WaterBody table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO waterbody
			  SELECT ID, 9 AS OBJECTCLASS_ID,
			   CAST(replace(trim(CLASS),'' '',''--/\--'') AS VARCHAR2(256)) AS CLASS,
			   CAST(null AS VARCHAR2(4000)) as CLASS_CODESPACE,
			   CAST(replace(trim(FUNCTION),'' '',''--/\--'') AS VARCHAR2(1000)) AS FUNCTION,
			   CAST(null AS VARCHAR2(4000)) as FUNCTION_CODESPACE,
			   CAST(replace(trim(USAGE),'' '',''--/\--'') AS VARCHAR2(1000)) AS USAGE,
			   CAST(null AS VARCHAR2(4000)) as USAGE_CODESPACE,
			   LOD0_MULTI_CURVE, LOD1_MULTI_CURVE, LOD0_MULTI_SURFACE_ID,
			   LOD1_MULTI_SURFACE_ID, LOD1_SOLID_ID, LOD2_SOLID_ID,
			   LOD3_SOLID_ID, LOD4_SOLID_ID
			  FROM '||v2_schema_name||'.waterbody t';
    dbms_output.put_line('WaterBody table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillWaterBoundarySurfaceTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('WaterBoundary_Surface table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO waterboundary_surface
			  SELECT ID,
			   (select o.id from '||v2_schema_name||'.objectclass o where o.classname = w.type) AS OBJECTCLASS_ID,
			   WATER_LEVEL, CAST(null AS VARCHAR2(4000)) as WATER_LEVEL_CODESPACE,
			   LOD2_SURFACE_ID, LOD3_SURFACE_ID, LOD4_SURFACE_ID
			  FROM '||v2_schema_name||'.waterboundary_surface w';
    dbms_output.put_line('WaterBoundary_Surface table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE fillWaterbodToWaterbndSrfTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Waterbod_To_Waterbnd_Srf table is being copied...');
    EXECUTE IMMEDIATE 'INSERT /*+ APPEND */ INTO waterbod_to_waterbnd_srf
			  SELECT * FROM '||v2_schema_name||'.waterbod_to_waterbnd_srf';
    dbms_output.put_line('Waterbod_To_Waterbnd_Srf table copy is completed.' || SYSTIMESTAMP);
  END;

  PROCEDURE updateSurfaceDataTable(op CHAR, v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Surface_Data table is being updated...');  
    IF upper(op) <> 'YES' AND upper(op) <> 'Y' THEN
      -- update the reference in the surface_data table
      UPDATE (
        SELECT ti.id AS t, sd.id AS s
          FROM surface_data sd
          INNER JOIN tex_image ti
          ON sd.id = ti.id
      ) tex
      SET tex.t = tex.s;
    ELSE
      EXECUTE IMMEDIATE 'UPDATE surface_data sd_v4 SET tex_image_id = (
          SELECT t.id FROM tex_image t, '||v2_schema_name||'.surface_data sd_v2
              WHERE sd_v4.id = sd_v2.id AND sd_v2.tex_image_uri = t.tex_image_uri)';
    END IF;
    dbms_output.put_line('Surface_Data table is updated. ' || SYSTIMESTAMP);  
  END;
  
  PROCEDURE updateSurfaceGeometryTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Surface_Geometry table is being updated...');
    -- BUILDING
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from '||v2_schema_name||'.building b
			 where b.LOD1_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.building b
			 where b.LOD1_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from '||v2_schema_name||'.building b
			 where b.LOD2_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.building b
			 where b.LOD2_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from '||v2_schema_name||'.building b
			 where b.LOD3_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.building b
			 where b.LOD3_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from '||v2_schema_name||'.building b
			 where b.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.building b
			 where b.LOD4_GEOMETRY_ID = s.id)';
    -- ROOM
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select r.id from '||v2_schema_name||'.room r
			 where r.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.room r
			 where r.LOD4_GEOMETRY_ID = s.id)';
    -- BUILDING FURNITURE
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from '||v2_schema_name||'.building_furniture b
			 where b.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.building_furniture b
			 where b.LOD4_GEOMETRY_ID = s.id)';
    -- BUILDING INSTALLATION
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from '||v2_schema_name||'.building_installation b
			 where b.LOD2_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.building_installation b
			 where b.LOD2_GEOMETRY_ID = s.id)';

    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from '||v2_schema_name||'.building_installation b
			 where b.LOD3_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.building_installation b
			 where b.LOD3_GEOMETRY_ID = s.id)';

    EXECUTE IMMEDIATE 'update surface_geometry s
			set (CITYOBJECT_ID) =
			(select b.id from '||v2_schema_name||'.building_installation b
			 where b.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.building_installation b
			 where b.LOD4_GEOMETRY_ID = s.id)';
    -- CITY FURNITURE
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from '||v2_schema_name||'.city_furniture c
			 where c.LOD1_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.city_furniture c
			 where c.LOD1_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from '||v2_schema_name||'.city_furniture c
			 where c.LOD2_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.city_furniture c
			 where c.LOD2_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from '||v2_schema_name||'.city_furniture c
			 where c.LOD3_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.city_furniture c
			 where c.LOD3_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from '||v2_schema_name||'.city_furniture c
			 where c.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.city_furniture c
			 where c.LOD4_GEOMETRY_ID = s.id)';
    -- CITY OBJECT GENERIC ATTRIBUTE
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.cityobject_id from '||v2_schema_name||'.cityobject_genericattrib g
			 where g.SURFACE_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.cityobject_genericattrib g
			 where g.SURFACE_GEOMETRY_ID = s.id)';
    -- CITY OBJECT GROUP
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select c.id from '||v2_schema_name||'.cityobjectgroup c
			 where c.SURFACE_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.cityobjectgroup c
			 where c.SURFACE_GEOMETRY_ID = s.id)';
    -- GENERIC CITY OBJECT
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD0_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD0_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD1_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD1_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD2_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD2_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD3_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD3_GEOMETRY_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select g.id from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD4_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.generic_cityobject g
			 where g.LOD4_GEOMETRY_ID = s.id)';
    -- LAND USE
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from '||v2_schema_name||'.land_use l
			 where l.LOD0_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.land_use l
			 where l.LOD0_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from '||v2_schema_name||'.land_use l
			 where l.LOD1_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.land_use l
			 where l.LOD1_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from '||v2_schema_name||'.land_use l
			 where l.LOD2_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.land_use l
			 where l.LOD2_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from '||v2_schema_name||'.land_use l
			 where l.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.land_use l
			 where l.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select l.id from '||v2_schema_name||'.land_use l
			 where l.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.land_use l
			 where l.LOD4_MULTI_SURFACE_ID = s.id)';
    -- OPENING
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select o.id from '||v2_schema_name||'.opening o
			 where o.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.opening o
			 where o.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select o.id from '||v2_schema_name||'.opening o
			 where o.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.opening o
			 where o.LOD4_MULTI_SURFACE_ID = s.id)';
    -- THEMATIC SURFACE
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.thematic_surface t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.thematic_surface t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.thematic_surface t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.thematic_surface t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.thematic_surface t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.thematic_surface t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)';
    -- PLANT COVER
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select p.id from '||v2_schema_name||'.plant_cover p
			 where p.lod1_geometry_id = s.id)
			where exists
			(select * from '||v2_schema_name||'.plant_cover p
			 where p.lod1_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select p.id from '||v2_schema_name||'.plant_cover p
			 where p.lod2_geometry_id = s.id)
			where exists
			(select * from '||v2_schema_name||'.plant_cover p
			 where p.lod2_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select p.id from '||v2_schema_name||'.plant_cover p
			 where p.lod3_geometry_id = s.id)
			where exists
			(select * from '||v2_schema_name||'.plant_cover p
			 where p.lod3_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select p.id from '||v2_schema_name||'.plant_cover p
			 where p.lod4_geometry_id = s.id)
			where exists
			(select * from '||v2_schema_name||'.plant_cover p
			 where p.lod4_geometry_id = s.id)';
    -- SOLITARY VEGETATION OBJECT
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.id from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.lod1_geometry_id = s.id)
			where exists
			(select * from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.lod1_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.id from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.lod2_geometry_id = s.id)
			where exists
			(select * from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.lod2_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.id from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.lod3_geometry_id = s.id)
			where exists
			(select * from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.lod3_geometry_id = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select sv.id from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.lod4_geometry_id = s.id)
			where exists
			(select * from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.lod4_geometry_id = s.id)';
    -- TIN RELIEF
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.tin_relief t
			 where t.SURFACE_GEOMETRY_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.tin_relief t
			 where t.SURFACE_GEOMETRY_ID = s.id)';
    -- TRAFFIC AREA
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.traffic_area t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.traffic_area t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.traffic_area t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.traffic_area t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.traffic_area t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.traffic_area t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)';
    -- TRANSPORTATION COMPLEX
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.transportation_complex t
			 where t.LOD1_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.transportation_complex t
			 where t.LOD1_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.transportation_complex t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.transportation_complex t
			 where t.LOD2_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.transportation_complex t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.transportation_complex t
			 where t.LOD3_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select t.id from '||v2_schema_name||'.transportation_complex t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.transportation_complex t
			 where t.LOD4_MULTI_SURFACE_ID = s.id)';
    -- WATER BODY
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterbody w
			 where w.LOD0_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterbody w
			 where w.LOD0_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterbody w
			 where w.LOD1_MULTI_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterbody w
			 where w.LOD1_MULTI_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterbody w
			 where w.LOD1_SOLID_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterbody w
			 where w.LOD1_SOLID_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterbody w
			 where w.LOD2_SOLID_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterbody w
			 where w.LOD2_SOLID_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterbody w
			 where w.LOD3_SOLID_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterbody w
			 where w.LOD3_SOLID_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterbody w
			 where w.LOD4_SOLID_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterbody w
			 where w.LOD4_SOLID_ID = s.id)';
    -- WATER BOUNDARY SURFACE
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterboundary_surface w
			 where w.LOD2_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterboundary_surface w
			 where w.LOD2_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterboundary_surface w
			 where w.LOD3_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterboundary_surface w
			 where w.LOD3_SURFACE_ID = s.id)';
    EXECUTE IMMEDIATE 'update surface_geometry s
			set (s.CITYOBJECT_ID) =
			(select w.id from '||v2_schema_name||'.waterboundary_surface w
			 where w.LOD4_SURFACE_ID = s.id)
			where exists
			(select * from '||v2_schema_name||'.waterboundary_surface w
			 where w.LOD4_SURFACE_ID = s.id)';
    -- CITYOBJECT
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

  PROCEDURE updateCityObjectTable(v2_schema_name VARCHAR2 := USER)
  IS
  BEGIN
    dbms_output.put_line('Cityobject table is being updated...');
    -- BUILDING
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(b.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(b.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace,
				b.description
				from '||v2_schema_name||'.building b
			 where b.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.building b
			 where b.id = c.id)';
    -- ROOM
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(r.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(r.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, r.description from '||v2_schema_name||'.room r
			 where r.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.room r
			 where r.id = c.id)';
    -- BUILDING FURNITURE
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(b.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(b.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, b.description from '||v2_schema_name||'.building_furniture b
			 where b.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.building_furniture b
			 where b.id = c.id)';
    -- BUILDING INSTALLATION
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(b.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(b.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, b.description from '||v2_schema_name||'.building_installation b
			 where b.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.building_installation b
			 where b.id = c.id)';
    -- CITY FURNITURE
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(cf.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(cf.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, cf.description from '||v2_schema_name||'.city_furniture cf
			 where cf.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.city_furniture cf
			 where cf.id = c.id)';
    -- CITY OBJECT GROUP
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(co.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(co.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, co.description from '||v2_schema_name||'.cityobjectgroup co
			 where co.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.cityobjectgroup co
			 where co.id = c.id)';
    -- GENERIC CITY OBJECT
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(g.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(g.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, g.description from '||v2_schema_name||'.generic_cityobject g
			 where g.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.generic_cityobject g
			 where g.id = c.id)';
    -- LAND USE
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(l.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(l.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, l.description from '||v2_schema_name||'.land_use l
			 where l.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.land_use l
			 where l.id = c.id)';
    -- OPENING
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(o.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(o.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, o.description from '||v2_schema_name||'.opening o
			 where o.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.opening o
			 where o.id = c.id)';
    -- THEMATIC SURFACE
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(t.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(t.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, t.description from '||v2_schema_name||'.thematic_surface t
			 where t.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.thematic_surface t
			 where t.id = c.id)';
    -- PLANT COVER
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(p.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(p.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, p.description from '||v2_schema_name||'.plant_cover p
			 where p.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.plant_cover p
			 where p.id = c.id)';
    -- RELIEF COMPONENT
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(r.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(r.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, r.description from '||v2_schema_name||'.relief_component r
			 where r.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.relief_component r
			 where r.id = c.id)';
    -- RELIEF FEATURE
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(r.name, '' --/\-- '', ''--/\--'') AS,
				REPLACE(r.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, r.description from '||v2_schema_name||'.relief_feature r
			 where r.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.relief_feature r
			 where r.id = c.id)';
    -- SOLITARY VEGETATION OBJECT
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(sv.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(sv.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, sv.description from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.solitary_vegetat_object sv
			 where sv.id = c.id)';
    -- TRAFFIC AREA
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(t.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(t.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, t.description from '||v2_schema_name||'.traffic_area t
			 where t.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.traffic_area t
			 where t.id = c.id)';
    -- TRANSPORTATION COMPLEX
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(t.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(t.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, t.description from '||v2_schema_name||'.transportation_complex t
			 where t.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.transportation_complex t
			 where t.id = c.id)';
    -- WATER BODY
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(w.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(w.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, w.description from '||v2_schema_name||'.waterbody w
			 where w.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.waterbody w
			 where w.id = c.id)';
    -- WATER BOUNDARY SURFACE
    EXECUTE IMMEDIATE 'update cityobject c
			set (c.name,c.name_codespace,c.description) =
			(select
				REPLACE(w.name, '' --/\-- '', ''--/\--'') AS name,
				REPLACE(w.name_codespace, '' --/\-- '', ''--/\--'') AS name_codespace, w.description from '||v2_schema_name||'.waterboundary_surface w
			 where w.id = c.id)
			where exists
			(select * from '||v2_schema_name||'.waterboundary_surface w
			 where w.id = c.id)';
    dbms_output.put_line('Cityobject table is updated.' || SYSTIMESTAMP);
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
      from user_sequences
      where sequence_name like '%_SEQ'
      order by sequence_name;
    max_id NUMBER(10) := 0;
    seq_value NUMBER(10) := 0;
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
            EXECUTE IMMEDIATE query_str into max_id;
            -- dbms_output.put_line(user_sequences.sequencename || ':' || max_id);
            IF (max_id IS NOT NULL) THEN
              EXECUTE IMMEDIATE 'select ' || user_sequences.sequencename || '_SEQ.nextval from dual' into seq_value;
              IF (seq_value = 1) THEN
                EXECUTE IMMEDIATE 'select ' || user_sequences.sequencename || '_SEQ.nextval from dual' into seq_value;
              END IF;
              EXECUTE IMMEDIATE 'alter sequence ' || user_sequences.sequencename || '_SEQ increment by ' || (seq_value-1)*-1;
              EXECUTE IMMEDIATE 'alter sequence ' || user_sequences.sequencename || '_SEQ increment by ' || max_id;
              EXECUTE IMMEDIATE 'alter sequence ' || user_sequences.sequencename || '_SEQ increment by 1';
            END IF;
          ELSE
             query_str := 'select table_name from user_tables where table_name
              like ''%'
              || user_sequences.sequencename ||
              '%''';
              -- dbms_output.put_line(query_str);

             EXECUTE IMMEDIATE query_str into corrected_table_name;
             query_str := 'select max(id) from '|| corrected_table_name;
             EXECUTE IMMEDIATE query_str into max_id;
             -- dbms_output.put_line(user_sequences.sequencename || ':' || max_id);
             IF (max_id IS NOT NULL) THEN
              EXECUTE IMMEDIATE 'select ' || user_sequences.sequencename || '_SEQ.nextval from dual' into seq_value;
              IF (seq_value = 1) THEN
                EXECUTE IMMEDIATE 'select ' || user_sequences.sequencename || '_SEQ.nextval from dual' into seq_value;
              END IF;
              EXECUTE IMMEDIATE 'alter sequence ' || user_sequences.sequencename || '_SEQ increment by ' || (seq_value-1)*-1;
              EXECUTE IMMEDIATE 'alter sequence ' || user_sequences.sequencename || '_SEQ increment by ' || max_id;
              EXECUTE IMMEDIATE 'alter sequence ' || user_sequences.sequencename || '_SEQ increment by 1';
             END IF;
          END IF;
        END IF;
      END IF;
      max_id := 0;
      seq_value := 0;
      query_str := 0;
      table_exists := 0;
      corrected_table_name := '';
    END LOOP;
  END;
END citydb_migrate;
/
