@echo off
setlocal
set MSG=auto snapshot %DATE% %TIME%
git add -A
git commit -m "%MSG%" || echo (nothing to commit)
git push -u origin main
endlocal
