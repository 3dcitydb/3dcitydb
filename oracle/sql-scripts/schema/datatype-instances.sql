-----------------------------------------------------
-- Author: Karin Patenge, Oracle
-- Last update: October 6, 2025
-- Status: to be reviewed
-- This scripts requires Oracle Database version 23ai
-----------------------------------------------------

TRUNCATE TABLE datatype DROP STORAGE;

-- Core Module --

DECLARE
  v_schema1 CLOB  := @core:Undefined@;
  v_schema2 CLOB  := @core:Boolean@;
  v_schema3 CLOB  := @core:Integer@;
  v_schema4 CLOB  := @core:Double@;
  v_schema5 CLOB  := @core:String@;
  v_schema6 CLOB  := @core:URI@;
  v_schema7 CLOB  := @core:Timestamp@;
  v_schema8 CLOB  := @core:AddressProperty@;
  v_schema9 CLOB  := @core:AppearanceProperty@;
  v_schema10 CLOB  := @core:FeatureProperty@;
  v_schema11 CLOB  := @core:GeometryProperty@;
  v_schema12 CLOB  := @core:Reference@;
  v_schema13 CLOB  := @core:CityObjectRelation@;
  v_schema14 CLOB  := @core:Code@;
  v_schema15 CLOB  := @core:ExternalReference@;
  v_schema16 CLOB  := @core:ImplicitGeometryProperty@;
  v_schema17 CLOB  := @core:Measure@;
  v_schema18 CLOB  := @core:MeasureOrNilReasonList@;
  v_schema19 CLOB  := @core:Occupancy@;
  v_schema20 CLOB  := @core:QualifiedArea@;
  v_schema21 CLOB  := @core:QualifiedVolume@;
  v_schema22 CLOB  := @core:StringOrRef@;
  v_schema23 CLOB  := @core:TimePosition@;
  v_schema24 CLOB  := @core:Duration@;
  v_schema50 CLOB  := @core:ADEOfAbstractCityObject@;
  v_schema51 CLOB  := @core:ADEOfAbstractDynamizer@;
  v_schema52 CLOB  := @core:ADEOfAbstractFeature@;
  v_schema53 CLOB  := @core:ADEOfAbstractFeatureWithLifespan@;
  v_schema54 CLOB  := @core:ADEOfAbstractLogicalSpace@;
  v_schema55 CLOB  := @core:ADEOfAbstractOccupiedSpace@;
  v_schema56 CLOB  := @core:ADEOfAbstractPhysicalSpace@;
  v_schema57 CLOB  := @core:ADEOfAbstractPointCloud@;
  v_schema58 CLOB  := @core:ADEOfAbstractSpace@;
  v_schema59 CLOB  := @core:ADEOfAbstractSpaceBoundary@;
  v_schema60 CLOB  := @core:ADEOfAbstractThematicSurface@;
  v_schema61 CLOB  := @core:ADEOfAbstractUnoccupiedSpace@;
  v_schema62 CLOB  := @core:ADEOfAbstractVersion@;
  v_schema63 CLOB  := @core:ADEOfAbstractVersionTransition@;
  v_schema64 CLOB  := @core:ADEOfCityModel@;
  v_schema65 CLOB  := @core:ADEOfClosureSurface@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (1, null, 'Undefined', 1, 1),
    (2, null, 'Boolean', 0, 1),
    (3, null, 'Integer', 0, 1),
    (4, null, 'Double', 0, 1),
    (5, null, 'String', 0, 1),
    (6, null, 'URI', 0, 1),
    (7, null, 'Timestamp', 0, 1),
    (8, null, 'AddressProperty', 0, 1),
    (9, null, 'AppearanceProperty', 0, 1),
    (10, null, 'FeatureProperty', 0, 1),
    (11, null, 'GeometryProperty', 0, 1),
    (12, null, 'Reference', 0, 1),
    (13, null, 'CityObjectRelation', 0, 1),
    (14, null, 'Code', 0, 1),
    (15, null, 'ExternalReference', 0, 1),
    (16, null, 'ImplicitGeometryProperty', 0, 1),
    (17, null, 'Measure', 0, 1),
    (18, null, 'MeasureOrNilReasonList', 0, 1),
    (19, null, 'Occupancy', 0, 1),
    (20, null, 'QualifiedArea', 0, 1),
    (21, null, 'QualifiedVolume', 0, 1),
    (22, null, 'StringOrRef', 0, 1),
    (23, null, 'TimePosition', 0, 1),
    (24, null, 'Duration', 0, 1),
    (50, null, 'ADEOfAbstractCityObject', 1, 1),
    (51, null, 'ADEOfAbstractDynamizer', 1, 1),
    (52, null, 'ADEOfAbstractFeature', 1, 1),
    (53, null, 'ADEOfAbstractFeatureWithLifespan', 1, 1),
    (54, null, 'ADEOfAbstractLogicalSpace', 1, 1),
    (55, null, 'ADEOfAbstractOccupiedSpace', 1, 1),
    (56, null, 'ADEOfAbstractPhysicalSpace', 1, 1),
    (57, null, 'ADEOfAbstractPointCloud', 1, 1),
    (58, null, 'ADEOfAbstractSpace', 1, 1),
    (59, null, 'ADEOfAbstractSpaceBoundary', 1, 1),
    (60, null, 'ADEOfAbstractThematicSurface', 1, 1),
    (61, null, 'ADEOfAbstractUnoccupiedSpace', 1, 1),
    (62, null, 'ADEOfAbstractVersion', 1, 1),
    (63, null, 'ADEOfAbstractVersionTransition', 1, 1),
    (64, null, 'ADEOfCityModel', 1, 1),
    (65, null, 'ADEOfClosureSurface', 1, 1);

  map_datatype_schema(1, v_schema1);
  map_datatype_schema(2, v_schema2);
  map_datatype_schema(3, v_schema3);
  map_datatype_schema(4, v_schema4);
  map_datatype_schema(5, v_schema5);
  map_datatype_schema(6, v_schema6);
  map_datatype_schema(7, v_schema7);
  map_datatype_schema(8, v_schema8);
  map_datatype_schema(9, v_schema9);
  map_datatype_schema(10, v_schema10);
  map_datatype_schema(11, v_schema11);
  map_datatype_schema(12, v_schema12);
  map_datatype_schema(13, v_schema13);
  map_datatype_schema(14, v_schema14);
  map_datatype_schema(15, v_schema15);
  map_datatype_schema(16, v_schema16);
  map_datatype_schema(17, v_schema17);
  map_datatype_schema(18, v_schema18);
  map_datatype_schema(19, v_schema19);
  map_datatype_schema(20, v_schema20);
  map_datatype_schema(21, v_schema21);
  map_datatype_schema(22, v_schema22);
  map_datatype_schema(23, v_schema23);
  map_datatype_schema(24, v_schema24);
  map_datatype_schema(50, v_schema50);
  map_datatype_schema(51, v_schema51);
  map_datatype_schema(52, v_schema52);
  map_datatype_schema(53, v_schema53);
  map_datatype_schema(54, v_schema54);
  map_datatype_schema(55, v_schema55);
  map_datatype_schema(56, v_schema56);
  map_datatype_schema(57, v_schema57);
  map_datatype_schema(58, v_schema58);
  map_datatype_schema(59, v_schema59);
  map_datatype_schema(60, v_schema60);
  map_datatype_schema(61, v_schema61);
  map_datatype_schema(62, v_schema62);
  map_datatype_schema(63, v_schema63);
  map_datatype_schema(64, v_schema64);
  map_datatype_schema(65, v_schema65);

  COMMIT;
END;
/

-- Dynamizer Module --

DECLARE
  v_schema100 CLOB  := @dyn:AbstractTimeValuePair@;
  v_schema101 CLOB  := @dyn:AttributeReference@;
  v_schema102 CLOB  := @dyn:SensorConnection@;
  v_schema103 CLOB  := @dyn:TimeAppearance@;
  v_schema104 CLOB  := @dyn:TimeBoolean@;
  v_schema105 CLOB  := @dyn:TimeDouble@;
  v_schema106 CLOB  := @dyn:TimeGeometry@;
  v_schema107 CLOB  := @dyn:TimeImplicitGeometry@;
  v_schema108 CLOB  := @dyn:TimeInteger@;
  v_schema109 CLOB  := @dyn:TimeseriesComponent@;
  v_schema110 CLOB  := @dyn:TimeString@;
  v_schema111 CLOB  := @dyn:TimeURI@;
  v_schema112 CLOB  := @dyn:ADEOfAbstractAtomicTimeseries@;
  v_schema113 CLOB  := @dyn:ADEOfAbstractTimeseries@;
  v_schema114 CLOB  := @dyn:ADEOfCompositeTimeseries@;
  v_schema115 CLOB  := @dyn:ADEOfDynamizer@;
  v_schema116 CLOB  := @dyn:ADEOfGenericTimeseries@;
  v_schema117 CLOB  := @dyn:ADEOfStandardFileTimeseries@;
  v_schema118 CLOB  := @dyn:ADEOfTabulatedFileTimeseries@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (100, null, 'AbstractTimeValuePair', 1, 2),
    (101, null, 'AttributeReference', 0, 2),
    (102, null, 'SensorConnection', 0, 2),
    (103, 100, 'TimeAppearance', 0, 2),
    (104, 100, 'TimeBoolean', 0, 2),
    (105, 100, 'TimeDouble', 0, 2),
    (106, 100, 'TimeGeometry', 0, 2),
    (107, 100, 'TimeImplicitGeometry', 0, 2),
    (108, 100, 'TimeInteger', 0, 2),
    (109, null, 'TimeseriesComponent', 0, 2),
    (110, 100, 'TimeString', 0, 2),
    (111, 100, 'TimeURI', 0, 2),
    (112, null, 'ADEOfAbstractAtomicTimeseries', 1, 2),
    (113, null, 'ADEOfAbstractTimeseries', 1, 2),
    (114, null, 'ADEOfCompositeTimeseries', 1, 2),
    (115, null, 'ADEOfDynamizer', 1, 2),
    (116, null, 'ADEOfGenericTimeseries', 1, 2),
    (117, null, 'ADEOfStandardFileTimeseries', 1, 2),
    (118, null, 'ADEOfTabulatedFileTimeseries', 1, 2);

  map_datatype_schema(100, v_schema100);
  map_datatype_schema(101, v_schema101);
  map_datatype_schema(102, v_schema102);
  map_datatype_schema(103, v_schema103);
  map_datatype_schema(104, v_schema104);
  map_datatype_schema(105, v_schema105);
  map_datatype_schema(106, v_schema106);
  map_datatype_schema(107, v_schema107);
  map_datatype_schema(108, v_schema108);
  map_datatype_schema(109, v_schema108);
  map_datatype_schema(110, v_schema110);
  map_datatype_schema(111, v_schema111);
  map_datatype_schema(112, v_schema112);
  map_datatype_schema(113, v_schema113);
  map_datatype_schema(114, v_schema114);
  map_datatype_schema(115, v_schema115);
  map_datatype_schema(116, v_schema116);
  map_datatype_schema(117, v_schema117);
  map_datatype_schema(118, v_schema118);

  COMMIT;
END;
/

-- Generics Module --

DECLARE
  v_schema200 CLOB  := @gen:GenericAttributeSet@;
  v_schema201 CLOB  := @gen:ADEOfGenericLogicalSpace@;
  v_schema202 CLOB  := @gen:ADEOfGenericOccupiedSpace@;
  v_schema203 CLOB  := @gen:ADEOfGenericThematicSurface@;
  v_schema204 CLOB  := @gen:ADEOfGenericUnoccupiedSpace@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (200, null, 'GenericAttributeSet', 0, 3),
    (201, null, 'ADEOfGenericLogicalSpace', 1, 3),
    (202, null, 'ADEOfGenericOccupiedSpace', 1, 3),
    (203, null, 'ADEOfGenericThematicSurface', 1, 3),
    (204, null, 'ADEOfGenericUnoccupiedSpace', 1, 3);

  map_datatype_schema(200, v_schema200);
  map_datatype_schema(201, v_schema201);
  map_datatype_schema(202, v_schema202);
  map_datatype_schema(203, v_schema203);
  map_datatype_schema(204, v_schema204);

  COMMIT;
END;
/

-- LandUse Module --

DECLARE
  v_schema300 CLOB  := @luse:ADEOfLandUse@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (300, null, 'ADEOfLandUse', 1, 4);

  map_datatype_schema(300, v_schema300);

  COMMIT;
END;
/

-- PointCloud Module --

DECLARE
  v_schema400 CLOB  := @luse:ADEOfPointCloud@;

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (400, null, 'ADEOfPointCloud', 1, 5);

  map_datatype_schema(400, v_schema400);

  COMMIT;
END;
/

-- Relief Module --

DECLARE
  v_schema500 CLOB  := @dem:ADEOfAbstractReliefComponent@;
  v_schema501 CLOB  := @dem:ADEOfBreaklineRelief@;
  v_schema502 CLOB  := @dem:ADEOfMassPointRelief@;
  v_schema503 CLOB  := @dem:ADEOfRasterRelief@;
  v_schema504 CLOB  := @dem:ADEOfReliefFeature@;
  v_schema505 CLOB  := @dem:ADEOfTINRelief@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (500, null, 'ADEOfAbstractReliefComponent', 1, 6),
    (501, null, 'ADEOfBreaklineRelief', 1, 6),
    (502, null, 'ADEOfMassPointRelief', 1, 6),
    (503, null, 'ADEOfRasterRelief', 1, 6),
    (504, null, 'ADEOfReliefFeature', 1, 6),
    (505, null, 'ADEOfTINRelief', 1, 6);

  map_datatype_schema(500, v_schema500);
  map_datatype_schema(501, v_schema501);
  map_datatype_schema(502, v_schema502);
  map_datatype_schema(503, v_schema503);
  map_datatype_schema(504, v_schema504);
  map_datatype_schema(505, v_schema505);

  COMMIT;
END;
/

-- Transportation Module --

DECLARE
  v_schema600 CLOB  := @tran:ADEOfAbstractTransportationSpace@;
  v_schema601 CLOB  := @tran:ADEOfAuxiliaryTrafficArea@;
  v_schema602 CLOB  := @tran:ADEOfAuxiliaryTrafficSpace@;
  v_schema603 CLOB  := @tran:ADEOfClearanceSpace@;
  v_schema604 CLOB  := @tran:ADEOfHole@;
  v_schema605 CLOB  := @tran:ADEOfHoleSurface@;
  v_schema606 CLOB  := @tran:ADEOfIntersection@;
  v_schema607 CLOB  := @tran:ADEOfMarking@;
  v_schema608 CLOB  := @tran:ADEOfRailway@;
  v_schema609 CLOB  := @tran:ADEOfRoad@;
  v_schema610 CLOB  := @tran:ADEOfSection@;
  v_schema611 CLOB  := @tran:ADEOfSquare@;
  v_schema612 CLOB  := @tran:ADEOfTrack@;
  v_schema613 CLOB  := @tran:ADEOfTrafficArea@;
  v_schema614 CLOB  := @tran:ADEOfTrafficSpace@;
  v_schema615 CLOB  := @tran:ADEOfWaterway@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (600, null, 'ADEOfAbstractTransportationSpace', 1, 7),
    (601, null, 'ADEOfAuxiliaryTrafficArea', 1, 7),
    (602, null, 'ADEOfAuxiliaryTrafficSpace', 1, 7),
    (603, null, 'ADEOfClearanceSpace', 1, 7),
    (604, null, 'ADEOfHole', 1, 7),
    (605, null, 'ADEOfHoleSurface'),
    (606, null, 'ADEOfIntersection', 1, 7),
    (607, null, 'ADEOfMarking', 1, 7),
    (608, null, 'ADEOfRailway', 1, 7),
    (609, null, 'ADEOfRoad', 1, 7),
    (610, null, 'ADEOfSection', 1, 7),
    (611, null, 'ADEOfSquare', 1, 7),
    (612, null, 'ADEOfTrack', 1, 7),
    (613, null, 'ADEOfTrafficArea', 1, 7),
    (614, null, 'ADEOfTrafficSpace', 1, 7),
    (615, null, 'ADEOfWaterway', 1, 7);

  map_datatype_schema(600, v_schema600);
  map_datatype_schema(601, v_schema601);
  map_datatype_schema(602, v_schema602);
  map_datatype_schema(603, v_schema603);
  map_datatype_schema(604, v_schema604);
  map_datatype_schema(605, v_schema605);
  map_datatype_schema(606, v_schema606);
  map_datatype_schema(607, v_schema607);
  map_datatype_schema(608, v_schema608);
  map_datatype_schema(609, v_schema609);
  map_datatype_schema(610, v_schema610);
  map_datatype_schema(611, v_schema611);
  map_datatype_schema(612, v_schema612);
  map_datatype_schema(613, v_schema613);
  map_datatype_schema(614, v_schema614);
  map_datatype_schema(615, v_schema615);

  COMMIT;
END;
/

-- Construction Module --

DECLARE
  v_schema700 CLOB  := @con:ConstructionEvent@;
  v_schema701 CLOB  := @con:Elevation@;
  v_schema702 CLOB  := @con:Height@;
  v_schema703 CLOB  := @con:ADEOfAbstractConstruction@;
  v_schema704 CLOB  := @con:ADEOfAbstractConstructionSurface@;
  v_schema705 CLOB  := @con:ADEOfAbstractConstructiveElement@;
  v_schema706 CLOB  := @con:ADEOfAbstractFillingElement@;
  v_schema707 CLOB  := @con:ADEOfAbstractFillingSurface@;
  v_schema708 CLOB  := @con:ADEOfAbstractFurniture@;
  v_schema709 CLOB  := @con:ADEOfAbstractInstallation@;
  v_schema710 CLOB  := @con:ADEOfCeilingSurface@;
  v_schema711 CLOB  := @con:ADEOfDoor@;
  v_schema712 CLOB  := @con:ADEOfDoorSurface@;
  v_schema713 CLOB  := @con:ADEOfFloorSurface@;
  v_schema714 CLOB  := @con:ADEOfGroundSurface@;
  v_schema715 CLOB  := @con:ADEOfInteriorWallSurface@;
  v_schema716 CLOB  := @con:ADEOfOtherConstruction@;
  v_schema717 CLOB  := @con:ADEOfOuterCeilingSurface@;
  v_schema718 CLOB  := @con:ADEOfOuterFloorSurface@;
  v_schema719 CLOB  := @con:ADEOfRoofSurface@;
  v_schema720 CLOB  := @con:ADEOfWallSurface@;
  v_schema721 CLOB  := @con:ADEOfWindow@;
  v_schema722 CLOB  := @con:ADEOfWindowSurface@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (700, null, 'ConstructionEvent', 0, 8),
    (701, null, 'Elevation', 0, 8),
    (702, null, 'Height', 0, 8),
    (703, null, 'ADEOfAbstractConstruction', 1, 8),
    (704, null, 'ADEOfAbstractConstructionSurface', 1, 8),
    (705, null, 'ADEOfAbstractConstructiveElement', 1, 8),
    (706, null, 'ADEOfAbstractFillingElement', 1, 8),
    (707, null, 'ADEOfAbstractFillingSurface', 1, 8),
    (708, null, 'ADEOfAbstractFurniture', 1, 8),
    (709, null, 'ADEOfAbstractInstallation', 1, 8),
    (710, null, 'ADEOfCeilingSurface', 1, 8),
    (711, null, 'ADEOfDoor', 1, 8),
    (712, null, 'ADEOfDoorSurface', 1, 8),
    (713, null, 'ADEOfFloorSurface', 1, 8),
    (714, null, 'ADEOfGroundSurface', 1, 8),
    (715, null, 'ADEOfInteriorWallSurface', 1, 8),
    (716, null, 'ADEOfOtherConstruction', 1, 8),
    (717, null, 'ADEOfOuterCeilingSurface', 1, 8),
    (718, null, 'ADEOfOuterFloorSurface', 1, 8),
    (719, null, 'ADEOfRoofSurface', 1, 8),
    (720, null, 'ADEOfWallSurface', 1, 8),
    (721, null, 'ADEOfWindow', 1, 8),
    (722, null, 'ADEOfWindowSurface', 1, 8);

  map_datatype_schema(700, v_schema700);
  map_datatype_schema(701, v_schema701);
  map_datatype_schema(702, v_schema702);
  map_datatype_schema(703, v_schema703);
  map_datatype_schema(704, v_schema704);
  map_datatype_schema(705, v_schema705);
  map_datatype_schema(706, v_schema706);
  map_datatype_schema(707, v_schema707);
  map_datatype_schema(708, v_schema708);
  map_datatype_schema(709, v_schema709);
  map_datatype_schema(710, v_schema710);
  map_datatype_schema(711, v_schema711);
  map_datatype_schema(712, v_schema712);
  map_datatype_schema(713, v_schema713);
  map_datatype_schema(714, v_schema714);
  map_datatype_schema(715, v_schema715);
  map_datatype_schema(716, v_schema716);
  map_datatype_schema(717, v_schema717);
  map_datatype_schema(718, v_schema718);
  map_datatype_schema(719, v_schema719);
  map_datatype_schema(720, v_schema720);
  map_datatype_schema(721, v_schema721);
  map_datatype_schema(722, v_schema722);

  COMMIT;
END;
/

-- Tunnel Module --

DECLARE
  v_schema800 CLOB  := @tun:ADEOfAbstractTunnel@;
  v_schema801 CLOB  := @tun:ADEOfHollowSpace@;
  v_schema802 CLOB  := @tun:ADEOfTunnel@;
  v_schema803 CLOB  := @tun:ADEOfTunnelConstructiveElement@;
  v_schema804 CLOB  := @tun:ADEOfTunnelFurniture@;
  v_schema805 CLOB  := @tun:ADEOfTunnelInstallation@;
  v_schema806 CLOB  := @tun:ADEOfTunnelPart@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (800, null, 'ADEOfAbstractTunnel', 1, 9),
    (801, null, 'ADEOfHollowSpace', 1, 9),
    (802, null, 'ADEOfTunnel', 1, 9),
    (803, null, 'ADEOfTunnelConstructiveElement', 1, 9),
    (804, null, 'ADEOfTunnelFurniture', 1, 9),
    (805, null, 'ADEOfTunnelInstallation', 1, 9),
    (806, null, 'ADEOfTunnelPart', 1, 9);

  map_datatype_schema(800, v_schema800);
  map_datatype_schema(801, v_schema801);
  map_datatype_schema(802, v_schema802);
  map_datatype_schema(803, v_schema803);
  map_datatype_schema(804, v_schema804);
  map_datatype_schema(805, v_schema805);
  map_datatype_schema(806, v_schema806);

  COMMIT;
END;
/

-- Building Module --

DECLARE
  v_schema900 CLOB  := @bldg:RoomHeight@;
  v_schema901 CLOB  := @bldg:ADEOfAbstractBuilding@;
  v_schema902 CLOB  := @bldg:ADEOfAbstractBuildingSubdivision@;
  v_schema903 CLOB  := @bldg:ADEOfBuilding@;
  v_schema904 CLOB  := @bldg:ADEOfBuildingConstructiveElement@;
  v_schema905 CLOB  := @bldg:ADEOfBuildingFurniture@;
  v_schema906 CLOB  := @bldg:ADEOfBuildingInstallation@;
  v_schema907 CLOB  := @bldg:ADEOfBuildingPart@;
  v_schema908 CLOB  := @bldg:ADEOfBuildingRoom@;
  v_schema909 CLOB  := @bldg:ADEOfBuildingUnit@;
  v_schema910 CLOB  := @bldg:ADEOfStorey@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (900, null, 'RoomHeight', 0, 10),
    (901, null, 'ADEOfAbstractBuilding', 1, 10),
    (902, null, 'ADEOfAbstractBuildingSubdivision', 1, 10),
    (903, null, 'ADEOfBuilding', 1, 10),
    (904, null, 'ADEOfBuildingConstructiveElement', 1, 10),
    (905, null, 'ADEOfBuildingFurniture', 1, 10),
    (906, null, 'ADEOfBuildingInstallation', 1, 10),
    (907, null, 'ADEOfBuildingPart', 1, 10),
    (908, null, 'ADEOfBuildingRoom', 1, 10),
    (909, null, 'ADEOfBuildingUnit', 1, 10),
    (910, null, 'ADEOfStorey', 1, 10);

  map_datatype_schema(900, v_schema900);
  map_datatype_schema(901, v_schema901);
  map_datatype_schema(902, v_schema902);
  map_datatype_schema(903, v_schema903);
  map_datatype_schema(904, v_schema904);
  map_datatype_schema(905, v_schema905);
  map_datatype_schema(906, v_schema906);
  map_datatype_schema(907, v_schema907);
  map_datatype_schema(908, v_schema908);
  map_datatype_schema(909, v_schema909);
  map_datatype_schema(910, v_schema910);

  COMMIT;
END;
/

-- Bridge Module --

DECLARE
  v_schema CLOB  := ;
  v_schema1000 CLOB  := @brid:ADEOfAbstractBridge@;
  v_schema1001 CLOB  := @brid:ADEOfBridge@;
  v_schema1002 CLOB  := @brid:ADEOfBridgeConstructiveElement@;
  v_schema1003 CLOB  := @brid:ADEOfBridgeFurniture@;
  v_schema1004 CLOB  := @brid:ADEOfBridgeInstallation@;
  v_schema1005 CLOB  := @brid:ADEOfBridgePart@;
  v_schema1006 CLOB  := @brid:ADEOfBridgeRoom@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (1000, null, 'ADEOfAbstractBridge', 1, 11),
    (1001, null, 'ADEOfBridge', 1, 11),
    (1002, null, 'ADEOfBridgeConstructiveElement', 1, 11),
    (1003, null, 'ADEOfBridgeFurniture', 1, 11),
    (1004, null, 'ADEOfBridgeInstallation', 1, 11),
    (1005, null, 'ADEOfBridgePart', 1, 11),
    (1006, null, 'ADEOfBridgeRoom', 1, 11);

  map_datatype_schema(1000, v_schema1000);
  map_datatype_schema(1001, v_schema1001);
  map_datatype_schema(1002, v_schema1002);
  map_datatype_schema(1003, v_schema1003);
  map_datatype_schema(1004, v_schema1004);
  map_datatype_schema(1005, v_schema1005);
  map_datatype_schema(1006, v_schema1006);

  COMMIT;
END;
/

-- CityObjectGroup Module --

DECLARE
  v_schema1200 CLOB  := @grp:Role@;
  v_schema1201 CLOB  := @grp:ADEOfCityObjectGroup@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (1200, null, 'Role', 0, 13),
    (1201, null, 'ADEOfCityObjectGroup', 1, 13);

  map_datatype_schema(1200, v_schema1200);
  map_datatype_schema(1201, v_schema1201);

  COMMIT;
END;
/

-- Vegetation Module --

DECLARE
  v_schema1300 CLOB  := @veg:ADEOfAbstractVegetationObject@;
  v_schema1301 CLOB  := @veg:ADEOfPlantCover@;
  v_schema1302 CLOB  := @veg:ADEOfSolitaryVegetationObject@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (1300, null, 'ADEOfAbstractVegetationObject', 1, 14),
    (1301, null, 'ADEOfPlantCover', 1, 14),
    (1302, null, 'ADEOfSolitaryVegetationObject', 1, 14);

  map_datatype_schema(1300, v_schema1300);
  map_datatype_schema(1301, v_schema1301);
  map_datatype_schema(1302, v_schema1302);

  COMMIT;
END;
/

-- Versioning Module --

DECLARE
  v_schema1400 CLOB  := @vers:Transaction@;
  v_schema1401 CLOB  := @vers:ADEOfVersion@;
  v_schema1402 CLOB  := @vers:ADEOfVersionTransition;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (1400, null, 'Transaction', 0, 15),
    (1401, null, 'ADEOfVersion', 1, 15),
    (1402, null, 'ADEOfVersionTransition', 1, 15);

  map_datatype_schema(1400, v_schema1400);
  map_datatype_schema(1401, v_schema1401);
  map_datatype_schema(1402, v_schema1402);

  COMMIT;
END;
/


-- WaterBody Module --

DECLARE
  v_schema1500 CLOB  := @wtr:ADEOfAbstractWaterBoundarySurface@;
  v_schema1501 CLOB  := @wtr:ADEOfWaterBody@;
  v_schema1502 CLOB  := @wtr:ADEOfWaterGroundSurface@;
  v_schema1503 CLOB  := @wtr:ADEOfWaterSurface@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (1500, null, 'ADEOfAbstractWaterBoundarySurface', 1, 16),
    (1501, null, 'ADEOfWaterBody', 1, 16),
    (1502, null, 'ADEOfWaterGroundSurface', 1, 16),
    (1503, null, 'ADEOfWaterSurface', 1, 16);

  map_datatype_schema(1500, v_schema1500);
  map_datatype_schema(1501, v_schema1501);
  map_datatype_schema(1502, v_schema1502);
  map_datatype_schema(1503, v_schema1503);

  COMMIT;
END;
/

-- CityFurniture Module --

DECLARE
  v_schema1600 CLOB  := @frn:ADEOfCityFurniture@;

BEGIN

  INSERT INTO datatype (ID, SUPERTYPE_ID, TYPENAME, IS_ABSTRACT, NAMESPACE_ID)
  VALUES
    (1600, null, 'ADEOfCityFurniture', 1, 17);

  map_datatype_schema(1600, v_schema1600);

  COMMIT;
END;
/
