-- CREATE_CITYMODELASPECT_PROCEDURES.sql
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
-- 1.0       2006-04-03   release version                             LPlu
--                                                                    TKol
--                                                                    GGro
--                                                                    JSch
--                                                                    VStr
--

CREATE OR REPLACE PROCEDURE AddCityModelAspect(
  title VARCHAR2,
  description VARCHAR2,
  generator VARCHAR2,
  planningAlternativeId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  AddCityModelAspectBdy(title, description, generator, planningAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('CityModelAspect angelegt und dem Workspace ' || message || ' zugeordnet');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/




CREATE OR REPLACE PROCEDURE DeleteCityModelAspect(
  cityModelAspectId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  DeleteCityModelAspectBdy(cityModelAspectId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('CityModelAspect gelï¿½scht');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/







CREATE OR REPLACE PROCEDURE AddPAtoCMA(
  cityModelAspectId NUMBER,
  planningAlternativeId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  AddPAtoCMABdy(cityModelAspectId, planningAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Planungsalternative zum CityModelAspect hinzugefï¿½gt');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/








CREATE OR REPLACE PROCEDURE RemovePAfromCMA(
  cityModelAspectId NUMBER,
  planningAlternativeId NUMBER
)

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  RemovePAfromCMABdy(cityModelAspectId, planningAlternativeId, status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Planungsalternative vom CityModelAspect entfernt');
  ELSIF status = 2 THEN
    DBMS_OUTPUT.put_line('Letzte Planungsalternative entfernt und CityModelAspect gelï¿½scht');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/







CREATE OR REPLACE PROCEDURE DeleteAllCityModelAspects

IS
  status NUMBER;
  message VARCHAR2(256);

BEGIN
  DelAllCityModelAspectsBdy(status, message);
  IF status = 1 THEN
    DBMS_OUTPUT.put_line('Alle CityModelAspects gelï¿½scht');
  ELSE
    DBMS_OUTPUT.put_line('Fehler: ' || message);
  END IF;

END;
/