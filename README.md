![Build scripts](https://img.shields.io/github/actions/workflow/status/3dcitydb/3dcitydb/build-3dcitydb-scripts.yml?badge=build&style=flat-square)
![release](https://img.shields.io/github/v/release/3dcitydb/3dcitydb?display_name=tag&style=flat-square)

3D City Database V5
===================

The **3D City Database V5** is a free 3D geo database to store, represent, and manage 
virtual 3D city models on top of a standard spatial relational database. 
The database model contains semantically rich, hierarchically structured, multi-scale 
urban objects facilitating complex GIS modeling and analysis tasks, 
far beyond visualization.

The database schema of the 3D City Database V5 results from a systematic mapping 
of the data model defined in the 
[OGC City Geography Markup Language Conceptual Model (**CityGML Version 3.0**)](https://www.ogc.org/standard/citygml/),
an international standard for representing and exchanging
virtual 3D city models issued by the [Open Geospatial Consortium (OGC)](https://www.ogc.org/). 

Compared to the earlier versions of the 3DCityDB (V4), more generic mapping rules have been
applied resulting in a significant reduction of the number of database tables.
Furthermore, geometry objects are now directly mapped onto corresponding data types 
provided by PostGIS; i.e. Solid, MultiSurface, CompositeSurfaces, TINs, etc. are no longer
split into their individual polygons stored as separate rows as it was done in 3DCityDB V4. 
This makes it much easier to express spatial queries in SQL, faster to evaluate such queries, 
and also to directly connect to the 3DCityDB from geoinformation systems 
like QGIS or ArcGIS and utilize the spatial objects. Overview of the 
[relational schema of 3DCityDB V5](postgresql/db-schema/3dcitydb-schema.pdf).

The 3D City Database has been realized as a PostgreSQL/PostGIS database schema with a collection of pgSQL utility functions, supporting following key features:

 * Full support for CityGML versions 3.0, 2.0 and 1.0
 * Complex thematic modelling including support for Application Domain Extensions (ADE). 
 * Four (CityGML 3.0) or Five (CityGML 2.0 and 1.0) different Levels of Detail (LODs)
 * Appearance information (textures and materials)
 * Digital terrain models (DTMs) represented as TINs
 * Representation of generic and prototypical 3D objects
 * Free, also recursive aggregation of geo objects
 * Flexible 3D geometries (Solid, CompositeSolid, MultiSurface, CompositeSurface, 
   Polygon, TINs, MultiCurve, CompositeCurve, LineString, LinearRing, Point)
 * Stored database functions to delete complex objects including all their nested 
   sub-objects and geometries. As an alternative, objects can only be marked as terminated,
   which leaves them in the database but sets their termination date timestamps accordingly.
   This realizes a simple but powerful historization / versioning mechanism. 
 * Import and export tool available to read and write CityGML datasets of arbitrary file 
   sizes using both GML and CityJSON encoding. 
   The [citydb-tool](https://github.com/3dcitydb/citydb-tool) allows the on-the-fly
   upgrade of CityGML 2.0 / 1.0 datasets during import to CityGML 3.0 and the downgrade 
   of stored CityGML 3.0 datasets in the database to CityGML 2.0 or 1.0 files.

The 3D City Database comes as a collection of SQL scripts that allow for creating and 
dropping database instances. Different versions of automatically generated Docker containers are
available. They allow for an immediate launching of a PostgreSQL/PostGIS database with 
preinstalled 3DCityDB data schema and scripts by a single command.

Who is using the 3D City Database?
----------------------------------

The 3DCityDB V5 has just been released and we expect that most users of the earlier
version (V4) will migrate to the new version sometime in the future. Note, that the 
earlier version V4 is still working, 
[available](https://github.com/3dcitydb/3dcitydb/tree/3dcitydb-v4), and will also still
be supported for some time in the next 1-2 years. However, we recommend to start new projects 
using the new version V5. V4 of the 3D City Database is in use in real life production systems in 
many places around the world such as Berlin, Potsdam, Hamburg, Munich, Frankfurt, Dresden, 
Rotterdam, Vienna, Helsinki, Singapore, Zurich and is also being used in a number of research projects.

The companies [Virtual City Systems](https://vc.systems/) and [M.O.S.S.](https://www.moss.de/), 
who are also partners in development, use the 3D City Database at the core of their 
commercial products and services to create, maintain, visualize, transform, and export 
virtual 3D city models. Furthermore, the state mapping agencies of the federal states in Germany 
store and manage the nation-wide collected 3D city models (including approx. 56 million building models
and bridges) in CityGML LOD1 and LOD2 using the 3D City Database. 

Where to find CityGML data?
---------------------------
An excellent list of Open Data 3D city models, especially also represented using CityGML, 
can be found in the [Awesome CityGML list](https://github.com/OloOcki/awesome-citygml). 
Currently, datasets from 21 countries and 65 regions/cities can be downloaded for free
(with a total of >210 million semantic 3D building models). All of the provided CityGML files 
can be loaded, analyzed, and managed using the 3DCityDB.

License
-------
The 3D City Database is licensed under the 
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
See the `LICENSE` file for more details.

Note that releases of the software before version 3.3.0 continue to be licensed under 
[GNU LGPL 3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html).
To request a previous release of the 3D City Database under Apache License 2.0 
create a GitHub issue.

Latest release
--------------
The latest stable release of the 3D City Database is 5.1.2.

You can download the latest release as well as previous releases from the
[releases section](https://github.com/3dcitydb/3dcitydb/releases).

System requirements
-------------------
Setting up an instance of the 3D City Database requires an existing installation of a PostgreSQL database. Currently, only following database versions are supported:

* PostgreSQL >= 14 with PostGIS >= 3.1

It is recommended that you always install the latest patches, minor releases, and security updates for your
database system. Database versions that have reached end-of-life are no longer supported by the 3D City Database.

Documentation and literature
----------------------------
A complete and comprehensive user manual on the 3D City Database V5 and its tools is
available [online](https://docs.3dcitydb.org/).

An Open Access paper on the 3DCityDB (version 4) has been published in the International
Journal on Open Geospatial Data, Software and Standards 3 (5), 2018: 
[Z. Yao, C. Nagel, F. Kunde, G. Hudra, P. Willkomm, A. Donaubauer, T. Adolphi, T. H. Kolbe: 3DCityDB - a 3D geodatabase solution for the management, analysis, and visualization of semantic 3D city models based on CityGML](https://doi.org/10.1186/s40965-018-0046-7). 
Please use this reference when citing the 3DCityDB project.

Database setup
--------------
To create a new database instance of the 3D City Database, download and unzip the
latest release from the [releases section](https://github.com/3dcitydb/3dcitydb/releases)
or [build](https://github.com/3dcitydb/3dcitydb#building) the database scripts
from source. Afterwards, simply execute the `create-db.bat` batch script
under Windows respectively the `create-db.sh` shell script under UNIX/Linux/MacOS
environments. These scripts are available for PostgreSQL with PostGIS extension
and can be found in the subfolders "3dcitydb/postgresql/shell-scripts/windows"
and "3dcitydb/postgresql/shell-scripts/unix".

The connection details for your database account have to be edited in the
`connection-details` script prior to running the `create-db` script (or any
other shell script provided in these folders).

The shell scripts can usually be executed on double click. For some UNIX/Linux
distributions, you will have to run the script from within a shell environment.
Please open your favorite shell and first check whether execution rights are
correctly set for the script.

To make the script executable for the owner of the file, enter the following:

    chmod u+x create-db.sh

Afterwards, simply run the script by the following command:

    ./create-db.sh

The setup procedure requires the following mandatory user inputs:
1) Spatial Reference System ID (SRID) to be used for all geometry objects,
2) EPSG code of the height system (optional),
3) String encoding of the SRS used for the gml:srsName attribute in CityGML exports.

Afterwards, the script will start the setup procedure and invoke additional
SQL scripts in the background. Please refer to the 
[user manual](https://docs.3dcitydb.org/latest/first-steps/)
of the 3D City Database for a comprehensive step-by-step guide.

Database deletion
-----------------
To drop an existing database instance of the 3D City Database, simply execute
the shell script `drop-db` for your database and operating system. Make sure 
that you have entered the correct connection details in the script 
`connection-details` beforehand.

Using with Docker
-----------------

The 3D City Database is also available as Docker image. You can either build an image for PostgreSQL 
yourself using one of the provided Docker files or use a pre-built PostgreSQL image from Docker Hub at 
[https://hub.docker.com/r/3dcitydb/3dcitydb-pg](https://hub.docker.com/r/3dcitydb/3dcitydb-pg) 
or from Github container registry at 
[https://github.com/orgs/3dcitydb/packages?ecosystem=container](https://github.com/orgs/3dcitydb/packages?ecosystem=container).

A comprehensive documentation on how to use the 3D City Database with Docker can be found in the
[online user manual](https://docs.3dcitydb.org/latest/3dcitydb/docker/).

Building
--------

The 3D City Database uses [Gradle](https://gradle.org/) as build system. To build the
database scripts for setting up and running a database instance from source,
clone the repository to your local machine and run the following command from
the root of the repository.

    > gradlew installDist

The build process runs on all major operating systems and only requires Java 11 or
higher to run.

If the build was successful, you will find the 3D City Database scripts
under `build/install/3dcitydb`.

Contributing
------------
* To file bugs found in the software create a GitHub issue.
* To contribute code for fixing filed issues create a pull request with the issue id.
* To propose a new feature create a GitHub issue and open a discussion.

Cooperation partners and supporters
-----------------------------------
The 3D City Database V5 has been developed by and with the support from the following cooperation partners:

* [Chair of Geoinformatics, Technical University of Munich](https://www.asg.ed.tum.de/gis/)
* [Virtual City Systems, Berlin](https://vc.systems/)
* [M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen](https://www.moss.de/)
* [Zentrum für Geodäsie und Geoinformatik, Hochschule für Technik Stuttgart](https://www.hft-stuttgart.de/p/zhihang-yao)
* [LIST Eco GmbH & Co. KG, Köln-Ehrenfeld](https://www.list-eco.de/)

Further plans
-------------
We are currently working on a couple of things and functionalities, that are intended to be provided in the future:

* Support for the Oracle database management system (sponsors or contributors are welcome!)
* Support for a tool to export visualization data in the form of 3DTiles. For that purpose we are 
  currently customizing the third-party Open Source tool [pg2b3dm](https://github.com/Geodan/pg2b3dm) 
  developed by Bert Temme to directly work on the 3DCityDB V5. The tool will be provided as a customized 
  Docker container, too.
* Inclusion of the recently released 
  [3DCityDB Web Map Client 2.0.0](https://github.com/3dcitydb/3dcitydb-web-map) as part of the 
  new 3DCityDB V5 software package together with the visualization tool mentioned above
* Collaboration with Giorgio Agugiaro from TU Delft on getting the 
  [QGIS plugin for 3DCityDB V4](https://github.com/tudelft3d/3DCityDB-Tools-for-QGIS) upgraded
  to V5. (In fact, Giorgio and his team are already working on this)
* Support for the CityGML 3.0 modules Versioning and Pointcloud in the citydb-tool

More information on CityGML
---------------------------
[OGC CityGML](https://www.ogc.org/standard/citygml/) is an open data model for the 
structuring and representation of semantic 3D city models. The aim of CityGML is to 
provide a common definition of the basic entities, attributes, and relations 
of 3D city models. Such models play a key role in Urban Digital Twins, but also to
facilitate BIM-GIS integration while keeping the structural, spatial, and semantic 
information. The [CityGML conceptual model](https://docs.ogc.org/is/20-010/20-010.html) 
has been mapped onto different data encodings (i.e. data exchange formats). 
The [GML encoding](https://docs.ogc.org/is/21-006r2/21-006r2.html) 
("CityGML files") is a complete mapping of all aspects of the conceptual data model 
of CityGML 3.0 onto XML and guarantees lossless data transfer of any kind of CityGML data. 
[CityJSON](https://www.ogc.org/standards/cityjson/) is a mapping of a
subset of CityGML 3.0 onto a simpler, JSON-based file format. The 3DCityDB can be 
considered a third type of encoding of the CityGML data model - in this case, data 
is encoded within the tables of a spatial relational database schema.

CityGML is an international OGC standard and can be used free of charge.