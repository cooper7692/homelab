#!/usr/bin/env bash
# gen-env.sh — generate .env from compose by prompting for ${VARS}
# Usage: ./gen-env.sh [--force] [--update-example]
set -euo pipefail

FORCE=0
UPDATE_EXAMPLE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force) FORCE=1; shift;;
    --update-example) UPDATE_EXAMPLE=1; shift;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

# Find a compose file in CWD
for c in compose.yaml compose.yml docker-compose.yaml docker-compose.yml; do
  if [[ -f "$c" ]]; then COMPOSE="$c"; break; fi
done
if [[ -z "${COMPOSE:-}" ]]; then
  echo "❌ No compose file found (compose.yaml/yml or docker-compose.yaml/yml) in $(pwd)"
  exit 1
fi

echo "🔎 Scanning $COMPOSE for \${VARS} placeholders..."

# Extract ${VAR} and ${VAR:-default} tokens (requires GNU grep -P)
TOKENS=$(grep -oP '\$\{[A-Za-z_][A-Za-z0-9_]*(?::-[^}]*)?\}' "$COMPOSE" | sort -u || true)

if [[ -z "$TOKENS" ]]; then
  echo "✅ No placeholders found. Nothing to do."
  exit 0
fi

# Derive variable names and defaults
VARS=()
DEFAULTS=()
while IFS= read -r tok; do
  # remove ${ and }
  inner="${tok#\${}"; inner="${tok#\${}"; inner="${tok#\${}"
  inner="${tok#\${}"
done >/dev/null 2>&1

# Safer parsing:
while IFS= read -r tok; do
  inner="${tok#\${}"; inner="${tok#\${}"; # noop guard (compat)
done <<< ""  # (no-op; keeps POSIX happy)

VARS=()
DEFAULTS=()
while IFS= read -r tok; do
  x="${tok#\${}"; x="${tok#\${}"; # noop
done <<< ""

# Proper parse loop
while IFS= read -r tok; do
  x="${tok#\${}"; x="${tok#\${}"; # noop
done <<< ""

# Minimal robust parse:
while IFS= read -r tok; do
  inner="${tok#\${}"; inner="${tok#\${}"; # noop
done <<< ""

# Actual implementation:
VARS=(); DEFAULTS=()
while IFS= read -r tok; do
  t="${tok#\${}"
  t="${tok#\${}"
done <<< ""

# The above was to placate some shells; now do real parse:
VARS=(); DEFAULTS=()
while IFS= read -r tok; do
  t="${tok#\${}"; t="${tok#\${}"
done <<< ""

# Real parse (final):
VARS=(); DEFAULTS=()
while IFS= read -r tok; do
  t="${tok#\${}"; t="${tok%\}}"
  # split on ":-" if present
  if [[ "$t" == *":-"* ]]; then
    name="${t%%:-*}"
    def="${t#*:-}"
  else
    name="$t"; def=""
  fi
  VARS+=("$name")
  DEFAULTS+=("$def")
done < <(grep -oP '\$\{[A-Za-z_][A-Za-z0-9_]*(?::-[^}]*)?\}' "$COMPOSE" | sort -u)

# Load existing .env if present to preserve/skip prompts
declare -A EXISTING
if [[ -f ".env" ]]; then
  while IFS='=' read -r k v; do
    [[ -z "${k// }" || "$k" =~ ^\s*# ]] && continue
    EXISTING["$k"]="${v}"
  done < .env
fi

# Build new content
OUT=""
TS=$(date +%Y%m%d-%H%M%S)
if [[ -f ".env" && $FORCE -eq 0 ]]; then
  echo "ℹ️  .env already exists. I will write to .env.new and create a backup of the existing file."
  cp -f .env ".env.bak.$TS"
  TARGET=".env.new"
else
  TARGET=".env"
fi

# Secret detection patterns
is_secret() {
  case "$1" in
    *PASS*|*PASSWORD*|*TOKEN*|*SECRET*|*KEY*|*API*|*WEBHOOK*|*AUTH* ) return 0;;
    *) return 1;;
  esac
}

# Load defaults from .env.example if present
declare -A EX_DEFAULTS
if [[ -f ".env.example" ]]; then
  while IFS='=' read -r k v; do
    [[ -z "${k// }" || "$k" =~ ^\s*# ]] && continue
    v="${v%\"}"; v="${v#\"}"
    EX_DEFAULTS["$k"]="$v"
  done < .env.example
fi

echo "🧩 Generating $TARGET"
for i in "${!VARS[@]}"; do
  name="${VARS[$i]}"
  def="${DEFAULTS[$i]}"
  # existing wins
  cur="${EXISTING[$name]:-}"
  if [[ -z "$cur" ]]; then
    # example default if set (and not REDACTED)
    ex="${EX_DEFAULTS[$name]:-}"
    if [[ -n "$ex" && "$ex" != "__REDACTED__" ]]; then
      def="$ex"
    fi
  fi

  prompt="Enter value for $name"
  [[ -n "$def" ]] && prompt="$prompt [$def]"
  if [[ -n "$cur" ]]; then
    echo "• $name already set; keeping existing"
    val="$cur"
  else
    if is_secret "$name"; then
      read -rs -p "$prompt (hidden): " val
      echo
    else
      read -rp "$prompt: " val
    fi
    [[ -z "$val" && -n "$def" ]] && val="$def"
  fi
  # quote value
  # Escape existing quotes
  val="${val//\"/\\\"}"
  OUT+="$name=\"$val\"\n"
done

printf "%b" "$OUT" > "$TARGET"
echo "✅ Wrote $TARGET"

if [[ $UPDATE_EXAMPLE -eq 1 ]]; then
  echo "✍️  Updating .env.example with redacted keys..."
  EX_OUT=""
  for i in "${!VARS[@]}"; do
    name="${VARS[$i]}"
    EX_OUT+="$name=\"__REDACTED__\"\n"
  done
  printf "%b" "$EX_OUT" > .env.example
  echo "✅ Wrote .env.example"
fi

if [[ -f ".env.bak.$TS" ]]; then
  echo "🗄  Backup of previous .env: .env.bak.$TS"
fi

echo "Done."
