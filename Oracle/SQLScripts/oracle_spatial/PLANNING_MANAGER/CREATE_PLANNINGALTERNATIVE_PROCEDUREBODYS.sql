-- CREATE_PLANNINGALTERNATIVE_PROCEDUREBODYS.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Gerhard König <gerhard.koenig@tu-berlin.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Alexandra Stadler <stadler@igg.tu-berlin.de>
--
--	     		Prof. Dr. Lutz Pluemer <pluemer@ikg.uni-bonn.de>
--              Dr. Gerhard Groeger <groeger@ikg.uni-bonn.de>
--              Joerg Schmittwilken <schmittwilken@ikg.uni-bonn.de>
--              Viktor Stroh <stroh@ikg.uni-bonn.de>
--
-- Copyright:   (c) 2007-2008  Institute for Geodesy and Geoinformation Science,
--                             Technische Universit�t Berlin, Germany
--                             http://www.igg.tu-berlin.de
--  		(c) 2004-2006, Institute for Cartography and Geoinformation,
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
-- Prozeduren zum Umgang mit Planungsalternativen
--
--   + AddPlanningAlternativeBdy
--   + UpdatePlanningAlternativeBdy
--   + DiscardPlanningAlternativeBdy
--   + GetDiffBdy
--   + GetAllDiffBdy
--   + GetConflictsBdy
--   + GetAllConflictsBdy
--   + RefreshPlanningAlternativeBdy
--   + GetRefreshDateBdy
--   + DelAllPlanningAlternativesBdy
--   + DelTermPlanningAlternativesBdy
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 0.7.5     2006-04-03   release version                             LPlu
--                                                                    TKol
--                                                                    GGro
--                                                                    JSch
--                                                                    VStr
--


/* 1
 * Die Prozedur legt einen Datensatz in der Tabelle PLANNING_ALTERNATIVE an
 * und erzeugt einen Workspace. Der Workspacename setzt sich aus der Kennung
 * 'PA', dem Benutzernamen,der ID der Planung und der ID der Planungsalternative
 * zusammen (PID_PAID) und wird aus dem Workspace LIVE abgeleitet.
 * Workspacenamen d�rfen max. 30 Zeichen lang sein. Ist der Benutzername l�nger als
 * 15 Zeichen, so werden die ersten zehn und die letzten f�nf Zeichen des Namens
 * verwendet. So bleibt im Workspacenamen jeweils f�nf Zeichen f�r PlanungsId und
 * ID der Planungsalternative, was 99.999 Planungen und ebenso vielen Alternativen
 * entspricht.
 * Die Prozedur wird nur ausgef�hrt, wenn die angegebene Planung noch aktiv ist.
 *
 * @param planningId Name der Planung, der eine Alternative hinzugef�gt werden
 *        soll
 * @param title Kurzbezeichnung der anzulegenden Alternative
 * @param description Kurze Beschreibung der anzulegenden Alternative
 * @param generator Name desjenigen, der die Alternative anlegt hat
 * @param planner Name des Autors dieser Alternative (Planer)
 * @param fatherWorkspaceName Name des Workspace, aus dem der Workspace der
 *        Alternative abgeleitet werden soll
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return Workspacename der Planungsalternative oder Fehlermeldung
 */



CREATE OR REPLACE PROCEDURE AddPlanningAlternativeBdy(
  planningId NUMBER,
  title VARCHAR2,
  description VARCHAR2,
  generator VARCHAR2,
  planner VARCHAR2,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  sequenceGeneratedId NUMBER;
  planningCount NUMBER;
  planningStatus NUMBER;
  userName VARCHAR2(30);
  workspaceName VARCHAR2(30);
  planningCountException EXCEPTION;
  planningStatusException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planung
  checkPlanning(planningId, planningCount, planningStatus);

  IF planningCount = 1 THEN   -- Planung existiert
    IF planningStatus = 1 THEN  -- Planung noch aktiv

      -- den n�chsten Z�hler der Sequenz abholen
      SELECT planning_alternative_seq.nextval INTO sequenceGeneratedId
      FROM dual;

      -- den Benutzernamen dieser Session abfragen
      SELECT user INTO userName
      FROM dual;

      -- den Benutzernamen auf 15 Zeichen begrenzen
      IF LENGTH(userName) > 15 THEN
      	userName := SUBSTR(userName, 1, 9) || SUBSTR(userName, LENGTH(userName) - 5, LENGTH(userName));
      END IF;

      -- Workspacename festlegen
      workspaceName := 'PA_' || userName || '_' || TO_CHAR(planningId) || '_' || TO_CHAR(sequenceGeneratedId);

      -- Tupel einf�gen
      INSERT INTO planning_alternative
      VALUES(
        sequenceGeneratedId,
        planningId,
        title,
        description,
        generator,
        planner,
        workspaceName,
        CURRENT_TIMESTAMP,
        null
      );

      -- Workspace anlegen und Savepoint 'refreshed' erzeugen
      DBMS_WM.GoToWorkspace('LIVE');
      DBMS_WM.CreateWorkspace(workspaceName);
      DBMS_WM.CreateSavepoint(workspaceName, 'refreshed');

      COMMIT;
      setOutParameter(1, workspaceName, outStatus, outMessage);

    ELSE   -- Planung bereits beendet
      RAISE planningStatusException;
    END IF;

  ELSE   -- Planung existiert nicht
    RAISE planningCountException;
  END IF;


EXCEPTION
  WHEN planningCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planung existiert nicht', outStatus, outMessage);
  WHEN planningStatusException THEN
    setOutParameter(0, '3D-Geo-DB: Planung ist bereits beendet', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/








/* 2
 * Die Prozedur �ndert die Parameter Titel, Beschreibung,
 * Datenbankerzeuger und Planer einer aktiven Planungsalternative.
 * Alle existierenden Eintr�ge werden �berschrieben.
 *
 * @param id ID der Planungsalternative
 * @param title Kurzbezeichnung Planung
 * @param description Kurze Beschreibung der Planung
 * @param generator derjenige, der den Datensatz in die DB einf�gt
 * @param planner Planer
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return null oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE UpdatePlanningAlternativeBdy(
  planningAlternativeId NUMBER,
  newTitle VARCHAR2,
  newDescription VARCHAR2,
  newGenerator VARCHAR2,
  newPlanner VARCHAR2,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  paCount NUMBER;
  paStatus NUMBER;
  paCountException EXCEPTION;
  paStatusException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planung
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);

  IF paCount = 1 THEN   -- Planungsalternative existiert
    IF paStatus = 1 THEN  -- Planungsalternative noch aktiv
      -- �ndern eines bestehenden Tupels
      UPDATE planning_alternative
      SET
        title = newTitle,
        description = newDescription,
        generator = newGenerator,
        planner = newPlanner
      WHERE id = planningAlternativeId;

      COMMIT;
      setOutParameter(1, NULL, outStatus, outMessage);

    ELSE   -- Planungsalternative bereits beendet
      RAISE paStatusException;
    END IF;

  ELSE   -- Planungsalternative existiert nicht
    RAISE paCountException;
  END IF;


EXCEPTION
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN paStatusException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative ist bereits beendet', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/






/* 3
 * Die Prozedur beendet einen Datensatz in der Tabelle PLANNING_ALTERNATIVE
 * indem ein Terminierungsdatum gesetzt wird.
 * Der zugeh�rige Workspace wird nicht gel�scht. Es wird lediglich ein Savepoint
 * mit dem Namen "terminated" gesetzt.
 * Die Prozedur wird nur ausgef�hrt, wenn die Planung noch nicht beendet wurde.
 *
 * @param planningAlternativeId ID der zu beendenden Planungsalternative
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return null oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE DiscardPlanningAlternativeBdy(
  planningAlternativeId NUMBER,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  workspacename VARCHAR2(30);
  paCount NUMBER;
  paStatus NUMBER;
  paCountException EXCEPTION;
  paStatusException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planung
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);

  IF paCount = 1 THEN   -- Planungsalternative existiert
    IF paStatus = 1 THEN  -- Planungsalternative noch aktiv
	    -- Workspacenamen abfragen
	    SELECT workspace_name INTO workspacename
	    FROM planning_alternative
	    WHERE id = planningAlternativeId;

	    -- Terminierungsdatum setzen
	    UPDATE planning_alternative
	    SET termination_date = CURRENT_TIMESTAMP
	    WHERE id = PlanningAlternativeID;

	    -- Savepoint im Workspace setzen
	    DBMS_WM.CreateSavepoint(workspacename, 'terminated');

		  COMMIT;
		  setOutParameter(1, NULL, outStatus, outMessage);

    ELSE   -- Planungsalternative bereits beendet
      RAISE paStatusException;
    END IF;

  ELSE   -- Planungsalternative existiert nicht
    RAISE paCountException;
  END IF;


EXCEPTION
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN paStatusException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative ist bereits beendet', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/





/* 4 warn
 * TODO: �bergabe der PlanungsalternativenID oder des Workspacenamen?
 *
 * Die Prozedur gibt die Gesamtzahl der Tupel zur�ck, die im Workspace LIVE
 * und dem angegebenen Workspace in unterschiedlichen Versionen vorliegen.
 * Zur Berechnung wird die Summe der Differenzen �ber alle versionierten
 * Tabellen (z.B. BUILDINGS, CITYOBJECT usw.) gebildet.
 * Diese Zahl ist einerseits ein Indikator f�r den Umfang der in der
 * Planungsalternativen durchgef�hrten �nderungen am 3D-Stadtmodell.
 * Andererseits gibt er Aufschluss �ber die Komplexit�t der �bernahme einer
 * Planungsalternative in den LIVE Workspace.
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return Anzahl der Differenzen oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE GetDiffBdy(
  planningAlternativeId VARCHAR2,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  ws VARCHAR2(30);
  diff INTEGER;
  c INTEGER;
  paCount NUMBER;
  paStatus NUMBER;
  paCountException EXCEPTION;
  paStatusException EXCEPTION;

  cursor versioned_tables_cur is
    select table_name from user_wm_versioned_tables;

BEGIN
  -- Abfragen der Existenz und des Status der Planung
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);

  IF paCount = 1 THEN   -- Planungsalternative existiert
    IF paStatus = 1 THEN  -- Planungsalternative noch aktiv
    	-- Workspacenamen abfragen
    	SELECT workspace_name INTO ws
    	FROM planning_alternative
    	WHERE id = planningAlternativeId;

	    -- Differenzen zu LIVE auswerten lassen
	    dbms_wm.SetDiffVersions('LIVE', ws);

      -- Differenzen z�hlen 
      for versioned_tables_rec in versioned_tables_cur loop
        execute immediate 'SELECT (COUNT(WM_CODE) / 3) FROM ' || versioned_tables_rec.table_name || '_DIFF' into c;
        diff := diff + c;
      end loop;
    
	    setOutParameter(1, TO_CHAR(diff), outStatus, outMessage);

    ELSE   -- Planungsalternative bereits beendet
      RAISE paStatusException;
    END IF;

  ELSE   -- Planungsalternative existiert nicht
    RAISE paCountException;
  END IF;


EXCEPTION
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN paStatusException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative ist bereits beendet', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/




/* 5 warn
 * �hnlich der Prozedur GetDiff (s.o.) wird die Summe der Differenzen
 * zwischen LIVE und allen Workspaces der nicht beendeten Planungsalternativen
 * zur�ckgegeben.
 *
 * @return Summe der Differenzen oder "0 + Fehlercode" falls beim Ausf�hren der
 *         Prozedur Fehler auftreten
 */

CREATE OR REPLACE PROCEDURE GetAllDiffBdy(
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  planningAlternativeId VARCHAR2(30);
  status NUMBER;
  message VARCHAR(256);
  diff NUMBER;
  GetDiffException EXCEPTION;
  CURSOR planningAlternatives IS  -- enth�lt alle Workspacenamen
    SELECT id
    FROM planning_alternative
    WHERE termination_date IS NULL;

BEGIN
  diff := 0;
  -- Cursor durchlaufen und jeweiligen Differenzen abfragen
  OPEN planningAlternatives;
    LOOP
      FETCH planningAlternatives INTO planningAlternativeId;
      EXIT WHEN planningAlternatives%NOTFOUND;

      GetDiffBdy(planningAlternativeId, status, message);

      IF status = 1 THEN
        DBMS_OUTPUT.put_line(planningAlternativeId || ': ' || TO_NUMBER(message));
        diff := diff + TO_NUMBER(message);
      ELSE
        RAISE GetDiffException;
      END IF;

    END LOOP;
  CLOSE planningAlternatives;

  setOutParameter(1, TO_CHAR(diff), outStatus, outMessage);

EXCEPTION
  WHEN GetDiffException THEN
    setOutParameter(0, '3D-Geo-DB: Fehler beim Lesen der Differenzen', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/




/* 6 warn
 * Die Prozedur gibt die Gesamtzahl der Tupel zur�ck, die sowohl im Workspace
 * LIVE, als auch im angegebenen Workspace ge�ndert wurden. Zur Berechnung wird
 * die Summe der Konflikte �ber alle versionierten Tabellen (z.B. BUILDINGS,
 * CITYOBJECT usw.) gebildet.
 * Die Funktion zeigt also an, ob eine �bernahme der Planungsalternative in den
 * LIVE Workspace (Merge) oder ein �Erneuern� des Originaldatenbestandes in
 * einer Planungsalterna-tive (Refresh) m�glich ist. Merge und Refresh k�nnen
 * nur f�r Workspaces durchgef�hrt wer-den, zwischen denen keine Konflikte
 * bestehen.
 *
 * @param workspace Name des Workspaces, dessen Konflikte mit LIVE gez�hlt
 *        werden sollen
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return Anzahl der Konflikte oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE GetConflictsBdy(
  planningAlternativeId NUMBER,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  conf INTEGER;
  ws VARCHAR2(30);
  c INTEGER;
  paCount NUMBER;
  paStatus NUMBER;
  paCountException EXCEPTION;
  paStatusException EXCEPTION;
  
  cursor versioned_tables_cur is
    select table_name from user_wm_versioned_tables;

BEGIN
  -- Abragen der Existenz und des Status der Planung
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);

  IF paCount = 1 THEN   -- Planungsalternative existiert
    IF paStatus = 1 THEN  -- Planungsalternative noch aktiv

    	-- Workspacenamen abfragen
    	SELECT workspace_name INTO ws
    	FROM planning_alternative
    	WHERE id = planningAlternativeId;

      -- Differenzen zu LIVE auswerten lassen
      dbms_wm.SetConflictWorkspace(ws);

      -- Differenzen z�hlen 
      for versioned_tables_rec in versioned_tables_cur loop
        execute immediate 'SELECT (COUNT(WM_DELETED) / 3) FROM ' || versioned_tables_rec.table_name || '_DIFF' into c;
        conf := conf + c;
      end loop;
    
	    setOutParameter(1, TO_CHAR(conf), outStatus, outMessage);

    ELSE   -- Planungsalternative bereits beendet
      RAISE paStatusException;
    END IF;

  ELSE   -- Planungsalternative existiert nicht
    RAISE paCountException;
  END IF;


EXCEPTION
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN paStatusException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative ist bereits beendet', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/




/* 7 warn
 * TODO: Kann die Prozedur entfallen?
 *
 * Die Prozedur gibt die Anzahl der Konflikte zwischen LIVE und allen
 * existierenden Workspaces von Planungsalternativen zur�ck
 */


CREATE OR REPLACE PROCEDURE GetAllConflictsBdy(
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  planningAlternativeId VARCHAR2(30);
  status NUMBER;
  message VARCHAR(256);
  conf NUMBER;
  GetConfException EXCEPTION;
  CURSOR planningAlternatives IS  -- enth�lt alle Workspacenamen
    SELECT id
    FROM planning_alternative
    WHERE termination_date IS NULL;

BEGIN
  conf := 0;
  -- Cursor durchlaufen und jeweiligen Differenzen abfragen
  OPEN planningAlternatives;
    LOOP
      FETCH planningAlternatives INTO planningAlternativeId;
      EXIT WHEN planningAlternatives%NOTFOUND;

      GetConflictsBdy(planningAlternativeId, status, message);

      IF status = 1 THEN
        DBMS_OUTPUT.put_line(planningAlternativeId || ': ' || TO_NUMBER(message));
        conf := conf + TO_NUMBER(message);
      ELSE
        RAISE GetConfException;
      END IF;

    END LOOP;
  CLOSE planningAlternatives;

  setOutParameter(1, TO_CHAR(conf), outStatus, outMessage);

EXCEPTION
  WHEN GetConfException THEN
    setOutParameter(0, '3D-Geo-DB: Fehler beim Lesen der Konflikte', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/








/* 8
 * Die Prozedur aktualisiert die Daten des Workspaces der angegebenen
 * Planungsalternative mit denen des LIVE Workspaces. Dies ist notwendig, wenn
 * sich der Datenbestand in LIVE seit em Anlegen der Planungsalternative
 * ge�ndert hat. Diese ist beispielsweise dann der Fall, wenn eine anderen
 * Planungsalternative in den LIVE Workspace �bernommen wurde. �nde-rungen im
 * LIVE Workspace werden nicht automatisch in alle Kind-Workspaces
 * (Planungsal-ternativen) �bernommen!
 * Der Aufruf dieser Prozedur ist nur dann m�glich, wenn keine Konflikte
 * zwischen dem LIVE Workspace und dem Workspace der angegebenen
 * Planungsalternative existieren. Es werden durch den Aufruf nur die Tupel der
 * versionierten Tabellen ge�ndert, die in LIVE j�nger sind, als im Workspace
 * der Planungsalternative. Die Anzahl dieser Tupel kann mit der Prozedur
 * GetDiff vorab analysiert werden.
 * Vor der Aktualisierung des Workspaces wird ein Savepoint mit dem Namen
 * "refreshed" gesetzt (ggf. �berschrieben), der es erm�glicht, das Datum des
 * letzten Aufrufens der Prozedur zu speichern.
 *
 * @param planningAlternativeId ID der Planungsalternative
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return null oder Fehlermeldung
 */


CREATE OR REPLACE PROCEDURE RefreshPlanningAlternativeBdy(
  planningAlternativeId NUMBER,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  planningAlternativeStatus DATE;
  workspacename VARCHAR2(30);
  isRefreshed INTEGER;
  paCount NUMBER;
  paStatus NUMBER;
  paCountException EXCEPTION;
  paStatusException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planung
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);

  IF paCount = 1 THEN   -- Planungsalternative existiert
    IF paStatus = 1 THEN  -- Planungsalternative noch aktiv

      -- Suchen des Workspace Namen
      SELECT workspace_name INTO workspacename
      FROM planning_alternative
      WHERE id = planningAlternativeId;

      -- Pr�fen ob Savepoint schon existiert
      SELECT count(savepoint) INTO isRefreshed
      FROM all_workspace_savepoints
      WHERE workspace = workspacename AND savepoint LIKE 'refreshed';

      -- Savepoint setzen
      IF isRefreshed > 0 THEN
        DBMS_WM.DeleteSavepoint(workspacename, 'refreshed');
      END IF;

      DBMS_WM.CreateSavepoint(workspacename, 'refreshed');

      -- Ausf�hren des Refresh
      DBMS_WM.RefreshWorkspace(workspacename);

	    setOutParameter(1, NULL, outStatus, outMessage);

    ELSE   -- Planungsalternative bereits beendet
      RAISE paStatusException;
    END IF;

  ELSE   -- Planungsalternative existiert nicht
    RAISE paCountException;
  END IF;


EXCEPTION
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN paStatusException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative ist bereits beendet', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/





/* 9
 * Die Prozedur gibt das Datum der letzten Aktualisierung des Workspaces einer
 * Planungsalternative zur�ck. Wurde die Planungsalternative noch nicht
 * expliziet aktualisiert, so wird das Datum zur�ckgegeben, an dem der Workspace
 * angelegt wurde.
 *
 * @param planningAlternativeID ID der Planungsalternative
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return Refresh-Datum oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE GetRefreshDateBdy(
  planningAlternativeId NUMBER,
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  workspaceName VARCHAR2(30);
  refreshDate DATE;
  paCount NUMBER;
  paStatus NUMBER;
  paCountException EXCEPTION;
  paStatusException EXCEPTION;

BEGIN
  -- Abragen der Existenz und des Status der Planung
  checkPlanningAlternative(planningAlternativeId, paCount, paStatus);

  IF paCount = 1 THEN   -- Planungsalternative existiert
    IF paStatus = 1 THEN  -- Planungsalternative noch aktiv

      -- Name des Workspaces abfragen
      SELECT workspace_name INTO workspaceName
      FROM planning_alternative
      WHERE id = planningAlternativeId;

      -- Refresh-Datum abfragen
      SELECT createtime INTO refreshDate
    	FROM all_workspace_savepoints
    	WHERE savepoint LIKE 'refreshed' AND workspace LIKE workspaceName;

	    setOutParameter(1, TO_CHAR(refreshDate, 'DD.MM.YYYY HH24:MI:SS'), outStatus, outMessage);

    ELSE   -- Planungsalternative bereits beendet
      RAISE paStatusException;
    END IF;

  ELSE   -- Planungsalternative existiert nicht
    RAISE paCountException;
  END IF;

EXCEPTION
  WHEN paCountException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative existiert nicht', outStatus, outMessage);
  WHEN paStatusException THEN
    setOutParameter(0, '3D-Geo-DB: Planungsalternative ist bereits beendet', outStatus, outMessage);
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/





/* 10
 * Die Prozedur l�scht alle in der Tabelle planning_alternative vermerkten
 * Workspaces (Spalte 'workspace_name') und die entsprechenden Tupel in der
 * Tabelle. Es werden somit alle Planungsalternativen und ihre Workspaces
 * gel�scht!
 * Achtung: Dies Prozedur l�scht s�mtliche Daten der Workspaces unwiderrufbar
 * und dient lediglich dem Optimieren der Systemperformance oder dem L�schen des
 * Datenbankschemas!
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return null oder Fehlermeldung
 */


CREATE OR REPLACE PROCEDURE DelAllPlanningAlternativesBdy(
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  planningAlternativeId NUMBER;
  workspacename VARCHAR2(30);
  CURSOR workspaces IS  -- enth�lt alle Workspacenamen
    SELECT workspace_name
    FROM planning_alternative;

BEGIN
  -- Cursor durchlaufen und jeweiligen Workspace l�schen
  OPEN workspaces;
    LOOP
      FETCH workspaces INTO workspacename;
      EXIT WHEN workspaces%NOTFOUND;

      SELECT id INTO planningAlternativeId
      FROM planning_alternative
      WHERE workspace_name LIKE workspacename;

      DBMS_WM.RemoveWorkspace(workspacename);

      DELETE planning_alternative
      WHERE id = planningAlternativeId;

      DBMS_OUTPUT.PUT_LINE(planningAlternativeId || ' gel�scht');

    END LOOP;
  CLOSE workspaces;

  COMMIT;
  setOutParameter(1, NULL, outStatus, outMessage);

EXCEPTION
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/







/* 11
 * Die Prozedur l�scht alle terminierten und in der Tabelle planning_alternative
 * vermerkten Workspaces (Spalte 'workspace_name') und die entsprechenden Tupel
 * in der Tabelle. Es werden somit alle beendeten Planungsalternativen und ihre
 * Workspaces gel�scht!
 * Achtung: Dies Prozedur l�scht s�mtliche Daten der Workspaces unwiderrufbar
 * und dient lediglich dem Optimieren der Systemperformance oder dem L�schen des
 * Datenbankschemas!
 *
 * @return Status der Ausf�hrung: 1 = fehlerfrei, 0 = fehlerhaft
 * @return null oder Fehlermeldung
 */

CREATE OR REPLACE PROCEDURE DelTermPlanningAlternativesBdy(
  outStatus OUT NUMBER,
  outMessage OUT VARCHAR2
)

IS
  -- lokale Variablen
  planningAlternativeId NUMBER;
  workspacename VARCHAR2(30);
  CURSOR workspaces IS  -- enth�lt die Workspacenamen aller beendeten Planungsalternativen
    SELECT workspace_name
    FROM planning_alternative
    WHERE termination_date IS NOT NULL;

BEGIN
  -- Cursor durchlaufen und jeweiligen Workspace l�schen
  OPEN workspaces;
    LOOP
      FETCH workspaces INTO workspacename;
      EXIT WHEN workspaces%NOTFOUND;

      SELECT id INTO planningAlternativeId
      FROM planning_alternative
      WHERE workspace_name LIKE workspacename;

      DBMS_WM.RemoveWorkspace(workspacename);
      DELETE planning_alternative WHERE id = planningAlternativeId;

      DBMS_OUTPUT.PUT_LINE(planningAlternativeId || ' gel�scht');
    END LOOP;
  CLOSE workspaces;

  COMMIT;
  setOutParameter(1, NULL, outStatus, outMessage);

EXCEPTION
  WHEN OTHERS THEN
    setOutParameter(0, sqlerrm, outStatus, outMessage);

END;
/