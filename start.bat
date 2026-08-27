@echo off
echo ==================================================
echo   Starting ERPNext Healthcare HMS System...
echo ==================================================

docker compose up -d

echo.
echo Services started!
echo The system is initializing databases and site configs.
echo.
echo Web Access URL: http://localhost:8080
echo Default Credentials:
echo   Username: Administrator
echo   Password: admin
echo.
echo To view live logs, run logs.bat
pause
