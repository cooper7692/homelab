@echo off
git add -A
git commit -m "%~1" || echo nothing
git push -u origin main
