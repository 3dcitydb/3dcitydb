3D City Database - The Open Source CityGML Database

Version 4.0.1

  This software is free software and is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.


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
9. Active Developers
10. Contact
11. Websites
12. Disclaimer


1. License
----------

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this software except in compliance with the License.
You may obtain a copy of the License at
 
    http://www.apache.org/licenses/LICENSE-2.0


2. Copyright
------------

(C) 2013 - 2019
Chair of Geoinformatics
Technical University of Munich, Germany
https://www.gis.bgu.tum.de/


3. About
--------

The 3D City Database is a free 3D geo database to store, represent, and
manage virtual 3D city models on top of a standard spatial relational
database. The database model contains semantically rich, hierarchically
structured, multi-scale urban objects facilitating complex GIS modeling and
analysis tasks, far beyond visualization. In 2012, the 3D City Database
received the Oracle Spatial Excellence Award for Education and Research.

The schema of the 3D City Database
is based on the City Geography Markup Language (CityGML), an international
standard for representing and exchanging virtual 3D city models issued
by the Open Geospatial Consortium (OGC).

The 3D City Database has been realized as Oracle Spatial/Locator and
PostgreSQL/PostGIS database schema, supporting following key features:

    * Full support for CityGML versions 2.0.0 and 1.0.0
    * Complex thematic modelling incl. support for Application Domain
      Extensions (ADE)
    * Five different Levels of Detail (LODs)
    * Appearance information (textures and materials)
    * Digital terrain models (DTMs)
    * Representation of generic and prototypical 3D objects
    * Free, also recursive aggregation of geo objects
    * Flexible 3D geometries (Solid, BRep)
	
The 3D City Database comes as a collection of SQL scripts that allow
for creating and dropping database instances.

The 3D City Database is an open source project and a joint development 
of the cooperation partners:
    * Chair of Geoinformatics, Technische Universität München,
    * virtualcitySYSTEMS GmbH, and 
    * M.O.S.S. Computer Grafik Systeme GmbH. 


4. System requirements
----------------------

* Oracle DBMS >= 10g R2 with Spatial or Locator option
* PostgreSQL DBMS >= 9.3 with PostGIS extension >= 2.0


5. Database setup
-----------------

To create a new database instance of the 3D City Database, simply execute
the "CREATE_DB.bat" batch script under Windows respectively the "CREATE_DB.sh"
shell script under UNIX/Linux/MacOS environments. These scripts are available
for both Oracle and PostgreSQL and can be found in the subfolders "3dcitydb/
oracle/ShellScripts" and "3dcitydb/postgresql/ShellScripts".

The connection details for your database account have to be edited in the
CONNECTION_DETAILS script prior to running the CREATE_DB scripts (or any
other batch/shell script provided in these folders).

The batch/shell script can be executed on double click. For some UNIX/Linux
distributions, you will have to run the script from within a shell environment.
Please open your favorite shell and first check whether execution rights are
correctly set for the script.

To make the script executable for the owner of the file, enter the following:

    chmod u+x CREATE_DB.sh

Afterwards, simply run the script by the following command:

    ./CREATE_DB.sh

The setup procedure requires the following mandatory user inputs:
1) Spatial Reference System ID (SRID) to be used for all geometry objects,
2) EPSG code of the height system (optional),
3) String encoding of the SRS used for the gml:srsName attribute.

For Oracle, two additional inputs are required:
4) Decision whether the database instance should be versioning enabled,
5) Whether the Oracle DBMS runs with Locator or Spatial license option.

Afterwards, the script will start the setup procedure and invoke additional
SQL scripts in the background. Please refer to the PDF documentation of the
3D City Database for a comprehensive step-by-step guide.


6. Database deletion
--------------------

To drop an existing database instance of the 3D City Database, simply execute
the batch/shell script "DROP_DB" for your database (Oracle or PostgreSQL) and
operating system. Make sure that you have entered the correct connection
details in the script CONNECTION_DETAILS beforehand.


7. Documentation
----------------

A complete and comprehensive documentation on the 3D City Database is provided
in the distribution package and can be downloaded from the project's website at
https://www.3dcitydb.org/3dcitydb/documentation/


8. Cooperation partners and supporters  
--------------------------------------

The 3D City Database has been developed by and with the support from
the following cooperation partners:

* Chair of Geoinformatics, Technical University of Munich
  https://www.gis.bgu.tum.de/
* virtualcitySYSTEMS GmbH, Berlin
  http://www.virtualcitysystems.de/
* M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen
  http://www.moss.de/

  
9. Active Developers
--------------------

Claus Nagel <cnagel@virtualcitysystems.de>
Zhihang Yao <zyao@virtualcitysystems.de>
Felix Kunde <felix-kunde@gmx.de>
György Hudra <ghudra@moss.de>
Thomas H. Kolbe <thomas.kolbe@tum.de>

Version 4.0 is based on earlier versions of the 3D City Database.
Please refer to the 3D City Database documentation for the list of
all contributors to previous versions.


10. Contact
-----------

thomas.kolbe@tum.de
cnagel@virtualcitysystems.de
hschulz@moss.de


11. Websites
------------

Official 3D City Database website: 
http://www.3dcitydb.org/

Related websites:
https://github.com/3dcitydb/
http://www.gis.bgu.tum.de/
http://www.citygml.org/
http://www.citygmlwiki.org/
http://www.opengeospatial.org/standards/citygml


12. Disclaimer
--------------

THIS SOFTWARE IS PROVIDED BY THE CHAIR OF GEOINFORMATION FROM TU MUNICH
(TUMGI) "AS IS" AND "WITH ALL FAULTS." 
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