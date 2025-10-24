SET DEFINE OFF
DELETE FROM datatype;

-- Core Module --

DECLARE
  v_schema1 JSON := JSON(@core:Undefined@);
  v_schema2 JSON := JSON(@core:Boolean@);
  v_schema3 JSON := JSON(@core:Integer@);
  v_schema4 JSON := JSON(@core:Double@);
  v_schema5 JSON := JSON(@core:String@);
  v_schema6 JSON := JSON(@core:URI@);
  v_schema7 JSON := JSON(@core:Timestamp@);
  v_schema8 JSON := JSON(@core:AddressProperty@);
  v_schema9 JSON := JSON(@core:AppearanceProperty@);
  v_schema10 JSON := JSON(@core:FeatureProperty@);
  v_schema11 JSON := JSON(@core:GeometryProperty@);
  v_schema12 JSON := JSON(@core:Reference@);
  v_schema13 JSON := JSON(@core:CityObjectRelation@);
  v_schema14 JSON := JSON(@core:Code@);
  v_schema15 JSON := JSON(@core:ExternalReference@);
  v_schema16 JSON := JSON(@core:ImplicitGeometryProperty@);
  v_schema17 JSON := JSON(@core:Measure@);
  v_schema18 JSON := JSON(@core:MeasureOrNilReasonList@);
  v_schema19 JSON := JSON(@core:Occupancy@);
  v_schema20 JSON := JSON(@core:QualifiedArea@);
  v_schema21 JSON := JSON(@core:QualifiedVolume@);
  v_schema22 JSON := JSON(@core:StringOrRef@);
  v_schema23 JSON := JSON(@core:TimePosition@);
  v_schema24 JSON := JSON(@core:Duration@);
  v_schema50 JSON := JSON(@core:ADEOfAbstractCityObject@);
  v_schema51 JSON := JSON(@core:ADEOfAbstractDynamizer@);
  v_schema52 JSON := JSON(@core:ADEOfAbstractFeature@);
  v_schema53 JSON := JSON(@core:ADEOfAbstractFeatureWithLifespan@);
  v_schema54 JSON := JSON(@core:ADEOfAbstractLogicalSpace@);
  v_schema55 JSON := JSON(@core:ADEOfAbstractOccupiedSpace@);
  v_schema56 JSON := JSON(@core:ADEOfAbstractPhysicalSpace@);
  v_schema57 JSON := JSON(@core:ADEOfAbstractPointCloud@);
  v_schema58 JSON := JSON(@core:ADEOfAbstractSpace@);
  v_schema59 JSON := JSON(@core:ADEOfAbstractSpaceBoundary@);
  v_schema60 JSON := JSON(@core:ADEOfAbstractThematicSurface@);
  v_schema61 JSON := JSON(@core:ADEOfAbstractUnoccupiedSpace@);
  v_schema62 JSON := JSON(@core:ADEOfAbstractVersion@);
  v_schema63 JSON := JSON(@core:ADEOfAbstractVersionTransition@);
  v_schema64 JSON := JSON(@core:ADEOfCityModel@);
  v_schema65 JSON := JSON(@core:ADEOfClosureSurface@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1, null, 'Undefined', 1, 1, v_schema1),
    (2, null, 'Boolean', 0, 1, v_schema2),
    (3, null, 'Integer', 0, 1, v_schema3),
    (4, null, 'Double', 0, 1, v_schema4),
    (5, null, 'String', 0, 1, v_schema5),
    (6, null, 'URI', 0, 1, v_schema6),
    (7, null, 'Timestamp', 0, 1, v_schema7),
    (8, null, 'AddressProperty', 0, 1, v_schema8),
    (9, null, 'AppearanceProperty', 0, 1, v_schema9),
    (10, null, 'FeatureProperty', 0, 1, v_schema10),
    (11, null, 'GeometryProperty', 0, 1, v_schema11),
    (12, null, 'Reference', 0, 1, v_schema12),
    (13, null, 'CityObjectRelation', 0, 1, v_schema13),
    (14, null, 'Code', 0, 1, v_schema14),
    (15, null, 'ExternalReference', 0, 1, v_schema15),
    (16, null, 'ImplicitGeometryProperty', 0, 1, v_schema16),
    (17, null, 'Measure', 0, 1, v_schema17),
    (18, null, 'MeasureOrNilReasonList', 0, 1, v_schema18),
    (19, null, 'Occupancy', 0, 1, v_schema19),
    (20, null, 'QualifiedArea', 0, 1, v_schema20),
    (21, null, 'QualifiedVolume', 0, 1, v_schema21),
    (22, null, 'StringOrRef', 0, 1, v_schema22),
    (23, null, 'TimePosition', 0, 1, v_schema23),
    (24, null, 'Duration', 0, 1, v_schema24),
    (50, null, 'ADEOfAbstractCityObject', 1, 1, v_schema50),
    (51, null, 'ADEOfAbstractDynamizer', 1, 1, v_schema51),
    (52, null, 'ADEOfAbstractFeature', 1, 1, v_schema52),
    (53, null, 'ADEOfAbstractFeatureWithLifespan', 1, 1, v_schema53),
    (54, null, 'ADEOfAbstractLogicalSpace', 1, 1, v_schema54),
    (55, null, 'ADEOfAbstractOccupiedSpace', 1, 1, v_schema55),
    (56, null, 'ADEOfAbstractPhysicalSpace', 1, 1, v_schema56),
    (57, null, 'ADEOfAbstractPointCloud', 1, 1, v_schema57),
    (58, null, 'ADEOfAbstractSpace', 1, 1, v_schema58),
    (59, null, 'ADEOfAbstractSpaceBoundary', 1, 1, v_schema59),
    (60, null, 'ADEOfAbstractThematicSurface', 1, 1, v_schema60),
    (61, null, 'ADEOfAbstractUnoccupiedSpace', 1, 1, v_schema61),
    (62, null, 'ADEOfAbstractVersion', 1, 1, v_schema62),
    (63, null, 'ADEOfAbstractVersionTransition', 1, 1, v_schema63),
    (64, null, 'ADEOfCityModel', 1, 1, v_schema64),
    (65, null, 'ADEOfClosureSurface', 1, 1, v_schema65);

  COMMIT;
END;
/

-- Dynamizer Module --

DECLARE
  v_schema100 JSON := JSON(@dyn:AbstractTimeValuePair@);
  v_schema101 JSON := JSON(@dyn:AttributeReference@);
  v_schema102 JSON := JSON(@dyn:SensorConnection@);
  v_schema103 JSON := JSON(@dyn:TimeAppearance@);
  v_schema104 JSON := JSON(@dyn:TimeBoolean@);
  v_schema105 JSON := JSON(@dyn:TimeDouble@);
  v_schema106 JSON := JSON(@dyn:TimeGeometry@);
  v_schema107 JSON := JSON(@dyn:TimeImplicitGeometry@);
  v_schema108 JSON := JSON(@dyn:TimeInteger@);
  v_schema109 JSON := JSON(@dyn:TimeseriesComponent@);
  v_schema110 JSON := JSON(@dyn:TimeString@);
  v_schema111 JSON := JSON(@dyn:TimeURI@);
  v_schema112 JSON := JSON(@dyn:ADEOfAbstractAtomicTimeseries@);
  v_schema113 JSON := JSON(@dyn:ADEOfAbstractTimeseries@);
  v_schema114 JSON := JSON(@dyn:ADEOfCompositeTimeseries@);
  v_schema115 JSON := JSON(@dyn:ADEOfDynamizer@);
  v_schema116 JSON := JSON(@dyn:ADEOfGenericTimeseries@);
  v_schema117 JSON := JSON(@dyn:ADEOfStandardFileTimeseries@);
  v_schema118 JSON := JSON(@dyn:ADEOfTabulatedFileTimeseries@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (100, null, 'AbstractTimeValuePair', 1, 2, v_schema100),
    (101, null, 'AttributeReference', 0, 2, v_schema101),
    (102, null, 'SensorConnection', 0, 2, v_schema102),
    (103, 100, 'TimeAppearance', 0, 2, v_schema103),
    (104, 100, 'TimeBoolean', 0, 2, v_schema104),
    (105, 100, 'TimeDouble', 0, 2, v_schema105),
    (106, 100, 'TimeGeometry', 0, 2, v_schema106),
    (107, 100, 'TimeImplicitGeometry', 0, 2, v_schema107),
    (108, 100, 'TimeInteger', 0, 2, v_schema108),
    (109, null, 'TimeseriesComponent', 0, 2, v_schema109),
    (110, 100, 'TimeString', 0, 2, v_schema110),
    (111, 100, 'TimeURI', 0, 2, v_schema111),
    (112, null, 'ADEOfAbstractAtomicTimeseries', 1, 2, v_schema112),
    (113, null, 'ADEOfAbstractTimeseries', 1, 2, v_schema113),
    (114, null, 'ADEOfCompositeTimeseries', 1, 2, v_schema114),
    (115, null, 'ADEOfDynamizer', 1, 2, v_schema115),
    (116, null, 'ADEOfGenericTimeseries', 1, 2, v_schema116),
    (117, null, 'ADEOfStandardFileTimeseries', 1, 2, v_schema117),
    (118, null, 'ADEOfTabulatedFileTimeseries', 1, 2, v_schema118);

  COMMIT;
END;
/

-- Generics Module --

DECLARE
  v_schema200 JSON := JSON(@gen:GenericAttributeSet@);
  v_schema201 JSON := JSON(@gen:ADEOfGenericLogicalSpace@);
  v_schema202 JSON := JSON(@gen:ADEOfGenericOccupiedSpace@);
  v_schema203 JSON := JSON(@gen:ADEOfGenericThematicSurface@);
  v_schema204 JSON := JSON(@gen:ADEOfGenericUnoccupiedSpace@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (200, null, 'GenericAttributeSet', 0, 3, v_schema200),
    (201, null, 'ADEOfGenericLogicalSpace', 1, 3, v_schema201),
    (202, null, 'ADEOfGenericOccupiedSpace', 1, 3, v_schema202),
    (203, null, 'ADEOfGenericThematicSurface', 1, 3, v_schema203),
    (204, null, 'ADEOfGenericUnoccupiedSpace', 1, 3, v_schema204);

  COMMIT;
END;
/

-- LandUse Module --

DECLARE
  v_schema300 JSON := JSON(@luse:ADEOfLandUse@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (300, null, 'ADEOfLandUse', 1, 4, v_schema300);

  COMMIT;
END;
/

-- PointCloud Module --

DECLARE
  v_schema400 JSON := JSON(@luse:ADEOfPointCloud@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (400, null, 'ADEOfPointCloud', 1, 5, v_schema400);

  COMMIT;
END;
/

-- Relief Module --

DECLARE
  v_schema500 JSON := JSON(@dem:ADEOfAbstractReliefComponent@);
  v_schema501 JSON := JSON(@dem:ADEOfBreaklineRelief@);
  v_schema502 JSON := JSON(@dem:ADEOfMassPointRelief@);
  v_schema503 JSON := JSON(@dem:ADEOfRasterRelief@);
  v_schema504 JSON := JSON(@dem:ADEOfReliefFeature@);
  v_schema505 JSON := JSON(@dem:ADEOfTINRelief@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (500, null, 'ADEOfAbstractReliefComponent', 1, 6, v_schema500),
    (501, null, 'ADEOfBreaklineRelief', 1, 6, v_schema501),
    (502, null, 'ADEOfMassPointRelief', 1, 6, v_schema502),
    (503, null, 'ADEOfRasterRelief', 1, 6, v_schema503),
    (504, null, 'ADEOfReliefFeature', 1, 6, v_schema504),
    (505, null, 'ADEOfTINRelief', 1, 6, v_schema505);

  COMMIT;
END;
/

-- Transportation Module --

DECLARE
  v_schema600 JSON := JSON(@tran:ADEOfAbstractTransportationSpace@);
  v_schema601 JSON := JSON(@tran:ADEOfAuxiliaryTrafficArea@);
  v_schema602 JSON := JSON(@tran:ADEOfAuxiliaryTrafficSpace@);
  v_schema603 JSON := JSON(@tran:ADEOfClearanceSpace@);
  v_schema604 JSON := JSON(@tran:ADEOfHole@);
  v_schema605 JSON := JSON(@tran:ADEOfHoleSurface@);
  v_schema606 JSON := JSON(@tran:ADEOfIntersection@);
  v_schema607 JSON := JSON(@tran:ADEOfMarking@);
  v_schema608 JSON := JSON(@tran:ADEOfRailway@);
  v_schema609 JSON := JSON(@tran:ADEOfRoad@);
  v_schema610 JSON := JSON(@tran:ADEOfSection@);
  v_schema611 JSON := JSON(@tran:ADEOfSquare@);
  v_schema612 JSON := JSON(@tran:ADEOfTrack@);
  v_schema613 JSON := JSON(@tran:ADEOfTrafficArea@);
  v_schema614 JSON := JSON(@tran:ADEOfTrafficSpace@);
  v_schema615 JSON := JSON(@tran:ADEOfWaterway@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (600, null, 'ADEOfAbstractTransportationSpace', 1, 7, v_schema600),
    (601, null, 'ADEOfAuxiliaryTrafficArea', 1, 7, v_schema601),
    (602, null, 'ADEOfAuxiliaryTrafficSpace', 1, 7, v_schema602),
    (603, null, 'ADEOfClearanceSpace', 1, 7, v_schema603),
    (604, null, 'ADEOfHole', 1, 7, v_schema604),
    (605, null, 'ADEOfHoleSurface', 1, 7, v_schema605),
    (606, null, 'ADEOfIntersection', 1, 7, v_schema606),
    (607, null, 'ADEOfMarking', 1, 7, v_schema607),
    (608, null, 'ADEOfRailway', 1, 7, v_schema608),
    (609, null, 'ADEOfRoad', 1, 7, v_schema609),
    (610, null, 'ADEOfSection', 1, 7, v_schema610),
    (611, null, 'ADEOfSquare', 1, 7, v_schema611),
    (612, null, 'ADEOfTrack', 1, 7, v_schema612),
    (613, null, 'ADEOfTrafficArea', 1, 7, v_schema613),
    (614, null, 'ADEOfTrafficSpace', 1, 7, v_schema614),
    (615, null, 'ADEOfWaterway', 1, 7, v_schema615);

  COMMIT;
END;
/

-- Construction Module --

DECLARE
  v_schema700 JSON := JSON(@con:ConstructionEvent@);
  v_schema701 JSON := JSON(@con:Elevation@);
  v_schema702 JSON := JSON(@con:Height@);
  v_schema703 JSON := JSON(@con:ADEOfAbstractConstruction@);
  v_schema704 JSON := JSON(@con:ADEOfAbstractConstructionSurface@);
  v_schema705 JSON := JSON(@con:ADEOfAbstractConstructiveElement@);
  v_schema706 JSON := JSON(@con:ADEOfAbstractFillingElement@);
  v_schema707 JSON := JSON(@con:ADEOfAbstractFillingSurface@);
  v_schema708 JSON := JSON(@con:ADEOfAbstractFurniture@);
  v_schema709 JSON := JSON(@con:ADEOfAbstractInstallation@);
  v_schema710 JSON := JSON(@con:ADEOfCeilingSurface@);
  v_schema711 JSON := JSON(@con:ADEOfDoor@);
  v_schema712 JSON := JSON(@con:ADEOfDoorSurface@);
  v_schema713 JSON := JSON(@con:ADEOfFloorSurface@);
  v_schema714 JSON := JSON(@con:ADEOfGroundSurface@);
  v_schema715 JSON := JSON(@con:ADEOfInteriorWallSurface@);
  v_schema716 JSON := JSON(@con:ADEOfOtherConstruction@);
  v_schema717 JSON := JSON(@con:ADEOfOuterCeilingSurface@);
  v_schema718 JSON := JSON(@con:ADEOfOuterFloorSurface@);
  v_schema719 JSON := JSON(@con:ADEOfRoofSurface@);
  v_schema720 JSON := JSON(@con:ADEOfWallSurface@);
  v_schema721 JSON := JSON(@con:ADEOfWindow@);
  v_schema722 JSON := JSON(@con:ADEOfWindowSurface@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (700, null, 'ConstructionEvent', 0, 8, v_schema700),
    (701, null, 'Elevation', 0, 8, v_schema701),
    (702, null, 'Height', 0, 8, v_schema702),
    (703, null, 'ADEOfAbstractConstruction', 1, 8, v_schema703),
    (704, null, 'ADEOfAbstractConstructionSurface', 1, 8, v_schema704),
    (705, null, 'ADEOfAbstractConstructiveElement', 1, 8, v_schema705),
    (706, null, 'ADEOfAbstractFillingElement', 1, 8, v_schema706),
    (707, null, 'ADEOfAbstractFillingSurface', 1, 8, v_schema707),
    (708, null, 'ADEOfAbstractFurniture', 1, 8, v_schema708),
    (709, null, 'ADEOfAbstractInstallation', 1, 8, v_schema709),
    (710, null, 'ADEOfCeilingSurface', 1, 8, v_schema710),
    (711, null, 'ADEOfDoor', 1, 8, v_schema711),
    (712, null, 'ADEOfDoorSurface', 1, 8, v_schema712),
    (713, null, 'ADEOfFloorSurface', 1, 8, v_schema713),
    (714, null, 'ADEOfGroundSurface', 1, 8, v_schema714),
    (715, null, 'ADEOfInteriorWallSurface', 1, 8, v_schema715),
    (716, null, 'ADEOfOtherConstruction', 1, 8, v_schema716),
    (717, null, 'ADEOfOuterCeilingSurface', 1, 8, v_schema717),
    (718, null, 'ADEOfOuterFloorSurface', 1, 8, v_schema718),
    (719, null, 'ADEOfRoofSurface', 1, 8, v_schema719),
    (720, null, 'ADEOfWallSurface', 1, 8, v_schema720),
    (721, null, 'ADEOfWindow', 1, 8, v_schema721),
    (722, null, 'ADEOfWindowSurface', 1, 8, v_schema722);

  COMMIT;
END;
/

-- Tunnel Module --

DECLARE
  v_schema800 JSON := JSON(@tun:ADEOfAbstractTunnel@);
  v_schema801 JSON := JSON(@tun:ADEOfHollowSpace@);
  v_schema802 JSON := JSON(@tun:ADEOfTunnel@);
  v_schema803 JSON := JSON(@tun:ADEOfTunnelConstructiveElement@);
  v_schema804 JSON := JSON(@tun:ADEOfTunnelFurniture@);
  v_schema805 JSON := JSON(@tun:ADEOfTunnelInstallation@);
  v_schema806 JSON := JSON(@tun:ADEOfTunnelPart@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (800, null, 'ADEOfAbstractTunnel', 1, 9, v_schema800),
    (801, null, 'ADEOfHollowSpace', 1, 9, v_schema801),
    (802, null, 'ADEOfTunnel', 1, 9, v_schema802),
    (803, null, 'ADEOfTunnelConstructiveElement', 1, 9, v_schema803),
    (804, null, 'ADEOfTunnelFurniture', 1, 9, v_schema804),
    (805, null, 'ADEOfTunnelInstallation', 1, 9, v_schema805),
    (806, null, 'ADEOfTunnelPart', 1, 9, v_schema806);

  COMMIT;
END;
/

-- Building Module --

DECLARE
  v_schema900 JSON := JSON(@bldg:RoomHeight@);
  v_schema901 JSON := JSON(@bldg:ADEOfAbstractBuilding@);
  v_schema902 JSON := JSON(@bldg:ADEOfAbstractBuildingSubdivision@);
  v_schema903 JSON := JSON(@bldg:ADEOfBuilding@);
  v_schema904 JSON := JSON(@bldg:ADEOfBuildingConstructiveElement@);
  v_schema905 JSON := JSON(@bldg:ADEOfBuildingFurniture@);
  v_schema906 JSON := JSON(@bldg:ADEOfBuildingInstallation@);
  v_schema907 JSON := JSON(@bldg:ADEOfBuildingPart@);
  v_schema908 JSON := JSON(@bldg:ADEOfBuildingRoom@);
  v_schema909 JSON := JSON(@bldg:ADEOfBuildingUnit@);
  v_schema910 JSON := JSON(@bldg:ADEOfStorey@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (900, null, 'RoomHeight', 0, 10, v_schema900),
    (901, null, 'ADEOfAbstractBuilding', 1, 10, v_schema901),
    (902, null, 'ADEOfAbstractBuildingSubdivision', 1, 10, v_schema902),
    (903, null, 'ADEOfBuilding', 1, 10, v_schema903),
    (904, null, 'ADEOfBuildingConstructiveElement', 1, 10, v_schema904),
    (905, null, 'ADEOfBuildingFurniture', 1, 10, v_schema905),
    (906, null, 'ADEOfBuildingInstallation', 1, 10, v_schema906),
    (907, null, 'ADEOfBuildingPart', 1, 10, v_schema907),
    (908, null, 'ADEOfBuildingRoom', 1, 10, v_schema908),
    (909, null, 'ADEOfBuildingUnit', 1, 10, v_schema909),
    (910, null, 'ADEOfStorey', 1, 10, v_schema910);

  COMMIT;
END;
/

-- Bridge Module --

DECLARE
  v_schema1000 JSON := JSON(@brid:ADEOfAbstractBridge@);
  v_schema1001 JSON := JSON(@brid:ADEOfBridge@);
  v_schema1002 JSON := JSON(@brid:ADEOfBridgeConstructiveElement@);
  v_schema1003 JSON := JSON(@brid:ADEOfBridgeFurniture@);
  v_schema1004 JSON := JSON(@brid:ADEOfBridgeInstallation@);
  v_schema1005 JSON := JSON(@brid:ADEOfBridgePart@);
  v_schema1006 JSON := JSON(@brid:ADEOfBridgeRoom@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1000, null, 'ADEOfAbstractBridge', 1, 11, v_schema1000),
    (1001, null, 'ADEOfBridge', 1, 11, v_schema1001),
    (1002, null, 'ADEOfBridgeConstructiveElement', 1, 11, v_schema1002),
    (1003, null, 'ADEOfBridgeFurniture', 1, 11, v_schema1003),
    (1004, null, 'ADEOfBridgeInstallation', 1, 11, v_schema1004),
    (1005, null, 'ADEOfBridgePart', 1, 11, v_schema1005),
    (1006, null, 'ADEOfBridgeRoom', 1, 11, v_schema1006);

  COMMIT;
END;
/

-- CityObjectGroup Module --

DECLARE
  v_schema1200 JSON := JSON(@grp:Role@);
  v_schema1201 JSON := JSON(@grp:ADEOfCityObjectGroup@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1200, null, 'Role', 0, 13, v_schema1200),
    (1201, null, 'ADEOfCityObjectGroup', 1, 13, v_schema1201);

  COMMIT;
END;
/

-- Vegetation Module --

DECLARE
  v_schema1300 JSON := JSON(@veg:ADEOfAbstractVegetationObject@);
  v_schema1301 JSON := JSON(@veg:ADEOfPlantCover@);
  v_schema1302 JSON := JSON(@veg:ADEOfSolitaryVegetationObject@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1300, null, 'ADEOfAbstractVegetationObject', 1, 14, v_schema1300),
    (1301, null, 'ADEOfPlantCover', 1, 14, v_schema1301),
    (1302, null, 'ADEOfSolitaryVegetationObject', 1, 14, v_schema1302);

  COMMIT;
END;
/

-- Versioning Module --

DECLARE
  v_schema1400 JSON := JSON(@vers:Transaction@);
  v_schema1401 JSON := JSON(@vers:ADEOfVersion@);
  v_schema1402 JSON := JSON(@vers:ADEOfVersionTransition@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1400, null, 'Transaction', 0, 15, v_schema1400),
    (1401, null, 'ADEOfVersion', 1, 15, v_schema1401),
    (1402, null, 'ADEOfVersionTransition', 1, 15, v_schema1402);

  COMMIT;
END;
/


-- WaterBody Module --

DECLARE
  v_schema1500 JSON := JSON(@wtr:ADEOfAbstractWaterBoundarySurface@);
  v_schema1501 JSON := JSON(@wtr:ADEOfWaterBody@);
  v_schema1502 JSON := JSON(@wtr:ADEOfWaterGroundSurface@);
  v_schema1503 JSON := JSON(@wtr:ADEOfWaterSurface@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1500, null, 'ADEOfAbstractWaterBoundarySurface', 1, 16, v_schema1500),
    (1501, null, 'ADEOfWaterBody', 1, 16, v_schema1501),
    (1502, null, 'ADEOfWaterGroundSurface', 1, 16, v_schema1502),
    (1503, null, 'ADEOfWaterSurface', 1, 16, v_schema1503);

  COMMIT;
END;
/

-- CityFurniture Module --

DECLARE
  v_schema1600 JSON := JSON(@frn:ADEOfCityFurniture@);
BEGIN
  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
  VALUES
    (1600, null, 'ADEOfCityFurniture', 1, 17, v_schema1600);

  COMMIT;
END;
/
