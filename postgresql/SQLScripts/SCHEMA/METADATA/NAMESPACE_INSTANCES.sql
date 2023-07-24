DELETE FROM namespace;

-- Core Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (0, 'core', 'http://www.3dcitydb.org/3dcitydb/5.0');

-- Dynamizer Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1, 'dyn', 'http://www.3dcitydb.org/3dcitydb/dynamizer/5.0');

-- Generics Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (2, 'gen', 'http://www.3dcitydb.org/3dcitydb/generics/5.0');

-- LandUse Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (3, 'luse', 'http://www.3dcitydb.org/3dcitydb/landuse/5.0');

-- PointCloud Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (4, 'pcl', 'http://www.3dcitydb.org/3dcitydb/pointcloud/5.0');

-- Relief Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (5, 'dem', 'http://www.3dcitydb.org/3dcitydb/relief/5.0');

-- Transportation Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (6, 'tran', 'http://www.3dcitydb.org/3dcitydb/transportation/5.0');

-- Construction Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (7, 'con', 'http://www.3dcitydb.org/3dcitydb/construction/5.0');

-- Tunnel Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (8, 'tun', 'http://www.3dcitydb.org/3dcitydb/tunnel/5.0');

-- Building Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (9, 'bldg', 'http://www.3dcitydb.org/3dcitydb/building/5.0');

-- Bridge Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (10, 'brid', 'http://www.3dcitydb.org/3dcitydb/bridge/5.0');

-- Appearance Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (11, 'app', 'http://www.3dcitydb.org/3dcitydb/appearance/5.0');

-- CityObjectGroup Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (12, 'grp', 'http://www.3dcitydb.org/3dcitydb/cityobjectgroup/5.0');

-- Vegetation Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (13, 'veg', 'http://www.3dcitydb.org/3dcitydb/vegetation/5.0');

-- Versioning Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (14, 'vers', 'http://www.3dcitydb.org/3dcitydb/versioning/5.0');

-- WaterBody Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (15, 'wtr', 'http://www.3dcitydb.org/3dcitydb/waterbody/5.0');

-- CityFurniture Module --
INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (16, 'frn', 'http://www.3dcitydb.org/3dcitydb/cityfurniture/5.0');

-- Deprecated Module --
INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (17, 'depr', 'http://www.3dcitydb.org/3dcitydb/deprecated/5.0');
