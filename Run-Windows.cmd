@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Set-BVGWallpaper.ps1" %*
echo.
pause
