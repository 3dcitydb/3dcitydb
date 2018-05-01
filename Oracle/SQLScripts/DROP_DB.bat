@echo off
:: Shell script to drop an instance of the 3D City Database
:: on Oracle Spatial/Locator

:: Provide your database details here -----------------------------------------
set SQLPLUSBIN=path_to_sqlplus
set HOST=your_host_address
set PORT=1521
set SID=your_SID_or_database_name
set USERNAME=your_username
::-----------------------------------------------------------------------------

:: add sqlplus to PATH
set PATH=%PATH%;%SQLPLUSBIN%

:: cd to path of the shell script
cd /d %~dp0

:: Prompt for DBVERSION -------------------------------------------------------
:dbversion
set var=
echo.
echo Which database license are you using? (Oracle Spatial(S)/Oracle Locator(L)): Press ENTER to use default.
set /p var="(default DBVERSION=Oracle Spatial(S)): "

IF /i NOT "%var%"=="" (
  set DBVERSION=%var%
) else (
  set DBVERSION=S
)

set res=f
IF /i "%DBVERSION%"=="s" (set res=t)
IF /i "%DBVERSION%"=="l" (set res=t)
IF "%res%"=="f" (
  echo Illegal input! Enter S or L.
  GOTO:dbversion
)

:: Run DROP_DB.sql to drop the 3D City Database instance ----------------------
sqlplus "%USERNAME%@\"%HOST%:%PORT%/%SID%\"" @DROP_DB.sql "%DBVERSION%"
