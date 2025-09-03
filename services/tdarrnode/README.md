# tdarrnode Service

**Node target:** node2

This folder holds the **CURRENT** configuration for `tdarrnode`. Archived snapshots live in `versions/`.

## Files
- `compose.yaml` — copied from your uploaded repo (no changes)
- `.env.example` — placeholders extracted from compose (`${VARS}`)
- (No Traefik config generated; service has no detected Web UI.)

## Sensitive Info
Keep real secrets in `*.private.*` or `.env` (ignored by Git). Commit only the `*.example.*` templates.

## Snapshotting
When you want to archive the current state:
- Linux/macOS: `./scripts/new-version.sh tdarrnode`
- Windows: `scripts\windows\new-version.bat tdarrnode`
