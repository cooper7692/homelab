#!/usr/bin/env bash
# bump-version.sh — bump MAJOR.MINOR.REV in homelab/VERSION and append changelog
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_FILE="$ROOT/VERSION"
CHANGELOG="$ROOT/docs/changelog.md"

MAJOR=0; MINOR=0; REV=0
case "${1:-}" in
  --major) MAJOR=1 ;;
  --minor) MINOR=1 ;;
  --rev|--patch) REV=1 ;;
  "" ) echo "Usage: $0 --major|--minor|--rev"; exit 1 ;;
  * ) echo "Unknown flag: $1"; exit 1 ;;
esac

if [[ ! -f "$VERSION_FILE" ]]; then
  echo "1.0.0" > "$VERSION_FILE"
fi

CUR=$(cat "$VERSION_FILE" | tr -d '\r\n' )
if [[ ! "$CUR" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "Invalid current version: $CUR"
  exit 1
fi
A=${BASH_REMATCH[1]}; B=${BASH_REMATCH[2]}; C=${BASH_REMATCH[3]}

if [[ $MAJOR -eq 1 ]]; then
  A=$((A+1)); B=0; C=0
elif [[ $MINOR -eq 1 ]]; then
  B=$((B+1)); C=0
else
  C=$((C+1))
fi

NEW="${A}.${B}.${C}"
echo "$NEW" > "$VERSION_FILE"
TS=$(date '+%Y-%m-%d %H:%M:%S')
mkdir -p "$(dirname "$CHANGELOG")"
if [[ ! -f "$CHANGELOG" ]]; then echo "# Changelog" > "$CHANGELOG"; fi
echo "- ${TS} — Version bumped to ${NEW}" >> "$CHANGELOG"
echo "New version: $NEW"
