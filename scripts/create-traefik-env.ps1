param(
  [string]$BaseDir = $(Resolve-Path "$PSScriptRoot\..").Path
)
$envPath = Join-Path $BaseDir "traefik\.env"

$TZ = Read-Host 'TZ [America/Detroit]'; if (-not $TZ) { $TZ = "America/Detroit" }
$PUID = Read-Host 'PUID [1000]'; if (-not $PUID) { $PUID = "1000" }
$PGID = Read-Host 'PGID [1000]'; if (-not $PGID) { $PGID = "1000" }
$ACME_EMAIL = Read-Host 'ACME_EMAIL'

$mode = Read-Host 'Cloudflare method: 1) Global Key  2) Scoped DNS Token [1/2]'
if ($mode -eq '1') {
  $CF_API_EMAIL = Read-Host 'CF_API_EMAIL'
  $CF_API_KEY = Read-Host 'CF_API_KEY'
  $CF_DNS_API_TOKEN = ""
} else {
  $CF_API_EMAIL = ""
  $CF_API_KEY = ""
  $CF_DNS_API_TOKEN = Read-Host 'CF_DNS_API_TOKEN'
}

$PROXY_CONFIG_DIR = Read-Host 'PROXY_CONFIG_DIR [/opt/proxy/config]'; if (-not $PROXY_CONFIG_DIR) { $PROXY_CONFIG_DIR = "/opt/proxy/config" }
$PROXY_CONFIGS_DIR = Read-Host 'PROXY_CONFIGS_DIR [/opt/proxy/configs]'; if (-not $PROXY_CONFIGS_DIR) { $PROXY_CONFIGS_DIR = "/opt/proxy/configs" }
$PROXY_ACME_JSON = Read-Host 'PROXY_ACME_JSON [/opt/proxy/acme.json]'; if (-not $PROXY_ACME_JSON) { $PROXY_ACME_JSON = "/opt/proxy/acme.json" }
$PROXY_LOG_DIR = Read-Host 'PROXY_LOG_DIR [/opt/proxy/logs]'; if (-not $PROXY_LOG_DIR) { $PROXY_LOG_DIR = "/opt/proxy/logs" }

$TRAEFIKADMIN = Read-Host 'TRAEFIKADMIN (htpasswd line e.g., user:$2y$...)'

New-Item -ItemType Directory -Force -Path (Split-Path $envPath) | Out-Null
@"
TZ="$TZ"
PUID="$PUID"
PGID="$PGID"
ACME_EMAIL="$ACME_EMAIL"
CF_API_EMAIL="$CF_API_EMAIL"
CF_API_KEY="$CF_API_KEY"
CF_DNS_API_TOKEN="$CF_DNS_API_TOKEN"
PROXY_CONFIG_DIR="$PROXY_CONFIG_DIR"
PROXY_CONFIGS_DIR="$PROXY_CONFIGS_DIR"
PROXY_ACME_JSON="$PROXY_ACME_JSON"
PROXY_LOG_DIR="$PROXY_LOG_DIR"
TRAEFIKADMIN='$TRAEFIKADMIN'
"@ | Set-Content -Path $envPath -Encoding UTF8

Write-Host "Wrote $envPath"
