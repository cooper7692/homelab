param(
  [switch]$Major = $false,
  [switch]$Minor = $false,
  [switch]$Rev   = $false
)
# bump-version.ps1 — bump MAJOR.MINOR.REV and update changelog

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Join-Path $root ".."
$root = Resolve-Path $root
$versionFile = Join-Path $root "VERSION"
$changelog = Join-Path $root "docs\changelog.md"

if (-not (Test-Path $versionFile)) {
  "1.0.0" | Set-Content -LiteralPath $versionFile -Encoding UTF8
}

$cur = (Get-Content -LiteralPath $versionFile -Raw).Trim()
if ($cur -notmatch '^([0-9]+)\.([0-9]+)\.([0-9]+)$') {
  throw "Invalid current version: $cur"
}

$a = [int]$Matches[1]; $b = [int]$Matches[2]; $c = [int]$Matches[3]

if ($Major) { $a++; $b=0; $c=0 }
elseif ($Minor) { $b++; $c=0 }
elseif ($Rev) { $c++ }
else {
  throw "Specify one: -Major | -Minor | -Rev"
}

$new = "$a.$b.$c"
$new | Set-Content -LiteralPath $versionFile -Encoding UTF8

$ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
if (-not (Test-Path $changelog)) {
  "# Changelog`n" | Set-Content -LiteralPath $changelog -Encoding UTF8
}
Add-Content -LiteralPath $changelog -Value ("- {0} — Version bumped to {1}" -f $ts, $new)

Write-Host "New version: $new"
