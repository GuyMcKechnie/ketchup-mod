@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Source and destination
set "SRC=C:\Users\mckec\Documents\Coding\rimworld\ketchup-mod\NanaDaBanana.Ketchup\NanaDaBanana.Ketchup"
set "DST=C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Mods\KetchupMod"

rem Folders to process
set "FOLDERS=About Assemblies Defs Languages Patches Sounds Textures"

set "EXITCODE=0"

if not exist "%SRC%" (
  echo [deploy] ERROR: Source not found: "%SRC%"
  exit /b 2
)

if not exist "%DST%" (
  mkdir "%DST%" 2>nul
  if errorlevel 1 (
    echo [deploy] ERROR: Cannot create destination: "%DST%". Try running Visual Studio as Administrator.
    exit /b 5
  )
)

echo [deploy] Copying XML and DLL files...
echo [deploy] From: "%SRC%"
echo [deploy] To  : "%DST%"
echo.

for %%F in (%FOLDERS%) do (
  if exist "%SRC%\%%F" (
    echo [deploy] %%F
    rem Copy only *.xml and *.dll, include subfolders, skip older files
    robocopy "%SRC%\%%F" "%DST%\%%F" *.xml *.dll /S /XO /XJ /R:2 /W:1 /NFL /NDL /NP >nul
    set "RC=!errorlevel!"
    rem Normalize ROBOCOPY exit codes (0-7 are success/info)
    if !RC! LSS 8 set "RC=0"
    if not !RC! == 0 (
      echo [deploy] ERROR: robocopy failed for %%F with code !RC!
      set "EXITCODE=!RC!"
    )
  ) else (
    echo [deploy] Skipping %%F (not found in source).
  )
)

echo.
if %EXITCODE%==0 (
  echo [deploy] Done.
) else (
  echo [deploy] Completed with errors. ExitCode=%EXITCODE%
)
exit /b %EXITCODE%