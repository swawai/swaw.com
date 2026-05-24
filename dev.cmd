@echo off
setlocal

if not defined BANYAN_DEV_PORT set "BANYAN_DEV_PORT=5120"
set "ROOT_DIR=%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference = 'Stop';" ^
  "$root = (Resolve-Path -LiteralPath $env:ROOT_DIR).Path;" ^
  "$bind = $env:BANYAN_DEV_BIND;" ^
  "if ([string]::IsNullOrWhiteSpace($bind)) {" ^
  "  $bind = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |" ^
  "    Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' -and $_.IPAddress -notlike '0.*' } |" ^
  "    Sort-Object InterfaceMetric, InterfaceIndex |" ^
  "    Select-Object -First 1 -ExpandProperty IPAddress;" ^
  "  if ([string]::IsNullOrWhiteSpace($bind)) { $bind = '127.0.0.1'; }" ^
  "}" ^
  "$public = Join-Path $root 'public';" ^
  "if (Test-Path -LiteralPath $public) {" ^
  "  $resolved = (Resolve-Path -LiteralPath $public).Path;" ^
  "  $expected = [System.IO.Path]::GetFullPath((Join-Path $root 'public'));" ^
  "  if ($resolved.TrimEnd('\') -ne $expected.TrimEnd('\')) { throw ('Refusing to delete unexpected path: ' + $resolved); }" ^
  "  Remove-Item -LiteralPath $resolved -Recurse -Force -ErrorAction Stop;" ^
  "}" ^
  "Set-Location -LiteralPath $root;" ^
  "$env:BANYAN_DEV_BIND = $bind;" ^
  "Write-Host ('Starting swaw.com dev server on {0}:{1}' -f $env:BANYAN_DEV_BIND, $env:BANYAN_DEV_PORT);" ^
  "& npm run dev;" ^
  "exit $LASTEXITCODE"
exit /b %errorlevel%
