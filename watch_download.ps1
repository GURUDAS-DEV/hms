Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "  Live Docker Download & Container Monitor               " -ForegroundColor Green
Write-Host "  (Press Ctrl+C at any time to exit)                     " -ForegroundColor Gray
Write-Host "=========================================================" -ForegroundColor Cyan

while ($true) {
    Clear-Host
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "  LIVE DOCKER DOWNLOAD PROGRESS                          " -ForegroundColor Yellow
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host ""
    if (Test-Path "C:\Users\Gursa\.gemini\antigravity-ide\brain\60076296-7971-4930-9d4e-241fcd92a9d8\.system_generated\tasks\task-219.log") {
        Get-Content "C:\Users\Gursa\.gemini\antigravity-ide\brain\60076296-7971-4930-9d4e-241fcd92a9d8\.system_generated\tasks\task-219.log" -Tail 15
    }
    Write-Host ""
    Write-Host "---------------------------------------------------------" -ForegroundColor Gray
    Write-Host "Current Container Status:" -ForegroundColor Green
    docker compose ps
    Write-Host "---------------------------------------------------------" -ForegroundColor Gray
    Start-Sleep -Seconds 3
}
