-----------------------------------------------------
-- Author: Karin Patenge, Oracle
-- Last update: October 6, 2025
-- Status: to be reviewed
-- This scripts requires Oracle Database version 23ai
-----------------------------------------------------

-- turn off the checking for substitution variables
SET DEFINE OFF;

-- truncate table before insert
TRUNCATE TABLE objectclass DROP STORAGE;

-- Core Module --

DECLARE
  v_schema1 CLOB  := @core:Undefined@;
  v_schema2 CLOB  := @core:AbstractObject@;
  v_schema3 CLOB  := @core:AbstractObject@;
  v_schema4 CLOB  := @core:Address@;
  v_schema5 CLOB  := @core:AbstractPointCloud@;
  v_schema6 CLOB  := @core:AbstractFeatureWithLifespan@;
  v_schema7 CLOB  := @core:AbstractCityObject@;
  v_schema8 CLOB  := @core:AbstractSpace@;
  v_schema9 CLOB  := @core:AbstractLogicalSpace@;
  v_schema10 CLOB  := @core:AbstractPhysicalSpace@;
  v_schema11 CLOB  := @core:AbstractUnoccupiedSpace@;
  v_schema12 CLOB  := @core:AbstractOccupiedSpace@;
  v_schema13 CLOB  := @core:AbstractSpaceBoundary@;
  v_schema14 CLOB  := @core:AbstractThematicSurface@;
  v_schema15 CLOB  := @core:ClosureSurface@;
  v_schema16 CLOB  := @core:AbstractDynamizer@;
  v_schema17 CLOB  := @core:AbstractVersionTransition@;
  v_schema18 CLOB  := @core:CityModel@;
  v_schema19 CLOB  := @core:AbstractVersion@;
  v_schema20 CLOB  := @core:AbstractAppearance@;
  v_schema21 CLOB  := @core:ImplicitGeometry@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (1, null, 'Undefined', 1, 0, 1),
    (2, null, 'AbstractObject', 1, 0, 1),
    (3, 2, 'AbstractFeature', 1, 0, 1),
    (4, null, 'Address', 0, 0, 1),
    (5, 3, 'AbstractPointCloud', 1, 0, 1),
    (6, 3, 'AbstractFeatureWithLifespan', 1, 0, 1),
    (7, 6, 'AbstractCityObject', 1, 0, 1),
    (8, 7, 'AbstractSpace', 1, 0, 1),
    (9, 8, 'AbstractLogicalSpace', 1, 0, 1),
    (10, 8, 'AbstractPhysicalSpace', 1, 0, 1),
    (11, 10, 'AbstractUnoccupiedSpace', 1, 0, 1),
    (12, 10, 'AbstractOccupiedSpace', 1, 0, 1),
    (13, 7, 'AbstractSpaceBoundary', 1, 0, 1),
    (14, 13, 'AbstractThematicSurface', 1, 0, 1),
    (15, 14, 'ClosureSurface', 0, 0, 1),
    (16, 6, 'AbstractDynamizer', 1, 0, 1),
    (17, 6, 'AbstractVersionTransition', 1, 0, 1),
    (18, 6, 'CityModel', 0, 0, 1),
    (19, 6, 'AbstractVersion', 1, 0, 1),
    (20, null, 'AbstractAppearance', 1, 0, 1),
    (21, null, 'ImplicitGeometry', 0, 0, 1);

  map_objectclass_schema(1, v_schema1);
  map_objectclass_schema(2, v_schema2);
  map_objectclass_schema(3, v_schema3);
  map_objectclass_schema(4, v_schema4);
  map_objectclass_schema(5, v_schema5);
  map_objectclass_schema(6, v_schema6);
  map_objectclass_schema(7, v_schema7);
  map_objectclass_schema(8, v_schema8);
  map_objectclass_schema(9, v_schema9);
  map_objectclass_schema(10, v_schema10);
  map_objectclass_schema(11, v_schema11);
  map_objectclass_schema(12, v_schema12);
  map_objectclass_schema(13, v_schema13);
  map_objectclass_schema(14, v_schema14);
  map_objectclass_schema(15, v_schema15);
  map_objectclass_schema(16, v_schema16);
  map_objectclass_schema(17, v_schema17);
  map_objectclass_schema(18, v_schema18);
  map_objectclass_schema(19, v_schema19);
  map_objectclass_schema(20, v_schema20);
  map_objectclass_schema(21, v_schema21);

  COMMIT;
END;
/

-- Dynamizer Module --

DECLARE
  v_schema100 CLOB  := @dyn:Dynamizer@;
  v_schema101 CLOB  := @dynAbstractTimeseries@;
  v_schema102 CLOB  := @dyn:AbstractAtomicTimeseries@;
  v_schema103 CLOB  := @dyn:TabulatedFileTimeseries@;
  v_schema104 CLOB  := @dyn:StandardFileTimeseries@;
  v_schema105 CLOB  := @dyn:GenericTimeseries@;
  v_schema106 CLOB  := @dyn:CompositeTimeseries@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (100, 16, 'Dynamizer', 0, 0, 2),
    (101, 3, 'AbstractTimeseries', 1, 0, 2),
    (102, 101, 'AbstractAtomicTimeseries', 1, 0, 2),
    (103, 102, 'TabulatedFileTimeseries', 0, 0, 2),
    (104, 102, 'StandardFileTimeseries', 0, 0, 2),
    (105, 102, 'GenericTimeseries', 0, 0, 2),
    (106, 101, 'CompositeTimeseries', 0, 0, 2);

  map_objectclass_schema(100, v_schema100);
  map_objectclass_schema(101, v_schema101);
  map_objectclass_schema(102, v_schema102);
  map_objectclass_schema(103, v_schema103);
  map_objectclass_schema(104, v_schema104);
  map_objectclass_schema(105, v_schema105);
  map_objectclass_schema(106, v_schema106);

  COMMIT;
END;
/

-- Generics Module --

DECLARE
  v_schema200 CLOB  := @gen:GenericLogicalSpace@;
  v_schema201 CLOB  := @gen:GenericOccupiedSpace@;
  v_schema202 CLOB  := @gen:GenericUnoccupiedSpace@;
  v_schema203 CLOB  := @gen:GenericThematicSurface@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (200, 9, 'GenericLogicalSpace', 0, 1, 3),
    (201, 12, 'GenericOccupiedSpace', 0, 1, 3),
    (202, 11, 'GenericUnoccupiedSpace', 0, 1, 3),
    (203, 14, 'GenericThematicSurface', 0, 0, 3);

  map_objectclass_schema(200, v_schema200);
  map_objectclass_schema(201, v_schema201);
  map_objectclass_schema(202, v_schema202);
  map_objectclass_schema(203, v_schema203);

  COMMIT;
END;
/

-- LandUse Module --

DECLARE
  v_schema300 CLOB  := @luse:LandUse@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (300, 14, 'LandUse', 0, 1, 4);

  map_objectclass_schema(300, v_schema300);

  COMMIT;
END;
/

-- PointCloud Module --

DECLARE
  v_schema400 CLOB  := @pcl:PointCloud@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (400, 5, 'PointCloud', 0, 0, 5);

  map_objectclass_schema(400, v_schema400);

  COMMIT;
END;
/

-- Relief Module --

DECLARE
  v_schema500 CLOB  := @dem:ReliefFeature@;
  v_schema501 CLOB  := @dem:AbstractReliefComponent@;
  v_schema502 CLOB  := @dem:TINRelief@;
  v_schema503 CLOB  := @dem:MassPointRelief@;
  v_schema504 CLOB  := @dem:BreaklineRelief@;
  v_schema505 CLOB  := @dem:RasterRelief@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (500, 13, 'ReliefFeature', 0, 1, 6),
    (501, 13, 'AbstractReliefComponent', 1, 0, 6),
    (502, 501, 'TINRelief', 0, 0, 6),
    (503, 501, 'MassPointRelief', 0, 0, 6),
    (504, 501, 'BreaklineRelief', 0, 0, 6),
    (505, 501, 'RasterRelief', 0, 0, 6);

  map_objectclass_schema(500, v_schema500);
  map_objectclass_schema(501, v_schema501);
  map_objectclass_schema(502, v_schema502);
  map_objectclass_schema(503, v_schema503);
  map_objectclass_schema(504, v_schema504);
  map_objectclass_schema(505, v_schema505);

  COMMIT;
END;
/

-- Transportation Module --

DECLARE
  v_schema600 CLOB  := @tran:AbstractTransportationSpace@;
  v_schema601 CLOB  := @tran:Railway@;
  v_schema602 CLOB  := @tran:Section@;
  v_schema603 CLOB  := @tran:Waterway@;
  v_schema604 CLOB  := @tran:Intersection@;
  v_schema605 CLOB  := @tran:Square@;
  v_schema606 CLOB  := @tran:Track@;
  v_schema607 CLOB  := @tran:Road@;
  v_schema608 CLOB  := @tran:AuxiliaryTrafficSpace@;
  v_schema609 CLOB  := @tran:ClearanceSpace@;
  v_schema610 CLOB  := @tran:TrafficSpace@;
  v_schema611 CLOB  := @tran:Hole@;
  v_schema612 CLOB  := @tran:AuxiliaryTrafficArea@;
  v_schema613 CLOB  := @tran:TrafficArea@;
  v_schema614 CLOB  := @tran:Marking@;
  v_schema615 CLOB  := @tran:HoleSurface@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (600, 11, 'AbstractTransportationSpace', 1, 0, 7),
    (601, 600, 'Railway', 0, 1, 7),
    (602, 600, 'Section', 0, 0, 7),
    (603, 600, 'Waterway', 0, 1, 7),
    (604, 600, 'Intersection', 0, 0, 7),
    (605, 600, 'Square', 0, 1, 7),
    (606, 600, 'Track', 0, 1, 7),
    (607, 600, 'Road', 0, 1, 7),
    (608, 11, 'AuxiliaryTrafficSpace', 0, 0, 7),
    (609, 11, 'ClearanceSpace', 0, 0, 7),
    (610, 11, 'TrafficSpace', 0, 0, 7),
    (611, 11, 'Hole', 0, 0, 7),
    (612, 14, 'AuxiliaryTrafficArea', 0, 0, 7),
    (613, 14, 'TrafficArea', 0, 0, 7),
    (614, 14, 'Marking', 0, 0, 7),
    (615, 14, 'HoleSurface', 0, 0, 7);

  map_objectclass_schema(600, v_schema600);
  map_objectclass_schema(601, v_schema601);
  map_objectclass_schema(602, v_schema602);
  map_objectclass_schema(603, v_schema603);
  map_objectclass_schema(604, v_schema604);
  map_objectclass_schema(605, v_schema605);
  map_objectclass_schema(606, v_schema606);
  map_objectclass_schema(607, v_schema607);
  map_objectclass_schema(608, v_schema608);
  map_objectclass_schema(609, v_schema609);
  map_objectclass_schema(610, v_schema610);
  map_objectclass_schema(611, v_schema611);
  map_objectclass_schema(612, v_schema612);
  map_objectclass_schema(613, v_schema613);
  map_objectclass_schema(614, v_schema614);
  map_objectclass_schema(615, v_schema615);

  COMMIT;
END;
/

-- Construction Module --

DECLARE
  v_schema700 CLOB  := @con:AbstractConstruction@;
  v_schema701 CLOB  := @con:OtherConstruction@;
  v_schema702 CLOB  := @con:AbstractConstructiveElement@;
  v_schema703 CLOB  := @con:AbstractFillingElement@;
  v_schema704 CLOB  := @con:Window@;
  v_schema705 CLOB  := @con:Door@;
  v_schema706 CLOB  := @con:AbstractFurniture@;
  v_schema707 CLOB  := @con:AbstractInstallation@;
  v_schema708 CLOB  := @con:AbstractConstructionSurface@;
  v_schema709 CLOB  := @con:WallSurface@;
  v_schema710 CLOB  := @con:GroundSurface@;
  v_schema711 CLOB  := @con:InteriorWallSurface@;
  v_schema712 CLOB  := @con:RoofSurface@;
  v_schema713 CLOB  := @con:FloorSurface@;
  v_schema714 CLOB  := @con:OuterFloorSurface@;
  v_schema715 CLOB  := @con:CeilingSurface@;
  v_schema716 CLOB  := @con:OuterCeilingSurface@;
  v_schema717 CLOB  := @con:AbstractFillingSurface@;
  v_schema718 CLOB  := @con:DoorSurface@;
  v_schema719 CLOB  := @con:WindowSurface@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (700, 12, 'AbstractConstruction', 1, 0, 8),
    (701, 700, 'OtherConstruction', 0, 1, 8),
    (702, 12, 'AbstractConstructiveElement', 1, 0, 8),
    (703, 12, 'AbstractFillingElement', 1, 0, 8),
    (704, 703, 'Window', 0, 0, 8),
    (705, 703, 'Door', 0, 0, 8),
    (706, 12, 'AbstractFurniture', 1, 0, 8),
    (707, 12, 'AbstractInstallation', 1, 0, 8),
    (708, 14, 'AbstractConstructionSurface', 1, 0, 8),
    (709, 708, 'WallSurface', 0, 0, 8),
    (710, 708, 'GroundSurface', 0, 0, 8),
    (711, 708, 'InteriorWallSurface', 0, 0, 8),
    (712, 708, 'RoofSurface', 0, 0, 8),
    (713, 708, 'FloorSurface', 0, 0, 8),
    (714, 708, 'OuterFloorSurface', 0, 0, 8),
    (715, 708, 'CeilingSurface', 0, 0, 8),
    (716, 708, 'OuterCeilingSurface', 0, 0, 8),
    (717, 14, 'AbstractFillingSurface', 1, 0, 8),
    (718, 717, 'DoorSurface', 0, 0, 8),
    (719, 717, 'WindowSurface', 0, 0, 8);

  map_objectclass_schema(700, v_schema700);
  map_objectclass_schema(701, v_schema701);
  map_objectclass_schema(702, v_schema702);
  map_objectclass_schema(703, v_schema703);
  map_objectclass_schema(704, v_schema704);
  map_objectclass_schema(705, v_schema705);
  map_objectclass_schema(706, v_schema706);
  map_objectclass_schema(707, v_schema707);
  map_objectclass_schema(708, v_schema708);
  map_objectclass_schema(709, v_schema709);
  map_objectclass_schema(710, v_schema710);
  map_objectclass_schema(711, v_schema711);
  map_objectclass_schema(712, v_schema712);
  map_objectclass_schema(713, v_schema713);
  map_objectclass_schema(714, v_schema714);
  map_objectclass_schema(715, v_schema715);
  map_objectclass_schema(716, v_schema716);
  map_objectclass_schema(717, v_schema717);
  map_objectclass_schema(718, v_schema718);
  map_objectclass_schema(719, v_schema719);

  COMMIT;
END;
/

-- Tunnel Module --

DECLARE
  v_schema800 CLOB  := @tun:AbstractTunnel@;
  v_schema801 CLOB  := @tun:Tunnel@;
  v_schema802 CLOB  := @tun:TunnelPart@;
  v_schema803 CLOB  := @tun:TunnelConstructiveElement@;
  v_schema804 CLOB  := @tun:HollowSpace@;
  v_schema805 CLOB  := @tun:TunnelInstallation@;
  v_schema806 CLOB  := @tun:TunnelFurniture@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (800, 700, 'AbstractTunnel', 1, 0, 9),
    (801, 800, 'Tunnel', 0, 1, 9),
    (802, 800, 'TunnelPart', 0, 0, 9),
    (803, 702, 'TunnelConstructiveElement', 0, 0, 9),
    (804, 11, 'HollowSpace', 0, 0, 9),
    (805, 707, 'TunnelInstallation', 0, 0, 9),
    (806, 706, 'TunnelFurniture', 0, 0, 9);

  map_objectclass_schema(800, v_schema800);
  map_objectclass_schema(801, v_schema801);
  map_objectclass_schema(802, v_schema802);
  map_objectclass_schema(803, v_schema803);
  map_objectclass_schema(804, v_schema804);
  map_objectclass_schema(805, v_schema805);
  map_objectclass_schema(806, v_schema806);

  COMMIT;
END;
/

-- Building Module --

DECLARE
  v_schema900 CLOB  := @bldg:AbstractBuilding@;
  v_schema901 CLOB  := @bldg:Building@;
  v_schema902 CLOB  := @bldg:BuildingPart@;
  v_schema903 CLOB  := @bldg:BuildingConstructiveElement@;
  v_schema904 CLOB  := @bldg:BuildingRoom@;
  v_schema905 CLOB  := @bldg:BuildingInstallation@;
  v_schema906 CLOB  := @bldg:BuildingFurniture@;
  v_schema907 CLOB  := @bldg:AbstractBuildingSubdivision@;
  v_schema908 CLOB  := @bldg:BuildingUnit@;
  v_schema909 CLOB  := @bldg:Storey@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (900, 700, 'AbstractBuilding', 1, 0, 10),
    (901, 900, 'Building', 0, 1, 10),
    (902, 900, 'BuildingPart', 0, 0, 10),
    (903, 702, 'BuildingConstructiveElement', 0, 0, 10),
    (904, 11, 'BuildingRoom', 0, 0, 10),
    (905, 707, 'BuildingInstallation', 0, 0, 10),
    (906, 706, 'BuildingFurniture', 0, 0, 10),
    (907, 9, 'AbstractBuildingSubdivision', 1, 0, 10),
    (908, 907, 'BuildingUnit', 0, 0, 10),
    (909, 907, 'Storey', 0, 0, 10);

  map_objectclass_schema(900, v_schema900);
  map_objectclass_schema(901, v_schema901);
  map_objectclass_schema(902, v_schema902);
  map_objectclass_schema(903, v_schema903);
  map_objectclass_schema(904, v_schema904);
  map_objectclass_schema(905, v_schema905);
  map_objectclass_schema(906, v_schema906);
  map_objectclass_schema(907, v_schema907);
  map_objectclass_schema(908, v_schema908);
  map_objectclass_schema(909, v_schema909);

  COMMIT;
END;
/

-- Bridge Module --

DECLARE
  v_schema1000 CLOB  := @brid:AbstractBridge@;
  v_schema1001 CLOB  := @brid:Bridge@;
  v_schema1002 CLOB  := @brid:BridgePart@;
  v_schema1003 CLOB  := @brid:BridgeConstructiveElement@;
  v_schema1004 CLOB  := @brid:BridgeRoom@;
  v_schema1005 CLOB  := @brid:BridgeInstallation@;
  v_schema1006 CLOB  := @brid:BridgeFurniture@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (1000, 700, 'AbstractBridge', 1, 0, 11),
    (1001, 1000, 'Bridge', 0, 1, 11),
    (1002, 1000, 'BridgePart', 0, 0, 11),
    (1003, 702, 'BridgeConstructiveElement', 0, 0, 11),
    (1004, 11, 'BridgeRoom', 0, 0, 11),
    (1005, 707, 'BridgeInstallation', 0, 0, 11),
    (1006, 706, 'BridgeFurniture', 0, 0, 11);

  map_objectclass_schema(1000, v_schema1000);
  map_objectclass_schema(1001, v_schema1001);
  map_objectclass_schema(1002, v_schema1002);
  map_objectclass_schema(1003, v_schema1003);
  map_objectclass_schema(1004, v_schema1004);
  map_objectclass_schema(1005, v_schema1005);
  map_objectclass_schema(1006, v_schema1006);

  COMMIT;
END;
/

-- Appearance Module --

DECLARE
  v_schema1100 CLOB  := @app:Appearance@;
  v_schema1101 CLOB  := @app:AbstractSurfaceData@;
  v_schema1102 CLOB  := @app:X3DMaterial@;
  v_schema1103 CLOB  := @app:AbstractTexture@;
  v_schema1104 CLOB  := @app:ParameterizedTexture@;
  v_schema1105 CLOB  := @app:GeoreferencedTexture@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (1100, 20, 'Appearance', 0, 0, 12),
    (1101, null, 'AbstractSurfaceData', 1, 0, 12),
    (1102, 1101, 'X3DMaterial', 0, 0, 12),
    (1103, 1101, 'AbstractTexture', 1, 0, 12),
    (1104, 1103, 'ParameterizedTexture', 0, 0, 12),
    (1105, 1103, 'GeoreferencedTexture', 0, 0, 12);

  map_objectclass_schema(1100, v_schema1100);
  map_objectclass_schema(1101, v_schema1101);
  map_objectclass_schema(1102, v_schema1102);
  map_objectclass_schema(1103, v_schema1103);
  map_objectclass_schema(1104, v_schema1104);
  map_objectclass_schema(1105, v_schema1105);

  COMMIT;
END;
/

-- CityObjectGroup Module --

DECLARE
  v_schema1200 CLOB  := @grp:CityObjectGroup@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (1200, 9, 'CityObjectGroup', 0, 1, 13);

  map_objectclass_schema(1200, v_schema1200);

  COMMIT;
END;
/

-- Vegetation Module --

DECLARE
  v_schema1300 CLOB  := @veg:AbstractVegetationObject@;
  v_schema1301 CLOB  := @veg:SolitaryVegetationObject@;
  v_schema1302 CLOB  := @veg:PlantCover@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (1300, 12, 'AbstractVegetationObject', 1, 0, 14),
    (1301, 1300, 'SolitaryVegetationObject', 0, 1, 14),
    (1302, 1300, 'PlantCover', 0, 1, 14);

  map_objectclass_schema(1300, v_schema1300);
  map_objectclass_schema(1301, v_schema1301);
  map_objectclass_schema(1302, v_schema1302);

  COMMIT;
END;
/

-- Versioning Module --

DECLARE
  v_schema1400 CLOB  := @vers:Version@;
  v_schema1401 CLOB  := @vers:VersionTransition@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (1400, 19, 'Version', 0, 0, 15),
    (1401, 17, 'VersionTransition', 0, 0, 15);

  map_objectclass_schema(1400, v_schema1400);
  map_objectclass_schema(1401, v_schema1401);

  COMMIT;
END;
/

-- WaterBody Module --

DECLARE
  v_schema1500 CLOB  := @wtr:WaterBody@;
  v_schema1501 CLOB  := @wtr:AbstractWaterBoundarySurface@;
  v_schema1502 CLOB  := @wtr:WaterSurface@;
  v_schema1503 CLOB  := @wtr:WaterGroundSurface@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (1500, 12, 'WaterBody', 0, 1, 16),
    (1501, 14, 'AbstractWaterBoundarySurface', 1, 0, 16),
    (1502, 1501, 'WaterSurface', 0, 0, 16),
    (1503, 1501, 'WaterGroundSurface', 0, 0, 16);

  map_objectclass_schema(1500, v_schema1500);
  map_objectclass_schema(1501, v_schema1501);
  map_objectclass_schema(1502, v_schema1502);
  map_objectclass_schema(1503, v_schema1503);

  COMMIT;
END;
/

-- CityFurniture Module --

DECLARE
  v_schema1600 CLOB  := @frn:CityFurniture@;

BEGIN

  INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
  VALUES
    (1600, 12, 'CityFurniture', 0, 1, 17);

  map_objectclass_schema(1600, v_schema1600);

  COMMIT;
END;
/

