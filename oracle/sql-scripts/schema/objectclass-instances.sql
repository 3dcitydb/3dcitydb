SET DEFINE OFF
DELETE FROM objectclass;

-- Core Module --

DECLARE
  v_schema_1 JSON := JSON(@core:Undefined@);
  v_schema_2 JSON := JSON(@core:AbstractObject@);
  v_schema_3 JSON := JSON(@core:AbstractObject@);
  v_schema_4 JSON := JSON(@core:Address@);
  v_schema_5 JSON := JSON(@core:AbstractPointCloud@);
  v_schema_6 JSON := JSON(@core:AbstractFeatureWithLifespan@);
  v_schema_7 JSON := JSON(@core:AbstractCityObject@);
  v_schema_8 JSON := JSON(@core:AbstractSpace@);
  v_schema_9 JSON := JSON(@core:AbstractLogicalSpace@);
  v_schema_10 JSON := JSON(@core:AbstractPhysicalSpace@);
  v_schema_11 JSON := JSON(@core:AbstractUnoccupiedSpace@);
  v_schema_12 JSON := JSON(@core:AbstractOccupiedSpace@);
  v_schema_13 JSON := JSON(@core:AbstractSpaceBoundary@);
  v_schema_14 JSON := JSON(@core:AbstractThematicSurface@);
  v_schema_15 JSON := JSON(@core:ClosureSurface@);
  v_schema_16 JSON := JSON(@core:AbstractDynamizer@);
  v_schema_17 JSON := JSON(@core:AbstractVersionTransition@);
  v_schema_18 JSON := JSON(@core:CityModel@);
  v_schema_19 JSON := JSON(@core:AbstractVersion@);
  v_schema_20 JSON := JSON(@core:AbstractAppearance@);
  v_schema_21 JSON := JSON(@core:ImplicitGeometry@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (1, null, 'Undefined', 1, 0, 1, v_schema_1),
    (2, null, 'AbstractObject', 1, 0, 1, v_schema_2),
    (3, 2, 'AbstractFeature', 1, 0, 1, v_schema_3),
    (4, null, 'Address', 0, 0, 1, v_schema_4),
    (5, 3, 'AbstractPointCloud', 1, 0, 1, v_schema_5),
    (6, 3, 'AbstractFeatureWithLifespan', 1, 0, 1, v_schema_6),
    (7, 6, 'AbstractCityObject', 1, 0, 1, v_schema_7),
    (8, 7, 'AbstractSpace', 1, 0, 1, v_schema_8),
    (9, 8, 'AbstractLogicalSpace', 1, 0, 1, v_schema_9),
    (10, 8, 'AbstractPhysicalSpace', 1, 0, 1, v_schema_10),
    (11, 10, 'AbstractUnoccupiedSpace', 1, 0, 1, v_schema_11),
    (12, 10, 'AbstractOccupiedSpace', 1, 0, 1, v_schema_12),
    (13, 7, 'AbstractSpaceBoundary', 1, 0, 1, v_schema_13),
    (14, 13, 'AbstractThematicSurface', 1, 0, 1, v_schema_14),
    (15, 14, 'ClosureSurface', 0, 0, 1, v_schema_15),
    (16, 6, 'AbstractDynamizer', 1, 0, 1, v_schema_16),
    (17, 6, 'AbstractVersionTransition', 1, 0, 1, v_schema_17),
    (18, 6, 'CityModel', 0, 0, 1, v_schema_18),
    (19, 6, 'AbstractVersion', 1, 0, 1, v_schema_19),
    (20, null, 'AbstractAppearance', 1, 0, 1, v_schema_20),
    (21, null, 'ImplicitGeometry', 0, 0, 1, v_schema_21);
END;
/

-- Dynamizer Module --

DECLARE
  v_schema_100 JSON := JSON(@dyn:Dynamizer@);
  v_schema_101 JSON := JSON(@dyn:AbstractTimeseries@);
  v_schema_102 JSON := JSON(@dyn:AbstractAtomicTimeseries@);
  v_schema_103 JSON := JSON(@dyn:TabulatedFileTimeseries@);
  v_schema_104 JSON := JSON(@dyn:StandardFileTimeseries@);
  v_schema_105 JSON := JSON(@dyn:GenericTimeseries@);
  v_schema_106 JSON := JSON(@dyn:CompositeTimeseries@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (100, 16, 'Dynamizer', 0, 0, 2, v_schema_100),
    (101, 3, 'AbstractTimeseries', 1, 0, 2, v_schema_101),
    (102, 101, 'AbstractAtomicTimeseries', 1, 0, 2, v_schema_102),
    (103, 102, 'TabulatedFileTimeseries', 0, 0, 2, v_schema_103),
    (104, 102, 'StandardFileTimeseries', 0, 0, 2, v_schema_104),
    (105, 102, 'GenericTimeseries', 0, 0, 2, v_schema_105),
    (106, 101, 'CompositeTimeseries', 0, 0, 2, v_schema_106);
END;
/

-- Generics Module --

DECLARE
  v_schema_200 JSON := JSON(@gen:GenericLogicalSpace@);
  v_schema_201 JSON := JSON(@gen:GenericOccupiedSpace@);
  v_schema_202 JSON := JSON(@gen:GenericUnoccupiedSpace@);
  v_schema_203 JSON := JSON(@gen:GenericThematicSurface@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (200, 9, 'GenericLogicalSpace', 0, 1, 3, v_schema_200),
    (201, 12, 'GenericOccupiedSpace', 0, 1, 3, v_schema_201),
    (202, 11, 'GenericUnoccupiedSpace', 0, 1, 3, v_schema_202),
    (203, 14, 'GenericThematicSurface', 0, 0, 3, v_schema_203);
END;
/

-- LandUse Module --

DECLARE
  v_schema_300 JSON := JSON(@luse:LandUse@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (300, 14, 'LandUse', 0, 1, 4, v_schema_300);
END;
/

-- PointCloud Module --

DECLARE
  v_schema_400 JSON := JSON(@pcl:PointCloud@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (400, 5, 'PointCloud', 0, 0, 5, v_schema_400);
END;
/

-- Relief Module --

DECLARE
  v_schema_500 JSON := JSON(@dem:ReliefFeature@);
  v_schema_501 JSON := JSON(@dem:AbstractReliefComponent@);
  v_schema_502 JSON := JSON(@dem:TINRelief@);
  v_schema_503 JSON := JSON(@dem:MassPointRelief@);
  v_schema_504 JSON := JSON(@dem:BreaklineRelief@);
  v_schema_505 JSON := JSON(@dem:RasterRelief@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (500, 13, 'ReliefFeature', 0, 1, 6, v_schema_500),
    (501, 13, 'AbstractReliefComponent', 1, 0, 6, v_schema_501),
    (502, 501, 'TINRelief', 0, 0, 6, v_schema_502),
    (503, 501, 'MassPointRelief', 0, 0, 6, v_schema_503),
    (504, 501, 'BreaklineRelief', 0, 0, 6, v_schema_504),
    (505, 501, 'RasterRelief', 0, 0, 6, v_schema_505);
END;
/

-- Transportation Module --

DECLARE
  v_schema_600 JSON := JSON(@tran:AbstractTransportationSpace@);
  v_schema_601 JSON := JSON(@tran:Railway@);
  v_schema_602 JSON := JSON(@tran:Section@);
  v_schema_603 JSON := JSON(@tran:Waterway@);
  v_schema_604 JSON := JSON(@tran:Intersection@);
  v_schema_605 JSON := JSON(@tran:Square@);
  v_schema_606 JSON := JSON(@tran:Track@);
  v_schema_607 JSON := JSON(@tran:Road@);
  v_schema_608 JSON := JSON(@tran:AuxiliaryTrafficSpace@);
  v_schema_609 JSON := JSON(@tran:ClearanceSpace@);
  v_schema_610 JSON := JSON(@tran:TrafficSpace@);
  v_schema_611 JSON := JSON(@tran:Hole@);
  v_schema_612 JSON := JSON(@tran:AuxiliaryTrafficArea@);
  v_schema_613 JSON := JSON(@tran:TrafficArea@);
  v_schema_614 JSON := JSON(@tran:Marking@);
  v_schema_615 JSON := JSON(@tran:HoleSurface@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (600, 11, 'AbstractTransportationSpace', 1, 0, 7, v_schema_600),
    (601, 600, 'Railway', 0, 1, 7, v_schema_601),
    (602, 600, 'Section', 0, 0, 7, v_schema_602),
    (603, 600, 'Waterway', 0, 1, 7, v_schema_603),
    (604, 600, 'Intersection', 0, 0, 7, v_schema_604),
    (605, 600, 'Square', 0, 1, 7, v_schema_605),
    (606, 600, 'Track', 0, 1, 7, v_schema_606),
    (607, 600, 'Road', 0, 1, 7, v_schema_607),
    (608, 11, 'AuxiliaryTrafficSpace', 0, 0, 7, v_schema_608),
    (609, 11, 'ClearanceSpace', 0, 0, 7, v_schema_609),
    (610, 11, 'TrafficSpace', 0, 0, 7, v_schema_610),
    (611, 11, 'Hole', 0, 0, 7, v_schema_611),
    (612, 14, 'AuxiliaryTrafficArea', 0, 0, 7, v_schema_612),
    (613, 14, 'TrafficArea', 0, 0, 7, v_schema_613),
    (614, 14, 'Marking', 0, 0, 7, v_schema_614),
    (615, 14, 'HoleSurface', 0, 0, 7, v_schema_615);
END;
/

-- Construction Module --

DECLARE
  v_schema_700 JSON := JSON(@con:AbstractConstruction@);
  v_schema_701 JSON := JSON(@con:OtherConstruction@);
  v_schema_702 JSON := JSON(@con:AbstractConstructiveElement@);
  v_schema_703 JSON := JSON(@con:AbstractFillingElement@);
  v_schema_704 JSON := JSON(@con:Window@);
  v_schema_705 JSON := JSON(@con:Door@);
  v_schema_706 JSON := JSON(@con:AbstractFurniture@);
  v_schema_707 JSON := JSON(@con:AbstractInstallation@);
  v_schema_708 JSON := JSON(@con:AbstractConstructionSurface@);
  v_schema_709 JSON := JSON(@con:WallSurface@);
  v_schema_710 JSON := JSON(@con:GroundSurface@);
  v_schema_711 JSON := JSON(@con:InteriorWallSurface@);
  v_schema_712 JSON := JSON(@con:RoofSurface@);
  v_schema_713 JSON := JSON(@con:FloorSurface@);
  v_schema_714 JSON := JSON(@con:OuterFloorSurface@);
  v_schema_715 JSON := JSON(@con:CeilingSurface@);
  v_schema_716 JSON := JSON(@con:OuterCeilingSurface@);
  v_schema_717 JSON := JSON(@con:AbstractFillingSurface@);
  v_schema_718 JSON := JSON(@con:DoorSurface@);
  v_schema_719 JSON := JSON(@con:WindowSurface@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (700, 12, 'AbstractConstruction', 1, 0, 8, v_schema_700),
    (701, 700, 'OtherConstruction', 0, 1, 8, v_schema_701),
    (702, 12, 'AbstractConstructiveElement', 1, 0, 8, v_schema_702),
    (703, 12, 'AbstractFillingElement', 1, 0, 8, v_schema_703),
    (704, 703, 'Window', 0, 0, 8, v_schema_704),
    (705, 703, 'Door', 0, 0, 8, v_schema_705),
    (706, 12, 'AbstractFurniture', 1, 0, 8, v_schema_706),
    (707, 12, 'AbstractInstallation', 1, 0, 8, v_schema_707),
    (708, 14, 'AbstractConstructionSurface', 1, 0, 8, v_schema_708),
    (709, 708, 'WallSurface', 0, 0, 8, v_schema_709),
    (710, 708, 'GroundSurface', 0, 0, 8, v_schema_710),
    (711, 708, 'InteriorWallSurface', 0, 0, 8, v_schema_711),
    (712, 708, 'RoofSurface', 0, 0, 8, v_schema_712),
    (713, 708, 'FloorSurface', 0, 0, 8, v_schema_713),
    (714, 708, 'OuterFloorSurface', 0, 0, 8, v_schema_714),
    (715, 708, 'CeilingSurface', 0, 0, 8, v_schema_715),
    (716, 708, 'OuterCeilingSurface', 0, 0, 8, v_schema_716),
    (717, 14, 'AbstractFillingSurface', 1, 0, 8, v_schema_717),
    (718, 717, 'DoorSurface', 0, 0, 8, v_schema_718),
    (719, 717, 'WindowSurface', 0, 0, 8, v_schema_719);
END;
/

-- Tunnel Module --

DECLARE
  v_schema_800 JSON := JSON(@tun:AbstractTunnel@);
  v_schema_801 JSON := JSON(@tun:Tunnel@);
  v_schema_802 JSON := JSON(@tun:TunnelPart@);
  v_schema_803 JSON := JSON(@tun:TunnelConstructiveElement@);
  v_schema_804 JSON := JSON(@tun:HollowSpace@);
  v_schema_805 JSON := JSON(@tun:TunnelInstallation@);
  v_schema_806 JSON := JSON(@tun:TunnelFurniture@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (800, 700, 'AbstractTunnel', 1, 0, 9, v_schema_800),
    (801, 800, 'Tunnel', 0, 1, 9, v_schema_801),
    (802, 800, 'TunnelPart', 0, 0, 9, v_schema_802),
    (803, 702, 'TunnelConstructiveElement', 0, 0, 9, v_schema_803),
    (804, 11, 'HollowSpace', 0, 0, 9, v_schema_804),
    (805, 707, 'TunnelInstallation', 0, 0, 9, v_schema_805),
    (806, 706, 'TunnelFurniture', 0, 0, 9, v_schema_806);
END;
/

-- Building Module --

DECLARE
  v_schema_900 JSON := JSON(@bldg:AbstractBuilding@);
  v_schema_901 JSON := JSON(@bldg:Building@);
  v_schema_902 JSON := JSON(@bldg:BuildingPart@);
  v_schema_903 JSON := JSON(@bldg:BuildingConstructiveElement@);
  v_schema_904 JSON := JSON(@bldg:BuildingRoom@);
  v_schema_905 JSON := JSON(@bldg:BuildingInstallation@);
  v_schema_906 JSON := JSON(@bldg:BuildingFurniture@);
  v_schema_907 JSON := JSON(@bldg:AbstractBuildingSubdivision@);
  v_schema_908 JSON := JSON(@bldg:BuildingUnit@);
  v_schema_909 JSON := JSON(@bldg:Storey@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (900, 700, 'AbstractBuilding', 1, 0, 10, v_schema_900),
    (901, 900, 'Building', 0, 1, 10, v_schema_901),
    (902, 900, 'BuildingPart', 0, 0, 10, v_schema_902),
    (903, 702, 'BuildingConstructiveElement', 0, 0, 10, v_schema_903),
    (904, 11, 'BuildingRoom', 0, 0, 10, v_schema_904),
    (905, 707, 'BuildingInstallation', 0, 0, 10, v_schema_905),
    (906, 706, 'BuildingFurniture', 0, 0, 10, v_schema_906),
    (907, 9, 'AbstractBuildingSubdivision', 1, 0, 10, v_schema_907),
    (908, 907, 'BuildingUnit', 0, 0, 10, v_schema_908),
    (909, 907, 'Storey', 0, 0, 10, v_schema_909);
END;
/

-- Bridge Module --

DECLARE
  v_schema_1000 JSON := JSON(@brid:AbstractBridge@);
  v_schema_1001 JSON := JSON(@brid:Bridge@);
  v_schema_1002 JSON := JSON(@brid:BridgePart@);
  v_schema_1003 JSON := JSON(@brid:BridgeConstructiveElement@);
  v_schema_1004 JSON := JSON(@brid:BridgeRoom@);
  v_schema_1005 JSON := JSON(@brid:BridgeInstallation@);
  v_schema_1006 JSON := JSON(@brid:BridgeFurniture@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (1000, 700, 'AbstractBridge', 1, 0, 11, v_schema_1000),
    (1001, 1000, 'Bridge', 0, 1, 11, v_schema_1001),
    (1002, 1000, 'BridgePart', 0, 0, 11, v_schema_1002),
    (1003, 702, 'BridgeConstructiveElement', 0, 0, 11, v_schema_1003),
    (1004, 11, 'BridgeRoom', 0, 0, 11, v_schema_1004),
    (1005, 707, 'BridgeInstallation', 0, 0, 11, v_schema_1005),
    (1006, 706, 'BridgeFurniture', 0, 0, 11, v_schema_1006);
END;
/

-- Appearance Module --

DECLARE
  v_schema_1100 JSON := JSON(@app:Appearance@);
  v_schema_1101 JSON := JSON(@app:AbstractSurfaceData@);
  v_schema_1102 JSON := JSON(@app:X3DMaterial@);
  v_schema_1103 JSON := JSON(@app:AbstractTexture@);
  v_schema_1104 JSON := JSON(@app:ParameterizedTexture@);
  v_schema_1105 JSON := JSON(@app:GeoreferencedTexture@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (1100, 20, 'Appearance', 0, 0, 12, v_schema_1100),
    (1101, null, 'AbstractSurfaceData', 1, 0, 12, v_schema_1101),
    (1102, 1101, 'X3DMaterial', 0, 0, 12, v_schema_1102),
    (1103, 1101, 'AbstractTexture', 1, 0, 12, v_schema_1103),
    (1104, 1103, 'ParameterizedTexture', 0, 0, 12, v_schema_1104),
    (1105, 1103, 'GeoreferencedTexture', 0, 0, 12, v_schema_1105);
END;
/

-- CityObjectGroup Module --

DECLARE
  v_schema_1200 JSON := JSON(@grp:CityObjectGroup@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (1200, 9, 'CityObjectGroup', 0, 1, 13, v_schema_1200);
END;
/

-- Vegetation Module --

DECLARE
  v_schema_1300 JSON := JSON(@veg:AbstractVegetationObject@);
  v_schema_1301 JSON := JSON(@veg:SolitaryVegetationObject@);
  v_schema_1302 JSON := JSON(@veg:PlantCover@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (1300, 12, 'AbstractVegetationObject', 1, 0, 14, v_schema_1300),
    (1301, 1300, 'SolitaryVegetationObject', 0, 1, 14, v_schema_1301),
    (1302, 1300, 'PlantCover', 0, 1, 14, v_schema_1302);
END;
/

-- Versioning Module --

DECLARE
  v_schema_1400 JSON := JSON(@vers:Version@);
  v_schema_1401 JSON := JSON(@vers:VersionTransition@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (1400, 19, 'Version', 0, 0, 15, v_schema_1400),
    (1401, 17, 'VersionTransition', 0, 0, 15, v_schema_1401);
END;
/

-- WaterBody Module --

DECLARE
  v_schema_1500 JSON := JSON(@wtr:WaterBody@);
  v_schema_1501 JSON := JSON(@wtr:AbstractWaterBoundarySurface@);
  v_schema_1502 JSON := JSON(@wtr:WaterSurface@);
  v_schema_1503 JSON := JSON(@wtr:WaterGroundSurface@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (1500, 12, 'WaterBody', 0, 1, 16, v_schema_1500),
    (1501, 14, 'AbstractWaterBoundarySurface', 1, 0, 16, v_schema_1501),
    (1502, 1501, 'WaterSurface', 0, 0, 16, v_schema_1502),
    (1503, 1501, 'WaterGroundSurface', 0, 0, 16, v_schema_1503);
END;
/

-- CityFurniture Module --

DECLARE
  v_schema_1600 JSON := JSON(@frn:CityFurniture@);
BEGIN
  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
  VALUES
    (1600, 12, 'CityFurniture', 0, 1, 17, v_schema_1600);
END;
/

SET DEFINE ON