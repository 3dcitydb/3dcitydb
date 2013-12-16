-- DTM_SEQ.sql
--
-- Authors:     Prof. Dr. Lutz Pluemer <pluemer@ikg.uni-bonn.de>
--              Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Dr. Gerhard Groeger <groeger@ikg.uni-bonn.de>
--              Joerg Schmittwilken <schmittwilken@ikg.uni-bonn.de>
--              Viktor Stroh <stroh@ikg.uni-bonn.de>
--              Dr. Andreas Poth <poth@lat-lon.de>
--
-- Copyright:   (c) 2004-2006, Institute for Cartography and Geoinformation,
--                             Universit�t Bonn, Germany
--                             http://www.ikg.uni-bonn.de
--              (c) 2005-2006, lat/lon GmbH, Germany
--                             http://www.lat-lon.de
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
-- 1.0       2006-04-03   release version                             LPlu
--                                                                    TKol
--                                                                    GGro
--                                                                    JSch
--                                                                    VStr
--                                                                    APot
--

-- DROP SEQUENCE "RASTER_REL_IMP_SEQ";
CREATE SEQUENCE "RASTER_REL_IMP_SEQ" INCREMENT BY 1 START WITH 1 MINVALUE 1;

-- DROP SEQUENCE "RASTER_REL_RDT_SEQ";
CREATE SEQUENCE "RASTER_REL_RDT_SEQ" INCREMENT BY 1 START WITH 1 MINVALUE 1;

-- DROP SEQUENCE "RASTER_REL_RDT_IMP_SEQ";
CREATE SEQUENCE "RASTER_REL_RDT_IMP_SEQ" INCREMENT BY 1 START WITH 1 MINVALUE 1;
