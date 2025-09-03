@echo off
setlocal
git init -b main
git config core.hooksPath .githooks
echo Repo initialized on branch main with hooks enabled.
endlocal
