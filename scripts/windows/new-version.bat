@echo off
setlocal
if "%~1"=="" (
  echo Usage: scripts\windows\new-version.bat ^<service^>
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0new-version.ps1" -Service "%~1"
endlocal
