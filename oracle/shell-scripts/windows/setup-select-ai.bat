@echo off
:: Shell script to set up Oracle Select AI for the 3D City Database
:: on Oracle Database 23ai or higher

:: Get the current directory path of this script file
set CURRENT_DIR=%~dp0
cd "%CURRENT_DIR%/../../sql-scripts"

:: Read database connection details
if NOT [%1]==[] (
  call %1
) else (
  if exist connection-details.bat (
    call connection-details.bat
  ) else (
    call "%CURRENT_DIR%connection-details.bat"
  )
)

:: Set database client
if "%ORACLE_CLIENT%"=="" (
  set "ORACLE_CLIENT=sqlplus"
) else (
  if exist "%ORACLE_CLIENT%\" (
    set "ORACLE_CLIENT=%ORACLE_CLIENT%\sqlplus"
  )
)

:: Welcome message
echo  _______   ___ _ _        ___  ___
echo ^|__ /   \ / __(_) ^|_ _  _^|   ^\^| _ )
echo  ^|_ \ ^|) ^| (__^| ^|  _^| ^|^| ^| ^|) ^| _ \
echo ^|___/___/ \___^|_^|\__^|\_, ^|___/^|___/
echo                      ^|__/
echo.
echo 3D City Database - Oracle Select AI Setup
echo.
echo ######################################################################################
echo.
echo This script sets up Oracle Select AI for the 3DCityDB. It requires:
echo   - Oracle Database 23ai or higher with DBMS_CLOUD_AI pre-installed
echo   - SYS (SYSDBA) access for network ACL and privilege configuration
echo   - A Google API key for the AI profile (free at https://aistudio.google.com)
echo.
echo Documentation and help:
echo    3DCityDB website:    https://www.3dcitydb.org
echo    3DCityDB on GitHub:  https://github.com/3dcitydb
echo.
echo ######################################################################################

:: Prompt for SYS password -------------------------------------------------------
echo.
set "SYS_PWD="
set /p SYS_PWD="Please enter the SYS password: "

if "%SYS_PWD%"=="" (
  echo ERROR: SYS password is required.
  goto error
)

:: Check DBMS_CLOUD_AI availability -----------------------------------------------
echo.
echo Checking DBMS_CLOUD_AI availability ...

set "TMPCHECK=%TEMP%\3dcitydb_check_%RANDOM%.sql"
set "TMPOUT=%TEMP%\3dcitydb_out_%RANDOM%.txt"

> "%TMPCHECK%" (
  echo SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
  echo SELECT COUNT^(^*^) FROM dba_objects WHERE object_name = 'DBMS_CLOUD_AI' AND object_type = 'PACKAGE';
  echo EXIT
)

"%ORACLE_CLIENT%" -S -L "sys/%SYS_PWD%@%DB_HOST%:%DB_PORT%/%ORACLE_PDB% as sysdba" @"%TMPCHECK%" > "%TMPOUT%"
set /p CLOUD_AI_CHECK=<"%TMPOUT%"
del "%TMPCHECK%" 2>nul
del "%TMPOUT%" 2>nul

:: Trim spaces
for /f "tokens=*" %%a in ("%CLOUD_AI_CHECK%") do set "CLOUD_AI_CHECK=%%a"

if not "%CLOUD_AI_CHECK%"=="1" (
  echo.
  echo ERROR: DBMS_CLOUD_AI is not available in this database.
  echo Please install DBMS_CLOUD first. Refer to the Oracle documentation:
  echo   https://docs.oracle.com/en/database/oracle/oracle-database/23/arpls/DBMS_CLOUD.html
  goto error
)

echo DBMS_CLOUD_AI is available.

:: Prompt for SSL wallet directory ------------------------------------------------
set "SSL_WALLET_DIR="
echo.
set /p SSL_WALLET_DIR="Please enter the SSL wallet directory (default: C:\oracle\wallet): "
if "%SSL_WALLET_DIR%"=="" set "SSL_WALLET_DIR=C:\oracle\wallet"

:: Prompt for Google API key ------------------------------------------------------
echo.
set "GOOGLE_API_KEY="
set /p GOOGLE_API_KEY="Please enter the Google API key: "

if "%GOOGLE_API_KEY%"=="" (
  echo ERROR: Google API key is required.
  goto error
)

:: Prompt for Google model -------------------------------------------------------
echo.
set "GOOGLE_MODEL="
set /p GOOGLE_MODEL="Please enter the Google model (default: gemini-2.5-flash): "
if "%GOOGLE_MODEL%"=="" set "GOOGLE_MODEL=gemini-2.5-flash"

:: --- Step 1: Run SYS setup (ACLs, roles, privileges, PDB grants) ---------------
echo.
echo Running SYS setup (ACLs, roles, privileges) ...
echo Connecting as SYS to "%DB_HOST%:%DB_PORT%/%ORACLE_PDB%" ...

set "TMPSYS=%TEMP%\3dcitydb_sys_%RANDOM%.sql"

> "%TMPSYS%" (
  echo WHENEVER OSERROR EXIT 9;
  echo WHENEVER SQLERROR EXIT SQL.SQLCODE;
  echo ALTER SESSION SET CONTAINER = CDB$ROOT;
  echo DEFINE SSL_WALLET_DIR='%SSL_WALLET_DIR%'
  echo DEFINE CLOUD_OWNER='C##CLOUD$SERVICE'
  echo DEFINE PDB_NAME='%ORACLE_PDB%'
  echo DEFINE DB_USER='%DB_USER%'
  echo @cloud-ai/select-ai-sys-setup.sql
  echo EXIT
)

"%ORACLE_CLIENT%" -S -L "sys/%SYS_PWD%@%DB_HOST%:%DB_PORT%/%ORACLE_PDB% as sysdba" @"%TMPSYS%"
set SYS_RC=%ERRORLEVEL%
del "%TMPSYS%" 2>nul

if %SYS_RC% NEQ 0 (
  echo.
  echo ERROR: SYS setup failed.
  goto error
)

echo SYS setup completed successfully.

:: --- Step 2: Property catalog view + annotations (as app user) -----------------
echo.
echo Creating property catalog view and schema annotations ...
echo Connecting to "%DB_USER%@%DB_HOST%:%DB_PORT%/%ORACLE_PDB%" ...

set "TMPCATALOG=%TEMP%\3dcitydb_catalog_%RANDOM%.sql"

> "%TMPCATALOG%" (
  echo WHENEVER OSERROR EXIT 9;
  echo WHENEVER SQLERROR EXIT SQL.SQLCODE;
  echo @cloud-ai/select-ai-property-catalog.sql
  echo EXIT
)

"%ORACLE_CLIENT%" -S -L "%DB_USER%@%DB_HOST%:%DB_PORT%/%ORACLE_PDB%" @"%TMPCATALOG%"
set CATALOG_RC=%ERRORLEVEL%
del "%TMPCATALOG%" 2>nul

if %CATALOG_RC% NEQ 0 (
  echo.
  echo ERROR: Property catalog setup failed.
  goto error
)

echo Property catalog and annotations created successfully.

:: --- Step 3: Create AI profile (as app user) ------------------------------------
echo.
echo Creating Google credential and AI profile ...
echo Connecting to "%DB_USER%@%DB_HOST%:%DB_PORT%/%ORACLE_PDB%" ...

set "TMPPROFILE=%TEMP%\3dcitydb_profile_%RANDOM%.sql"

> "%TMPPROFILE%" (
  echo WHENEVER OSERROR EXIT 9;
  echo WHENEVER SQLERROR EXIT SQL.SQLCODE;
  echo DEFINE GOOGLE_API_KEY='%GOOGLE_API_KEY%'
  echo DEFINE GOOGLE_MODEL='%GOOGLE_MODEL%'
  echo DEFINE DB_USER='%DB_USER%'
  echo @cloud-ai/select-ai-create-profile.sql
  echo EXIT
)

"%ORACLE_CLIENT%" -S -L "%DB_USER%@%DB_HOST%:%DB_PORT%/%ORACLE_PDB%" @"%TMPPROFILE%"
set PROFILE_RC=%ERRORLEVEL%
del "%TMPPROFILE%" 2>nul

if %PROFILE_RC% NEQ 0 (
  echo.
  echo ERROR: AI profile creation failed.
  goto error
)

echo.
echo Select AI setup completed successfully!
echo You can now use Select AI in your 3DCityDB instance.
echo.
pause
goto end

:error
echo.
pause
exit /b 1

:end
