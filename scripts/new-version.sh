#!/usr/bin/env bash
set -euo pipefail
SERVICE="${1:-}"
COPY="${2:-}"
if [ -z "$SERVICE" ]; then echo "Service required"; exit 1; fi
VERSIONS="services/$SERVICE/versions"
mkdir -p "$VERSIONS"
LATEST=$(ls "$VERSIONS" | grep -E '^v[0-9]{4}$' | sort | tail -n1 || true)
if [ -z "$LATEST" ]; then NEXT=v0001; else NUM=$((10#${LATEST:1}+1)); NEXT=$(printf "v%04d" $NUM); fi
NEW="$VERSIONS/$NEXT"
mkdir -p "$NEW"
if [ "$COPY" = "--copy-latest" ] && [ -n "$LATEST" ]; then rsync -a --exclude '.env' --exclude '*.private.*' "$VERSIONS/$LATEST/" "$NEW/"; fi
echo "$(date '+%F %T') — Created $SERVICE $NEXT" >> docs/changelog.md
echo "Created $NEW"
