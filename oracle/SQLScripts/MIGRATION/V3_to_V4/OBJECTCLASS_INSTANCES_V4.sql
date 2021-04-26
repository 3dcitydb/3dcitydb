-- 3D City Database - The Open Source CityGML Database
-- https://www.3dcitydb.org/
--
-- Copyright 2013 - 2021
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.lrg.tum.de/gis/
--
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
--
-- Virtual City Systems, Berlin <https://vc.systems/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0
WHERE id = 0;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'cityobject'
WHERE id = 1;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'cityobject', baseclass_id = 1
WHERE id = 2;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'cityobject', baseclass_id = 2
WHERE id = 3;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'land_use', baseclass_id = 3
WHERE id = 4;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'generic_cityobject', baseclass_id = 3
WHERE id = 5;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'cityobject', baseclass_id = 3
WHERE id = 6;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'solitary_vegetat_object', baseclass_id = 3
WHERE id = 7;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'plant_cover', baseclass_id = 3
WHERE id = 8;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'cityobject', baseclass_id = 3
WHERE id = 105;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'waterbody', baseclass_id = 3
WHERE id = 9;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'waterboundary_surface', baseclass_id = 3
WHERE id = 10;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'waterboundary_surface', baseclass_id = 3
WHERE id = 11;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'waterboundary_surface', baseclass_id = 3
WHERE id = 12;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'waterboundary_surface', baseclass_id = 3
WHERE id = 13;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'relief_feature', baseclass_id = 3
WHERE id = 14;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'relief_component', baseclass_id = 3
WHERE id = 15;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tin_relief', baseclass_id = 3
WHERE id = 16;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'masspoint_relief', baseclass_id = 3
WHERE id = 17;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'breakline_relief', baseclass_id = 3
WHERE id = 18;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'raster_relief', baseclass_id = 3
WHERE id = 19;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'cityobject', baseclass_id = 3
WHERE id = 20;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'city_furniture', baseclass_id = 3
WHERE id = 21;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'cityobject', baseclass_id = 3
WHERE id = 22;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'cityobjectgroup', baseclass_id = 3
WHERE id = 23;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'building', baseclass_id = 3
WHERE id = 24;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'building', baseclass_id = 3
WHERE id = 25;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'building', baseclass_id = 3
WHERE id = 26;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'building_installation', baseclass_id = 3
WHERE id = 27;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'building_installation', baseclass_id = 3
WHERE id = 28;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 29;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 30;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 31;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 32;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 33;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 34;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 35;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 36;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'opening', baseclass_id = 3
WHERE id = 37;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'opening', baseclass_id = 3
WHERE id = 38;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'opening', baseclass_id = 3
WHERE id = 39;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'building_furniture', baseclass_id = 3
WHERE id = 40;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'room', baseclass_id = 3
WHERE id = 41;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'transportation_complex', baseclass_id = 3
WHERE id = 42;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'transportation_complex', baseclass_id = 3
WHERE id = 43;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'transportation_complex', baseclass_id = 3
WHERE id = 44;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'transportation_complex', baseclass_id = 3
WHERE id = 45;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'transportation_complex', baseclass_id = 3
WHERE id = 46;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'traffic_area', baseclass_id = 3
WHERE id = 47;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'traffic_area', baseclass_id = 3
WHERE id = 48;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'cityobject', baseclass_id = 2
WHERE id = 49;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'appearance', baseclass_id = 2
WHERE id = 50;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'surface_data', baseclass_id = 2
WHERE id = 51;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'surface_data', baseclass_id = 2
WHERE id = 52;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'surface_data', baseclass_id = 2
WHERE id = 53;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'surface_data', baseclass_id = 2
WHERE id = 54;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'surface_data', baseclass_id = 2
WHERE id = 55;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'textureparam', baseclass_id = 1
WHERE id = 56;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'citymodel', baseclass_id = 2
WHERE id = 57;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'address', baseclass_id = 2
WHERE id = 58;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'implicit_geometry', baseclass_id = 1
WHERE id = 59;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 60;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'thematic_surface', baseclass_id = 3
WHERE id = 61;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'bridge', baseclass_id = 3
WHERE id = 62;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'bridge', baseclass_id = 3
WHERE id = 63;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'bridge', baseclass_id = 3
WHERE id = 64;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_installation', baseclass_id = 3
WHERE id = 65;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_installation', baseclass_id = 3
WHERE id = 66;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 67;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 68;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 69;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 70;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 71;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 72;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 73;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 74;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 75;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_thematic_surface', baseclass_id = 3
WHERE id = 76;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_opening', baseclass_id = 3
WHERE id = 77;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_opening', baseclass_id = 3
WHERE id = 78;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_opening', baseclass_id = 3
WHERE id = 79;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_furniture', baseclass_id = 3
WHERE id = 80;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_room', baseclass_id = 3
WHERE id = 81;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'bridge_constr_element', baseclass_id = 3
WHERE id = 82;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'tunnel', baseclass_id = 3
WHERE id = 83;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'tunnel', baseclass_id = 3
WHERE id = 84;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 1, tablename = 'tunnel', baseclass_id = 3
WHERE id = 85;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_installation', baseclass_id = 3
WHERE id = 86;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_installation', baseclass_id = 3
WHERE id = 87;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 88;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 89;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 90;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 91;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 92;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 93;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 94;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 95;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 96;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_thematic_surface', baseclass_id = 3
WHERE id = 97;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_opening', baseclass_id = 3
WHERE id = 98;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_opening', baseclass_id = 3
WHERE id = 99;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_opening', baseclass_id = 3
WHERE id = 100;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_furniture', baseclass_id = 3
WHERE id = 101;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'tunnel_hollow_space', baseclass_id = 3
WHERE id = 102;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'textureparam', baseclass_id = 1
WHERE id = 103;

UPDATE objectclass SET is_ade_class = 0, is_toplevel = 0, tablename = 'textureparam', baseclass_id = 1
WHERE id = 104;

INSERT INTO objectclass (id, is_ade_class, is_toplevel, classname, tablename, superclass_id, baseclass_id)
VALUES (106,0,0,'_BrepGeometry','surface_geometry',0,1);

INSERT INTO objectclass (id, is_ade_class, is_toplevel, classname, tablename, superclass_id, baseclass_id)
VALUES (107,0,0,'Polygon','surface_geometry',106,1);

INSERT INTO objectclass (id, is_ade_class, is_toplevel, classname, tablename, superclass_id, baseclass_id)
VALUES (108,0,0,'BrepAggregate','surface_geometry',106,1);

INSERT INTO objectclass (id, is_ade_class, is_toplevel, classname, tablename, superclass_id, baseclass_id)
VALUES (109,0,0,'TexImage','tex_image',0,0);

INSERT INTO objectclass (id, is_ade_class, is_toplevel, classname, tablename, superclass_id, baseclass_id)
VALUES (110,0,0,'ExternalReference','external_reference',0,0);

INSERT INTO objectclass (id, is_ade_class, is_toplevel, classname, tablename, superclass_id, baseclass_id)
VALUES (111,0,0,'GridCoverage','grid_coverage',0,0);

INSERT INTO objectclass (id, is_ade_class, is_toplevel, classname, tablename, superclass_id, baseclass_id)
VALUES (112,0,0,'_genericAttribute','cityobject_genericattrib',0,0);

INSERT INTO objectclass (id, is_ade_class, is_toplevel, classname, tablename, superclass_id, baseclass_id)
VALUES (113,0,0,'genericAttributeSet','cityobject_genericattrib',112,0);