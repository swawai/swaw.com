@echo off
setlocal
call "%~dp0dev.cmd" --processes
exit /b %errorlevel%
