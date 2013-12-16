-- DROP_PLANNING_MANAGER.sql
--
-- Authors:     Prof. Dr. Lutz Pluemer <pluemer@ikg.uni-bonn.de>
--              Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Dr. Gerhard Groeger <groeger@ikg.uni-bonn.de>
--              Joerg Schmittwilken <schmittwilken@ikg.uni-bonn.de>
--              Viktor Stroh <stroh@ikg.uni-bonn.de>
--
-- Copyright:   (c) 2004-2006, Institute for Cartography and Geoinformation,
--                             Universit�t Bonn, Germany
--                             http://www.ikg.uni-bonn.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
-- Aufruf der Einzelskripte zum L�schen der Tabellen, Sequenzen und Prozeduren.
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

SELECT 'PlanningManager: Dropping workspaces, tables, sequences and stored procedures' as message from DUAL;

COMMIT;

EXECUTE DeleteAllPlanningAlternatives;
EXECUTE DeleteAllCityModelAspects;

DROP TABLE "CITY_MODEL_ASPECT_COMPONENT" CASCADE CONSTRAINT PURGE;
DROP TABLE "CITY_MODEL_ASPECT" CASCADE CONSTRAINT PURGE;
DROP TABLE "PLANNING_ALTERNATIVE" CASCADE CONSTRAINT PURGE;
DROP TABLE "PLANNING" CASCADE CONSTRAINT PURGE;

DROP SEQUENCE "CITY_MODEL_ASPECT_SEQ";
DROP SEQUENCE "PLANNING_ALTERNATIVE_SEQ";
DROP SEQUENCE "PLANNING_SEQ";

DROP PROCEDURE "ADDPLANNINGBDY";
DROP PROCEDURE "UPDATEPLANNINGBDY";
DROP PROCEDURE "DISCARDPLANNINGBDY";
DROP PROCEDURE "ACCEPTPLANNINGBDY";

DROP PROCEDURE "ADDPLANNINGALTERNATIVEBDY";
DROP PROCEDURE "UPDATEPLANNINGALTERNATIVEBDY";
DROP PROCEDURE "DISCARDPLANNINGALTERNATIVEBDY";
DROP PROCEDURE "GETDIFFBDY";
DROP PROCEDURE "GETALLDIFFBDY";
DROP PROCEDURE "GETCONFLICTSBDY";
DROP PROCEDURE "GETALLCONFLICTSBDY";
DROP PROCEDURE "REFRESHPLANNINGALTERNATIVEBDY";
DROP PROCEDURE "DELALLPLANNINGALTERNATIVESBDY";
DROP PROCEDURE "DELTERMPLANNINGALTERNATIVESBDY";

DROP PROCEDURE "ADDCITYMODELASPECTBDY";
DROP PROCEDURE "DELETECITYMODELASPECTBDY";
DROP PROCEDURE "ADDPATOCMABDY";
DROP PROCEDURE "REMOVEPAFROMCMABDY";
DROP PROCEDURE "DELALLCITYMODELASPECTSBDY";

DROP PROCEDURE "ADDPLANNING";
DROP PROCEDURE "UPDATEPLANNING";
DROP PROCEDURE "DISCARDPLANNING";
DROP PROCEDURE "ACCEPTPLANNING";

DROP PROCEDURE "ADDPLANNINGALTERNATIVE";
DROP PROCEDURE "UPDATEPLANNINGALTERNATIVE";
DROP PROCEDURE "DISCARDPLANNINGALTERNATIVE";
DROP PROCEDURE "GETDIFF";
DROP PROCEDURE "GETALLDIFF";
DROP PROCEDURE "GETCONFLICTS";
DROP PROCEDURE "GETALLCONFLICTS";
DROP PROCEDURE "REFRESHPLANNINGALTERNATIVE";
DROP PROCEDURE "DELETEALLPLANNINGALTERNATIVES";
DROP PROCEDURE "DELETETERMPLANNINGALTERNATIVES";

DROP PROCEDURE "ADDCITYMODELASPECT";
DROP PROCEDURE "DELETECITYMODELASPECT";
DROP PROCEDURE "ADDPATOCMA";
DROP PROCEDURE "REMOVEPAFROMCMA";
DROP PROCEDURE "DELETEALLCITYMODELASPECTS";

COMMIT;

SHOW ERRORS;

SELECT 'PlanningManager: Finished!' as message from DUAL;
