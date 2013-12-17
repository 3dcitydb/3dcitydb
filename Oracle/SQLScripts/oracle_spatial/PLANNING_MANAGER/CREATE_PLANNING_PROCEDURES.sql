-- CREATE_PLANNING_PROCEDURES.sql
--
-- Authors:     Prof. Dr. Lutz Pluemer <pluemer@ikg.uni-bonn.de>
--              Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
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
--

CREATE OR REPLACE PROCEDURE AddPlanning(
  title VARCHAR2,
  description VARCHAR2,
  executive VARCHAR2,
  spatialExtent MDSYS.SDO_GEOMETRY
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  AddPlanningBdy(title, description, executive, spatialExtent, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Planung mit der ID ' || message || ' angelegt');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/




CREATE OR REPLACE PROCEDURE UpdatePlanning(
  newId NUMBER,
  newTitle VARCHAR2,
  newDescription VARCHAR2,
  newExecutive VARCHAR2,
  newSpatialExtent MDSYS.SDO_GEOMETRY
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  UpdatePlanningBdy(newId, newTitle, newDescription, newExecutive, newSpatialExtent, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Metadaten der Planung aktualisiert');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/






CREATE OR REPLACE PROCEDURE DiscardPlanning(
  planningId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  DiscardPlanningBdy(planningId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Planung beendet');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/




CREATE OR REPLACE PROCEDURE AcceptPlanning(
  planningId NUMBER,
  acceptedAlternativeId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  AcceptPlanningBdy(planningId, acceptedAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Planung ï¿½bernommen');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/