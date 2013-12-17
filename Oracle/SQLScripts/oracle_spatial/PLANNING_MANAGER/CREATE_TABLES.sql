-- CREATE_TABLES.sql
--
-- Authors:     Prof. Dr. Lutz Pluemer <pluemer@ikg.uni-bonn.de>
--              Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Dr. Gerhard Groeger <groeger@ikg.uni-bonn.de>
--              Joerg Schmittwilken <schmittwilken@ikg.uni-bonn.de>
--              Viktor Stroh <stroh@ikg.uni-bonn.de>

-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de

--              (c) 2004-2006, Institute for Cartography and Geoinformation,
--                             Universität Bonn, Germany
--                             http://www.ikg.uni-bonn.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
-- Creates tables necessary for the management of Plannings by PL/SQL or
-- PlanningManager
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 0.2.2     2006-04-03   release version                             LPlu
--                                                                    TKol
--                                                                    GGro
--                                                                    JSch
--                                                                    VStr
--


CREATE TABLE "CITY_MODEL_ASPECT"
(
"ID" NUMBER NOT NULL,
"TITLE" VARCHAR2 (256),
"DESCRIPTION" VARCHAR2 (4000),
"GENERATOR" VARCHAR2 (256),
"WORKSPACE_NAME" VARCHAR2 (30),
"STARTING_DATE" DATE
);


CREATE TABLE "CITY_MODEL_ASPECT_COMPONENT"
(
"CITY_MODEL_ASPECT_ID" NUMBER NOT NULL,
"PLANNING_ALTERNATIVE_ID" NUMBER NOT NULL
);


CREATE TABLE "PLANNING"
(
"ID" NUMBER NOT NULL,
"TITLE" VARCHAR2 (256),
"DESCRIPTION" VARCHAR2 (4000),
"EXECUTIVE" VARCHAR2 (256),
"SPATIAL_EXTENT" MDSYS.SDO_GEOMETRY,
"STARTING_DATE" DATE,
"TERMINATION_DATE" DATE
);


DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'PLANNING';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES ('PLANNING', 'SPATIAL_EXTENT',
    MDSYS.SDO_DIM_ARRAY
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000000000, 10000000.000000000, 0.0000005),
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000000000, 10000000.000000000, 0.0000005)
      ) ,
      &SRSNO);




CREATE TABLE "PLANNING_ALTERNATIVE"
(
"ID" NUMBER NOT NULL,
"PLANNING_ID" NUMBER,
"TITLE" VARCHAR2 (256),
"DESCRIPTION" VARCHAR2 (4000),
"GENERATOR" VARCHAR2 (256),
"PLANNER" VARCHAR2 (256),
"WORKSPACE_NAME" VARCHAR2 (30),
"STARTING_DATE" DATE,
"TERMINATION_DATE" DATE
);

