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

CREATE INDEX ADDRESS_INX ON ADDRESS (GMLID, GMLID_CODESPACE);

CREATE INDEX ADDRESS_TO_BRIDGE_FKX ON ADDRESS_TO_BRIDGE (ADDRESS_ID);

CREATE INDEX ADDRESS_TO_BRIDGE_FKX1 ON ADDRESS_TO_BRIDGE (BRIDGE_ID);

CREATE INDEX ADDRESS_TO_BUILDING_FKX ON ADDRESS_TO_BUILDING (ADDRESS_ID);

CREATE INDEX ADDRESS_TO_BUILDING_FKX1 ON ADDRESS_TO_BUILDING (BUILDING_ID);

CREATE INDEX APPEARANCE_CITYMODEL_FKX ON APPEARANCE (CITYMODEL_ID);

CREATE INDEX APPEARANCE_CITYOBJECT_FKX ON APPEARANCE (CITYOBJECT_ID);

CREATE INDEX APPEARANCE_INX ON APPEARANCE (GMLID, GMLID_CODESPACE);

CREATE INDEX APPEARANCE_THEME_INX ON APPEARANCE (THEME);

CREATE INDEX APP_TO_SURF_DATA_FKX ON APPEAR_TO_SURFACE_DATA (SURFACE_DATA_ID);

CREATE INDEX APP_TO_SURF_DATA_FKX1 ON APPEAR_TO_SURFACE_DATA (APPEARANCE_ID);

CREATE INDEX BREAKLINE_REL_OBJCLASS_FKX ON BREAKLINE_RELIEF (OBJECTCLASS_ID);

CREATE INDEX BRIDGE_LOD1MSRF_FKX ON BRIDGE (LOD1_MULTI_SURFACE_ID);

CREATE INDEX BRIDGE_LOD1SOLID_FKX ON BRIDGE (LOD1_SOLID_ID);

CREATE INDEX BRIDGE_LOD2MSRF_FKX ON BRIDGE (LOD2_MULTI_SURFACE_ID);

CREATE INDEX BRIDGE_LOD2SOLID_FKX ON BRIDGE (LOD2_SOLID_ID);

CREATE INDEX BRIDGE_LOD3MSRF_FKX ON BRIDGE (LOD3_MULTI_SURFACE_ID);

CREATE INDEX BRIDGE_LOD3SOLID_FKX ON BRIDGE (LOD3_SOLID_ID);

CREATE INDEX BRIDGE_LOD4MSRF_FKX ON BRIDGE (LOD4_MULTI_SURFACE_ID);

CREATE INDEX BRIDGE_LOD4SOLID_FKX ON BRIDGE (LOD4_SOLID_ID);

CREATE INDEX BRIDGE_OBJECTCLASS_FKX ON BRIDGE (OBJECTCLASS_ID);

CREATE INDEX BRIDGE_PARENT_FKX ON BRIDGE (BRIDGE_PARENT_ID);

CREATE INDEX BRIDGE_ROOT_FKX ON BRIDGE (BRIDGE_ROOT_ID);

CREATE INDEX BRIDGE_CONSTR_BRIDGE_FKX ON BRIDGE_CONSTR_ELEMENT (BRIDGE_ID);

CREATE INDEX BRIDGE_CONSTR_LOD1BREP_FKX ON BRIDGE_CONSTR_ELEMENT (LOD1_BREP_ID);

CREATE INDEX BRIDGE_CONSTR_LOD1IMPL_FKX ON BRIDGE_CONSTR_ELEMENT (LOD1_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_CONSTR_LOD2BREP_FK ON BRIDGE_CONSTR_ELEMENT (LOD2_BREP_ID);

CREATE INDEX BRIDGE_CONSTR_LOD2IMPL_FKX ON BRIDGE_CONSTR_ELEMENT (LOD2_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_CONSTR_LOD3BREP_FKX ON BRIDGE_CONSTR_ELEMENT (LOD3_BREP_ID);

CREATE INDEX BRIDGE_CONSTR_LOD3IMPL_FKX ON BRIDGE_CONSTR_ELEMENT (LOD3_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_CONSTR_LOD4BREP_FKX ON BRIDGE_CONSTR_ELEMENT (LOD4_BREP_ID);

CREATE INDEX BRIDGE_CONSTR_LOD4IMPL_FKX ON BRIDGE_CONSTR_ELEMENT (LOD4_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_CONSTR_OBJCLASS_FKX ON BRIDGE_CONSTR_ELEMENT (OBJECTCLASS_ID);

CREATE INDEX BRIDGE_FURN_BRD_ROOM_FKX ON BRIDGE_FURNITURE (BRIDGE_ROOM_ID);

CREATE INDEX BRIDGE_FURN_LOD4BREP_FKX ON BRIDGE_FURNITURE (LOD4_BREP_ID);

CREATE INDEX BRIDGE_FURN_LOD4IMPL_FKX ON BRIDGE_FURNITURE (LOD4_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_FURN_OBJCLASS_FKX ON BRIDGE_FURNITURE (OBJECTCLASS_ID);

CREATE INDEX BRIDGE_INST_BRD_ROOM_FKX ON BRIDGE_INSTALLATION (BRIDGE_ROOM_ID);

CREATE INDEX BRIDGE_INST_BRIDGE_FKX ON BRIDGE_INSTALLATION (BRIDGE_ID);

CREATE INDEX BRIDGE_INST_LOD2BREP_FKX ON BRIDGE_INSTALLATION (LOD2_BREP_ID);

CREATE INDEX BRIDGE_INST_LOD2IMPL_FKX ON BRIDGE_INSTALLATION (LOD2_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_INST_LOD3BREP_FKX ON BRIDGE_INSTALLATION (LOD3_BREP_ID);

CREATE INDEX BRIDGE_INST_LOD3IMPL_FKX ON BRIDGE_INSTALLATION (LOD3_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_INST_LOD4BREP_FKX ON BRIDGE_INSTALLATION (LOD4_BREP_ID);

CREATE INDEX BRIDGE_INST_LOD4IMPL_FKX ON BRIDGE_INSTALLATION (LOD4_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_INST_OBJCLASS_FKX ON BRIDGE_INSTALLATION (OBJECTCLASS_ID);

CREATE INDEX BRIDGE_OPEN_ADDRESS_FKX ON BRIDGE_OPENING (ADDRESS_ID);

CREATE INDEX BRIDGE_OPEN_LOD3IMPL_FKX ON BRIDGE_OPENING (LOD3_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_OPEN_LOD3MSRF_FKX ON BRIDGE_OPENING (LOD3_MULTI_SURFACE_ID);

CREATE INDEX BRIDGE_OPEN_LOD4IMPL_FKX ON BRIDGE_OPENING (LOD4_IMPLICIT_REP_ID);

CREATE INDEX BRIDGE_OPEN_LOD4MSRF_FKX ON BRIDGE_OPENING (LOD4_MULTI_SURFACE_ID);

CREATE INDEX BRIDGE_OPEN_OBJCLASS_FKX ON BRIDGE_OPENING (OBJECTCLASS_ID);

CREATE INDEX BRD_OPEN_TO_THEM_SRF_FKX ON BRIDGE_OPEN_TO_THEM_SRF (BRIDGE_OPENING_ID);

CREATE INDEX BRD_OPEN_TO_THEM_SRF_FKX1 ON BRIDGE_OPEN_TO_THEM_SRF (BRIDGE_THEMATIC_SURFACE_ID);

CREATE INDEX BRIDGE_ROOM_BRIDGE_FKX ON BRIDGE_ROOM (BRIDGE_ID);

CREATE INDEX BRIDGE_ROOM_LOD4MSRF_FKX ON BRIDGE_ROOM (LOD4_MULTI_SURFACE_ID);

CREATE INDEX BRIDGE_ROOM_LOD4SOLID_FKX ON BRIDGE_ROOM (LOD4_SOLID_ID);

CREATE INDEX BRIDGE_ROOM_OBJCLASS_FKX ON BRIDGE_ROOM (OBJECTCLASS_ID);

CREATE INDEX BRD_THEM_SRF_BRD_CONST_FKX ON BRIDGE_THEMATIC_SURFACE (BRIDGE_CONSTR_ELEMENT_ID);

CREATE INDEX BRD_THEM_SRF_BRD_INST_FKX ON BRIDGE_THEMATIC_SURFACE (BRIDGE_INSTALLATION_ID);

CREATE INDEX BRD_THEM_SRF_BRD_ROOM_FKX ON BRIDGE_THEMATIC_SURFACE (BRIDGE_ROOM_ID);

CREATE INDEX BRD_THEM_SRF_BRIDGE_FKX ON BRIDGE_THEMATIC_SURFACE (BRIDGE_ID);

CREATE INDEX BRD_THEM_SRF_LOD2MSRF_FKX ON BRIDGE_THEMATIC_SURFACE (LOD2_MULTI_SURFACE_ID);

CREATE INDEX BRD_THEM_SRF_LOD3MSRF_FKX ON BRIDGE_THEMATIC_SURFACE (LOD3_MULTI_SURFACE_ID);

CREATE INDEX BRD_THEM_SRF_LOD4MSRF_FKX ON BRIDGE_THEMATIC_SURFACE (LOD4_MULTI_SURFACE_ID);

CREATE INDEX BRD_THEM_SRF_OBJCLASS_FKX ON BRIDGE_THEMATIC_SURFACE (OBJECTCLASS_ID);

CREATE INDEX BUILDING_LOD0FOOTPRINT_FKX ON BUILDING (LOD0_FOOTPRINT_ID);

CREATE INDEX BUILDING_LOD0ROOFPRINT_FKX ON BUILDING (LOD0_ROOFPRINT_ID);

CREATE INDEX BUILDING_LOD1MSRF_FKX ON BUILDING (LOD1_MULTI_SURFACE_ID);

CREATE INDEX BUILDING_LOD1SOLID_FKX ON BUILDING (LOD1_SOLID_ID);

CREATE INDEX BUILDING_LOD2MSRF_FKX ON BUILDING (LOD2_MULTI_SURFACE_ID);

CREATE INDEX BUILDING_LOD2SOLID_FKX ON BUILDING (LOD2_SOLID_ID);

CREATE INDEX BUILDING_LOD3MSRF_FKX ON BUILDING (LOD3_MULTI_SURFACE_ID);

CREATE INDEX BUILDING_LOD3SOLID_FKX ON BUILDING (LOD3_SOLID_ID);

CREATE INDEX BUILDING_LOD4MSRF_FKX ON BUILDING (LOD4_MULTI_SURFACE_ID);

CREATE INDEX BUILDING_LOD4SOLID_FKX ON BUILDING (LOD4_SOLID_ID);

CREATE INDEX BUILDING_OBJECTCLASS_FKX ON BUILDING (OBJECTCLASS_ID);

CREATE INDEX BUILDING_PARENT_FKX ON BUILDING (BUILDING_PARENT_ID);

CREATE INDEX BUILDING_ROOT_FKX ON BUILDING (BUILDING_ROOT_ID);

CREATE INDEX BLDG_FURN_LOD4BREP_FKX ON BUILDING_FURNITURE (LOD4_BREP_ID);

CREATE INDEX BLDG_FURN_LOD4IMPL_FKX ON BUILDING_FURNITURE (LOD4_IMPLICIT_REP_ID);

CREATE INDEX BLDG_FURN_OBJCLASS_FKX ON BUILDING_FURNITURE (OBJECTCLASS_ID);

CREATE INDEX BLDG_FURN_ROOM_FK ON BUILDING_FURNITURE (ROOM_ID);

CREATE INDEX BLDG_INST_BUILDING_FKX ON BUILDING_INSTALLATION (BUILDING_ID);

CREATE INDEX BLDG_INST_LOD2BREP_FKX ON BUILDING_INSTALLATION (LOD2_BREP_ID);

CREATE INDEX BLDG_INST_LOD2IMPL_FKX ON BUILDING_INSTALLATION (LOD2_IMPLICIT_REP_ID);

CREATE INDEX BLDG_INST_LOD3BREP_FKX ON BUILDING_INSTALLATION (LOD3_BREP_ID);

CREATE INDEX BLDG_INST_LOD3IMPL_FKX ON BUILDING_INSTALLATION (LOD3_IMPLICIT_REP_ID);

CREATE INDEX BLDG_INST_LOD4BREP_FKX ON BUILDING_INSTALLATION (LOD4_BREP_ID);

CREATE INDEX BLDG_INST_LOD4IMPL_FKX ON BUILDING_INSTALLATION (LOD4_IMPLICIT_REP_ID);

CREATE INDEX BLDG_INST_OBJECTCLASS_FKX ON BUILDING_INSTALLATION (OBJECTCLASS_ID);

CREATE INDEX BLDG_INST_ROOM_FKX ON BUILDING_INSTALLATION (ROOM_ID);

CREATE INDEX CITYMODEL_INX ON CITYMODEL (GMLID, GMLID_CODESPACE);

CREATE INDEX CITYOBJECT_INX ON CITYOBJECT (GMLID, GMLID_CODESPACE);

CREATE INDEX CITYOBJECT_LINEAGE_INX ON CITYOBJECT (LINEAGE);

CREATE INDEX CITYOBJECT_OBJECTCLASS_FKX ON CITYOBJECT (OBJECTCLASS_ID);

CREATE INDEX CITYOBJ_CREATION_DATE_INX ON CITYOBJECT (CREATION_DATE);

CREATE INDEX CITYOBJ_LAST_MOD_DATE_INX ON CITYOBJECT (LAST_MODIFICATION_DATE);

CREATE INDEX CITYOBJ_TERM_DATE_INX ON CITYOBJECT (TERMINATION_DATE);

CREATE INDEX GROUP_BREP_FKX ON CITYOBJECTGROUP (BREP_ID);

CREATE INDEX GROUP_OBJECTCLASS_FKX ON CITYOBJECTGROUP (OBJECTCLASS_ID);

CREATE INDEX GROUP_PARENT_CITYOBJ_FKX ON CITYOBJECTGROUP (PARENT_CITYOBJECT_ID);

CREATE INDEX GENERICATTRIB_CITYOBJ_FKX ON CITYOBJECT_GENERICATTRIB (CITYOBJECT_ID);

CREATE INDEX GENERICATTRIB_GEOM_FKX ON CITYOBJECT_GENERICATTRIB (SURFACE_GEOMETRY_ID);

CREATE INDEX GENERICATTRIB_PARENT_FKX ON CITYOBJECT_GENERICATTRIB (PARENT_GENATTRIB_ID);

CREATE INDEX GENERICATTRIB_ROOT_FKX ON CITYOBJECT_GENERICATTRIB (ROOT_GENATTRIB_ID);

CREATE INDEX CITYOBJECT_MEMBER_FKX ON CITYOBJECT_MEMBER (CITYOBJECT_ID);

CREATE INDEX CITYOBJECT_MEMBER_FKX1 ON CITYOBJECT_MEMBER (CITYMODEL_ID);

CREATE INDEX CITY_FURN_LOD1BREP_FKX ON CITY_FURNITURE (LOD1_BREP_ID);

CREATE INDEX CITY_FURN_LOD1IMPL_FKX ON CITY_FURNITURE (LOD1_IMPLICIT_REP_ID);

CREATE INDEX CITY_FURN_LOD2BREP_FKX ON CITY_FURNITURE (LOD2_BREP_ID);

CREATE INDEX CITY_FURN_LOD2IMPL_FKX ON CITY_FURNITURE (LOD2_IMPLICIT_REP_ID);

CREATE INDEX CITY_FURN_LOD3BREP_FKX ON CITY_FURNITURE (LOD3_BREP_ID);

CREATE INDEX CITY_FURN_LOD3IMPL_FKX ON CITY_FURNITURE (LOD3_IMPLICIT_REP_ID);

CREATE INDEX CITY_FURN_LOD4BREP_FKX ON CITY_FURNITURE (LOD4_BREP_ID);

CREATE INDEX CITY_FURN_LOD4IMPL_FKX ON CITY_FURNITURE (LOD4_IMPLICIT_REP_ID);

CREATE INDEX CITY_FURN_OBJCLASS_FKX ON CITY_FURNITURE (OBJECTCLASS_ID);

CREATE INDEX EXT_REF_CITYOBJECT_FKX ON EXTERNAL_REFERENCE (CITYOBJECT_ID);

CREATE INDEX GENERAL_CITYOBJECT_FKX ON GENERALIZATION (CITYOBJECT_ID);

CREATE INDEX GENERAL_GENERALIZES_TO_FKX ON GENERALIZATION (GENERALIZES_TO_ID);

CREATE INDEX GEN_OBJECT_LOD0BREP_FKX ON GENERIC_CITYOBJECT (LOD0_BREP_ID);

CREATE INDEX GEN_OBJECT_LOD0IMPL_FKX ON GENERIC_CITYOBJECT (LOD0_IMPLICIT_REP_ID);

CREATE INDEX GEN_OBJECT_LOD1BREP_FKX ON GENERIC_CITYOBJECT (LOD1_BREP_ID);

CREATE INDEX GEN_OBJECT_LOD1IMPL_FKX ON GENERIC_CITYOBJECT (LOD1_IMPLICIT_REP_ID);

CREATE INDEX GEN_OBJECT_LOD2BREP_FKX ON GENERIC_CITYOBJECT (LOD2_BREP_ID);

CREATE INDEX GEN_OBJECT_LOD2IMPL_FKX ON GENERIC_CITYOBJECT (LOD2_IMPLICIT_REP_ID);

CREATE INDEX GEN_OBJECT_LOD3BREP_FKX ON GENERIC_CITYOBJECT (LOD3_BREP_ID);

CREATE INDEX GEN_OBJECT_LOD3IMPL_FKX ON GENERIC_CITYOBJECT (LOD3_IMPLICIT_REP_ID);

CREATE INDEX GEN_OBJECT_LOD4BREP_FKX ON GENERIC_CITYOBJECT (LOD4_BREP_ID);

CREATE INDEX GEN_OBJECT_LOD4IMPL_FKX ON GENERIC_CITYOBJECT (LOD4_IMPLICIT_REP_ID);

CREATE INDEX GEN_OBJECT_OBJCLASS_FKX ON GENERIC_CITYOBJECT (OBJECTCLASS_ID);

CREATE INDEX GTCO_COGID_IDX ON GROUP_TO_CITYOBJECT (CITYOBJECTGROUP_ID);

CREATE INDEX IMPLICIT_GEOM_INX ON IMPLICIT_GEOMETRY (GMLID, GMLID_CODESPACE);

CREATE INDEX IMPLICIT_GEOM_BREP_FKX ON IMPLICIT_GEOMETRY (RELATIVE_BREP_ID);

CREATE INDEX IMPLICIT_GEOM_REF2LIB_INX ON IMPLICIT_GEOMETRY (REFERENCE_TO_LIBRARY);

CREATE INDEX LAND_USE_LOD0MSRF_FKX ON LAND_USE (LOD0_MULTI_SURFACE_ID);

CREATE INDEX LAND_USE_LOD1MSRF_FKX ON LAND_USE (LOD1_MULTI_SURFACE_ID);

CREATE INDEX LAND_USE_LOD2MSRF_FKX ON LAND_USE (LOD2_MULTI_SURFACE_ID);

CREATE INDEX LAND_USE_LOD3MSRF_FKX ON LAND_USE (LOD3_MULTI_SURFACE_ID);

CREATE INDEX LAND_USE_LOD4MSRF_FKX ON LAND_USE (LOD4_MULTI_SURFACE_ID);

CREATE INDEX LAND_USE_OBJCLASS_FKX ON LAND_USE (OBJECTCLASS_ID);

CREATE INDEX MASSPOINT_REL_OBJCLASS_FKX ON MASSPOINT_RELIEF (OBJECTCLASS_ID);

CREATE INDEX OBJECTCLASS_BASECLASS_FKX ON OBJECTCLASS (BASECLASS_ID);

CREATE INDEX OBJECTCLASS_SUPERCLASS_FKX ON OBJECTCLASS (SUPERCLASS_ID);

CREATE INDEX OPENING_ADDRESS_FKX ON OPENING (ADDRESS_ID);

CREATE INDEX OPENING_LOD3IMPL_FKX ON OPENING (LOD3_IMPLICIT_REP_ID);

CREATE INDEX OPENING_LOD3MSRF_FKX ON OPENING (LOD3_MULTI_SURFACE_ID);

CREATE INDEX OPENING_LOD4IMPL_FKX ON OPENING (LOD4_IMPLICIT_REP_ID);

CREATE INDEX OPENING_LOD4MSRF_FKX ON OPENING (LOD4_MULTI_SURFACE_ID);

CREATE INDEX OPENING_OBJECTCLASS_FKX ON OPENING (OBJECTCLASS_ID);

CREATE INDEX OPEN_TO_THEM_SURFACE_FKX ON OPENING_TO_THEM_SURFACE (OPENING_ID);

CREATE INDEX OPEN_TO_THEM_SURFACE_FKX1 ON OPENING_TO_THEM_SURFACE (THEMATIC_SURFACE_ID);

CREATE INDEX PLANT_COVER_LOD1MSOLID_FKX ON PLANT_COVER (LOD1_MULTI_SOLID_ID);

CREATE INDEX PLANT_COVER_LOD1MSRF_FKX ON PLANT_COVER (LOD1_MULTI_SURFACE_ID);

CREATE INDEX PLANT_COVER_LOD2MSRF_FKX ON PLANT_COVER (LOD2_MULTI_SURFACE_ID);

CREATE INDEX PLANT_COVER_LOD2SOLID_FKX ON PLANT_COVER (LOD2_MULTI_SOLID_ID);

CREATE INDEX PLANT_COVER_LOD3MSOLID_FKX ON PLANT_COVER (LOD3_MULTI_SOLID_ID);

CREATE INDEX PLANT_COVER_LOD3MSRF_FKX ON PLANT_COVER (LOD3_MULTI_SURFACE_ID);

CREATE INDEX PLANT_COVER_LOD4MSOLID_FKX ON PLANT_COVER (LOD4_MULTI_SOLID_ID);

CREATE INDEX PLANT_COVER_LOD4MSRF_FKX ON PLANT_COVER (LOD4_MULTI_SURFACE_ID);

CREATE INDEX PLANT_COVER_OBJCLASS_FKX ON PLANT_COVER (OBJECTCLASS_ID);

CREATE INDEX RELIEF_COMP_OBJCLASS_FKX ON RELIEF_COMPONENT (OBJECTCLASS_ID);

CREATE INDEX RELIEF_FEAT_OBJCLASS_FKX ON RELIEF_FEATURE (OBJECTCLASS_ID);

CREATE INDEX REL_FEAT_TO_REL_COMP_FKX ON RELIEF_FEAT_TO_REL_COMP (RELIEF_COMPONENT_ID);

CREATE INDEX REL_FEAT_TO_REL_COMP_FKX1 ON RELIEF_FEAT_TO_REL_COMP (RELIEF_FEATURE_ID);

CREATE INDEX ROOM_BUILDING_FKX ON ROOM (BUILDING_ID);

CREATE INDEX ROOM_LOD4MSRF_FKX ON ROOM (LOD4_MULTI_SURFACE_ID);

CREATE INDEX ROOM_LOD4SOLID_FKX ON ROOM (LOD4_SOLID_ID);

CREATE INDEX ROOM_OBJECTCLASS_FKX ON ROOM (OBJECTCLASS_ID);

CREATE INDEX SCHEMA_REFERENCING_FKX1 ON SCHEMA_REFERENCING (REFERENCED_ID);

CREATE INDEX SCHEMA_REFERENCING_FKX2 ON SCHEMA_REFERENCING (REFERENCING_ID);

CREATE INDEX SCHEMA_TO_OBJECTCLASS_FKX1 ON SCHEMA_TO_OBJECTCLASS (SCHEMA_ID);

CREATE INDEX SCHEMA_TO_OBJECTCLASS_FKX2 ON SCHEMA_TO_OBJECTCLASS (OBJECTCLASS_ID);

CREATE INDEX SOL_VEG_OBJ_LOD1BREP_FKX ON SOLITARY_VEGETAT_OBJECT (LOD1_BREP_ID);

CREATE INDEX SOL_VEG_OBJ_LOD1IMPL_FKX ON SOLITARY_VEGETAT_OBJECT (LOD1_IMPLICIT_REP_ID);

CREATE INDEX SOL_VEG_OBJ_LOD2BREP_FKX ON SOLITARY_VEGETAT_OBJECT (LOD2_BREP_ID);

CREATE INDEX SOL_VEG_OBJ_LOD2IMPL_FKX ON SOLITARY_VEGETAT_OBJECT (LOD2_IMPLICIT_REP_ID);

CREATE INDEX SOL_VEG_OBJ_LOD3BREP_FKX ON SOLITARY_VEGETAT_OBJECT (LOD3_BREP_ID);

CREATE INDEX SOL_VEG_OBJ_LOD3IMPL_FKX ON SOLITARY_VEGETAT_OBJECT (LOD3_IMPLICIT_REP_ID);

CREATE INDEX SOL_VEG_OBJ_LOD4BREP_FKX ON SOLITARY_VEGETAT_OBJECT (LOD4_BREP_ID);

CREATE INDEX SOL_VEG_OBJ_LOD4IMPL_FKX ON SOLITARY_VEGETAT_OBJECT (LOD4_IMPLICIT_REP_ID);

CREATE INDEX SOL_VEG_OBJ_OBJCLASS_FKX ON SOLITARY_VEGETAT_OBJECT (OBJECTCLASS_ID);

CREATE INDEX SURFACE_DATA_INX ON SURFACE_DATA (GMLID, GMLID_CODESPACE);

CREATE INDEX SURFACE_DATA_OBJCLASS_FKX ON SURFACE_DATA (OBJECTCLASS_ID);

CREATE INDEX SURFACE_DATA_TEX_IMAGE_FKX ON SURFACE_DATA (TEX_IMAGE_ID);

CREATE INDEX SURFACE_GEOM_CITYOBJ_FKX ON SURFACE_GEOMETRY (CITYOBJECT_ID);

CREATE INDEX SURFACE_GEOM_INX ON SURFACE_GEOMETRY (GMLID, GMLID_CODESPACE);

CREATE INDEX SURFACE_GEOM_PARENT_FKX ON SURFACE_GEOMETRY (PARENT_ID);

CREATE INDEX SURFACE_GEOM_ROOT_FKX ON SURFACE_GEOMETRY (ROOT_ID);

CREATE INDEX TEXPARAM_GEOM_FKX ON TEXTUREPARAM (SURFACE_GEOMETRY_ID);

CREATE INDEX TEXPARAM_SURFACE_DATA_FKX ON TEXTUREPARAM (SURFACE_DATA_ID);

CREATE INDEX THEM_SURFACE_BLDG_INST_FKX ON THEMATIC_SURFACE (BUILDING_INSTALLATION_ID);

CREATE INDEX THEM_SURFACE_BUILDING_FKX ON THEMATIC_SURFACE (BUILDING_ID);

CREATE INDEX THEM_SURFACE_LOD2MSRF_FKX ON THEMATIC_SURFACE (LOD2_MULTI_SURFACE_ID);

CREATE INDEX THEM_SURFACE_LOD3MSRF_FKX ON THEMATIC_SURFACE (LOD3_MULTI_SURFACE_ID);

CREATE INDEX THEM_SURFACE_LOD4MSRF_FKX ON THEMATIC_SURFACE (LOD4_MULTI_SURFACE_ID);

CREATE INDEX THEM_SURFACE_OBJCLASS_FKX ON THEMATIC_SURFACE (OBJECTCLASS_ID);

CREATE INDEX THEM_SURFACE_ROOM_FKX ON THEMATIC_SURFACE (ROOM_ID);

CREATE INDEX TIN_RELIEF_GEOM_FKX ON TIN_RELIEF (SURFACE_GEOMETRY_ID);

CREATE INDEX TIN_RELIEF_OBJCLASS_FKX ON TIN_RELIEF (OBJECTCLASS_ID);

CREATE INDEX TRAFFIC_AREA_LOD2MSRF_FKX ON TRAFFIC_AREA (LOD2_MULTI_SURFACE_ID);

CREATE INDEX TRAFFIC_AREA_LOD3MSRF_FKX ON TRAFFIC_AREA (LOD3_MULTI_SURFACE_ID);

CREATE INDEX TRAFFIC_AREA_LOD4MSRF_FKX ON TRAFFIC_AREA (LOD4_MULTI_SURFACE_ID);

CREATE INDEX TRAFFIC_AREA_OBJCLASS_FKX ON TRAFFIC_AREA (OBJECTCLASS_ID);

CREATE INDEX TRAFFIC_AREA_TRANCMPLX_FKX ON TRAFFIC_AREA (TRANSPORTATION_COMPLEX_ID);

CREATE INDEX TRAN_COMPLEX_LOD1MSRF_FKX ON TRANSPORTATION_COMPLEX (LOD1_MULTI_SURFACE_ID);

CREATE INDEX TRAN_COMPLEX_LOD2MSRF_FKX ON TRANSPORTATION_COMPLEX (LOD2_MULTI_SURFACE_ID);

CREATE INDEX TRAN_COMPLEX_LOD3MSRF_FKX ON TRANSPORTATION_COMPLEX (LOD3_MULTI_SURFACE_ID);

CREATE INDEX TRAN_COMPLEX_LOD4MSRF_FKX ON TRANSPORTATION_COMPLEX (LOD4_MULTI_SURFACE_ID);

CREATE INDEX TRAN_COMPLEX_OBJCLASS_FKX ON TRANSPORTATION_COMPLEX (OBJECTCLASS_ID);

CREATE INDEX TUNNEL_LOD1MSRF_FKX ON TUNNEL (LOD1_MULTI_SURFACE_ID);

CREATE INDEX TUNNEL_LOD1SOLID_FKX ON TUNNEL (LOD1_SOLID_ID);

CREATE INDEX TUNNEL_LOD2MSRF_FKX ON TUNNEL (LOD2_MULTI_SURFACE_ID);

CREATE INDEX TUNNEL_LOD2SOLID_FKX ON TUNNEL (LOD2_SOLID_ID);

CREATE INDEX TUNNEL_LOD3MSRF_FKX ON TUNNEL (LOD3_MULTI_SURFACE_ID);

CREATE INDEX TUNNEL_LOD3SOLID_FKX ON TUNNEL (LOD3_SOLID_ID);

CREATE INDEX TUNNEL_LOD4MSRF_FKX ON TUNNEL (LOD4_MULTI_SURFACE_ID);

CREATE INDEX TUNNEL_LOD4SOLID_FKX ON TUNNEL (LOD4_SOLID_ID);

CREATE INDEX TUNNEL_OBJECTCLASS_FKX ON TUNNEL (OBJECTCLASS_ID);

CREATE INDEX TUNNEL_PARENT_FKX ON TUNNEL (TUNNEL_PARENT_ID);

CREATE INDEX TUNNEL_ROOT_FKX ON TUNNEL (TUNNEL_ROOT_ID);

CREATE INDEX TUNNEL_FURN_HSPACE_FKX ON TUNNEL_FURNITURE (TUNNEL_HOLLOW_SPACE_ID);

CREATE INDEX TUNNEL_FURN_LOD4BREP_FKX ON TUNNEL_FURNITURE (LOD4_BREP_ID);

CREATE INDEX TUNNEL_FURN_LOD4IMPL_FKX ON TUNNEL_FURNITURE (LOD4_IMPLICIT_REP_ID);

CREATE INDEX TUNNEL_FURN_OBJCLASS_FKX ON TUNNEL_FURNITURE (OBJECTCLASS_ID);

CREATE INDEX TUN_HSPACE_LOD4MSRF_FKX ON TUNNEL_HOLLOW_SPACE (LOD4_MULTI_SURFACE_ID);

CREATE INDEX TUN_HSPACE_LOD4SOLID_FKX ON TUNNEL_HOLLOW_SPACE (LOD4_SOLID_ID);

CREATE INDEX TUN_HSPACE_OBJCLASS_FKX ON TUNNEL_HOLLOW_SPACE (OBJECTCLASS_ID);

CREATE INDEX TUN_HSPACE_TUNNEL_FKX ON TUNNEL_HOLLOW_SPACE (TUNNEL_ID);

CREATE INDEX TUNNEL_INST_HSPACE_FKX ON TUNNEL_INSTALLATION (TUNNEL_HOLLOW_SPACE_ID);

CREATE INDEX TUNNEL_INST_LOD2BREP_FKX ON TUNNEL_INSTALLATION (LOD2_BREP_ID);

CREATE INDEX TUNNEL_INST_LOD2IMPL_FKX ON TUNNEL_INSTALLATION (LOD2_IMPLICIT_REP_ID);

CREATE INDEX TUNNEL_INST_LOD3BREP_FKX ON TUNNEL_INSTALLATION (LOD3_BREP_ID);

CREATE INDEX TUNNEL_INST_LOD3IMPL_FKX ON TUNNEL_INSTALLATION (LOD3_IMPLICIT_REP_ID);

CREATE INDEX TUNNEL_INST_LOD4BREP_FKX ON TUNNEL_INSTALLATION (LOD4_BREP_ID);

CREATE INDEX TUNNEL_INST_LOD4IMPL_FKX ON TUNNEL_INSTALLATION (LOD4_IMPLICIT_REP_ID);

CREATE INDEX TUNNEL_INST_OBJCLASS_FKX ON TUNNEL_INSTALLATION (OBJECTCLASS_ID);

CREATE INDEX TUNNEL_INST_TUNNEL_FKX ON TUNNEL_INSTALLATION (TUNNEL_ID);

CREATE INDEX TUNNEL_OPEN_LOD3IMPL_FKX ON TUNNEL_OPENING (LOD3_IMPLICIT_REP_ID);

CREATE INDEX TUNNEL_OPEN_LOD3MSRF_FKX ON TUNNEL_OPENING (LOD3_MULTI_SURFACE_ID);

CREATE INDEX TUNNEL_OPEN_LOD4IMPL_FKX ON TUNNEL_OPENING (LOD4_IMPLICIT_REP_ID);

CREATE INDEX TUNNEL_OPEN_LOD4MSRF_FKX ON TUNNEL_OPENING (LOD4_MULTI_SURFACE_ID);

CREATE INDEX TUNNEL_OPEN_OBJCLASS_FKX ON TUNNEL_OPENING (OBJECTCLASS_ID);

CREATE INDEX TUN_OPEN_TO_THEM_SRF_FKX ON TUNNEL_OPEN_TO_THEM_SRF (TUNNEL_OPENING_ID);

CREATE INDEX TUN_OPEN_TO_THEM_SRF_FKX1 ON TUNNEL_OPEN_TO_THEM_SRF (TUNNEL_THEMATIC_SURFACE_ID);

CREATE INDEX TUN_THEM_SRF_HSPACE_FKX ON TUNNEL_THEMATIC_SURFACE (TUNNEL_HOLLOW_SPACE_ID);

CREATE INDEX TUN_THEM_SRF_LOD2MSRF_FKX ON TUNNEL_THEMATIC_SURFACE (LOD2_MULTI_SURFACE_ID);

CREATE INDEX TUN_THEM_SRF_LOD3MSRF_FKX ON TUNNEL_THEMATIC_SURFACE (LOD3_MULTI_SURFACE_ID);

CREATE INDEX TUN_THEM_SRF_LOD4MSRF_FKX ON TUNNEL_THEMATIC_SURFACE (LOD4_MULTI_SURFACE_ID);

CREATE INDEX TUN_THEM_SRF_OBJCLASS_FKX ON TUNNEL_THEMATIC_SURFACE (OBJECTCLASS_ID);

CREATE INDEX TUN_THEM_SRF_TUNNEL_FKX ON TUNNEL_THEMATIC_SURFACE (TUNNEL_ID);

CREATE INDEX TUN_THEM_SRF_TUN_INST_FKX ON TUNNEL_THEMATIC_SURFACE (TUNNEL_INSTALLATION_ID);

CREATE INDEX WATERBODY_LOD0MSRF_FK ON WATERBODY (LOD0_MULTI_SURFACE_ID);

CREATE INDEX WATERBODY_LOD1MSRF_FK ON WATERBODY (LOD1_MULTI_SURFACE_ID);

CREATE INDEX WATERBODY_LOD1SOLID_FK ON WATERBODY (LOD1_SOLID_ID);

CREATE INDEX WATERBODY_LOD2SOLID_FK ON WATERBODY (LOD2_SOLID_ID);

CREATE INDEX WATERBODY_LOD3SOLID_FK ON WATERBODY (LOD3_SOLID_ID);

CREATE INDEX WATERBODY_LOD4SOLID_FK ON WATERBODY (LOD4_SOLID_ID);

CREATE INDEX WATERBODY_OBJCLASS_FKX ON WATERBODY (OBJECTCLASS_ID);

CREATE INDEX WATERBOD_TO_WATERBND_FKX ON WATERBOD_TO_WATERBND_SRF (WATERBOUNDARY_SURFACE_ID);

CREATE INDEX WATERBOD_TO_WATERBND_FKX1 ON WATERBOD_TO_WATERBND_SRF (WATERBODY_ID);

CREATE INDEX WATERBND_SRF_LOD2SRF_FKX ON WATERBOUNDARY_SURFACE (LOD2_SURFACE_ID);

CREATE INDEX WATERBND_SRF_LOD3SRF_FKX ON WATERBOUNDARY_SURFACE (LOD3_SURFACE_ID);

CREATE INDEX WATERBND_SRF_LOD4SRF_FKX ON WATERBOUNDARY_SURFACE (LOD4_SURFACE_ID);

CREATE INDEX WATERBND_SRF_OBJCLASS_FKX ON WATERBOUNDARY_SURFACE (OBJECTCLASS_ID);