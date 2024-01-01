DELETE FROM objectclass;

-- Core Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1, null, 'Undefined', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (2, null, 'ObjectType', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (3, 2, 'FeatureType', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (4, 3, 'AbstractFeature', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (5, 4, 'Address', 0, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (6, 4, 'AbstractPointCloud', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (7, 4, 'AbstractFeatureWithLifespan', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (8, 7, 'AbstractCityObject', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (9, 8, 'AbstractSpace', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (10, 9, 'AbstractLogicalSpace', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (11, 9, 'AbstractPhysicalSpace', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (12, 11, 'AbstractUnoccupiedSpace', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (13, 11, 'AbstractOccupiedSpace', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (14, 8, 'AbstractSpaceBoundary', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (15, 14, 'AbstractThematicSurface', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (16, 15, 'ClosureSurface', 0, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (17, 7, 'AbstractDynamizer', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (18, 7, 'AbstractVersionTransition', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (19, 7, 'CityModel', 0, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (20, 7, 'AbstractVersion', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (21, 7, 'AbstractAppearance', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (22, 2, 'ImplicitGeometry', 0, 0, 1);

-- Dynamizer Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (100, 17, 'Dynamizer', 0, 0, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (101, 4, 'AbstractTimeseries', 1, 0, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (102, 101, 'AbstractAtomicTimeseries', 1, 0, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (103, 102, 'TabulatedFileTimeseries', 0, 0, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (104, 102, 'StandardFileTimeseries', 0, 0, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (105, 102, 'GenericTimeseries', 0, 0, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (106, 101, 'CompositeTimeseries', 0, 0, 2);

-- Generics Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (200, 10, 'GenericLogicalSpace', 0, 1, 3);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (201, 13, 'GenericOccupiedSpace', 0, 1, 3);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (202, 12, 'GenericUnoccupiedSpace', 0, 1, 3);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (203, 15, 'GenericThematicSurface', 0, 0, 3);

-- LandUse Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (300, 15, 'LandUse', 0, 1, 4);

-- PointCloud Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (400, 6, 'PointCloud', 0, 0, 5);

-- Relief Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (500, 14, 'ReliefFeature', 0, 1, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (501, 14, 'AbstractReliefComponent', 1, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (502, 501, 'TINRelief', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (503, 501, 'MassPointRelief', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (504, 501, 'BreaklineRelief', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (505, 501, 'RasterRelief', 0, 0, 6);

-- Transportation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (600, 12, 'AbstractTransportationSpace', 1, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (602, 600, 'Railway', 0, 1, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (603, 600, 'Section', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (604, 600, 'Waterway', 0, 1, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (605, 600, 'Intersection', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (606, 600, 'Square', 0, 1, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (607, 600, 'Track', 0, 1, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (608, 600, 'Road', 0, 1, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (609, 12, 'AuxiliaryTrafficSpace', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (610, 12, 'ClearanceSpace', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (611, 12, 'TrafficSpace', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (612, 12, 'Hole', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (613, 15, 'AuxiliaryTrafficArea', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (614, 15, 'TrafficArea', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (615, 15, 'Marking', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (616, 15, 'HoleSurface', 0, 0, 7);

-- Construction Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (700, 13, 'AbstractConstruction', 1, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (701, 700, 'OtherConstruction', 0, 1, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (702, 13, 'AbstractConstructiveElement', 1, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (703, 13, 'AbstractFillingElement', 1, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (704, 703, 'Window', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (705, 703, 'Door', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (706, 13, 'AbstractFurniture', 1, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (707, 13, 'AbstractInstallation', 1, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (708, 15, 'AbstractConstructionSurface', 1, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (709, 708, 'WallSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (710, 708, 'GroundSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (711, 708, 'InteriorWallSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (712, 708, 'RoofSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (713, 708, 'FloorSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (714, 708, 'OuterFloorSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (715, 708, 'CeilingSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (716, 708, 'OuterCeilingSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (717, 15, 'AbstractFillingSurface', 1, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (718, 717, 'DoorSurface', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (719, 717, 'WindowSurface', 0, 0, 8);

-- Tunnel Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (800, 700, 'AbstractTunnel', 1, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (801, 800, 'Tunnel', 0, 1, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (802, 800, 'TunnelPart', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (803, 702, 'TunnelConstructiveElement', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (804, 12, 'HollowSpace', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (805, 707, 'TunnelInstallation', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (806, 706, 'TunnelFurniture', 0, 0, 9);

-- Building Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (900, 700, 'AbstractBuilding', 1, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (901, 900, 'Building', 0, 1, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (902, 900, 'BuildingPart', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (903, 702, 'BuildingConstructiveElement', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (904, 12, 'BuildingRoom', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (905, 707, 'BuildingInstallation', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (906, 706, 'BuildingFurniture', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (907, 10, 'AbstractBuildingSubdivision', 1, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (908, 907, 'BuildingUnit', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (909, 907, 'Storey', 0, 0, 10);

-- Bridge Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1000, 700, 'AbstractBridge', 1, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1001, 1000, 'Bridge', 0, 1, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1002, 1000, 'BridgePart', 0, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1003, 702, 'BridgeConstructiveElement', 0, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1004, 12, 'BridgeRoom', 0, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1005, 707, 'BridgeInstallation', 0, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1006, 706, 'BridgeFurniture', 0, 0, 11);

-- Appearance Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1100, 21, 'Appearance', 0, 0, 12);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1101, 4, 'AbstractSurfaceData', 1, 0, 12);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1102, 1101, 'X3DMaterial', 0, 0, 12);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1103, 1101, 'AbstractTexture', 1, 0, 12);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1104, 1103, 'ParameterizedTexture', 0, 0, 12);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1105, 1103, 'GeoreferencedTexture', 0, 0, 12);

-- CityObjectGroup Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1200, 10, 'CityObjectGroup', 0, 1, 13);

-- Vegetation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1300, 13, 'AbstractVegetationObject', 1, 0, 14);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1301, 1300, 'SolitaryVegetationObject', 0, 1, 14);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1302, 1300, 'PlantCover', 0, 1, 14);

-- Versioning Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1400, 20, 'Version', 0, 0, 15);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1401, 18, 'VersionTransition', 0, 0, 15);

-- WaterBody Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1500, 13, 'WaterBody', 0, 1, 16);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1501, 15, 'AbstractWaterBoundarySurface', 1, 0, 16);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1502, 1501, 'WaterSurface', 0, 0, 16);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1503, 1501, 'WaterGroundSurface', 0, 0, 16);

-- CityFurniture Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1600, 13, 'CityFurniture', 0, 1, 17);











