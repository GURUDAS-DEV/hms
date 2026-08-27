Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Installing Healthcare Module into ERPNext...     " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`n1. Getting Healthcare App..." -ForegroundColor Yellow
docker compose exec backend bench get-app healthcare --branch version-15

Write-Host "`n2. Installing Healthcare App on site 'frontend'..." -ForegroundColor Yellow
docker compose exec backend bench --site frontend install-app healthcare

Write-Host "`n3. Running Database Migrations..." -ForegroundColor Yellow
docker compose exec backend bench --site frontend migrate

Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "  Healthcare Module installed successfully!       " -ForegroundColor Green
Write-Host "  Visit http://localhost:8080 to access your HMS. " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
