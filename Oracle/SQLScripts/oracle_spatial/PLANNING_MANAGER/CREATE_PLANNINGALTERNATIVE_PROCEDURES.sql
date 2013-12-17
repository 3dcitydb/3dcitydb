-- CREATE_PLANNINGALTERNATIVE_PROCEDURES.sql
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
-- Dieses Skript erzeugt fï¿½r jede *Bdy Porzedur eine entsprechende PL/SQL
-- Prozedur, die aus SQL*PLUS o.ï¿½. angesprochen werden kann. Es wird zusï¿½tzlich
-- eine Bildschimausgabe generiert.
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

CREATE OR REPLACE PROCEDURE AddPlanningAlternative(
  planningId NUMBER,
  title VARCHAR2,
  description VARCHAR2,
  generator VARCHAR2,
  planner VARCHAR2
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  AddPlanningAlternativeBdy(planningId, title, description, generator, planner, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Planungsalternative angelegt und dem Workspace ' || message || ' zugeordnet');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/






CREATE OR REPLACE PROCEDURE UpdatePlanningAlternative(
  planningAlternativeId NUMBER,
  newTitle VARCHAR2,
  newDescription VARCHAR2,
  newGenerator VARCHAR2,
  newPlanner VARCHAR2
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  UpdatePlanningAlternativeBdy(planningAlternativeId, newTitle, newDescription, newGenerator, newPlanner, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Metadaten der Planungsalternativen aktualisiert');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/






CREATE OR REPLACE PROCEDURE DiscardPlanningAlternative(
  planningAlternativeId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  DiscardPlanningAlternativeBdy(planningAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Planungsalternativen beendet');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/









CREATE OR REPLACE PROCEDURE GetDiff(
  planningAlternativeId VARCHAR2
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  GetDiffBdy(planningAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Anzahl der Differenzen: ' || message);
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/







CREATE OR REPLACE PROCEDURE GetAllDiff

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  GetAllDiffBdy(status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Gesamtzahl der Differenzen: ' || message);
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/





CREATE OR REPLACE PROCEDURE GetConflicts(
  planningAlternativeId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  GetConflictsBdy(planningAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Anzahl der Konfilkte: ' || message);
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/







CREATE OR REPLACE PROCEDURE GetAllConflicts

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  GetAllConflictsBdy(status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Gesamtzahl der Konflikte: ' || message);
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/







CREATE OR REPLACE PROCEDURE RefreshPlanningAlternative(
  planningAlternativeId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  RefreshPlanningAlternativeBdy(planningAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Workspace der Planungsalternative aktualisiert');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/







CREATE OR REPLACE PROCEDURE GetRefreshDate(
  planningAlternativeId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  GetRefreshDateBdy(planningAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Letzte Aktualisierung: ' || message);
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/







CREATE OR REPLACE PROCEDURE deleteAllPlanningAlternatives

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  DelAllPlanningAlternativesBdy(status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Alle Planungsalternativen gelï¿½scht');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/







CREATE OR REPLACE PROCEDURE deleteTermPlanningAlternatives

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  DelTermPlanningAlternativesBdy(status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Alle beendeten Planungsalternativen gelï¿½scht');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/