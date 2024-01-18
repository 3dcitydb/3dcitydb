DELETE FROM objectclass;

-- Core Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1, null, 'Undefined', 1, 0, 1, @core:Undefined@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (2, null, 'AbstractObject', 1, 0, 1, @core:AbstractObject@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (3, 2, 'AbstractFeature', 1, 0, 1, @core:AbstractFeature@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (4, null, 'Address', 0, 0, 1, @core:Address@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (5, 3, 'AbstractPointCloud', 1, 0, 1, @core:AbstractPointCloud@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (6, 3, 'AbstractFeatureWithLifespan', 1, 0, 1, @core:AbstractFeatureWithLifespan@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (7, 6, 'AbstractCityObject', 1, 0, 1, @core:AbstractCityObject@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (8, 7, 'AbstractSpace', 1, 0, 1, @core:AbstractSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (9, 8, 'AbstractLogicalSpace', 1, 0, 1, @core:AbstractLogicalSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (10, 8, 'AbstractPhysicalSpace', 1, 0, 1, @core:AbstractPhysicalSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (11, 10, 'AbstractUnoccupiedSpace', 1, 0, 1, @core:AbstractUnoccupiedSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (12, 10, 'AbstractOccupiedSpace', 1, 0, 1, @core:AbstractOccupiedSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (13, 7, 'AbstractSpaceBoundary', 1, 0, 1, @core:AbstractSpaceBoundary@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (14, 13, 'AbstractThematicSurface', 1, 0, 1, @core:AbstractThematicSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (15, 14, 'ClosureSurface', 0, 0, 1, @core:ClosureSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (16, 6, 'AbstractDynamizer', 1, 0, 1, @core:AbstractDynamizer@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (17, 6, 'AbstractVersionTransition', 1, 0, 1, @core:AbstractVersionTransition@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (18, 6, 'CityModel', 0, 0, 1, @core:CityModel@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (19, 6, 'AbstractVersion', 1, 0, 1, @core:AbstractVersion@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (20, null, 'AbstractAppearance', 1, 0, 1, @core:AbstractAppearance@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (21, null, 'ImplicitGeometry', 0, 0, 1, @core:ImplicitGeometry@);

-- Dynamizer Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (100, 16, 'Dynamizer', 0, 0, 2, @dyn:Dynamizer@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (101, 3, 'AbstractTimeseries', 1, 0, 2, @dyn:AbstractTimeseries@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (102, 101, 'AbstractAtomicTimeseries', 1, 0, 2, @dyn:AbstractAtomicTimeseries@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (103, 102, 'TabulatedFileTimeseries', 0, 0, 2, @dyn:TabulatedFileTimeseries@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (104, 102, 'StandardFileTimeseries', 0, 0, 2, @dyn:StandardFileTimeseries@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (105, 102, 'GenericTimeseries', 0, 0, 2, @dyn:GenericTimeseries@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (106, 101, 'CompositeTimeseries', 0, 0, 2, @dyn:CompositeTimeseries@);

-- Generics Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (200, 9, 'GenericLogicalSpace', 0, 1, 3, @gen:GenericLogicalSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (201, 12, 'GenericOccupiedSpace', 0, 1, 3, @gen:GenericOccupiedSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (202, 11, 'GenericUnoccupiedSpace', 0, 1, 3, @gen:GenericUnoccupiedSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (203, 14, 'GenericThematicSurface', 0, 0, 3, @gen:GenericThematicSurface@);

-- LandUse Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (300, 14, 'LandUse', 0, 1, 4, @luse:LandUse@);

-- PointCloud Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (400, 5, 'PointCloud', 0, 0, 5, @pcl:PointCloud@);

-- Relief Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (500, 13, 'ReliefFeature', 0, 1, 6, @dem:ReliefFeature@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (501, 13, 'AbstractReliefComponent', 1, 0, 6, @dem:AbstractReliefComponent@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (502, 501, 'TINRelief', 0, 0, 6, @dem:TINRelief@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (503, 501, 'MassPointRelief', 0, 0, 6, @dem:MassPointRelief@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (504, 501, 'BreaklineRelief', 0, 0, 6, @dem:BreaklineRelief@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (505, 501, 'RasterRelief', 0, 0, 6, @dem:RasterRelief@);

-- Transportation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (600, 11, 'AbstractTransportationSpace', 1, 0, 7, @tran:AbstractTransportationSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (601, 600, 'Railway', 0, 1, 7, @tran:Railway@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (602, 600, 'Section', 0, 0, 7, @tran:Section@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (603, 600, 'Waterway', 0, 1, 7, @tran:Waterway@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (604, 600, 'Intersection', 0, 0, 7, @tran:Intersection@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (605, 600, 'Square', 0, 1, 7, @tran:Square@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (606, 600, 'Track', 0, 1, 7, @tran:Track@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (607, 600, 'Road', 0, 1, 7, @tran:Road@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (608, 11, 'AuxiliaryTrafficSpace', 0, 0, 7, @tran:AuxiliaryTrafficSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (609, 11, 'ClearanceSpace', 0, 0, 7, @tran:ClearanceSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (610, 11, 'TrafficSpace', 0, 0, 7, @tran:TrafficSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (611, 11, 'Hole', 0, 0, 7, @tran:Hole@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (612, 14, 'AuxiliaryTrafficArea', 0, 0, 7, @tran:AuxiliaryTrafficArea@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (613, 14, 'TrafficArea', 0, 0, 7, @tran:TrafficArea@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (614, 14, 'Marking', 0, 0, 7, @tran:Marking@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (615, 14, 'HoleSurface', 0, 0, 7, @tran:HoleSurface@);

-- Construction Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (700, 12, 'AbstractConstruction', 1, 0, 8, @con:AbstractConstruction@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (701, 700, 'OtherConstruction', 0, 1, 8, @con:OtherConstruction@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (702, 12, 'AbstractConstructiveElement', 1, 0, 8, @con:AbstractConstructiveElement@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (703, 12, 'AbstractFillingElement', 1, 0, 8, @con:AbstractFillingElement@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (704, 703, 'Window', 0, 0, 8, @con:Window@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (705, 703, 'Door', 0, 0, 8, @con:Door@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (706, 12, 'AbstractFurniture', 1, 0, 8, @con:AbstractFurniture@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (707, 12, 'AbstractInstallation', 1, 0, 8, @con:AbstractInstallation@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (708, 14, 'AbstractConstructionSurface', 1, 0, 8, @con:AbstractConstructionSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (709, 708, 'WallSurface', 0, 0, 8, @con:WallSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (710, 708, 'GroundSurface', 0, 0, 8, @con:GroundSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (711, 708, 'InteriorWallSurface', 0, 0, 8, @con:InteriorWallSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (712, 708, 'RoofSurface', 0, 0, 8, @con:RoofSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (713, 708, 'FloorSurface', 0, 0, 8, @con:FloorSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (714, 708, 'OuterFloorSurface', 0, 0, 8, @con:OuterFloorSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (715, 708, 'CeilingSurface', 0, 0, 8, @con:CeilingSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (716, 708, 'OuterCeilingSurface', 0, 0, 8, @con:OuterCeilingSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (717, 14, 'AbstractFillingSurface', 1, 0, 8, @con:AbstractFillingSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (718, 717, 'DoorSurface', 0, 0, 8, @con:DoorSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (719, 717, 'WindowSurface', 0, 0, 8, @con:WindowSurface@);

-- Tunnel Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (800, 700, 'AbstractTunnel', 1, 0, 9, @tun:AbstractTunnel@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (801, 800, 'Tunnel', 0, 1, 9, @tun:Tunnel@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (802, 800, 'TunnelPart', 0, 0, 9, @tun:TunnelPart@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (803, 702, 'TunnelConstructiveElement', 0, 0, 9, @tun:TunnelConstructiveElement@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (804, 11, 'HollowSpace', 0, 0, 9, @tun:HollowSpace@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (805, 707, 'TunnelInstallation', 0, 0, 9, @tun:TunnelInstallation@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (806, 706, 'TunnelFurniture', 0, 0, 9, @tun:TunnelFurniture@);

-- Building Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (900, 700, 'AbstractBuilding', 1, 0, 10, @bldg:AbstractBuilding@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (901, 900, 'Building', 0, 1, 10, @bldg:Building@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (902, 900, 'BuildingPart', 0, 0, 10, @bldg:BuildingPart@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (903, 702, 'BuildingConstructiveElement', 0, 0, 10, @bldg:BuildingConstructiveElement@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (904, 11, 'BuildingRoom', 0, 0, 10, @bldg:BuildingRoom@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (905, 707, 'BuildingInstallation', 0, 0, 10, @bldg:BuildingInstallation@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (906, 706, 'BuildingFurniture', 0, 0, 10, @bldg:BuildingFurniture@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (907, 9, 'AbstractBuildingSubdivision', 1, 0, 10, @bldg:AbstractBuildingSubdivision@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (908, 907, 'BuildingUnit', 0, 0, 10, @bldg:BuildingUnit@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (909, 907, 'Storey', 0, 0, 10, @bldg:Storey@);

-- Bridge Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1000, 700, 'AbstractBridge', 1, 0, 11, @brid:AbstractBridge@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1001, 1000, 'Bridge', 0, 1, 11, @brid:Bridge@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1002, 1000, 'BridgePart', 0, 0, 11, @brid:BridgePart@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1003, 702, 'BridgeConstructiveElement', 0, 0, 11, @brid:BridgeConstructiveElement@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1004, 11, 'BridgeRoom', 0, 0, 11, @brid:BridgeRoom@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1005, 707, 'BridgeInstallation', 0, 0, 11, @brid:BridgeInstallation@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1006, 706, 'BridgeFurniture', 0, 0, 11, @brid:BridgeFurniture@);

-- Appearance Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1100, 20, 'Appearance', 0, 0, 12, @app:Appearance@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1101, null, 'AbstractSurfaceData', 1, 0, 12, @app:AbstractSurfaceData@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1102, 1101, 'X3DMaterial', 0, 0, 12, @app:X3DMaterial@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1103, 1101, 'AbstractTexture', 1, 0, 12, @app:AbstractTexture@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1104, 1103, 'ParameterizedTexture', 0, 0, 12, @app:ParameterizedTexture@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1105, 1103, 'GeoreferencedTexture', 0, 0, 12, @app:GeoreferencedTexture@);

-- CityObjectGroup Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1200, 9, 'CityObjectGroup', 0, 1, 13, @grp:CityObjectGroup@);

-- Vegetation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1300, 12, 'AbstractVegetationObject', 1, 0, 14, @veg:AbstractVegetationObject@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1301, 1300, 'SolitaryVegetationObject', 0, 1, 14, @veg:SolitaryVegetationObject@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1302, 1300, 'PlantCover', 0, 1, 14, @veg:PlantCover@);

-- Versioning Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1400, 19, 'Version', 0, 0, 15, @vers:Version@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1401, 17, 'VersionTransition', 0, 0, 15, @vers:VersionTransition@);

-- WaterBody Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1500, 12, 'WaterBody', 0, 1, 16, @wtr:WaterBody@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1501, 14, 'AbstractWaterBoundarySurface', 1, 0, 16, @wtr:AbstractWaterBoundarySurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1502, 1501, 'WaterSurface', 0, 0, 16, @wtr:WaterSurface@);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1503, 1501, 'WaterGroundSurface', 0, 0, 16, @wtr:WaterGroundSurface@);

-- CityFurniture Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID, SCHEMA)
VALUES (1600, 12, 'CityFurniture', 0, 1, 17, @frn:CityFurniture@);
