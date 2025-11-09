SET DEFINE OFF
DELETE FROM datatype;

-- Core Module --

DECLARE
  v_schema_1 JSON := JSON(@core:Undefined@);
  v_schema_2 JSON := JSON(@core:Boolean@);
  v_schema_3 JSON := JSON(@core:Integer@);
  v_schema_4 JSON := JSON(@core:Double@);
  v_schema_5 JSON := JSON(@core:String@);
  v_schema_6 JSON := JSON(@core:URI@);
  v_schema_7 JSON := JSON(@core:Timestamp@);
  v_schema_8 JSON := JSON(@core:AddressProperty@);
  v_schema_9 JSON := JSON(@core:AppearanceProperty@);
  v_schema_10 JSON := JSON(@core:FeatureProperty@);
  v_schema_11 JSON := JSON(@core:GeometryProperty@);
  v_schema_12 JSON := JSON(@core:Reference@);
  v_schema_13 JSON := JSON(@core:CityObjectRelation@);
  v_schema_14 JSON := JSON(@core:Code@);
  v_schema_15 JSON := JSON(@core:ExternalReference@);
  v_schema_16 JSON := JSON(@core:ImplicitGeometryProperty@);
  v_schema_17 JSON := JSON(@core:Measure@);
  v_schema_18 JSON := JSON(@core:MeasureOrNilReasonList@);
  v_schema_19 JSON := JSON(@core:Occupancy@);
  v_schema_20 JSON := JSON(@core:QualifiedArea@);
  v_schema_21 JSON := JSON(@core:QualifiedVolume@);
  v_schema_22 JSON := JSON(@core:StringOrRef@);
  v_schema_23 JSON := JSON(@core:TimePosition@);
  v_schema_24 JSON := JSON(@core:Duration@);
  v_schema_50 JSON := JSON(@core:ADEOfAbstractCityObject@);
  v_schema_51 JSON := JSON(@core:ADEOfAbstractDynamizer@);
  v_schema_52 JSON := JSON(@core:ADEOfAbstractFeature@);
  v_schema_53 JSON := JSON(@core:ADEOfAbstractFeatureWithLifespan@);
  v_schema_54 JSON := JSON(@core:ADEOfAbstractLogicalSpace@);
  v_schema_55 JSON := JSON(@core:ADEOfAbstractOccupiedSpace@);
  v_schema_56 JSON := JSON(@core:ADEOfAbstractPhysicalSpace@);
  v_schema_57 JSON := JSON(@core:ADEOfAbstractPointCloud@);
  v_schema_58 JSON := JSON(@core:ADEOfAbstractSpace@);
  v_schema_59 JSON := JSON(@core:ADEOfAbstractSpaceBoundary@);
  v_schema_60 JSON := JSON(@core:ADEOfAbstractThematicSurface@);
  v_schema_61 JSON := JSON(@core:ADEOfAbstractUnoccupiedSpace@);
  v_schema_62 JSON := JSON(@core:ADEOfAbstractVersion@);
  v_schema_63 JSON := JSON(@core:ADEOfAbstractVersionTransition@);
  v_schema_64 JSON := JSON(@core:ADEOfCityModel@);
  v_schema_65 JSON := JSON(@core:ADEOfClosureSurface@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1, null, 'Undefined', 1, 1, v_schema_1),
    (2, null, 'Boolean', 0, 1, v_schema_2),
    (3, null, 'Integer', 0, 1, v_schema_3),
    (4, null, 'Double', 0, 1, v_schema_4),
    (5, null, 'String', 0, 1, v_schema_5),
    (6, null, 'URI', 0, 1, v_schema_6),
    (7, null, 'Timestamp', 0, 1, v_schema_7),
    (8, null, 'AddressProperty', 0, 1, v_schema_8),
    (9, null, 'AppearanceProperty', 0, 1, v_schema_9),
    (10, null, 'FeatureProperty', 0, 1, v_schema_10),
    (11, null, 'GeometryProperty', 0, 1, v_schema_11),
    (12, null, 'Reference', 0, 1, v_schema_12),
    (13, null, 'CityObjectRelation', 0, 1, v_schema_13),
    (14, null, 'Code', 0, 1, v_schema_14),
    (15, null, 'ExternalReference', 0, 1, v_schema_15),
    (16, null, 'ImplicitGeometryProperty', 0, 1, v_schema_16),
    (17, null, 'Measure', 0, 1, v_schema_17),
    (18, null, 'MeasureOrNilReasonList', 0, 1, v_schema_18),
    (19, null, 'Occupancy', 0, 1, v_schema_19),
    (20, null, 'QualifiedArea', 0, 1, v_schema_20),
    (21, null, 'QualifiedVolume', 0, 1, v_schema_21),
    (22, null, 'StringOrRef', 0, 1, v_schema_22),
    (23, null, 'TimePosition', 0, 1, v_schema_23),
    (24, null, 'Duration', 0, 1, v_schema_24),
    (50, null, 'ADEOfAbstractCityObject', 1, 1, v_schema_50),
    (51, null, 'ADEOfAbstractDynamizer', 1, 1, v_schema_51),
    (52, null, 'ADEOfAbstractFeature', 1, 1, v_schema_52),
    (53, null, 'ADEOfAbstractFeatureWithLifespan', 1, 1, v_schema_53),
    (54, null, 'ADEOfAbstractLogicalSpace', 1, 1, v_schema_54),
    (55, null, 'ADEOfAbstractOccupiedSpace', 1, 1, v_schema_55),
    (56, null, 'ADEOfAbstractPhysicalSpace', 1, 1, v_schema_56),
    (57, null, 'ADEOfAbstractPointCloud', 1, 1, v_schema_57),
    (58, null, 'ADEOfAbstractSpace', 1, 1, v_schema_58),
    (59, null, 'ADEOfAbstractSpaceBoundary', 1, 1, v_schema_59),
    (60, null, 'ADEOfAbstractThematicSurface', 1, 1, v_schema_60),
    (61, null, 'ADEOfAbstractUnoccupiedSpace', 1, 1, v_schema_61),
    (62, null, 'ADEOfAbstractVersion', 1, 1, v_schema_62),
    (63, null, 'ADEOfAbstractVersionTransition', 1, 1, v_schema_63),
    (64, null, 'ADEOfCityModel', 1, 1, v_schema_64),
    (65, null, 'ADEOfClosureSurface', 1, 1, v_schema_65);
END;
/

-- Dynamizer Module --

DECLARE
  v_schema_100 JSON := JSON(@dyn:AbstractTimeValuePair@);
  v_schema_101 JSON := JSON(@dyn:AttributeReference@);
  v_schema_102 JSON := JSON(@dyn:SensorConnection@);
  v_schema_103 JSON := JSON(@dyn:TimeAppearance@);
  v_schema_104 JSON := JSON(@dyn:TimeBoolean@);
  v_schema_105 JSON := JSON(@dyn:TimeDouble@);
  v_schema_106 JSON := JSON(@dyn:TimeGeometry@);
  v_schema_107 JSON := JSON(@dyn:TimeImplicitGeometry@);
  v_schema_108 JSON := JSON(@dyn:TimeInteger@);
  v_schema_109 JSON := JSON(@dyn:TimeseriesComponent@);
  v_schema_110 JSON := JSON(@dyn:TimeString@);
  v_schema_111 JSON := JSON(@dyn:TimeURI@);
  v_schema_112 JSON := JSON(@dyn:ADEOfAbstractAtomicTimeseries@);
  v_schema_113 JSON := JSON(@dyn:ADEOfAbstractTimeseries@);
  v_schema_114 JSON := JSON(@dyn:ADEOfCompositeTimeseries@);
  v_schema_115 JSON := JSON(@dyn:ADEOfDynamizer@);
  v_schema_116 JSON := JSON(@dyn:ADEOfGenericTimeseries@);
  v_schema_117 JSON := JSON(@dyn:ADEOfStandardFileTimeseries@);
  v_schema_118 JSON := JSON(@dyn:ADEOfTabulatedFileTimeseries@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (100, null, 'AbstractTimeValuePair', 1, 2, v_schema_100),
    (101, null, 'AttributeReference', 0, 2, v_schema_101),
    (102, null, 'SensorConnection', 0, 2, v_schema_102),
    (103, 100, 'TimeAppearance', 0, 2, v_schema_103),
    (104, 100, 'TimeBoolean', 0, 2, v_schema_104),
    (105, 100, 'TimeDouble', 0, 2, v_schema_105),
    (106, 100, 'TimeGeometry', 0, 2, v_schema_106),
    (107, 100, 'TimeImplicitGeometry', 0, 2, v_schema_107),
    (108, 100, 'TimeInteger', 0, 2, v_schema_108),
    (109, null, 'TimeseriesComponent', 0, 2, v_schema_109),
    (110, 100, 'TimeString', 0, 2, v_schema_110),
    (111, 100, 'TimeURI', 0, 2, v_schema_111),
    (112, null, 'ADEOfAbstractAtomicTimeseries', 1, 2, v_schema_112),
    (113, null, 'ADEOfAbstractTimeseries', 1, 2, v_schema_113),
    (114, null, 'ADEOfCompositeTimeseries', 1, 2, v_schema_114),
    (115, null, 'ADEOfDynamizer', 1, 2, v_schema_115),
    (116, null, 'ADEOfGenericTimeseries', 1, 2, v_schema_116),
    (117, null, 'ADEOfStandardFileTimeseries', 1, 2, v_schema_117),
    (118, null, 'ADEOfTabulatedFileTimeseries', 1, 2, v_schema_118);
END;
/

-- Generics Module --

DECLARE
  v_schema_200 JSON := JSON(@gen:GenericAttributeSet@);
  v_schema_201 JSON := JSON(@gen:ADEOfGenericLogicalSpace@);
  v_schema_202 JSON := JSON(@gen:ADEOfGenericOccupiedSpace@);
  v_schema_203 JSON := JSON(@gen:ADEOfGenericThematicSurface@);
  v_schema_204 JSON := JSON(@gen:ADEOfGenericUnoccupiedSpace@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (200, null, 'GenericAttributeSet', 0, 3, v_schema_200),
    (201, null, 'ADEOfGenericLogicalSpace', 1, 3, v_schema_201),
    (202, null, 'ADEOfGenericOccupiedSpace', 1, 3, v_schema_202),
    (203, null, 'ADEOfGenericThematicSurface', 1, 3, v_schema_203),
    (204, null, 'ADEOfGenericUnoccupiedSpace', 1, 3, v_schema_204);
END;
/

-- LandUse Module --

DECLARE
  v_schema_300 JSON := JSON(@luse:ADEOfLandUse@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (300, null, 'ADEOfLandUse', 1, 4, v_schema_300);
END;
/

-- PointCloud Module --

DECLARE
  v_schema_400 JSON := JSON(@pcl:ADEOfPointCloud@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (400, null, 'ADEOfPointCloud', 1, 5, v_schema_400);
END;
/

-- Relief Module --

DECLARE
  v_schema_500 JSON := JSON(@dem:ADEOfAbstractReliefComponent@);
  v_schema_501 JSON := JSON(@dem:ADEOfBreaklineRelief@);
  v_schema_502 JSON := JSON(@dem:ADEOfMassPointRelief@);
  v_schema_503 JSON := JSON(@dem:ADEOfRasterRelief@);
  v_schema_504 JSON := JSON(@dem:ADEOfReliefFeature@);
  v_schema_505 JSON := JSON(@dem:ADEOfTINRelief@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (500, null, 'ADEOfAbstractReliefComponent', 1, 6, v_schema_500),
    (501, null, 'ADEOfBreaklineRelief', 1, 6, v_schema_501),
    (502, null, 'ADEOfMassPointRelief', 1, 6, v_schema_502),
    (503, null, 'ADEOfRasterRelief', 1, 6, v_schema_503),
    (504, null, 'ADEOfReliefFeature', 1, 6, v_schema_504),
    (505, null, 'ADEOfTINRelief', 1, 6, v_schema_505);
END;
/

-- Transportation Module --

DECLARE
  v_schema_600 JSON := JSON(@tran:ADEOfAbstractTransportationSpace@);
  v_schema_601 JSON := JSON(@tran:ADEOfAuxiliaryTrafficArea@);
  v_schema_602 JSON := JSON(@tran:ADEOfAuxiliaryTrafficSpace@);
  v_schema_603 JSON := JSON(@tran:ADEOfClearanceSpace@);
  v_schema_604 JSON := JSON(@tran:ADEOfHole@);
  v_schema_605 JSON := JSON(@tran:ADEOfHoleSurface@);
  v_schema_606 JSON := JSON(@tran:ADEOfIntersection@);
  v_schema_607 JSON := JSON(@tran:ADEOfMarking@);
  v_schema_608 JSON := JSON(@tran:ADEOfRailway@);
  v_schema_609 JSON := JSON(@tran:ADEOfRoad@);
  v_schema_610 JSON := JSON(@tran:ADEOfSection@);
  v_schema_611 JSON := JSON(@tran:ADEOfSquare@);
  v_schema_612 JSON := JSON(@tran:ADEOfTrack@);
  v_schema_613 JSON := JSON(@tran:ADEOfTrafficArea@);
  v_schema_614 JSON := JSON(@tran:ADEOfTrafficSpace@);
  v_schema_615 JSON := JSON(@tran:ADEOfWaterway@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (600, null, 'ADEOfAbstractTransportationSpace', 1, 7, v_schema_600),
    (601, null, 'ADEOfAuxiliaryTrafficArea', 1, 7, v_schema_601),
    (602, null, 'ADEOfAuxiliaryTrafficSpace', 1, 7, v_schema_602),
    (603, null, 'ADEOfClearanceSpace', 1, 7, v_schema_603),
    (604, null, 'ADEOfHole', 1, 7, v_schema_604),
    (605, null, 'ADEOfHoleSurface', 1, 7, v_schema_605),
    (606, null, 'ADEOfIntersection', 1, 7, v_schema_606),
    (607, null, 'ADEOfMarking', 1, 7, v_schema_607),
    (608, null, 'ADEOfRailway', 1, 7, v_schema_608),
    (609, null, 'ADEOfRoad', 1, 7, v_schema_609),
    (610, null, 'ADEOfSection', 1, 7, v_schema_610),
    (611, null, 'ADEOfSquare', 1, 7, v_schema_611),
    (612, null, 'ADEOfTrack', 1, 7, v_schema_612),
    (613, null, 'ADEOfTrafficArea', 1, 7, v_schema_613),
    (614, null, 'ADEOfTrafficSpace', 1, 7, v_schema_614),
    (615, null, 'ADEOfWaterway', 1, 7, v_schema_615);
END;
/

-- Construction Module --

DECLARE
  v_schema_700 JSON := JSON(@con:ConstructionEvent@);
  v_schema_701 JSON := JSON(@con:Elevation@);
  v_schema_702 JSON := JSON(@con:Height@);
  v_schema_703 JSON := JSON(@con:ADEOfAbstractConstruction@);
  v_schema_704 JSON := JSON(@con:ADEOfAbstractConstructionSurface@);
  v_schema_705 JSON := JSON(@con:ADEOfAbstractConstructiveElement@);
  v_schema_706 JSON := JSON(@con:ADEOfAbstractFillingElement@);
  v_schema_707 JSON := JSON(@con:ADEOfAbstractFillingSurface@);
  v_schema_708 JSON := JSON(@con:ADEOfAbstractFurniture@);
  v_schema_709 JSON := JSON(@con:ADEOfAbstractInstallation@);
  v_schema_710 JSON := JSON(@con:ADEOfCeilingSurface@);
  v_schema_711 JSON := JSON(@con:ADEOfDoor@);
  v_schema_712 JSON := JSON(@con:ADEOfDoorSurface@);
  v_schema_713 JSON := JSON(@con:ADEOfFloorSurface@);
  v_schema_714 JSON := JSON(@con:ADEOfGroundSurface@);
  v_schema_715 JSON := JSON(@con:ADEOfInteriorWallSurface@);
  v_schema_716 JSON := JSON(@con:ADEOfOtherConstruction@);
  v_schema_717 JSON := JSON(@con:ADEOfOuterCeilingSurface@);
  v_schema_718 JSON := JSON(@con:ADEOfOuterFloorSurface@);
  v_schema_719 JSON := JSON(@con:ADEOfRoofSurface@);
  v_schema_720 JSON := JSON(@con:ADEOfWallSurface@);
  v_schema_721 JSON := JSON(@con:ADEOfWindow@);
  v_schema_722 JSON := JSON(@con:ADEOfWindowSurface@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (700, null, 'ConstructionEvent', 0, 8, v_schema_700),
    (701, null, 'Elevation', 0, 8, v_schema_701),
    (702, null, 'Height', 0, 8, v_schema_702),
    (703, null, 'ADEOfAbstractConstruction', 1, 8, v_schema_703),
    (704, null, 'ADEOfAbstractConstructionSurface', 1, 8, v_schema_704),
    (705, null, 'ADEOfAbstractConstructiveElement', 1, 8, v_schema_705),
    (706, null, 'ADEOfAbstractFillingElement', 1, 8, v_schema_706),
    (707, null, 'ADEOfAbstractFillingSurface', 1, 8, v_schema_707),
    (708, null, 'ADEOfAbstractFurniture', 1, 8, v_schema_708),
    (709, null, 'ADEOfAbstractInstallation', 1, 8, v_schema_709),
    (710, null, 'ADEOfCeilingSurface', 1, 8, v_schema_710),
    (711, null, 'ADEOfDoor', 1, 8, v_schema_711),
    (712, null, 'ADEOfDoorSurface', 1, 8, v_schema_712),
    (713, null, 'ADEOfFloorSurface', 1, 8, v_schema_713),
    (714, null, 'ADEOfGroundSurface', 1, 8, v_schema_714),
    (715, null, 'ADEOfInteriorWallSurface', 1, 8, v_schema_715),
    (716, null, 'ADEOfOtherConstruction', 1, 8, v_schema_716),
    (717, null, 'ADEOfOuterCeilingSurface', 1, 8, v_schema_717),
    (718, null, 'ADEOfOuterFloorSurface', 1, 8, v_schema_718),
    (719, null, 'ADEOfRoofSurface', 1, 8, v_schema_719),
    (720, null, 'ADEOfWallSurface', 1, 8, v_schema_720),
    (721, null, 'ADEOfWindow', 1, 8, v_schema_721),
    (722, null, 'ADEOfWindowSurface', 1, 8, v_schema_722);
END;
/

-- Tunnel Module --

DECLARE
  v_schema_800 JSON := JSON(@tun:ADEOfAbstractTunnel@);
  v_schema_801 JSON := JSON(@tun:ADEOfHollowSpace@);
  v_schema_802 JSON := JSON(@tun:ADEOfTunnel@);
  v_schema_803 JSON := JSON(@tun:ADEOfTunnelConstructiveElement@);
  v_schema_804 JSON := JSON(@tun:ADEOfTunnelFurniture@);
  v_schema_805 JSON := JSON(@tun:ADEOfTunnelInstallation@);
  v_schema_806 JSON := JSON(@tun:ADEOfTunnelPart@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (800, null, 'ADEOfAbstractTunnel', 1, 9, v_schema_800),
    (801, null, 'ADEOfHollowSpace', 1, 9, v_schema_801),
    (802, null, 'ADEOfTunnel', 1, 9, v_schema_802),
    (803, null, 'ADEOfTunnelConstructiveElement', 1, 9, v_schema_803),
    (804, null, 'ADEOfTunnelFurniture', 1, 9, v_schema_804),
    (805, null, 'ADEOfTunnelInstallation', 1, 9, v_schema_805),
    (806, null, 'ADEOfTunnelPart', 1, 9, v_schema_806);
END;
/

-- Building Module --

DECLARE
  v_schema_900 JSON := JSON(@bldg:RoomHeight@);
  v_schema_901 JSON := JSON(@bldg:ADEOfAbstractBuilding@);
  v_schema_902 JSON := JSON(@bldg:ADEOfAbstractBuildingSubdivision@);
  v_schema_903 JSON := JSON(@bldg:ADEOfBuilding@);
  v_schema_904 JSON := JSON(@bldg:ADEOfBuildingConstructiveElement@);
  v_schema_905 JSON := JSON(@bldg:ADEOfBuildingFurniture@);
  v_schema_906 JSON := JSON(@bldg:ADEOfBuildingInstallation@);
  v_schema_907 JSON := JSON(@bldg:ADEOfBuildingPart@);
  v_schema_908 JSON := JSON(@bldg:ADEOfBuildingRoom@);
  v_schema_909 JSON := JSON(@bldg:ADEOfBuildingUnit@);
  v_schema_910 JSON := JSON(@bldg:ADEOfStorey@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (900, null, 'RoomHeight', 0, 10, v_schema_900),
    (901, null, 'ADEOfAbstractBuilding', 1, 10, v_schema_901),
    (902, null, 'ADEOfAbstractBuildingSubdivision', 1, 10, v_schema_902),
    (903, null, 'ADEOfBuilding', 1, 10, v_schema_903),
    (904, null, 'ADEOfBuildingConstructiveElement', 1, 10, v_schema_904),
    (905, null, 'ADEOfBuildingFurniture', 1, 10, v_schema_905),
    (906, null, 'ADEOfBuildingInstallation', 1, 10, v_schema_906),
    (907, null, 'ADEOfBuildingPart', 1, 10, v_schema_907),
    (908, null, 'ADEOfBuildingRoom', 1, 10, v_schema_908),
    (909, null, 'ADEOfBuildingUnit', 1, 10, v_schema_909),
    (910, null, 'ADEOfStorey', 1, 10, v_schema_910);
END;
/

-- Bridge Module --

DECLARE
  v_schema_1000 JSON := JSON(@brid:ADEOfAbstractBridge@);
  v_schema_1001 JSON := JSON(@brid:ADEOfBridge@);
  v_schema_1002 JSON := JSON(@brid:ADEOfBridgeConstructiveElement@);
  v_schema_1003 JSON := JSON(@brid:ADEOfBridgeFurniture@);
  v_schema_1004 JSON := JSON(@brid:ADEOfBridgeInstallation@);
  v_schema_1005 JSON := JSON(@brid:ADEOfBridgePart@);
  v_schema_1006 JSON := JSON(@brid:ADEOfBridgeRoom@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1000, null, 'ADEOfAbstractBridge', 1, 11, v_schema_1000),
    (1001, null, 'ADEOfBridge', 1, 11, v_schema_1001),
    (1002, null, 'ADEOfBridgeConstructiveElement', 1, 11, v_schema_1002),
    (1003, null, 'ADEOfBridgeFurniture', 1, 11, v_schema_1003),
    (1004, null, 'ADEOfBridgeInstallation', 1, 11, v_schema_1004),
    (1005, null, 'ADEOfBridgePart', 1, 11, v_schema_1005),
    (1006, null, 'ADEOfBridgeRoom', 1, 11, v_schema_1006);
END;
/

-- CityObjectGroup Module --

DECLARE
  v_schema_1200 JSON := JSON(@grp:Role@);
  v_schema_1201 JSON := JSON(@grp:ADEOfCityObjectGroup@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1200, null, 'Role', 0, 13, v_schema_1200),
    (1201, null, 'ADEOfCityObjectGroup', 1, 13, v_schema_1201);
END;
/

-- Vegetation Module --

DECLARE
  v_schema_1300 JSON := JSON(@veg:ADEOfAbstractVegetationObject@);
  v_schema_1301 JSON := JSON(@veg:ADEOfPlantCover@);
  v_schema_1302 JSON := JSON(@veg:ADEOfSolitaryVegetationObject@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1300, null, 'ADEOfAbstractVegetationObject', 1, 14, v_schema_1300),
    (1301, null, 'ADEOfPlantCover', 1, 14, v_schema_1301),
    (1302, null, 'ADEOfSolitaryVegetationObject', 1, 14, v_schema_1302);
END;
/

-- Versioning Module --

DECLARE
  v_schema_1400 JSON := JSON(@vers:Transaction@);
  v_schema_1401 JSON := JSON(@vers:ADEOfVersion@);
  v_schema_1402 JSON := JSON(@vers:ADEOfVersionTransition@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1400, null, 'Transaction', 0, 15, v_schema_1400),
    (1401, null, 'ADEOfVersion', 1, 15, v_schema_1401),
    (1402, null, 'ADEOfVersionTransition', 1, 15, v_schema_1402);
END;
/


-- WaterBody Module --

DECLARE
  v_schema_1500 JSON := JSON(@wtr:ADEOfAbstractWaterBoundarySurface@);
  v_schema_1501 JSON := JSON(@wtr:ADEOfWaterBody@);
  v_schema_1502 JSON := JSON(@wtr:ADEOfWaterGroundSurface@);
  v_schema_1503 JSON := JSON(@wtr:ADEOfWaterSurface@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1500, null, 'ADEOfAbstractWaterBoundarySurface', 1, 16, v_schema_1500),
    (1501, null, 'ADEOfWaterBody', 1, 16, v_schema_1501),
    (1502, null, 'ADEOfWaterGroundSurface', 1, 16, v_schema_1502),
    (1503, null, 'ADEOfWaterSurface', 1, 16, v_schema_1503);
END;
/

-- CityFurniture Module --

DECLARE
  v_schema_1600 JSON := JSON(@frn:ADEOfCityFurniture@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1600, null, 'ADEOfCityFurniture', 1, 17, v_schema_1600);
END;
/

SET DEFINE ON