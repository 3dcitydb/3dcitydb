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
set PATH=%SQLPLUSBIN%;%PATH%
:: cd to path of the shell script
cd /d %~dp0

:: Interactive mode or usage with arguments? ----------------------------------
if NOT [%1]==[] (
  GOTO:args
)

:: INTERACTIVE MODE -----------------------------------------------------------
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
GOTO:EOF

:: Correct number of args supplied? -------------------------------------------
:args
set argC=0
for %%x in (%*) do Set /A argC+=1

if NOT %argC% EQU 6 (
  echo ERROR: Invalid number of arguments. 1>&2
  call :usage
  GOTO:EOF
)

:: Parse args -----------------------------------------------------------------
:: %1 = HOST
:: %2 = PORT
:: %3 = SID
:: %4 = USERNAME
:: %5 = PASSWORD
:: %6 = DBVERSION

set HOST=%1
set PORT=%2
set SID=%3
set USERNAME=%4
set PASSWORD=%5
set DBVERSION=%6

:: Run CREATE_DB.sql to create the 3D City Database instance ------------------
sqlplus "%USERNAME%/\"%PASSWORD%\"@\"%HOST%:%PORT%/%SID%\"" @DROP_DB.sql "%DBVERSION%"
GOTO:EOF

:: Print usage information ----------------------------------------------------
:usage
echo. 1<&2
echo Usage: %~n0%~x0 HOST PORT SID USERNAME PASSWORD DBVERSION 1>&2
echo No args can be ommitted and the order is mandatory. 1>&2
echo. 1>&2
echo HOST          Database host 1>&2
echo PORT          Database port 1>&2
echo SID           Database sid 1>&2
echo USERNAME      Database username 1>&2
echo PASSWORD      Database password 1>&2
echo DBVERSION     Database license type, Oracle (S)patial or Oracle (L)ocator (S/L) 1>&2
echo. 1>&2
GOTO:EOF
