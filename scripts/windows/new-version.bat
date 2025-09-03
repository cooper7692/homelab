@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0new-version.ps1" -Service %1 %2
