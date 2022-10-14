DELETE FROM aggregation_info;

-- Core Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (20, 7, 'appearance', 1, 0, -1, 0);

-- Appearance Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1101, 1100, 'surfaceData', 1100, 0, -1, 0);

-- Bridge Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1001, 1002, 'bridgePart', 1000, 1, -1, 1);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (4, 1000, 'address', 1000, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1004, 1000, 'bridgeRoom', 1000, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1005, 1000, 'bridgeInstallation', 1000, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1006, 1000, 'bridgeFurniture', 1000, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1003, 1000, 'bridgeConstructiveElement', 1000, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1005, 1004, 'bridgeInstallation', 1000, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1006, 1004, 'bridgeFurniture', 1000, 0, -1, 0);

-- Building Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (901, 902, 'buildingPart', 900, 1, -1, 1);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (4, 900, 'address', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (4, 908, 'address', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (907, 900, 'buildingSubdivision', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (904, 900, 'buildingPart', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (905, 900, 'buildingInstallation', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (906, 900, 'buildingFurniture', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (903, 900, 'buildingConstructiveElement', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (906, 904, 'buildingFurniture', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (905, 904, 'buildingInstallation', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (905, 907, 'buildingInstallation', 900, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (906, 907, 'buildingFurniture', 900, 0, -1, 0);

-- 1200 Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (7, 1200, 'groupMember', 1200, 0, -1, 0);

-- Construction Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (4, 705, 'address', 700, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (4, 718, 'address', 700, 0, -1, 0);

-- Dynamizer Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (101, 100, 'dynamicData', 100, 0, -1, 0);

-- Relief Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (501, 500, 'reliefComponent', 500, 1, -1, 0);

-- Transportation Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (610, 611, 'clearanceSpace', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (611, 600, 'trafficSpace', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (615, 600, 'marking', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (612, 600, 'hole', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (609, 600, 'auxiliaryTrafficSpace', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (603, 607, 'section', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (605, 607, 'intersection', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (603, 608, 'section', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (605, 608, 'intersection', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (603, 604, 'section', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (605, 604, 'intersection', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (603, 602, 'section', 600, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (605, 602, 'intersection', 600, 0, -1, 0);

-- Tunnel Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (801, 802, 'tunnelPart', 800, 1, -1, 1);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (804, 800, 'hollowSpace', 800, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (805, 800, '805', 800, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (806, 800, 'tunnelFurniture', 800, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (803, 800, 'tunnelConstructiveElement', 800, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (806, 804, 'tunnelFurniture', 800, 0, -1, 0);

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (805, 804, '805', 800, 0, -1, 0);

-- Versioning Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (6, 1400, 'versionMember', 1400, 0, -1, 0);

-- WaterBody Module --

INSERT INTO aggregation_info (CHILD_ID, PARENT_ID, PROPERTY_NAME, PROPERTY_NAMESPACE_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE)
VALUES (1501, 1500, 'boundary', 1500, 0, -1, 0);

