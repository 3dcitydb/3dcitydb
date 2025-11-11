SET DEFINE OFF
DELETE FROM datatype;

-- Core Module --

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

-- Dynamizer Module --

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

-- Generics Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (200, null, 'GenericAttributeSet', 0, 3, v_schema_200),
  (201, null, 'ADEOfGenericLogicalSpace', 1, 3, v_schema_201),
  (202, null, 'ADEOfGenericOccupiedSpace', 1, 3, v_schema_202),
  (203, null, 'ADEOfGenericThematicSurface', 1, 3, v_schema_203),
  (204, null, 'ADEOfGenericUnoccupiedSpace', 1, 3, v_schema_204);

-- LandUse Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (300, null, 'ADEOfLandUse', 1, 4, v_schema_300);

-- PointCloud Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (400, null, 'ADEOfPointCloud', 1, 5, v_schema_400);

-- Relief Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (500, null, 'ADEOfAbstractReliefComponent', 1, 6, v_schema_500),
  (501, null, 'ADEOfBreaklineRelief', 1, 6, v_schema_501),
  (502, null, 'ADEOfMassPointRelief', 1, 6, v_schema_502),
  (503, null, 'ADEOfRasterRelief', 1, 6, v_schema_503),
  (504, null, 'ADEOfReliefFeature', 1, 6, v_schema_504),
  (505, null, 'ADEOfTINRelief', 1, 6, v_schema_505);

-- Transportation Module --

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

-- Construction Module --

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

-- Tunnel Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (800, null, 'ADEOfAbstractTunnel', 1, 9, v_schema_800),
  (801, null, 'ADEOfHollowSpace', 1, 9, v_schema_801),
  (802, null, 'ADEOfTunnel', 1, 9, v_schema_802),
  (803, null, 'ADEOfTunnelConstructiveElement', 1, 9, v_schema_803),
  (804, null, 'ADEOfTunnelFurniture', 1, 9, v_schema_804),
  (805, null, 'ADEOfTunnelInstallation', 1, 9, v_schema_805),
  (806, null, 'ADEOfTunnelPart', 1, 9, v_schema_806);

-- Building Module --

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

-- Bridge Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1000, null, 'ADEOfAbstractBridge', 1, 11, v_schema_1000),
  (1001, null, 'ADEOfBridge', 1, 11, v_schema_1001),
  (1002, null, 'ADEOfBridgeConstructiveElement', 1, 11, v_schema_1002),
  (1003, null, 'ADEOfBridgeFurniture', 1, 11, v_schema_1003),
  (1004, null, 'ADEOfBridgeInstallation', 1, 11, v_schema_1004),
  (1005, null, 'ADEOfBridgePart', 1, 11, v_schema_1005),
  (1006, null, 'ADEOfBridgeRoom', 1, 11, v_schema_1006);

-- CityObjectGroup Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1200, null, 'Role', 0, 13, v_schema_1200),
  (1201, null, 'ADEOfCityObjectGroup', 1, 13, v_schema_1201);

-- Vegetation Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1300, null, 'ADEOfAbstractVegetationObject', 1, 14, v_schema_1300),
  (1301, null, 'ADEOfPlantCover', 1, 14, v_schema_1301),
  (1302, null, 'ADEOfSolitaryVegetationObject', 1, 14, v_schema_1302);

-- Versioning Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1400, null, 'Transaction', 0, 15, v_schema_1400),
  (1401, null, 'ADEOfVersion', 1, 15, v_schema_1401),
  (1402, null, 'ADEOfVersionTransition', 1, 15, v_schema_1402);

-- WaterBody Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1500, null, 'ADEOfAbstractWaterBoundarySurface', 1, 16, v_schema_1500),
  (1501, null, 'ADEOfWaterBody', 1, 16, v_schema_1501),
  (1502, null, 'ADEOfWaterGroundSurface', 1, 16, v_schema_1502),
  (1503, null, 'ADEOfWaterSurface', 1, 16, v_schema_1503);

-- CityFurniture Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES
  (1600, null, 'ADEOfCityFurniture', 1, 17, v_schema_1600);

SET DEFINE ON