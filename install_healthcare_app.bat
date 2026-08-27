@echo off
echo ==================================================
echo   Installing Healthcare Module into ERPNext...
echo ==================================================

echo 1. Getting Healthcare App...
docker compose exec backend bench get-app healthcare --branch version-15

echo 2. Installing Healthcare App to frontend site...
docker compose exec backend bench --site frontend install-app healthcare

echo 3. Running Database Migrations...
docker compose exec backend bench --site frontend migrate

echo.
echo ==================================================
echo  Healthcare Module installed successfully!
echo  Visit http://localhost:8080 to access your HMS.
echo ==================================================
pause
