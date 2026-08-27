Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Starting ERPNext Healthcare HMS System...      " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan

docker compose up -d

Write-Host "`nServices started!" -ForegroundColor Green
Write-Host "The system is initializing databases and site configs." -ForegroundColor Yellow
Write-Host "`nWeb Access URL: http://localhost:8080" -ForegroundColor Cyan
Write-Host "Default Credentials:" -ForegroundColor White
Write-Host "  Username: Administrator" -ForegroundColor White
Write-Host "  Password: admin" -ForegroundColor White
Write-Host "`nTo check progress and logs, run: .\logs.ps1" -ForegroundColor Gray
