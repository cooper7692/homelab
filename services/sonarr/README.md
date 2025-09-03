# sonarr Service

**Node target:** node1

This folder holds the **CURRENT** configuration for `sonarr`. Archived snapshots live in `versions/`.

## Files
- `compose.yaml` — copied from your uploaded repo (no changes)
- `.env.example` — placeholders extracted from compose (`${VARS}`)
- `sonarr.traefik.config.yaml` — Traefik dynamic config for Web UI only (if present)

## Sensitive Info
Keep real secrets in `*.private.*` or `.env` (ignored by Git). Commit only the `*.example.*` templates.

## Snapshotting
When you want to archive the current state:
- Linux/macOS: `./scripts/new-version.sh sonarr`
- Windows: `scripts\windows\new-version.bat sonarr`
