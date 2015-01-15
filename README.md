3dcitydb
========

3D City Database version 3.0.0

The 3D City Database version 3.0.0 is free software and comes 
WITHOUT ANY WARRANTY. See the DISCLAIMER at the end 
of this document for more details. 


0. Index
--------

1. License
2. Copyright
3. About
4. System requirements
5. Database setup
6. Database deletion
7. Documentation
8. Cooperation partners and supporters
9. Developers
10. Contact
11. Websites
12. Disclaimer


1. License
----------

The 3D City Database version 3.0.0 is free software under the GNU Lesser 
General Public License Version 3.0. See the file LICENSE for more details. 
For a copy of the GNU Lesser General Public License see the files 
COPYING and COPYING.LESSER or visit http://www.gnu.org/licenses/.


2. Copyright
------------

(c) 2012-2014  
Chair of Geoinformatics (TUMGI)
Technische Universität München, Germany
http://www.gis.bv.tum.de

(c) 2007-2012  
Institute for Geodesy and Geoinformation Science (IGG)
Technische Universität Berlin, Germany
http://www.igg.tu-berlin.de

3. About
--------

The 3D City Database is a free 3D geo database to store, represent, and
manage virtual 3D city models on top of a standard spatial relational
database. The database model contains semantically rich, hierarchically
structured, multi-scale urban objects facilitating complex GIS modeling and
analysis tasks, far beyond visualization. The schema of the 3D City Database
is based on the City Geography Markup Language (CityGML), an international
standard for representing and exchanging virtual 3D city models issued
by the Open Geospatial Consortium (OGC).

The 3D City Database has been realized as an Oracle 10G R2 Spatial relational
database schema (or higher), supporting following key features:

    * Complex thematic modelling
    * Five different Levels of Detail (LODs)
    * Appearance data
    * Digital terrain models (DTMs)
    * Representation of generic and prototypical 3D objects
    * Free, also recursive aggregation of geo objects
    * Flexible 3D geometries
    * Version and history management

The 3D City Database is shipped as a collection of SQL scripts which allow
for creating and dropping database instances.

The 3D City Database Version 3.0.0 was developed in collaboration of the Chair of 
Geoinformatics, Technische Universität München (TUMGI), virtualcitySYSTEMS GmbH, and 
M.O.S.S. Computer Grafik Systeme GmbH. The previous version of the the 3D City Database 
was implemented on behalf of the Berliner Senatsverwaltung für Wirtschaft, Arbeit und
Frauen and the Berlin Partner GmbH. The development is continuing the work of the Institute 
for Geodesy and Geoinformation Science (IGG), TU Berlin, and the Institute for Cartography and 
Geoinformation (IKG), University of Bonn. Please find the previous versions of the database 
at http://www.3dcitydb.net/.


4. System requirements
----------------------

* Oracle Spatial 10g R2, 11g, 12c
* PostgreSQL 9.1+ with PostGIS 2.0+


5. Database setup
-----------------

To create a new database instance of the 3D City Database call the SQL script 
"CREATE_DB.sql" which can be found in the top-level SQL folder of the 
distribution package. This script will start the setup procedure and invoke 
further scripts in the background.

The setup procedure requires three mandatory user inputs:
1) Spatial Reference Identifier for newly created geometry objects (SRID),
2) corresponding GML conformant URN encoding for gml:srsName attributes, and
3) decision whether the database instance should be versioning enabled.


6. Database deletion
--------------------

To drop an existing database instance of the 3D City Database call the SQL script
"DROP_DB.sql" which can be found in the top-level SQL folder of the 
distribution package.


7. Documentation
----------------

A comprehensive documentation on the 3D City Database can be found
on the project's website at http://www.3dcitydb.net/3dcitydb/documentation/ 


8. Cooperation partners and supporters  
--------------------------------------

The development of the 3D City Database version 3.0.0 has been 
supported by the following cooperation partners:

* Chair of Geoinformatics
  Technische Universität München, Germany
  http://www.gis.bv.tum.de
* virtualcitySYSTEMS GmbH, Berlin
  http://www.virtualcitysystems.de/  
* M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen
  http://www.moss.de/  

  
9. Developers
-------------

Claus Nagel <cnagel@virtualcitysystems.de>
Felix Kunde <fkunde@virtualcitysystems.de>
Zhihang Yao <zhihang.yao@tum.de>
Thomas H. Kolbe <thomas.kolbe@tum.de>
György Hudra <ghudra@moss.de>
Arda Müftüoglu <amueftueoglu@moss.de>
Javier Herreruela <javier.herreruela@tu-berlin.de>
Alexandra Lorenz <alexandra.lorenz@tu-berlin.de>
Gerhard König <gerhard.koenig@tu-berlin.de>


10. Contact
----------

thomas.kolbe@tum.de
cnagel@virtualcitysystems.de
pwillkomm@moss.de


11. Websites
------------

Official 3D City Database website: 
http://www.3dcitydb.net/

Related websites:
https://github.com/3dcitydb/
http://www.gis.bv.tum.de/
http://www.citygml.org/
http://www.citygmlwiki.org/
http://www.opengeospatial.org/standards/citygml


12. Disclaimer
--------------

THIS SOFTWARE IS PROVIDED BY TUMGI "AS IS" AND "WITH ALL FAULTS." 
TUMGI MAKES NO REPRESENTATIONS OR WARRANTIES OF ANY KIND CONCERNING THE 
QUALITY, SAFETY OR SUITABILITY OF THE SOFTWARE, EITHER EXPRESSED OR 
IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.

TUMGI MAKES NO REPRESENTATIONS OR WARRANTIES AS TO THE TRUTH, ACCURACY OR 
COMPLETENESS OF ANY STATEMENTS, INFORMATION OR MATERIALS CONCERNING THE 
SOFTWARE THAT IS CONTAINED ON AND WITHIN ANY OF THE WEBSITES OWNED AND 
OPERATED BY TUMGI.

IN NO EVENT WILL TUMGI BE LIABLE FOR ANY INDIRECT, PUNITIVE, SPECIAL, 
INCIDENTAL OR CONSEQUENTIAL DAMAGES HOWEVER THEY MAY ARISE AND EVEN IF 
TUMGI HAVE BEEN PREVIOUSLY ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

