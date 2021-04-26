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

/******************************************************************
* INDEX_TABLE that holds INDEX_OBJ instances
* 
******************************************************************/
CREATE TABLE INDEX_TABLE (
  ID   SERIAL PRIMARY KEY,
  obj  citydb_pkg.INDEX_OBJ
);


/******************************************************************
* Populate INDEX_TABLE with INDEX_OBJ instances
* 
******************************************************************/
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_spatial_2d('cityobject_envelope_spx', 'cityobject', 'envelope'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_spatial_2d('surface_geom_spx', 'surface_geometry', 'geometry'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_spatial_2d('surface_geom_solid_spx', 'surface_geometry', 'solid_geometry'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('cityobject_inx', 'cityobject', 'gmlid, gmlid_codespace'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('cityobject_lineage_inx', 'cityobject', 'lineage'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('cityobj_creation_date_inx', 'cityobject', 'creation_date'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('cityobj_term_date_inx', 'cityobject', 'termination_date'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('cityobj_last_mod_date_inx', 'cityobject', 'last_modification_date'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('surface_geom_inx', 'surface_geometry', 'gmlid, gmlid_codespace'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('appearance_inx', 'appearance', 'gmlid, gmlid_codespace'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('appearance_theme_inx', 'appearance', 'theme'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('surface_data_inx', 'surface_data', 'gmlid, gmlid_codespace'));
INSERT INTO index_table (obj) VALUES (citydb_pkg.construct_normal('address_inx', 'address', 'gmlid, gmlid_codespace'));
