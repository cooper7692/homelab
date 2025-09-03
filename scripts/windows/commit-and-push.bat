@echo off
setlocal
set MSG=%~1
if "%MSG%"=="" set MSG=update configs
git add -A
git commit -m "%MSG%" || echo (nothing to commit)
git push -u origin main
endlocal
