-----------------------------------------------------
-- Author: Karin Patenge, Oracle
-- Last update: September 2025
-- Status: to be reviewed
-- This scripts requires Oracle Database version 23ai
-----------------------------------------------------

TRUNCATE TABLE objectclass DROP STORAGE;

-- Core Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (1, null, 'Undefined', 1, 0, 1, @core:Undefined@),
  (2, null, 'AbstractObject', 1, 0, 1, @core:AbstractObject@),
  (3, 2, 'AbstractFeature', 1, 0, 1, @core:AbstractFeature@),
  (4, null, 'Address', 0, 0, 1, @core:Address@),
  (5, 3, 'AbstractPointCloud', 1, 0, 1, @core:AbstractPointCloud@),
  (6, 3, 'AbstractFeatureWithLifespan', 1, 0, 1, @core:AbstractFeatureWithLifespan@),
  (7, 6, 'AbstractCityObject', 1, 0, 1, @core:AbstractCityObject@),
  (8, 7, 'AbstractSpace', 1, 0, 1, @core:AbstractSpace@),
  (9, 8, 'AbstractLogicalSpace', 1, 0, 1, @core:AbstractLogicalSpace@),
  (10, 8, 'AbstractPhysicalSpace', 1, 0, 1, @core:AbstractPhysicalSpace@),
  (11, 10, 'AbstractUnoccupiedSpace', 1, 0, 1, @core:AbstractUnoccupiedSpace@),
  (12, 10, 'AbstractOccupiedSpace', 1, 0, 1, @core:AbstractOccupiedSpace@),
  (13, 7, 'AbstractSpaceBoundary', 1, 0, 1, @core:AbstractSpaceBoundary@),
  (14, 13, 'AbstractThematicSurface', 1, 0, 1, @core:AbstractThematicSurface@),
  (15, 14, 'ClosureSurface', 0, 0, 1, @core:ClosureSurface@),
  (16, 6, 'AbstractDynamizer', 1, 0, 1, @core:AbstractDynamizer@),
  (17, 6, 'AbstractVersionTransition', 1, 0, 1, @core:AbstractVersionTransition@),
  (18, 6, 'CityModel', 0, 0, 1, @core:CityModel@),
  (19, 6, 'AbstractVersion', 1, 0, 1, @core:AbstractVersion@),
  (20, null, 'AbstractAppearance', 1, 0, 1, @core:AbstractAppearance@),
  (21, null, 'ImplicitGeometry', 0, 0, 1, @core:ImplicitGeometry@);

-- Dynamizer Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (100, 16, 'Dynamizer', 0, 0, 2, @dyn:Dynamizer@),
  (101, 3, 'AbstractTimeseries', 1, 0, 2, @dynAbstractTimeseries:@),
  (102, 101, 'AbstractAtomicTimeseries', 1, 0, 2, @dyn:AbstractAtomicTimeseries@),
  (103, 102, 'TabulatedFileTimeseries', 0, 0, 2, @dyn:TabulatedFileTimeseries@),
  (104, 102, 'StandardFileTimeseries', 0, 0, 2, @dyn:StandardFileTimeseries@),
  (105, 102, 'GenericTimeseries', 0, 0, 2, @dyn:GenericTimeseries@),
  (106, 101, 'CompositeTimeseries', 0, 0, 2, @dyn:CompositeTimeseries@);

-- Generics Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (200, 9, 'GenericLogicalSpace', 0, 1, 3, @gen:GenericLogicalSpace@),
  (201, 12, 'GenericOccupiedSpace', 0, 1, 3, @gen:GenericOccupiedSpace@),
  (202, 11, 'GenericUnoccupiedSpace', 0, 1, 3, @gen:GenericUnoccupiedSpace@),
  (203, 14, 'GenericThematicSurface', 0, 0, 3, @gen:GenericThematicSurface@);

-- LandUse Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (300, 14, 'LandUse', 0, 1, 4, @luse:LandUse@);

-- PointCloud Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (400, 5, 'PointCloud', 0, 0, 5, @pcl:PointCloud@);

-- Relief Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (500, 13, 'ReliefFeature', 0, 1, 6, @dem:ReliefFeature@),
  (501, 13, 'AbstractReliefComponent', 1, 0, 6, @dem:AbstractReliefComponent@),
  (502, 501, 'TINRelief', 0, 0, 6, @dem:TINRelief@),
  (503, 501, 'MassPointRelief', 0, 0, 6, @dem:MassPointRelief@),
  (504, 501, 'BreaklineRelief', 0, 0, 6, @dem:BreaklineRelief@),
  (505, 501, 'RasterRelief', 0, 0, 6, @dem:RasterRelief@);

-- Transportation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (600, 11, 'AbstractTransportationSpace', 1, 0, 7, @tran:AbstractTransportationSpace@),
  (601, 600, 'Railway', 0, 1, 7, @tran:Railway@),
  (602, 600, 'Section', 0, 0, 7, @tran:Section@),
  (603, 600, 'Waterway', 0, 1, 7, @tran:Waterway@),
  (604, 600, 'Intersection', 0, 0, 7, @tran:Intersection@),
  (605, 600, 'Square', 0, 1, 7, @tran:Square@),
  (606, 600, 'Track', 0, 1, 7, @tran:Track@),
  (607, 600, 'Road', 0, 1, 7, @tran:Road@),
  (608, 11, 'AuxiliaryTrafficSpace', 0, 0, 7, @tran:AuxiliaryTrafficSpace@),
  (609, 11, 'ClearanceSpace', 0, 0, 7, @tran:ClearanceSpace@),
  (610, 11, 'TrafficSpace', 0, 0, 7, @tran:TrafficSpace@),
  (611, 11, 'Hole', 0, 0, 7, @tran:Hole@),
  (612, 14, 'AuxiliaryTrafficArea', 0, 0, 7, @tran:AuxiliaryTrafficArea@),
  (613, 14, 'TrafficArea', 0, 0, 7, @tran:TrafficArea@),
  (614, 14, 'Marking', 0, 0, 7, @tran:Marking@),
  (615, 14, 'HoleSurface', 0, 0, 7, @tran:HoleSurface@);

-- Construction Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (700, 12, 'AbstractConstruction', 1, 0, 8, @con:AbstractConstruction@),
  (701, 700, 'OtherConstruction', 0, 1, 8, @con:OtherConstruction@),
  (702, 12, 'AbstractConstructiveElement', 1, 0, 8, @con:AbstractConstructiveElement@),
  (703, 12, 'AbstractFillingElement', 1, 0, 8, @con:AbstractFillingElement@),
  (704, 703, 'Window', 0, 0, 8, @con:Window@),
  (705, 703, 'Door', 0, 0, 8, @con:Door@),
  (706, 12, 'AbstractFurniture', 1, 0, 8, @con:AbstractFurniture@),
  (707, 12, 'AbstractInstallation', 1, 0, 8, @con:AbstractInstallation@),
  (708, 14, 'AbstractConstructionSurface', 1, 0, 8, @con:AbstractConstructionSurface@),
  (709, 708, 'WallSurface', 0, 0, 8, @con:WallSurface@),
  (710, 708, 'GroundSurface', 0, 0, 8, @con:GroundSurface@),
  (711, 708, 'InteriorWallSurface', 0, 0, 8, @con:InteriorWallSurface@),
  (712, 708, 'RoofSurface', 0, 0, 8, @con:RoofSurface@),
  (713, 708, 'FloorSurface', 0, 0, 8, @con:FloorSurface@),
  (714, 708, 'OuterFloorSurface', 0, 0, 8, @con:OuterFloorSurface@),
  (715, 708, 'CeilingSurface', 0, 0, 8, @con:CeilingSurface@),
  (716, 708, 'OuterCeilingSurface', 0, 0, 8, @con:OuterCeilingSurface@),
  (717, 14, 'AbstractFillingSurface', 1, 0, 8, @con:AbstractFillingSurface@),
  (718, 717, 'DoorSurface', 0, 0, 8, @con:DoorSurface@),
  (719, 717, 'WindowSurface', 0, 0, 8, @con:WindowSurface@);

-- Tunnel Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (800, 700, 'AbstractTunnel', 1, 0, 9, @tun:AbstractTunnel@),
  (801, 800, 'Tunnel', 0, 1, 9, @tun:Tunnel@),
  (802, 800, 'TunnelPart', 0, 0, 9, @tun:TunnelPart@),
  (803, 702, 'TunnelConstructiveElement', 0, 0, 9, @tun:TunnelConstructiveElement@),
  (804, 11, 'HollowSpace', 0, 0, 9, @tun:HollowSpace@),
  (805, 707, 'TunnelInstallation', 0, 0, 9, @tun:TunnelInstallation@),
  (806, 706, 'TunnelFurniture', 0, 0, 9, @tun:TunnelFurniture@);

-- Building Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (900, 700, 'AbstractBuilding', 1, 0, 10, @bldg:AbstractBuilding@),
  (901, 900, 'Building', 0, 1, 10, @bldg:Building@),
  (902, 900, 'BuildingPart', 0, 0, 10, @bldg:BuildingPart@),
  (903, 702, 'BuildingConstructiveElement', 0, 0, 10, @bldg:BuildingConstructiveElement@),
  (904, 11, 'BuildingRoom', 0, 0, 10, @bldg:BuildingRoom@),
  (905, 707, 'BuildingInstallation', 0, 0, 10, @bldg:BuildingInstallation@),
  (906, 706, 'BuildingFurniture', 0, 0, 10, @bldg:BuildingFurniture@),
  (907, 9, 'AbstractBuildingSubdivision', 1, 0, 10, @bldg:AbstractBuildingSubdivision@),
  (908, 907, 'BuildingUnit', 0, 0, 10, @bldg:BuildingUnit@),
  (909, 907, 'Storey', 0, 0, 10, @bldg:Storey@);

-- Bridge Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (1000, 700, 'AbstractBridge', 1, 0, 11, @brid:AbstractBridge@),
  (1001, 1000, 'Bridge', 0, 1, 11, @brid:Bridge@),
  (1002, 1000, 'BridgePart', 0, 0, 11, @brid:BridgePart@),
  (1003, 702, 'BridgeConstructiveElement', 0, 0, 11, @brid:BridgeConstructiveElement@),
  (1004, 11, 'BridgeRoom', 0, 0, 11, @brid:BridgeRoom@),
  (1005, 707, 'BridgeInstallation', 0, 0, 11, @brid:BridgeInstallation@),
  (1006, 706, 'BridgeFurniture', 0, 0, 11, @brid:BridgeFurniture@);

-- Appearance Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (1100, 20, 'Appearance', 0, 0, 12, @app:Appearance@),
  (1101, null, 'AbstractSurfaceData', 1, 0, 12, @app:AbstractSurfaceData@),
  (1102, 1101, 'X3DMaterial', 0, 0, 12, @app:X3DMaterial@),
  (1103, 1101, 'AbstractTexture', 1, 0, 12, @app:AbstractTexture@),
  (1104, 1103, 'ParameterizedTexture', 0, 0, 12, @app:ParameterizedTexture@),
  (1105, 1103, 'GeoreferencedTexture', 0, 0, 12, @app:GeoreferencedTexture@);

-- CityObjectGroup Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (1200, 9, 'CityObjectGroup', 0, 1, 13, @grp:CityObjectGroup@);

-- Vegetation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (1300, 12, 'AbstractVegetationObject', 1, 0, 14, @veg:AbstractVegetationObject@),
  (1301, 1300, 'SolitaryVegetationObject', 0, 1, 14, @veg:SolitaryVegetationObject@),
  (1302, 1300, 'PlantCover', 0, 1, 14, @veg:PlantCover@);

-- Versioning Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (1400, 19, 'Version', 0, 0, 15, @vers:Version@),
  (1401, 17, 'VersionTransition', 0, 0, 15, @vers:VersionTransition@);

-- WaterBody Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (1500, 12, 'WaterBody', 0, 1, 16, @wtr:WaterBody@),
  (1501, 14, 'AbstractWaterBoundarySurface', 1, 0, 16, @wtr:AbstractWaterBoundarySurface@),
  (1502, 1501, 'WaterSurface', 0, 0, 16, @wtr:WaterSurface@),
  (1503, 1501, 'WaterGroundSurface', 0, 0, 16, @wtr:WaterGroundSurface@);

-- CityFurniture Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES
  (1600, 12, 'CityFurniture', 0, 1, 17, @frn:CityFurniture@);

COMMIT;