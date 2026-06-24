@echo off
setlocal
set "ROOT_DIR=%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root = (Resolve-Path -LiteralPath $env:ROOT_DIR).Path;" ^
  "Get-CimInstance Win32_Process |" ^
  "  Where-Object { $_.CommandLine -and $_.CommandLine -like ('*' + $root + '*') -and $_.Name -match 'bun|node|hugo' } |" ^
  "  Select-Object ProcessId, Name, CommandLine |" ^
  "  Format-Table -Wrap"
