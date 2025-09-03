#!/usr/bin/env bash
set -euo pipefail
MSG="${1:-update configs}"
DEFAULT_BRANCH="main"
if [ ! -d ".git" ]; then
  git init -b "$DEFAULT_BRANCH"
  git config core.hooksPath .githooks
fi
git add -A
git commit -m "$MSG" || true
echo "To push: git remote add origin https://github.com/cooper7692/homelab.git && git push -u origin main"
