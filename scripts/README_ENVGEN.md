# Env Generator Scripts

These scripts scan the **compose file in the current folder** for `${VARS}` and build a `.env` by prompting you for values. Secrets are prompted **hidden**. They **never overwrite** your existing `.env` unless you pass `--force` (bash) or `-Force` (PowerShell).

## Files
- `scripts/gen-env.sh` — Linux/macOS
- `scripts/gen-env.ps1` — Windows PowerShell

## Usage
From inside a service folder (where `compose.yaml` or `docker-compose.yml` lives):

### Linux/macOS
```bash
chmod +x ./scripts/gen-env.sh
cd services/<service>
../../scripts/gen-env.sh            # creates .env (or .env.new if .env exists)
../../scripts/gen-env.sh --force    # overwrite .env (also writes a timestamped backup)
../../scripts/gen-env.sh --update-example  # also writes .env.example with redacted values
```

> Requires GNU grep with `-P`. On Ubuntu/Debian, `grep` already supports `-P`.

### Windows (PowerShell)
```powershell
cd services/<service>
..\..\scripts\gen-env.ps1              # creates .env (or .env.new if .env exists)
..\..\scripts\gen-env.ps1 -Force       # overwrite .env (also writes a timestamped backup)
..\..\scripts\gen-env.ps1 -UpdateExample  # also writes .env.example with redacted values
```

## How it decides defaults
- If the compose uses `${VAR:-default}`, that `default` is offered.
- If `.env.example` exists with a non-`__REDACTED__` value, that’s offered.
- If `.env` already exists, existing values are preserved unless `--force`/`-Force`.

## Secret detection
Variable names containing `PASS`, `PASSWORD`, `TOKEN`, `SECRET`, `KEY`, `API`, `WEBHOOK`, or `AUTH` are prompted **hidden**.

## Safety
- If `.env` exists and you don’t force overwrite, the scripts write to `.env.new` and create a backup of your current `.env` as `.env.bak.<timestamp>`.
- You can safely commit `.env.example` to GitHub; never commit real `.env`.

Generated 2025-09-05 21:09:30.
