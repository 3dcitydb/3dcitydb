-- CHECK_SRID.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2012, Institute for Geodesy and Geoinformation Science,
--                             Technische Universitaet Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Checks if the chosen SRID exists in the PostGIS database.  
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description     | Author
-- 1.0.0     2013-02-22   PostGIS version   FKun

CREATE OR REPLACE FUNCTION check_srid(srid INTEGER DEFAULT 0) RETURNS VARCHAR AS
$$
DECLARE
  dbsrid INTEGER;
  validation VARCHAR := 'SRID ok';
BEGIN
  EXECUTE 'SELECT srid FROM spatial_ref_sys WHERE srid = $1' INTO dbsrid USING srid;

  IF dbsrid <> 0 THEN
    BEGIN
      PERFORM ST_Transform(ST_GeomFromEWKT('SRID='||dbsrid||';POINT(1 1 1)'),4326);

	  RETURN validation;

      EXCEPTION
        WHEN others THEN
          RAISE EXCEPTION 'The chosen SRID % was not appropriate for PostGIS functions.', srid;

    END;
  ELSE
    RAISE EXCEPTION 'Table spatial_ref_sys does not contain the SRID %. Insert commands for missing SRIDs can be found at spatialreference.org', srid;
  END IF;
END;
$$
LANGUAGE plpgsql;