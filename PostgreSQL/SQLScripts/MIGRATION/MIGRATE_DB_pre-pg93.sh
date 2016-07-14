#!/bin/sh
# 3D City Database - The Open Source CityGML Database
# http://www.3dcitydb.org/
# 
# Copyright 2013 - 2016
# Chair of Geoinformatics
# Technical University of Munich, Germany
# https://www.gis.bgu.tum.de/
# 
# The 3D City Database is jointly developed with the following
# cooperation partners:
# 
# virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
# M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
#     
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Shell script to migrate an instance of the 3D City Database from v2.x to v3.1
# on PostgreSQL/PostGIS < 9.3

# Provide your database details here
export PGPORT=5432
export PGHOST=your_host_address
export PGUSER=your_username
export CITYDB=your_database
export PGBIN=path_to_psql

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Run MIGRATE_DB.sql to migrate the 3D City Database instance from v2.x to v3.1
"$PGBIN/psql" -d "$CITYDB" -f "MIGRATE_DB_pre-pg93.sql"