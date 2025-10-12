@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Deploy Ketchup mod files from dev folder to RimWorld Mods folder
:: Requires administrator privileges to write under Program Files (x86)

:: Elevate to admin if not already
fltmc >nul 2>&1 || (
  echo Requesting administrator privileges...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

:: Paths
set "SRC=C:\Users\mckec\Documents\Coding\rimworld\ketchup-mod"
set "DST=C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Mods\KetchupMod"

:: Validate source exists
if not exist "%SRC%" (
  echo ERROR: Source path not found: "%SRC%"
  exit /b 1
)

:: Ensure destination folder exists
if not exist "%DST%" (
  mkdir "%DST%" 2>nul
)

:: Default copy behavior: copy all files and subfolders, do NOT delete extras on destination
set "ROBO_FLAGS=/E /COPY:DAT /DCOPY:T /R:2 /W:1 /MT:16 /NFL /NDL /NP"

:: Optional modes:
::   pass MIRROR as first arg to make destination exactly match source (deletes extraneous files)
::   pass PREVIEW as first arg to show what would happen without copying (/L)
if /I "%~1"=="MIRROR" set "ROBO_FLAGS=/MIR /COPY:DAT /DCOPY:T /R:2 /W:1 /MT:16 /NFL /NDL /NP"
if /I "%~1"=="PREVIEW" set "ROBO_FLAGS=%ROBO_FLAGS% /L"

:: Exclusions: ignore typical dev/local folders and this deploy script
set "EXCLUDES=/XD .git .vscode /XF deploy-ketchup-mod.cmd"

echo Deploying from:
echo   %SRC%
echo To:
echo   %DST%

robocopy "%SRC%" "%DST%" * %ROBO_FLAGS% %EXCLUDES%
set "RC=%ERRORLEVEL%"

:: Interpret robocopy exit codes: 0-7 are success/info, 8+ indicate failure
if %RC% lss 8 (
  echo Deployment completed successfully. (robocopy code %RC%)
  exit /b 0
) else (
  echo ERROR: Deployment failed. (robocopy code %RC%)
  exit /b %RC%
)