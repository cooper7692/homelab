param(
  [switch]$Force = $false,
  [switch]$UpdateExample = $false
)
# gen-env.ps1 — generate .env from compose by prompting for ${VARS}

# Find compose file
$compose = @("compose.yaml","compose.yml","docker-compose.yaml","docker-compose.yml") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $compose) {
  Write-Error "No compose file found in $(Get-Location)"
  exit 1
}

Write-Host "🔎 Scanning $compose for `${VARS} placeholders..."

# Read file and extract ${VAR} and ${VAR:-default}
$text = Get-Content -Raw -LiteralPath $compose
$regex = '\$\{([A-Za-z_][A-Za-z0-9_]*)(?::-([^}]*))?\}'
$matches = [System.Text.RegularExpressions.Regex]::Matches($text, $regex)
$unique = @{}  # name -> default
foreach ($m in $matches) {
  $name = $m.Groups[1].Value
  $def = $m.Groups[2].Value
  if (-not $unique.ContainsKey($name)) { $unique[$name] = $def }
}

if ($unique.Keys.Count -eq 0) {
  Write-Host "✅ No placeholders found. Nothing to do."
  exit 0
}

# Load existing .env if present
$existing = @{}
if (Test-Path ".env") {
  foreach ($ln in Get-Content -LiteralPath ".env") {
    if ($ln -match '^\s*#' -or $ln.Trim().Length -eq 0) { continue }
    if ($ln -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$') {
      $k = $Matches[1]; $v = $Matches[2]
      $existing[$k] = $v
    }
  }
}

# Load .env.example defaults
$exDefaults = @{}
if (Test-Path ".env.example") {
  foreach ($ln in Get-Content -LiteralPath ".env.example") {
    if ($ln -match '^\s*#' -or $ln.Trim().Length -eq 0) { continue }
    if ($ln -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*"?([^"]*)"?\s*$') {
      $exDefaults[$Matches[1]] = $Matches[2]
    }
  }
}

# Secret detection
function Is-Secret([string]$name) {
  return ($name -match 'PASS|PASSWORD|TOKEN|SECRET|KEY|API|WEBHOOK|AUTH')
}

# Target handling
$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$target = ".env"
if (Test-Path ".env" -and -not $Force) {
  Write-Host "ℹ️  .env already exists. I will write to .env.new and create a backup of the existing file."
  Copy-Item ".env" ".env.bak.$ts" -Force
  $target = ".env.new"
}

$out = New-Object System.Text.StringBuilder

foreach ($name in $unique.Keys) {
  $def = $unique[$name]
  $cur = $existing[$name]
  if (-not $cur) {
    $ex = $exDefaults[$name]
    if ($ex -and $ex -ne "__REDACTED__") { $def = $ex }
  }

  if ($cur) {
    Write-Host "• $name already set; keeping existing"
    $val = $cur
  } else {
    $prompt = "Enter value for $name"
    if ($def) { $prompt += " [$def]" }
    if (Is-Secret $name) {
      $sec = Read-Host "$prompt (hidden)" -AsSecureString
      $BSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
      $val = [Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
      [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
    } else {
      $val = Read-Host "$prompt"
    }
    if (-not $val -and $def) { $val = $def }
  }
  $val = $val -replace '"','\"'
  [void]$out.AppendLine("$name=""$val""")
}

$out.ToString() | Set-Content -LiteralPath $target -Encoding UTF8
Write-Host "✅ Wrote $target"

if ($UpdateExample) {
  $exOut = New-Object System.Text.StringBuilder
  foreach ($name in $unique.Keys) {
    [void]$exOut.AppendLine("$name=""__REDACTED__""")
  }
  $exOut.ToString() | Set-Content -LiteralPath ".env.example" -Encoding UTF8
  Write-Host "✅ Wrote .env.example"
}

if (Test-Path ".env.bak.$ts") {
  Write-Host "🗄  Backup of previous .env: .env.bak.$ts"
}
