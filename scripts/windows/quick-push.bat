@echo off
git add -A
git commit -m "snapshot %DATE% %TIME%" || echo nothing
git push -u origin main
