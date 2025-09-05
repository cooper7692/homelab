#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")"/.. && pwd)"
ENV_PATH="$HERE/traefik/.env"

read -rp "TZ [America/Detroit]: " TZ; TZ=${TZ:-America/Detroit}
read -rp "PUID [1000]: " PUID; PUID=${PUID:-1000}
read -rp "PGID [1000]: " PGID; PGID=${PGID:-1000}
read -rp "ACME_EMAIL: " ACME_EMAIL

echo "Cloudflare method: 1) Global Key  2) Scoped DNS Token"
read -rp "Choose [1/2]: " CF_MODE
if [ "$CF_MODE" = "1" ]; then
  read -rp "CF_API_EMAIL: " CF_API_EMAIL
  read -rp "CF_API_KEY: " CF_API_KEY
  CF_DNS_API_TOKEN=""
else
  CF_API_EMAIL=""
  CF_API_KEY=""
  read -rp "CF_DNS_API_TOKEN: " CF_DNS_API_TOKEN
fi

read -rp "PROXY_CONFIG_DIR [/opt/proxy/config]: " PROXY_CONFIG_DIR; PROXY_CONFIG_DIR=${PROXY_CONFIG_DIR:-/opt/proxy/config}
read -rp "PROXY_CONFIGS_DIR [/opt/proxy/configs]: " PROXY_CONFIGS_DIR; PROXY_CONFIGS_DIR=${PROXY_CONFIGS_DIR:-/opt/proxy/configs}
read -rp "PROXY_ACME_JSON [/opt/proxy/acme.json]: " PROXY_ACME_JSON; PROXY_ACME_JSON=${PROXY_ACME_JSON:-/opt/proxy/acme.json}
read -rp "PROXY_LOG_DIR [/opt/proxy/logs]: " PROXY_LOG_DIR; PROXY_LOG_DIR=${PROXY_LOG_DIR:-/opt/proxy/logs}

read -rp "TRAEFIKADMIN (htpasswd line e.g., user:$2y$...): " TRAEFIKADMIN

mkdir -p "$(dirname "$ENV_PATH")"
cat > "$ENV_PATH" <<EOF
TZ="${TZ}"
PUID="${PUID}"
PGID="${PGID}"
ACME_EMAIL="${ACME_EMAIL}"
CF_API_EMAIL="${CF_API_EMAIL}"
CF_API_KEY="${CF_API_KEY}"
CF_DNS_API_TOKEN="${CF_DNS_API_TOKEN}"
PROXY_CONFIG_DIR="${PROXY_CONFIG_DIR}"
PROXY_CONFIGS_DIR="${PROXY_CONFIGS_DIR}"
PROXY_ACME_JSON="${PROXY_ACME_JSON}"
PROXY_LOG_DIR="${PROXY_LOG_DIR}"
TRAEFIKADMIN='${TRAEFIKADMIN}'
EOF

echo "Wrote $ENV_PATH"
