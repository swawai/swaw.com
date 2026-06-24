@echo off
setlocal

set "ROOT_DIR=%~dp0"
cd /d "%ROOT_DIR%"

if not exist "%ROOT_DIR%.xvenv\env.cmd" (
  echo Missing xvenv environment: %ROOT_DIR%.xvenv\env.cmd
  exit /b 1
)

call "%ROOT_DIR%.xvenv\env.cmd"
bun run prepare:external -- %*
exit /b %errorlevel%
