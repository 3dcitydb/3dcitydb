-- CREATE_PLANNING_MANAGER.sql
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
-- Aufruf der Einzelskripte zum Erstellen der notwendigen Tabellen, Indizes,
-- Sequenzen und Prozeduren.
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
--

SELECT 'PlanningManager: Creating tables, sequences and stored procedures!' as message from DUAL;

COMMIT;

SET SERVEROUTPUT ON;

-- database schema
@PLANNING_MANAGER/CREATE_TABLES.sql;
@PLANNING_MANAGER/CREATE_CONSTRAINTS.sql;
@PLANNING_MANAGER/CREATE_SPATIAL_INDEX.sql;

-- utility procedures
@PLANNING_MANAGER/CREATE_UTIL_PROCEDURES;

-- procedure bodies with return values (Java)
@PLANNING_MANAGER/CREATE_PLANNING_PROCEDUREBODYS.sql;
@PLANNING_MANAGER/CREATE_PLANNINGALTERNATIVE_PROCEDUREBODYS.sql;
@PLANNING_MANAGER/CREATE_CITYMODELASPECT_PROCEDUREBODYS.sql;

-- procedures for console output (SQL*Plus)
@PLANNING_MANAGER/CREATE_PLANNING_PROCEDURES.sql;
@PLANNING_MANAGER/CREATE_PLANNINGALTERNATIVE_PROCEDURES.sql;
@PLANNING_MANAGER/CREATE_CITYMODELASPECT_PROCEDURES.sql;

COMMIT;

SHOW ERRORS;

SELECT 'PlanningManager: Finished!' as message from DUAL;
