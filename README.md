# Homelab

This repository is the authoritative, versioned store for Cooper’s home lab configs.

## Versioning layout
- The **current** version of each service lives at `services/<service>/`
- **Archived** versions live at `services/<service>/versions/v000N/`

## Safety
- Real secrets in `*.private.*` and `.env` (ignored)
- Public-safe templates in `*.example.*` (committed)
- Pre-commit hook blocks sensitive filenames

## Windows & Linux helpers
- Linux/macOS: `scripts/commit-config.sh`, `scripts/new-version.sh`
- Windows: `scripts\windows\init-repo.bat`, `new-version.bat/ps1`, `commit-and-push.bat`, `quick-push.bat`

---

## 📜 Version History (Repo-wide)
### v0.4 — Imported legacy stacks & UI-only Traefik
- Imported compose files from node1/node2 zips (compose **as-is**)
- Generated `.env.example` from `${VAR}` placeholders
- Created **Traefik configs only for services with Web UIs**
- Added per-service READMEs with node targets
- Current-in-root layout with `versions/v0001` snapshots

### v0.3 — Current-in-root layout
- Keep current at `services/<service>/`, archive to `versions/` via helper scripts

### v0.2 — Frigate v0001, Windows helpers
### v0.1 — Initial scaffold
