-- CREATE_CITYMODELASPECT_PROCEDUREBODYS.sql
--
-- Authors:     Prof. Dr. Lutz Pluemer <pluemer@ikg.uni-bonn.de>
--              Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
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
-- Prozeduren zum Umgang mit CityModelAspects
---
---     + AddCityModelAspectBdy
---     + DeleteCityModelAspectBdy
---     + AddPAtoCMABdy
---     + RemovePAfromCMABdy
---     + DelAllCityModelAspectsBdy
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 0.6.4     2006-04-03   release version                             LPlu
--                                                                    TKol
--                                                                    GGro
--                                                                    JSch
--                                                                    VStr
--


/*
 * Die Prozedur erzeugt einen neuen CityModelAspekt, schreibt ein neues Tupel
 * in die entspre-chende Tabelle und erzeugt einen neuen Workspace. Der Name des
 * Workspaces setzt sich aus der Kennung 'CMA', dem Benutzernamen und der ID des
 * CityModelAspect zusammen (CMA_ CMAID).
 * Workspacenamen dï¿½rfen max. 30 Zeichen lang sein. Ist der Benutzername lï¿½nger als
 * 15 Zeichen, so werden die ersten zehn und die letzten fï¿½nf Zeichen des Namens
 * verwendet. Es bleiben im Workspacenamen 10 Zeichen fï¿½r die ID des
 * CityModelAspects.
 * CityModelAspects dienen lediglich der gleichzeitigen Betrachtung mehrerer
 * Planungsalternativen und sind somit temporï¿½rer Natur.
 *
 * @param title Kurzbezeichnung Planung
 * @param description Kurze Beschreibung der Planung
 * @param generator Name desjenigen, der die Alternative anlegt hat
 * @param planningAlternativeId ID der darzustellenden Planungsalternative
 *
 * @return Status der Ausfï¿½hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return Workspacename des CityModelAspects oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE AddCityModelAspectBdy(
  title VARCHAR2,
  description VARCHAR2,
  generator VARCHAR2,
  planningAlternativeId NUMBER,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  sequenceGeneratedId NUMBER;
  planningAlternativeWorkspace VARCHAR2(30);
  paCount NUMBER;
  paStatus NUMBER;
  userName VARCHAR2(30);
  workspaceName VARCHAR2(30);
  paCountException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planungsalternative
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);

  IF paCount = 1 THEN   -- Planungsalternative existiert
    -- Suchen des WorkspaceNamens der darzustellenden Planungsalternative
    SELECT workspace_name INTO planningAlternativeWorkspace
    FROM planning_alternative
    WHERE id = planningAlternativeId;

    -- den nï¿½chsten Zï¿½hler der Sequenz abholen
    SELECT city_model_aspect_seq.nextval INTO sequenceGeneratedId
    FROM dual;

      -- den Benutzernamen dieser Session abfragen
      SELECT user INTO userName
      FROM dual;

      -- den Benutzernamen auf 15 Zeichen begrenzen
      IF LENGTH(userName) > 15 THEN
      	userName := SUBSTR(userName, 1, 9) || SUBSTR(userName, LENGTH(userName) - 5, LENGTH(userName));
      END IF;

      -- Workspacenamen festlegen
      workspaceName := 'CMA_' || userName || '_' || TO_CHAR(sequenceGeneratedId);

    -- Tupel einfï¿½gen
    INSERT INTO city_model_aspect
    VALUES(
      sequenceGeneratedId,
      title,
      description,
      generator,
      workspaceName,
      CURRENT_TIMESTAMP
    );

    -- Eintrag in Zuordnungstabelle
    INSERT INTO city_model_aspect_component
    VALUES (sequenceGeneratedId, planningAlternativeId);

    -- Workspace anlegen
    DBMS_WM.GoToWorkspace(planningAlternativeWorkspace);
    DBMS_WM.CreateWorkspace(workspaceName);

    COMMIT;
    setOutParameter(1, workspaceName, outStatus, outMessage);

  ELSE   -- Planungsalternative existiert nicht
    RAISE paCountException;
  END IF;

EXCEPTION
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/







/*
 * Die Prozedur entfernt einen CityModelAspect. Die Tupel in den entsprechenden
 * Metadatentabellen (CITY_MODEL_ASPECT und CITY_MODEL_ASPECT_COMPONENT) werden
 * ebenso gelï¿½scht, wie der zugeordnete Workspace. Da CityModelApekts als
 * temporï¿½r definierte Sichten konzipiert sind, werden die Daten unwiderrufbar
 * gelï¿½scht.
 *
 * @param cityModelAspectId ID des zu entferndenden CityModelAspekt
 *
 * @return Status der Ausfï¿½hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return null oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE DeleteCityModelAspectBdy(
  cityModelAspectId NUMBER,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  workspaceName VARCHAR2(30);
  cmaCount NUMBER;
  cmaCountException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planung
  checkCityModelAspect(cityModelAspectId, cmaCount);

  IF cmaCount = 1 THEN   --  CityModelAspect existiert

    -- Suchen des Workspacenamen des CityModelAspects
    SELECT workspace_name INTO workspaceName
    FROM city_model_aspect
    WHERE id = cityModelAspectId;

    -- Tupel in der Zuordnungstabelle lï¿½schen
    DELETE city_model_aspect_component
    WHERE city_model_aspect_id = cityModelAspectId;

    -- Tupel in der Tabelle lï¿½schen
    DELETE city_model_aspect
    WHERE id = cityModelAspectId;

    -- Workspace lï¿½schen
    DBMS_WM.GoToWorkspace('LIVE');
    DBMS_WM.RemoveWorkspace(workspaceName);

    COMMIT;
    setOutParameter(1, NULL, outStatus, outMessage);

  ELSE   -- CityModelAspect existiert nicht
    RAISE cmaCountException;
  END IF;

EXCEPTION
  WHEN cmaCountException THEN
    setOutParameter(0, '3D-Geo-DB: CityModelAspect existiert nicht', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/





/*
 * TODO: Bisher ist lediglich ein Eintrag in die Metadaten realisiert!
 *
 * Die Prozedur fï¿½gt eine Planungsalternative zu einem CityModelAspekt hinzu.
 *
 * @param cityModelAspectId ID des CityModelAspekt, das die Alternative anzeigen
 *        soll
 * @param planningAlternativeId ID der anzuzeigenden Alternative
 *
 * @return Status der Ausfï¿½hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return null oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE AddPAtoCMABdy(
  cityModelAspectId NUMBER,
  planningAlternativeId NUMBER,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  planningId NUMBER;
  numb NUMBER;
  cmaCount NUMBER;
  paCount NUMBER;
  paStatus NUMBER;
  planningException EXCEPTION;
  cmaCountException EXCEPTION;
  paCountException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planungsalternative
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);
  -- Abragen der Existenz und des Status der Planung
  checkCityModelAspect(cityModelAspectId, cmaCount);

  IF cmaCount = 1 THEN   --  CityModelAspect existiert
    IF paCount = 1 THEN   -- Planungsalternative existiert

      -- Suchen der zugehï¿½rigen Planung der Planungsalternative
      SELECT planning_id INTO planningId
      FROM planning_alternative
      WHERE id = planningAlternativeId;

      -- Prï¿½fen wieviele Alternativen aus der entsprechenden Planung
      -- dem CityModelAspect bereits zugeordnet sind
      SELECT COUNT(c.planning_alternative_id) INTO numb
      FROM city_model_aspect_component c, planning_alternative p
      WHERE
        c.city_model_aspect_id = cityModelAspectId AND
        c.planning_alternative_id = p.id AND
        p.planning_id = planningId;

      IF numb < 1 THEN   -- noch keine Planungsalternative dieser Planung im CMA
        -- Eintrag in Zuordnungstabelle
        INSERT INTO city_model_aspect_component
        VALUES (cityModelAspectId, planningAlternativeId);

        COMMIT;
        setOutParameter(1, NULL, outStatus, outMessage);

      ELSE   -- es ist bereits eine Planungsalternative dieser Planung zugeordnet
        RAISE planningException;
      END IF;

    ELSE   -- Planungsalternative existiert nicht
      RAISE paCountException;
    END IF;

  ELSE   -- CityModelAspect existiert nicht
    RAISE cmaCountException;
  END IF;


EXCEPTION
  WHEN planningException THEN
    setOutParameter(0, '3D-Geo-DB: CityModelAspect enthï¿½lt bereits eine Planungsalternative dieser Planung', outStatus, outMessage);
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN cmaCountException THEN
    setOutParameter(0, '3D-Geo-DB: CityModelAspect existiert nicht', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/





/*
 * Die Prozedur entfernt eine Planungsalternative aus einem CityModelAspekt.
 *
 * @param cityModelAspectId ID des CityModelAspekt, das die Alternative anzeigt
 * @param planningAlternativeId ID der zu entfernenden Alternative
 *
 * @return Status der Ausfï¿½hrung:
           1 = fehlerfrei,
           2 = CMA gelï¿½scht, da letzte Planungsalternative entfernt wurde,
           0 = fehlerhaft
 * @return null oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE RemovePAfromCMABdy(
  cityModelAspectId NUMBER,
  planningAlternativeId NUMBER,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  cityModelAspectWorkspace VARCHAR2(30);
  status NUMBER;
  message VARCHAR2(256);
  memberCount NUMBER;
  cmaCount NUMBER;
  paCount NUMBER;
  paStatus NUMBER;
  cmaCountException EXCEPTION;
  paCountException EXCEPTION;
  removeLastException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planungsalternative
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);
  -- Abragen der Existenz und des Status der Planung
  checkCityModelAspect(cityModelAspectId, cmaCount);

  IF cmaCount = 1 THEN   --  CityModelAspect existiert
    IF paCount = 1 THEN   -- Planungsalternative existiert

      -- Zï¿½hlen der Planungsalternativen des CityModelAspects
      SELECT COUNT(city_model_aspect_id) INTO memberCount
      FROM city_model_aspect_component
      WHERE city_model_aspect_id = cityModelAspectId;

      IF memberCount > 1 THEN   -- es bleibt mind. eine Planungsalternative
        -- Lï¿½schen des entsprechenden Tupels der Verknï¿½pfungstabelle
        DELETE city_model_aspect_component
        WHERE city_model_aspect_id = cityModelAspectId AND planning_alternative_id = planningAlternativeId;

        COMMIT;
        setOutParameter(1, NULL, outStatus, outMessage);

      ELSE   -- die letzte Planungsalternative soll entfernt werden => CMA lï¿½schen
        DeleteCityModelAspectBdy(cityModelAspectId, status, message);
        IF status = 1 THEN   -- fehlerfrei gelï¿½scht
          COMMIT;
          setOutParameter(2, NULL, outStatus, outMessage);
        ELSE   -- Fehler beim Lï¿½schen
          setOutParameter(0, message, outStatus, outMessage);
        END IF;

      END IF;

    ELSE   -- Planungsalternative existiert nicht
      RAISE paCountException;
    END IF;

  ELSE   -- CityModelAspect existiert nicht
    RAISE cmaCountException;
  END IF;


EXCEPTION
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN cmaCountException THEN
    setOutParameter(0, '3D-Geo-DB: CityModelAspect existiert nicht', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/





/*
 * Die Prozedur lï¿½scht alle in der Tabelle city_model_aspect
 * vermerkten Workspaces (Spalte 'workspace_name') und die Metadaten der Tabelle
 * city_model_aspect_component
 *
 * @return Status der Ausfï¿½hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return null oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE DelAllCityModelAspectsBdy(
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  workspacename VARCHAR2(30);
  cmaId NUMBER;
  CURSOR workspaces IS -- enthï¿½lt alle Workspacenamen
  SELECT workspace_name
  FROM city_model_aspect;

BEGIN
  -- Cursor durchlaufen und jeweiligen Workspace lï¿½schen
  OPEN workspaces;
    LOOP
      FETCH workspaces INTO workspacename;
      EXIT WHEN workspaces%NOTFOUND;

      -- ID des CityModelAspects abfragen
      SELECT id INTO cmaId
      FROM city_model_aspect
      WHERE workspace_name LIKE workspacename ;

      -- Workspace lï¿½schen
      DBMS_WM.RemoveWorkspace(workspacename);

      -- Tupel lï¿½schen
      DELETE city_model_aspect_component
      WHERE city_model_aspect_id = cmaId;

      DELETE city_model_aspect
      WHERE id = cmaId;

      DBMS_OUTPUT.PUT_LINE(cmaId || ' gelï¿½scht');
    END LOOP;
  CLOSE workspaces;

  COMMIT;
  setOutParameter(1, NULL, outStatus, outMessage);

EXCEPTION
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/