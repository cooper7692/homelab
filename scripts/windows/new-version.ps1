param([Parameter(Mandatory=$true)][string]$Service)
$base = Join-Path "services" $Service
$src = $base
$versions = Join-Path $base "versions"
New-Item -ItemType Directory -Force -Path $versions | Out-Null
$existing = Get-ChildItem -Path $versions -Directory | Where-Object { $_.Name -match '^v\d{4}$' } | Sort-Object Name
if ($existing.Count -eq 0) { $next = "v0001" } else { $next = ("v{0:D4}" -f ([int]$existing[-1].Name.Substring(1) + 1)) }
$dest = Join-Path $versions $next
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Write-Host "Snapshotting CURRENT '$src' -> '$dest'"
robocopy "$src" "$dest" /E /NFL /NDL /NJH /NJS /NP /XF *.private.* .env /XD versions >nul
$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content "docs/changelog.md" "$stamp — Snapshotted $Service $next"
Write-Host "Created $dest"
