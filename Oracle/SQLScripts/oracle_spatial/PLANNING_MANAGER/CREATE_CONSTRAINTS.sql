-- CREATE_CONSTRAINTS.sql
--
-- Authors:     Prof. Dr. Lutz Pluemer <pluemer@ikg.uni-bonn.de>
--              Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Dr. Gerhard Groeger <groeger@ikg.uni-bonn.de>
--              Joerg Schmittwilken <schmittwilken@ikg.uni-bonn.de>
--              Viktor Stroh <stroh@ikg.uni-bonn.de>

-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de

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
--
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


ALTER TABLE "CITY_MODEL_ASPECT"
ADD CONSTRAINT "CITY_MODEL_ASPECT_PK" PRIMARY KEY("ID") ENABLE;

ALTER TABLE "CITY_MODEL_ASPECT_COMPONENT"
ADD CONSTRAINT "CITY_MODEL_ASPECT_COMPONENT_PK" PRIMARY KEY("CITY_MODEL_ASPECT_ID","PLANNING_ALTERNATIVE_ID") ENABLE;

ALTER TABLE "PLANNING"
ADD CONSTRAINT "PLANNING_AREA_PK" PRIMARY KEY("ID") ENABLE;

ALTER TABLE "PLANNING_ALTERNATIVE"
ADD CONSTRAINT "PLANNING_ALTERNATIVE_PK" PRIMARY KEY("ID") ENABLE;

ALTER TABLE "CITY_MODEL_ASPECT_COMPONENT"
ADD CONSTRAINT "REL_CITY_MODEL_ASPECT_ID_ID" FOREIGN KEY("CITY_MODEL_ASPECT_ID")REFERENCES "CITY_MODEL_ASPECT"("ID") ENABLE;

ALTER TABLE "CITY_MODEL_ASPECT_COMPONENT"
ADD CONSTRAINT "REL_PLANNING_ALTERNATIVE_ID_ID" FOREIGN KEY("PLANNING_ALTERNATIVE_ID")REFERENCES "PLANNING_ALTERNATIVE"("ID") ENABLE;

ALTER TABLE "PLANNING_ALTERNATIVE"
ADD CONSTRAINT "REL_PLANNING_ID_ID" FOREIGN KEY("PLANNING_ID")REFERENCES "PLANNING"("ID") ENABLE;

CREATE SEQUENCE "CITY_MODEL_ASPECT_SEQ" INCREMENT BY 1 START WITH 1 MINVALUE 1 ;

CREATE SEQUENCE "PLANNING_ALTERNATIVE_SEQ" INCREMENT BY 1 START WITH 1 MINVALUE 1 ;

CREATE SEQUENCE "PLANNING_SEQ" INCREMENT BY 1 START WITH 1 MINVALUE 1 ;
