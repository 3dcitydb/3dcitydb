-- CREATE_UTIL_PROCEDURES.sql
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


/*
 * Die Prozedur setzt die Ausgabeparameter
 *
 * @param statusValue Wert, der der Variable zugewiesen werden soll
 * @param messageValue Wert, der der Variable zugewiesen werden soll
 *
 * @return Variable, der der Wert zugewiesen werden soll
 * @return Variable, der der Wert zugewiesen werden soll
 *
 */

CREATE OR REPLACE PROCEDURE setOutParameter(
  statusValue IN NUMBER,
  messageValue IN VARCHAR2,
  statusParam OUT NUMBER,
  messageParam OUT VARCHAR2
)

IS

BEGIN
  statusParam := statusValue;
  messageParam := messageValue;

END;
/






/*
 * Die Prozedur prï¿½ft, ob die Planungen mit der gegeben ID existiert, und ob sie
 * beendet ist.
 *
 * @param ID der Planung
 *
 * @return Anzahl der Planungen
 * @return Status der Planung (1 = aktuell, 0 = beendet)
 *
 */

CREATE OR REPLACE PROCEDURE checkPlanning(
  planningId IN NUMBER,
  planningCount OUT NUMBER,
  planningStatus OUT NUMBER
)

IS
  planningTerminationDate NUMBER;

BEGIN
  -- Abfragen, ob die Planung existiert
  SELECT COUNT(id) INTO planningCount
  FROM planning
  WHERE id = planningId;

  -- Status der Planung abfragen
  SELECT COUNT(termination_date) INTO planningTerminationDate
  FROM planning
  WHERE id = planningId;

  IF planningTerminationDate = 0 THEN
    planningStatus := 1;
  ELSE
    planningStatus := 0;
  END IF;

END;
/






/*
 * Die Prozedur prï¿½ft, ob die Planungsalternative mit der gegeben ID existiert,
 * und ob sie beendet ist.
 *
 * @param ID der Planungsalternative
 *
 * @return Anzahl der Planungsalternativen
 * @return Status der Planungsalternativen (1 = aktuell, 0 = beendet)
 *
 */

CREATE OR REPLACE PROCEDURE checkPlanningAlternative(
  paId IN NUMBER,
  paCount OUT NUMBER,
  paStatus OUT NUMBER
)

IS
  paTerminationDate NUMBER;

BEGIN
  -- Abfragen, ob die Planungsalternative existiert
  SELECT COUNT(id) INTO paCount
  FROM planning_alternative
  WHERE id = paId;

  -- Status der Planungsalternative abfragen
  SELECT COUNT(termination_date) INTO paTerminationDate
  FROM planning_alternative
  WHERE id = paId;

  IF paTerminationDate = 0 THEN   -- kein Beedigungsdatum -> PA aktiv
    paStatus := 1;
  ELSE
    paStatus := 0;
  END IF;

END;
/






/*
 * Die Prozedur prï¿½ft, ob der CityModelAspect mit der gegeben ID existiert
 *
 * @param cmaId ID der Planungsalternative
 *
 * @return Anzahl der Planungsalternativen
 *
 */

CREATE OR REPLACE PROCEDURE checkCityModelAspect(
  cmaId IN NUMBER,
  cmaCount OUT NUMBER
)

IS

BEGIN
  -- Abfragen, ob die Planungsalternative existiert
  SELECT COUNT(id) INTO cmaCount
  FROM city_model_aspect
  WHERE id = cmaId;

END;
/