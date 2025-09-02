# Infrastructure Status Check
Write-Host "  Local Development Infrastructure Status" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n Core Infrastructure Services:" -ForegroundColor Yellow

# Check main infrastructure
try {
    $containers = docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | Select-String -Pattern "local-"
    foreach ($container in $containers) {
        $parts = $container.ToString().Split("`t")
        $name = $parts[0]
        $status = $parts[1]
        $ports = if ($parts.Length -gt 2) { $parts[2] } else { "No ports" }
        
        if ($status -like "*Up*") {
            Write-Host " $name" -ForegroundColor Green
            Write-Host "   Status: $status" -ForegroundColor Cyan
            if ($ports -ne "No ports") {
                Write-Host "   Ports: $ports" -ForegroundColor Cyan
            }
        } else {
            Write-Host " $name" -ForegroundColor Red
            Write-Host "   Status: $status" -ForegroundColor Red
        }
        Write-Host ""
    }
} catch {
    Write-Host " Error checking container status: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n Service URLs:" -ForegroundColor Yellow
Write-Host "Databases & Management:" -ForegroundColor Cyan
Write-Host "  PostgreSQL Admin: http://localhost:5050" -ForegroundColor Gray
Write-Host "  MongoDB Admin:    http://localhost:8081" -ForegroundColor Gray
Write-Host "  Redis Admin:      http://localhost:8082" -ForegroundColor Gray

Write-Host "`nMessage Brokers:" -ForegroundColor Cyan
Write-Host "  Kafka UI:         http://localhost:9021" -ForegroundColor Gray
Write-Host "  RabbitMQ Admin:   http://localhost:15672" -ForegroundColor Gray

Write-Host "`nAPI Gateways:" -ForegroundColor Cyan
Write-Host "  MuleSoft Flex:    http://localhost:8090" -ForegroundColor Gray
Write-Host "  AWS API Gateway:  http://localhost:3000" -ForegroundColor Green
Write-Host "  AWS SAM Local:    http://localhost:3002 (when ready)" -ForegroundColor Yellow

Write-Host "`n Quick Health Checks:" -ForegroundColor Yellow

# Test key services
$services = @(
    @{Name="PostgreSQL Admin"; URL="http://localhost:5050"},
    @{Name="MuleSoft Flex Gateway"; URL="http://localhost:8090"},
    @{Name="AWS API Gateway Simulator"; URL="http://localhost:3000/health"}
)

foreach ($service in $services) {
    try {
        $response = Invoke-WebRequest -Uri $service.URL -Method GET -TimeoutSec 3 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host " $($service.Name): Online" -ForegroundColor Green
        } else {
            Write-Host "  $($service.Name): Status $($response.StatusCode)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host " $($service.Name): Offline" -ForegroundColor Red
    }
}
