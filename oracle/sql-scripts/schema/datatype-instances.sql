-----------------------------------------------------
-- Author: Karin Patenge, Oracle
-- Last update: September 2025
-- Status: to be reviewed
-- This scripts requires Oracle Database version 23ai
-----------------------------------------------------

TRUNCATE TABLE datatype DROP STORAGE;

-- Core Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1, null, 'Undefined', 1, 1, @core:Undefined@),
  (2, null, 'Boolean', 0, 1, @core:Boolean@),
  (3, null, 'Integer', 0, 1, @core:Integer@),
  (4, null, 'Double', 0, 1, @core:Double@),
  (5, null, 'String', 0, 1, @core:String@),
  (6, null, 'URI', 0, 1, @core:URI@),
  (7, null, 'Timestamp', 0, 1, @core:Timestamp@),
  (8, null, 'AddressProperty', 0, 1, @core:AddressProperty@),
  (9, null, 'AppearanceProperty', 0, 1, @core:AppearanceProperty@),
  (10, null, 'FeatureProperty', 0, 1, @core:FeatureProperty@),
  (11, null, 'GeometryProperty', 0, 1, @core:GeometryProperty@),
  (12, null, 'Reference', 0, 1, @core:Reference@),
  (13, null, 'CityObjectRelation', 0, 1, @core:CityObjectRelation@),
  (14, null, 'Code', 0, 1, @core:Code@),
  (15, null, 'ExternalReference', 0, 1, @core:ExternalReference@),
  (16, null, 'ImplicitGeometryProperty', 0, 1, @core:ImplicitGeometryProperty@),
  (17, null, 'Measure', 0, 1, @core:Measure@),
  (18, null, 'MeasureOrNilReasonList', 0, 1, @core:MeasureOrNilReasonList@),
  (19, null, 'Occupancy', 0, 1, @core:Occupancy@),
  (20, null, 'QualifiedArea', 0, 1, @core:QualifiedArea@),
  (21, null, 'QualifiedVolume', 0, 1, @core:QualifiedVolume@),
  (22, null, 'StringOrRef', 0, 1, @core:StringOrRef@),
  (23, null, 'TimePosition', 0, 1, @core:TimePosition@),
  (24, null, 'Duration', 0, 1, @core:Duration@),
  (50, null, 'ADEOfAbstractCityObject', 1, 1, @core:ADEOfAbstractCityObject@),
  (51, null, 'ADEOfAbstractDynamizer', 1, 1, @core:ADEOfAbstractDynamizer@),
  (52, null, 'ADEOfAbstractFeature', 1, 1, @core:ADEOfAbstractFeature@),
  (53, null, 'ADEOfAbstractFeatureWithLifespan', 1, 1, @core:ADEOfAbstractFeatureWithLifespan@),
  (54, null, 'ADEOfAbstractLogicalSpace', 1, 1, @core:ADEOfAbstractLogicalSpace@),
  (55, null, 'ADEOfAbstractOccupiedSpace', 1, 1, @core:ADEOfAbstractOccupiedSpace@),
  (56, null, 'ADEOfAbstractPhysicalSpace', 1, 1, @core:ADEOfAbstractPhysicalSpace@),
  (57, null, 'ADEOfAbstractPointCloud', 1, 1, @core:ADEOfAbstractPointCloud@),
  (58, null, 'ADEOfAbstractSpace', 1, 1, @core:ADEOfAbstractSpace@),
  (59, null, 'ADEOfAbstractSpaceBoundary', 1, 1, @core:ADEOfAbstractSpaceBoundary@),
  (60, null, 'ADEOfAbstractThematicSurface', 1, 1, @core:ADEOfAbstractThematicSurface@),
  (61, null, 'ADEOfAbstractUnoccupiedSpace', 1, 1, @core:ADEOfAbstractUnoccupiedSpace@),
  (62, null, 'ADEOfAbstractVersion', 1, 1, @core:ADEOfAbstractVersion@),
  (63, null, 'ADEOfAbstractVersionTransition', 1, 1, @core:ADEOfAbstractVersionTransition@),
  (64, null, 'ADEOfCityModel', 1, 1, @core:ADEOfCityModel@),
  (65, null, 'ADEOfClosureSurface', 1, 1, @core:ADEOfClosureSurface@);

COMMIT;

-- Dynamizer Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (100, null, 'AbstractTimeValuePair', 1, 2, @dyn:AbstractTimeValuePair@),
  (101, null, 'AttributeReference', 0, 2, @dyn:AttributeReference@),
  (102, null, 'SensorConnection', 0, 2, @dyn:SensorConnection@),
  (103, 100, 'TimeAppearance', 0, 2, @dyn:TimeAppearance@),
  (104, 100, 'TimeBoolean', 0, 2, @dyn:TimeBoolean@),
  (105, 100, 'TimeDouble', 0, 2, @dyn:TimeDouble@),
  (106, 100, 'TimeGeometry', 0, 2, @dyn:TimeGeometry@),
  (107, 100, 'TimeImplicitGeometry', 0, 2, @dyn:TimeImplicitGeometry@),
  (108, 100, 'TimeInteger', 0, 2, @dyn:TimeInteger@),
  (109, null, 'TimeseriesComponent', 0, 2, @dyn:TimeseriesComponent@),
  (110, 100, 'TimeString', 0, 2, @dyn:TimeString@),
  (111, 100, 'TimeURI', 0, 2, @dyn:TimeURI@),
  (112, null, 'ADEOfAbstractAtomicTimeseries', 1, 2, @dyn:ADEOfAbstractAtomicTimeseries@),
  (113, null, 'ADEOfAbstractTimeseries', 1, 2, @dyn:ADEOfAbstractTimeseries@),
  (114, null, 'ADEOfCompositeTimeseries', 1, 2, @dyn:ADEOfCompositeTimeseries@),
  (115, null, 'ADEOfDynamizer', 1, 2, @dyn:ADEOfDynamizer@),
  (116, null, 'ADEOfGenericTimeseries', 1, 2, @dyn:ADEOfGenericTimeseries@),
  (117, null, 'ADEOfStandardFileTimeseries', 1, 2, @dyn:ADEOfStandardFileTimeseries@),
  (118, null, 'ADEOfTabulatedFileTimeseries', 1, 2, @dyn:ADEOfTabulatedFileTimeseries@);

COMMIT;

-- Generics Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (200, null, 'GenericAttributeSet', 0, 3, @gen:GenericAttributeSet@),
  (201, null, 'ADEOfGenericLogicalSpace', 1, 3, @gen:ADEOfGenericLogicalSpace@),
  (202, null, 'ADEOfGenericOccupiedSpace', 1, 3, @gen:ADEOfGenericOccupiedSpace@),
  (203, null, 'ADEOfGenericThematicSurface', 1, 3, @gen:ADEOfGenericThematicSurface@),
  (204, null, 'ADEOfGenericUnoccupiedSpace', 1, 3, @gen:ADEOfGenericUnoccupiedSpace@);

COMMIT;

-- LandUse Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (300, null, 'ADEOfLandUse', 1, 4, @luse:ADEOfLandUse@);

COMMIT;

-- PointCloud Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (400, null, 'ADEOfPointCloud', 1, 5, @luse:ADEOfPointCloud@);

COMMIT;

-- Relief Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (500, null, 'ADEOfAbstractReliefComponent', 1, 6, @dem:ADEOfAbstractReliefComponent@),
  (501, null, 'ADEOfBreaklineRelief', 1, 6, @dem:ADEOfBreaklineRelief@),
  (502, null, 'ADEOfMassPointRelief', 1, 6, @dem:ADEOfMassPointRelief@),
  (503, null, 'ADEOfRasterRelief', 1, 6, @dem:ADEOfRasterRelief@),
  (504, null, 'ADEOfReliefFeature', 1, 6, @dem:ADEOfReliefFeature@),
  (505, null, 'ADEOfTINRelief', 1, 6, @dem:ADEOfTINRelief@);

COMMIT;

-- Transportation Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (600, null, 'ADEOfAbstractTransportationSpace', 1, 7, @tran:ADEOfAbstractTransportationSpace@),
  (601, null, 'ADEOfAuxiliaryTrafficArea', 1, 7, @tran:ADEOfAuxiliaryTrafficArea@),
  (602, null, 'ADEOfAuxiliaryTrafficSpace', 1, 7, @tran:ADEOfAuxiliaryTrafficSpace@),
  (603, null, 'ADEOfClearanceSpace', 1, 7, @tran:ADEOfClearanceSpace@),
  (604, null, 'ADEOfHole', 1, 7, @tran:ADEOfHole@),
  (605, null, 'ADEOfHoleSurface', 1, 7, @tran:ADEOfHoleSurface@),
  (606, null, 'ADEOfIntersection', 1, 7, @tran:ADEOfIntersection@),
  (607, null, 'ADEOfMarking', 1, 7, @tran:ADEOfMarking@),
  (608, null, 'ADEOfRailway', 1, 7, @tran:ADEOfRailway@),
  (609, null, 'ADEOfRoad', 1, 7, @tran:ADEOfRoad@),
  (610, null, 'ADEOfSection', 1, 7, @tran:ADEOfSection@),
  (611, null, 'ADEOfSquare', 1, 7, @tran:ADEOfSquare@),
  (612, null, 'ADEOfTrack', 1, 7, @tran:ADEOfTrack@),
  (613, null, 'ADEOfTrafficArea', 1, 7, @tran:ADEOfTrafficArea@),
  (614, null, 'ADEOfTrafficSpace', 1, 7, @tran:ADEOfTrafficSpace@),
  (615, null, 'ADEOfWaterway', 1, 7, @tran:ADEOfWaterway@);

COMMIT;

-- Construction Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (700, null, 'ConstructionEvent', 0, 8, @con:ConstructionEvent@),
  (701, null, 'Elevation', 0, 8, @con:Elevation@),
  (702, null, 'Height', 0, 8, @con:Height@),
  (703, null, 'ADEOfAbstractConstruction', 1, 8, @con:ADEOfAbstractConstruction@),
  (704, null, 'ADEOfAbstractConstructionSurface', 1, 8, @con:ADEOfAbstractConstructionSurface@),
  (705, null, 'ADEOfAbstractConstructiveElement', 1, 8, @con:ADEOfAbstractConstructiveElement@),
  (706, null, 'ADEOfAbstractFillingElement', 1, 8, @con:ADEOfAbstractFillingElement@),
  (707, null, 'ADEOfAbstractFillingSurface', 1, 8, @con:ADEOfAbstractFillingSurface@),
  (708, null, 'ADEOfAbstractFurniture', 1, 8, @con:ADEOfAbstractFurniture@),
  (709, null, 'ADEOfAbstractInstallation', 1, 8, @con:ADEOfAbstractInstallation@),
  (710, null, 'ADEOfCeilingSurface', 1, 8, @con:ADEOfCeilingSurface@),
  (711, null, 'ADEOfDoor', 1, 8, @con:ADEOfDoor@),
  (712, null, 'ADEOfDoorSurface', 1, 8, @con:ADEOfDoorSurface@),
  (713, null, 'ADEOfFloorSurface', 1, 8, @con:ADEOfFloorSurface@),
  (714, null, 'ADEOfGroundSurface', 1, 8, @con:ADEOfGroundSurface@),
  (715, null, 'ADEOfInteriorWallSurface', 1, 8, @con:ADEOfInteriorWallSurface@),
  (716, null, 'ADEOfOtherConstruction', 1, 8, @con:ADEOfOtherConstruction@),
  (717, null, 'ADEOfOuterCeilingSurface', 1, 8, @con:ADEOfOuterCeilingSurface@),
  (718, null, 'ADEOfOuterFloorSurface', 1, 8, @con:ADEOfOuterFloorSurface@),
  (719, null, 'ADEOfRoofSurface', 1, 8, @con:ADEOfRoofSurface@),
  (720, null, 'ADEOfWallSurface', 1, 8, @con:ADEOfWallSurface@),
  (721, null, 'ADEOfWindow', 1, 8, @con:ADEOfWindow@),
  (722, null, 'ADEOfWindowSurface', 1, 8, @con:ADEOfWindowSurface@);

COMMIT;

-- Tunnel Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (800, null, 'ADEOfAbstractTunnel', 1, 9, @tun:ADEOfAbstractTunnel@),
  (801, null, 'ADEOfHollowSpace', 1, 9, @tun:ADEOfHollowSpace@),
  (802, null, 'ADEOfTunnel', 1, 9, @tun:ADEOfTunnel@),
  (803, null, 'ADEOfTunnelConstructiveElement', 1, 9, @tun:ADEOfTunnelConstructiveElement@),
  (804, null, 'ADEOfTunnelFurniture', 1, 9, @tun:ADEOfTunnelFurniture@),
  (805, null, 'ADEOfTunnelInstallation', 1, 9, @tun:ADEOfTunnelInstallation@),
  (806, null, 'ADEOfTunnelPart', 1, 9, @tun:ADEOfTunnelPart@);

COMMIT;

-- Building Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (900, null, 'RoomHeight', 0, 10, @bldg:RoomHeight@),
  (901, null, 'ADEOfAbstractBuilding', 1, 10, @bldg:ADEOfAbstractBuilding@),
  (902, null, 'ADEOfAbstractBuildingSubdivision', 1, 10, @bldg:ADEOfAbstractBuildingSubdivision@),
  (903, null, 'ADEOfBuilding', 1, 10, @bldg:ADEOfBuilding@),
  (904, null, 'ADEOfBuildingConstructiveElement', 1, 10, @bldg:ADEOfBuildingConstructiveElement@),
  (905, null, 'ADEOfBuildingFurniture', 1, 10, @bldg:ADEOfBuildingFurniture@),
  (906, null, 'ADEOfBuildingInstallation', 1, 10, @bldg:ADEOfBuildingInstallation@),
  (907, null, 'ADEOfBuildingPart', 1, 10, @bldg:ADEOfBuildingPart@),
  (908, null, 'ADEOfBuildingRoom', 1, 10, @bldg:ADEOfBuildingRoom@),
  (909, null, 'ADEOfBuildingUnit', 1, 10, @bldg:ADEOfBuildingUnit@),
  (910, null, 'ADEOfStorey', 1, 10, @bldg:ADEOfStorey@);

COMMIT;

-- Bridge Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1000, null, 'ADEOfAbstractBridge', 1, 11, @brid:ADEOfAbstractBridge@),
  (1001, null, 'ADEOfBridge', 1, 11, @brid:ADEOfBridge@),
  (1002, null, 'ADEOfBridgeConstructiveElement', 1, 11, @brid:ADEOfBridgeConstructiveElement@),
  (1003, null, 'ADEOfBridgeFurniture', 1, 11, @brid:ADEOfBridgeFurniture@),
  (1004, null, 'ADEOfBridgeInstallation', 1, 11, @brid:ADEOfBridgeInstallation@),
  (1005, null, 'ADEOfBridgePart', 1, 11, @brid:ADEOfBridgePart@),
  (1006, null, 'ADEOfBridgeRoom', 1, 11, @brid:ADEOfBridgeRoom@);

COMMIT;

-- CityObjectGroup Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1200, null, 'Role', 0, 13, @grp:Role@),
  (1201, null, 'ADEOfCityObjectGroup', 1, 13, @grp:ADEOfCityObjectGroup@);

COMMIT;

-- Vegetation Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1300, null, 'ADEOfAbstractVegetationObject', 1, 14, @veg:ADEOfAbstractVegetationObject@),
  (1301, null, 'ADEOfPlantCover', 1, 14, @veg:ADEOfPlantCover@),
  (1302, null, 'ADEOfSolitaryVegetationObject', 1, 14, @veg:ADEOfSolitaryVegetationObject@);

COMMIT;

-- Versioning Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1400, null, 'Transaction', 0, 15, @vers:Transaction@),
  (1401, null, 'ADEOfVersion', 1, 15, @vers:ADEOfVersion@),
  (1402, null, 'ADEOfVersionTransition', 1, 15, @vers:ADEOfVersionTransition@);

COMMIT;

-- WaterBody Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1500, null, 'ADEOfAbstractWaterBoundarySurface', 1, 16, @wtr:ADEOfAbstractWaterBoundarySurface@),
  (1501, null, 'ADEOfWaterBody', 1, 16, @wtr:ADEOfWaterBody@),
  (1502, null, 'ADEOfWaterGroundSurface', 1, 16, @wtr:ADEOfWaterGroundSurface@),
  (1503, null, 'ADEOfWaterSurface', 1, 16, @wtr:ADEOfWaterSurface@);

COMMIT;

-- CityFurniture Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1600, null, 'ADEOfCityFurniture', 1, 17, @frn:ADEOfCityFurniture@);

COMMIT;