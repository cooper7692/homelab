# Versioning Policy

We use **three-part numeric versions**: `MAJOR.MINOR.REV` (example: `1.23.456`).

- **MAJOR** — Breaking changes / major structural shifts (e.g., move to new reverse proxy, storage layout change).
- **MINOR** — Feature additions or non-breaking changes across services (new service added, notable config improvements).
- **REV** — Routine tweaks, fixes, documentation updates, or small config patches.

## How we bump
Use the helper scripts in `homelab/scripts/`:

### Linux/macOS
```bash
cd homelab
./scripts/bump-version.sh --major   # e.g., 1.0.0 -> 2.0.0
./scripts/bump-version.sh --minor   # e.g., 1.0.0 -> 1.1.0
./scripts/bump-version.sh --rev     # e.g., 1.0.0 -> 1.0.1
```

### Windows (PowerShell)
```powershell
cd homelab
./scripts/bump-version.ps1 -Major   # 1.0.0 -> 2.0.0
./scripts/bump-version.ps1 -Minor   # 1.0.0 -> 1.1.0
./scripts/bump-version.ps1 -Rev     # 1.0.0 -> 1.0.1
```

Each bump:
- Updates the `homelab/VERSION` file,
- Appends an entry to `homelab/docs/changelog.md` with timestamp and the new version number.

> Tip: After bumping, commit and (optionally) create a Git tag at the same version.
