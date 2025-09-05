# Homelab

Complete snapshot generated 2025-09-05 20:07:15. This repo contains current configs for services, historical versions,
and docs for planned changes. Traefik dynamic configs are hardened (TLS + gzip + security).

## Layout
- `services/<service>/` — current config for that service
- `services/<service>/versions/v000N/` — archived snapshots
- `docs/` — changelog, inventory, plans
- `.githooks/` — pre-commit hook to block sensitive files

## Notes
- Keep secrets in `.env` or files named `*.private.*` (ignored).
- Public templates live in `*.example.*`.


## Current Version

- **Version:** 1.0.1
- **Updated:** 2025-09-05 17:27:06  (ET)(ET)

## Versioning

We use `MAJOR.MINOR.REV` and keep the authoritative version in `homelab/VERSION`. Changes are logged in `homelab/docs/changelog.md`.
