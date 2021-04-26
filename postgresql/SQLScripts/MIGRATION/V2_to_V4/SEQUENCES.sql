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

/*************************************************
* create citydb schema
*
**************************************************/
DROP SCHEMA IF EXISTS citydb CASCADE;
CREATE SCHEMA citydb;


/*************************************************
* create sequences
*
**************************************************/
DROP SEQUENCE IF EXISTS citydb.address_seq;
CREATE SEQUENCE citydb.address_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.appearance_seq;
CREATE SEQUENCE citydb.appearance_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.citymodel_seq;
CREATE SEQUENCE citydb.citymodel_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.cityobject_seq;
CREATE SEQUENCE citydb.cityobject_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.cityobject_genericatt_seq;
CREATE SEQUENCE citydb.cityobject_genericatt_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.external_ref_seq;
CREATE SEQUENCE citydb.external_ref_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.grid_coverage_seq;
CREATE SEQUENCE citydb.grid_coverage_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.implicit_geometry_seq;
CREATE SEQUENCE citydb.implicit_geometry_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.surface_data_seq;
CREATE SEQUENCE citydb.surface_data_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.surface_geometry_seq;
CREATE SEQUENCE citydb.surface_geometry_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

DROP SEQUENCE IF EXISTS citydb.tex_image_seq;
CREATE SEQUENCE citydb.tex_image_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

CREATE SEQUENCE citydb.schema_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;

CREATE SEQUENCE citydb.ade_seq
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE
    OWNED BY NONE;
