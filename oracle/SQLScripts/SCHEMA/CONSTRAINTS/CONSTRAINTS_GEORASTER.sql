-- 3D City Database - The Open Source CityGML Database
-- https://www.3dcitydb.org/
--
-- Copyright 2013 - 2021
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.lrg.tum.de/gis/
--
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
--
-- Virtual City Systems, Berlin <https://vc.systems/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

@@CONSTRAINTS.sql

ALTER TABLE RASTER_RELIEF
ADD CONSTRAINT RASTER_RELIEF_OBJCLASS_FK FOREIGN KEY
(
  OBJECTCLASS_ID
)
REFERENCES OBJECTCLASS
(
  ID
)
ENABLE;
    
ALTER TABLE RASTER_RELIEF
ADD CONSTRAINT RASTER_RELIEF_COMP_FK FOREIGN KEY
(
  ID
)
REFERENCES RELIEF_COMPONENT
(
  ID
)
ENABLE;  

ALTER TABLE RASTER_RELIEF
ADD CONSTRAINT RASTER_RELIEF_COVERAGE_FK FOREIGN KEY
(
  COVERAGE_ID 
)
REFERENCES GRID_COVERAGE
(
  ID 
)
ENABLE;
