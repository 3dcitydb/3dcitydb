-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
--
-- Copyright 2013 - 2020
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.gis.bgu.tum.de/
--
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
--
-- virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
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

-- object: grid_coverage_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS grid_coverage_seq CASCADE;
CREATE SEQUENCE grid_coverage_seq
  INCREMENT BY 1
  MINVALUE 0
  MAXVALUE 2147483647
  START WITH 1
  CACHE 1
  NO CYCLE
  OWNED BY NONE;
-- ddl-end --

-- object: grid_coverage | type: TABLE --
-- DROP TABLE IF EXISTS grid_coverage CASCADE;
CREATE TABLE grid_coverage(
  id integer NOT NULL DEFAULT nextval('grid_coverage_seq'::regclass),
  rasterproperty raster,
  CONSTRAINT grid_coverage_pk PRIMARY KEY (id)
   WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: raster_relief | type: TABLE --
-- DROP TABLE IF EXISTS raster_relief CASCADE;
CREATE TABLE raster_relief(
  id integer NOT NULL,
  objectclass_id integer NOT NULL,
  raster_uri character varying(4000),
  coverage_id integer,
  CONSTRAINT raster_relief_pk PRIMARY KEY (id)
   WITH (FILLFACTOR = 100)

);
-- ddl-end --

-- object: raster_relief_comp_fk | type: CONSTRAINT --
-- ALTER TABLE raster_relief DROP CONSTRAINT IF EXISTS raster_relief_comp_fk CASCADE;
ALTER TABLE raster_relief ADD CONSTRAINT raster_relief_comp_fk FOREIGN KEY (id)
REFERENCES relief_component (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: raster_relief_coverage_fk | type: CONSTRAINT --
-- ALTER TABLE raster_relief DROP CONSTRAINT IF EXISTS raster_relief_coverage_fk CASCADE;
ALTER TABLE raster_relief ADD CONSTRAINT raster_relief_coverage_fk FOREIGN KEY (coverage_id)
REFERENCES grid_coverage (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: raster_relief_objclass_fk | type: CONSTRAINT --
-- ALTER TABLE raster_relief DROP CONSTRAINT IF EXISTS raster_relief_objclass_fk CASCADE;
ALTER TABLE raster_relief ADD CONSTRAINT raster_relief_objclass_fk FOREIGN KEY (objectclass_id)
REFERENCES objectclass (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: grid_coverage_raster_spx | type: INDEX --
-- DROP INDEX IF EXISTS grid_coverage_raster_spx CASCADE;
CREATE INDEX grid_coverage_raster_spx ON grid_coverage
  USING gist
  (
    (ST_ConvexHull(rasterproperty))
  );
-- ddl-end --

-- object: raster_relief_objclass_fkx | type: INDEX --
-- DROP INDEX IF EXISTS raster_relief_objclass_fkx CASCADE;
CREATE INDEX raster_relief_objclass_fkx ON raster_relief
  USING btree
  (
    objectclass_id ASC NULLS LAST
  ) WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: raster_relief_coverage_fkx | type: INDEX --
-- DROP INDEX IF EXISTS raster_relief_coverage_fkx CASCADE;
CREATE INDEX raster_relief_coverage_fkx ON raster_relief
  USING btree
  (
    coverage_id ASC NULLS LAST
  ) WITH (FILLFACTOR = 90);
-- ddl-end --

INSERT INTO objectclass ( ID , IS_ADE_CLASS, IS_TOPLEVEL, CLASSNAME , TABLENAME, SUPERCLASS_ID, BASECLASS_ID)
VALUES (19,0,0,'RasterRelief','raster_relief',15,3);

INSERT INTO objectclass ( ID , IS_ADE_CLASS, IS_TOPLEVEL, CLASSNAME , TABLENAME, SUPERCLASS_ID, BASECLASS_ID)
VALUES (111,0,0,'GridCoverage','grid_coverage',0,0);

--grid_coverage & raster_relief
INSERT INTO aggregation_info ( CHILD_ID , PARENT_ID, MIN_OCCURS, MAX_OCCURS, IS_COMPOSITE, JOIN_TABLE_OR_COLUMN_NAME)
VALUES (111,19,0,1,1,'coverage_id');
