#!/usr/bin/env bash
set -euo pipefail
SERVICE="${1:-}"
if [ -z "$SERVICE" ]; then echo "Usage: $0 <service>"; exit 1; fi
BASE="services/$SERVICE"
SRC="$BASE"
VERSIONS="$BASE/versions"
mkdir -p "$VERSIONS"
LATEST=$(ls "$VERSIONS" 2>/dev/null | grep -E '^v[0-9]{4}$' | sort | tail -n1 || true)
if [ -z "$LATEST" ]; then NEXT="v0001"; else NUM=$((10#${LATEST:1}+1)); NEXT=$(printf "v%04d" "$NUM"); fi
DEST="$VERSIONS/$NEXT"
mkdir -p "$DEST"
rsync -a --exclude 'versions/' --exclude '.env' --exclude '*.private.*' "$SRC/" "$DEST/"
STAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "$STAMP — Snapshotted $SERVICE $NEXT" >> docs/changelog.md
echo "Created $DEST"
