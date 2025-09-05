# Traefik Bundle (Clean)

This bundle contains a cleaned Traefik v3 setup:
- **compose.yaml** — DNS-01 via Cloudflare, file provider for dynamic routers, HTTPS redirect, logs.
- **configs/traefik.dashboard.config.yaml** — Dashboard router on `myproxy.ttgs.io` with BasicAuth.
- **.env.example** — Redacted; safe for Git.

## Generate your real `.env` (not committed)
Use one of the scripts to create a local `.env`:
- `scripts/create-traefik-env.sh` (Linux/macOS)
- `scripts/create-traefik-env.ps1` (Windows PowerShell)

These scripts prompt for secrets and write `services/traefik/.env` on your machine.
