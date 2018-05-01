@echo off
:: Shell script to create an instance of the 3D City Database
:: on Oracle Spatial/Locator

:: Provide your database details here -----------------------------------------
set PORT=1521
set HOST=your_host_address
set USERNAME=your_username
set SID=your_SID_or_database_name
set SQLPLUSBIN=path_to_sqlplus
set SRSNO=
set GMLSRSNAME=
:: Database versioning (yes/no)
set VERSIONING=no 
:: DB Version (S/L) for Oracle Spatial or Oracle Locator
set DBVERSION=S
::-----------------------------------------------------------------------------

:: add sqlplus to PATH
set PATH=%PATH%;%SQLPLUSBIN%
:: cd to path of the shell script
cd /d %~dp0

:: Run CREATE_DB.sql to create the 3D City Database instance
sqlplus "%USERNAME%@\"%HOST%:%PORT%/%SID%\"" @CREATE_DB.sql "%SRSNO%" "%GMLSRSNAME%" "%VERSIONING%" "%DBVERSION%"
