@echo off
setlocal

set "ROOT_DIR=%~dp0"
cd /d "%ROOT_DIR%"

call npm run prepare:external -- %*
exit /b %errorlevel%
