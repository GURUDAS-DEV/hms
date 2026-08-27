@echo off
title Docker Download & Live Progress Monitor
echo =========================================================
echo   Live Download & Container Progress Monitor
echo   (Press Ctrl+C at any time to exit)
echo =========================================================
echo.

:loop
cls
echo =========================================================
echo   LIVE DOCKER DOWNLOAD PROGRESS
echo =========================================================
echo.
powershell -Command "Get-Content C:\Users\Gursa\.gemini\antigravity-ide\brain\60076296-7971-4930-9d4e-241fcd92a9d8\.system_generated\tasks\task-219.log -Tail 15"
echo.
echo ---------------------------------------------------------
echo Current Container Status:
docker compose ps
echo ---------------------------------------------------------
timeout /t 3 /nobreak >nul
goto loop
