DELETE
FROM datatype;

-- Core Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1, null, 'Undefined', 1, 1, @core:Undefined@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (2, null, 'Boolean', 0, 1, @core:Boolean@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (3, null, 'Integer', 0, 1, @core:Integer@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (4, null, 'Double', 0, 1, @core:Double@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (5, null, 'String', 0, 1, @core:String@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (6, null, 'URI', 0, 1, @core:URI@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (7, null, 'Timestamp', 0, 1, @core:Timestamp@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (8, null, 'AddressProperty', 0, 1, @core:AddressProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (9, null, 'AppearanceProperty', 0, 1, @core:AppearanceProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (10, null, 'FeatureProperty', 0, 1, @core:FeatureProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (11, null, 'GeometryProperty', 0, 1, @core:GeometryProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (12, null, 'Reference', 0, 1, @core:Reference@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (13, null, 'CityObjectRelation', 0, 1, @core:CityObjectRelation@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (14, null, 'Code', 0, 1, @core:Code@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (15, null, 'ExternalReference', 0, 1, @core:ExternalReference@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (16, null, 'ImplicitGeometryProperty', 0, 1, @core:ImplicitGeometryProperty@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (17, null, 'Measure', 0, 1, @core:Measure@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (18, null, 'MeasureOrNilReasonList', 0, 1, @core:MeasureOrNilReasonList@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (19, null, 'Occupancy', 0, 1, @core:Occupancy@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (20, null, 'QualifiedArea', 0, 1, @core:QualifiedArea@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (21, null, 'QualifiedVolume', 0, 1, @core:QualifiedVolume@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (22, null, 'StringOrRef', 0, 1, @core:StringOrRef@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (23, null, 'TimePosition', 0, 1, @core:TimePosition@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (24, null, 'Duration', 0, 1, @core:Duration@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (50, null, 'ADEOfAbstractCityObject', 1, 1, @core:ADEOfAbstractCityObject@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (51, null, 'ADEOfAbstractDynamizer', 1, 1, @core:ADEOfAbstractDynamizer@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (52, null, 'ADEOfAbstractFeature', 1, 1, @core:ADEOfAbstractFeature@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (53, null, 'ADEOfAbstractFeatureWithLifespan', 1, 1, @core:ADEOfAbstractFeatureWithLifespan@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (54, null, 'ADEOfAbstractLogicalSpace', 1, 1, @core:ADEOfAbstractLogicalSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (55, null, 'ADEOfAbstractOccupiedSpace', 1, 1, @core:ADEOfAbstractOccupiedSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (56, null, 'ADEOfAbstractPhysicalSpace', 1, 1, @core:ADEOfAbstractPhysicalSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (57, null, 'ADEOfAbstractPointCloud', 1, 1, @core:ADEOfAbstractPointCloud@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (58, null, 'ADEOfAbstractSpace', 1, 1, @core:ADEOfAbstractSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (59, null, 'ADEOfAbstractSpaceBoundary', 1, 1, @core:ADEOfAbstractSpaceBoundary@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (60, null, 'ADEOfAbstractThematicSurface', 1, 1, @core:ADEOfAbstractThematicSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (61, null, 'ADEOfAbstractUnoccupiedSpace', 1, 1, @core:ADEOfAbstractUnoccupiedSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (62, null, 'ADEOfAbstractVersion', 1, 1, @core:ADEOfAbstractVersion@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (63, null, 'ADEOfAbstractVersionTransition', 1, 1, @core:ADEOfAbstractVersionTransition@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (64, null, 'ADEOfCityModel', 1, 1, @core:ADEOfCityModel@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (65, null, 'ADEOfClosureSurface', 1, 1, @core:ADEOfClosureSurface@);

-- Dynamizer Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (100, null, 'AttributeReference', 0, 2, @dyn:AttributeReference@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (101, null, 'SensorConnection', 0, 2, @dyn:SensorConnection@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (102, null, 'TimeseriesComponent', 0, 2, @dyn:TimeseriesComponent@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (103, null, 'TimeValuePair', 0, 2, @dyn:TimeValuePair@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (104, null, 'ADEOfAbstractAtomicTimeseries', 1, 2, @dyn:ADEOfAbstractAtomicTimeseries@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (105, null, 'ADEOfAbstractTimeseries', 1, 2, @dyn:ADEOfAbstractTimeseries@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (106, null, 'ADEOfCompositeTimeseries', 1, 2, @dyn:ADEOfCompositeTimeseries@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (107, null, 'ADEOfDynamizer', 1, 2, @dyn:ADEOfDynamizer@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (108, null, 'ADEOfGenericTimeseries', 1, 2, @dyn:ADEOfGenericTimeseries@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (109, null, 'ADEOfStandardFileTimeseries', 1, 2, @dyn:ADEOfStandardFileTimeseries@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (110, null, 'ADEOfTabulatedFileTimeseries', 1, 2, @dyn:ADEOfTabulatedFileTimeseries@);

-- Generics Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (200, null, 'GenericAttributeSet', 0, 3, @gen:GenericAttributeSet@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (201, null, 'ADEOfGenericLogicalSpace', 1, 3, @gen:ADEOfGenericLogicalSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (202, null, 'ADEOfGenericOccupiedSpace', 1, 3, @gen:ADEOfGenericOccupiedSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (203, null, 'ADEOfGenericThematicSurface', 1, 3, @gen:ADEOfGenericThematicSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (204, null, 'ADEOfGenericUnoccupiedSpace', 1, 3, @gen:ADEOfGenericUnoccupiedSpace@);

-- LandUse Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (300, null, 'ADEOfLandUse', 1, 4, @luse:ADEOfLandUse@);

-- PointCloud Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (400, null, 'ADEOfPointCloud', 1, 5, @pcl:ADEOfPointCloud@);

-- Relief Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (500, null, 'ADEOfAbstractReliefComponent', 1, 6, @dem:ADEOfAbstractReliefComponent@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (501, null, 'ADEOfBreaklineRelief', 1, 6, @dem:ADEOfBreaklineRelief@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (502, null, 'ADEOfMassPointRelief', 1, 6, @dem:ADEOfMassPointRelief@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (503, null, 'ADEOfRasterRelief', 1, 6, @dem:ADEOfRasterRelief@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (504, null, 'ADEOfReliefFeature', 1, 6, @dem:ADEOfReliefFeature@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (505, null, 'ADEOfTINRelief', 1, 6, @dem:ADEOfTINRelief@);

-- Transportation Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (600, null, 'ADEOfAbstractTransportationSpace', 1, 7, @tran:ADEOfAbstractTransportationSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (601, null, 'ADEOfAuxiliaryTrafficArea', 1, 7, @tran:ADEOfAuxiliaryTrafficArea@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (602, null, 'ADEOfAuxiliaryTrafficSpace', 1, 7, @tran:ADEOfAuxiliaryTrafficSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (603, null, 'ADEOfClearanceSpace', 1, 7, @tran:ADEOfClearanceSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (604, null, 'ADEOfHole', 1, 7, @tran:ADEOfHole@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (605, null, 'ADEOfHoleSurface', 1, 7, @tran:ADEOfHoleSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (606, null, 'ADEOfIntersection', 1, 7, @tran:ADEOfIntersection@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (607, null, 'ADEOfMarking', 1, 7, @tran:ADEOfMarking@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (608, null, 'ADEOfRailway', 1, 7, @tran:ADEOfRailway@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (609, null, 'ADEOfRoad', 1, 7, @tran:ADEOfRoad@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (610, null, 'ADEOfSection', 1, 7, @tran:ADEOfSection@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (611, null, 'ADEOfSquare', 1, 7, @tran:ADEOfSquare@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (612, null, 'ADEOfTrack', 1, 7, @tran:ADEOfTrack@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (613, null, 'ADEOfTrafficArea', 1, 7, @tran:ADEOfTrafficArea@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (614, null, 'ADEOfTrafficSpace', 1, 7, @tran:ADEOfTrafficSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (615, null, 'ADEOfWaterway', 1, 7, @tran:ADEOfWaterway@);

-- Construction Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (700, null, 'ConstructionEvent', 0, 8, @con:ConstructionEvent@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (701, null, 'Elevation', 0, 8, @con:Elevation@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (702, null, 'Height', 0, 8, @con:Height@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (703, null, 'ADEOfAbstractConstruction', 1, 8, @con:ADEOfAbstractConstruction@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (704, null, 'ADEOfAbstractConstructionSurface', 1, 8, @con:ADEOfAbstractConstructionSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (705, null, 'ADEOfAbstractConstructiveElement', 1, 8, @con:ADEOfAbstractConstructiveElement@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (706, null, 'ADEOfAbstractFillingElement', 1, 8, @con:ADEOfAbstractFillingElement@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (707, null, 'ADEOfAbstractFillingSurface', 1, 8, @con:ADEOfAbstractFillingSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (708, null, 'ADEOfAbstractFurniture', 1, 8, @con:ADEOfAbstractFurniture@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (709, null, 'ADEOfAbstractInstallation', 1, 8, @con:ADEOfAbstractInstallation@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (710, null, 'ADEOfCeilingSurface', 1, 8, @con:ADEOfCeilingSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (711, null, 'ADEOfDoor', 1, 8, @con:ADEOfDoor@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (712, null, 'ADEOfDoorSurface', 1, 8, @con:ADEOfDoorSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (713, null, 'ADEOfFloorSurface', 1, 8, @con:ADEOfFloorSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (714, null, 'ADEOfGroundSurface', 1, 8, @con:ADEOfGroundSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (715, null, 'ADEOfInteriorWallSurface', 1, 8, @con:ADEOfInteriorWallSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (716, null, 'ADEOfOtherConstruction', 1, 8, @con:ADEOfOtherConstruction@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (717, null, 'ADEOfOuterCeilingSurface', 1, 8, @con:ADEOfOuterCeilingSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (718, null, 'ADEOfOuterFloorSurface', 1, 8, @con:ADEOfOuterFloorSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (719, null, 'ADEOfRoofSurface', 1, 8, @con:ADEOfRoofSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (720, null, 'ADEOfWallSurface', 1, 8, @con:ADEOfWallSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (721, null, 'ADEOfWindow', 1, 8, @con:ADEOfWindow@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (722, null, 'ADEOfWindowSurface', 1, 8, @con:ADEOfWindowSurface@);

-- Tunnel Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (800, null, 'ADEOfAbstractTunnel', 1, 9, @tun:ADEOfAbstractTunnel@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (801, null, 'ADEOfHollowSpace', 1, 9, @tun:ADEOfHollowSpace@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (802, null, 'ADEOfTunnel', 1, 9, @tun:ADEOfTunnel@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (803, null, 'ADEOfTunnelConstructiveElement', 1, 9, @tun:ADEOfTunnelConstructiveElement@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (804, null, 'ADEOfTunnelFurniture', 1, 9, @tun:ADEOfTunnelFurniture@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (805, null, 'ADEOfTunnelInstallation', 1, 9, @tun:ADEOfTunnelInstallation@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (806, null, 'ADEOfTunnelPart', 1, 9, @tun:ADEOfTunnelPart@);

-- Building Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (900, null, 'RoomHeight', 0, 10, @bldg:RoomHeight@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (901, null, 'ADEOfAbstractBuilding', 1, 10, @bldg:ADEOfAbstractBuilding@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (902, null, 'ADEOfAbstractBuildingSubdivision', 1, 10, @bldg:ADEOfAbstractBuildingSubdivision@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (903, null, 'ADEOfBuilding', 1, 10, @bldg:ADEOfBuilding@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (904, null, 'ADEOfBuildingConstructiveElement', 1, 10, @bldg:ADEOfBuildingConstructiveElement@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (905, null, 'ADEOfBuildingFurniture', 1, 10, @bldg:ADEOfBuildingFurniture@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (906, null, 'ADEOfBuildingInstallation', 1, 10, @bldg:ADEOfBuildingInstallation@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (907, null, 'ADEOfBuildingPart', 1, 10, @bldg:ADEOfBuildingPart@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (908, null, 'ADEOfBuildingRoom', 1, 10, @bldg:ADEOfBuildingRoom@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (909, null, 'ADEOfBuildingUnit', 1, 10, @bldg:ADEOfBuildingUnit@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (910, null, 'ADEOfStorey', 1, 10, @bldg:ADEOfStorey@);

-- Bridge Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1000, null, 'ADEOfAbstractBridge', 1, 11, @brid:ADEOfAbstractBridge@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1001, null, 'ADEOfBridge', 1, 11, @brid:ADEOfBridge@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1002, null, 'ADEOfBridgeConstructiveElement', 1, 11, @brid:ADEOfBridgeConstructiveElement@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1003, null, 'ADEOfBridgeFurniture', 1, 11, @brid:ADEOfBridgeFurniture@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1004, null, 'ADEOfBridgeInstallation', 1, 11, @brid:ADEOfBridgeInstallation@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1005, null, 'ADEOfBridgePart', 1, 11, @brid:ADEOfBridgePart@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1006, null, 'ADEOfBridgeRoom', 1, 11, @brid:ADEOfBridgeRoom@);

-- CityObjectGroup Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1200, null, 'Role', 0, 13, @grp:Role@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1201, null, 'ADEOfCityObjectGroup', 1, 13, @grp:ADEOfCityObjectGroup@);

-- Vegetation Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1300, null, 'ADEOfAbstractVegetationObject', 1, 14, @veg:ADEOfAbstractVegetationObject@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1301, null, 'ADEOfPlantCover', 1, 14, @veg:ADEOfPlantCover@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1302, null, 'ADEOfSolitaryVegetationObject', 1, 14, @veg:ADEOfSolitaryVegetationObject@);

-- Versioning Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1400, null, 'Transaction', 0, 15, @vers:Transaction@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1401, null, 'ADEOfVersion', 1, 15, @vers:ADEOfVersion@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1402, null, 'ADEOfVersionTransition', 1, 15, @vers:ADEOfVersionTransition@);

-- WaterBody Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1500, null, 'ADEOfAbstractWaterBoundarySurface', 1, 16, @wtr:ADEOfAbstractWaterBoundarySurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1501, null, 'ADEOfWaterBody', 1, 16, @wtr:ADEOfWaterBody@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1502, null, 'ADEOfWaterGroundSurface', 1, 16, @wtr:ADEOfWaterGroundSurface@);

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1503, null, 'ADEOfWaterSurface', 1, 16, @wtr:ADEOfWaterSurface@);

-- CityFurniture Module --

INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID, SCHEMA)
VALUES (1600, null, 'ADEOfCityFurniture', 1, 17, @frn:ADEOfCityFurniture@);