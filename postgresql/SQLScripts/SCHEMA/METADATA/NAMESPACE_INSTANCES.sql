DELETE FROM namespace;

-- Core Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (0, 'core', 'http://www.opengis.net/citygml/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1, 'core', 'http://www.opengis.net/citygml/2.0');

-- Dynamizer Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (100, 'dyn', 'http://www.opengis.net/citygml/dynamizer/3.0');

-- Generics Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (200, 'gen', 'http://www.opengis.net/citygml/generics/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (201, 'gen', 'http://www.opengis.net/citygml/generics/2.0');

-- LandUse Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (300, 'luse', 'http://www.opengis.net/citygml/landuse/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (301, 'luse', 'http://www.opengis.net/citygml/landuse/2.0');

-- PointCloud Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (400, 'pnt', 'http://www.opengis.net/citygml/pointcloud/3.0');

-- Relief Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (500, 'dem', 'http://www.opengis.net/citygml/relief/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (501, 'dem', 'http://www.opengis.net/citygml/relief/2.0');

-- Transportation Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (600, 'tran', 'http://www.opengis.net/citygml/transportation/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (601, 'tran', 'http://www.opengis.net/citygml/transportation/2.0');

-- Construction Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (700, 'con', 'http://www.opengis.net/citygml/construction/3.0');

-- Tunnel Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (800, 'tun', 'http://www.opengis.net/citygml/tunnel/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (801, 'tun', 'http://www.opengis.net/citygml/tunnel/2.0');

-- Building Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (900, 'bldg', 'http://www.opengis.net/citygml/building/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (901, 'bldg', 'http://www.opengis.net/citygml/building/2.0');

-- Bridge Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1000, 'brid', 'http://www.opengis.net/citygml/bridge/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1001, 'brid', 'http://www.opengis.net/citygml/bridge/2.0');

-- Appearance Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1100, 'app', 'http://www.opengis.net/citygml/appearance/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1101, 'app', 'http://www.opengis.net/citygml/appearance/2.0');

-- CityObjectGroup Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1200, 'grp', 'http://www.opengis.net/citygml/cityobjectgroup/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1201, 'grp', 'http://www.opengis.net/citygml/cityobjectgroup/2.0');

-- Vegetation Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1300, 'veg', 'http://www.opengis.net/citygml/vegetation/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1301, 'veg', 'http://www.opengis.net/citygml/vegetation/2.0');

-- Versioning Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1400, 'ver', 'http://www.opengis.net/citygml/versioning/3.0');

-- WaterBody Module --

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1500, 'wtr', 'http://www.opengis.net/citygml/waterbody/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1501, 'wtr', 'http://www.opengis.net/citygml/waterbody/2.0');

-- CityFurniture Module --
INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1600, 'frn', 'http://www.opengis.net/citygml/cityfurniture/3.0');

INSERT INTO namespace (ID, ALIAS, NAMESPACE)
VALUES (1601, 'frn', 'http://www.opengis.net/citygml/cityfurniture/2.0');
