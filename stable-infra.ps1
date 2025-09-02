#!/usr/bin/env powershell

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("start", "stop", "restart", "status", "logs", "cleanup", "health")]
    [string]$Action = "status"
)

# Infrastructure Management Script
# Ensures maximum stability and reliability

function Write-Banner {
    Write-Host ""
    Write-Host "  STABLE DEVELOPMENT INFRASTRUCTURE MANAGER" -ForegroundColor Green -BackgroundColor Black
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
}

function Start-Infrastructure {
    Write-Host "🚀 Starting stable development infrastructure..." -ForegroundColor Yellow
    Write-Host ""
    
    # Ensure clean state
    docker-compose down --remove-orphans 2>$null
    
    # Start with dependency resolution
    docker-compose up -d --build --force-recreate
    
    Write-Host ""
    Write-Host " Waiting for services to stabilize..." -ForegroundColor Yellow
    Start-Sleep -Seconds 45
    
    Show-Status
}

function Stop-Infrastructure {
    Write-Host " Stopping development infrastructure..." -ForegroundColor Yellow
    docker-compose down --remove-orphans
    Write-Host " Infrastructure stopped" -ForegroundColor Green
}

function Restart-Infrastructure {
    Write-Host " Restarting development infrastructure..." -ForegroundColor Yellow
    Stop-Infrastructure
    Start-Sleep -Seconds 5
    Start-Infrastructure
}

function Show-Status {
    Write-Host " INFRASTRUCTURE STATUS REPORT" -ForegroundColor Cyan
    Write-Host "===============================" -ForegroundColor Cyan
    Write-Host ""
    
    # Check container status
    $containers = docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | Where-Object { $_ -like "*dev-*" }
    
    if ($containers) {
        Write-Host " RUNNING SERVICES:" -ForegroundColor Green
        Write-Host ""
        
        # Fixed service mapping
        $serviceMap = @{
            "dev-postgres" = "PostgreSQL Database (Port: 5432, UI: 5050)"
            "dev-pgladmin" = "PgAdmin Management (Port: 5050)"
            "dev-mongodb" = "MongoDB Database (Port: 27017, UI: 8081)"
            "dev-mongo-express" = "Mongo Express Management (Port: 8081)"
            "dev-redis" = "Redis Cache (Port: 6379, UI: 8082)"
            "dev-redis-commander" = "Redis Commander Management (Port: 8082)"
            "dev-kafka" = "Apache Kafka (Port: 9092, UI: 9021)"
            "dev-kafka-ui" = "Kafka UI Management (Port: 9021)"
            "dev-rabbitmq" = "RabbitMQ Broker (Port: 5672, UI: 15672)"
            "dev-api-gateway" = "API Gateway (Port: 8090, Management: 8091)"
        }
        
        docker ps --format "{{.Names}}" | Where-Object { $_ -like "dev-*" } | ForEach-Object {
            $serviceName = $serviceMap[$_]
            if ($serviceName) {
                Write-Host "   $serviceName" -ForegroundColor White
            }
        }
        
        Write-Host ""
        Write-Host " STABLE PORT MAPPINGS:" -ForegroundColor Cyan
        Write-Host "  PostgreSQL: localhost:5432 (UI: localhost:5050)" -ForegroundColor White
        Write-Host "  MongoDB: localhost:27017 (UI: localhost:8081)" -ForegroundColor White
        Write-Host "  Redis: localhost:6379 (UI: localhost:8082)" -ForegroundColor White
        Write-Host "  Kafka: localhost:9092 (UI: localhost:9021)" -ForegroundColor White
        Write-Host "  RabbitMQ: localhost:5672 (UI: localhost:15672)" -ForegroundColor White
        Write-Host "  API Gateway: localhost:8090 (Management: localhost:8091)" -ForegroundColor White
        
        Write-Host ""
        Write-Host " CREDENTIALS:" -ForegroundColor Cyan
        Write-Host "  PostgreSQL: devuser/devpass" -ForegroundColor White
        Write-Host "  MongoDB: admin/admin123" -ForegroundColor White
        Write-Host "  Redis: password 'devpass'" -ForegroundColor White
        Write-Host "  RabbitMQ: devuser/devpass" -ForegroundColor White
        Write-Host "  PgAdmin: admin@dev.local/admin123" -ForegroundColor White
        Write-Host "  Mongo Express: admin/admin123" -ForegroundColor White
        Write-Host "  Redis Commander: admin/admin123" -ForegroundColor White
        
    } else {
        Write-Host " No infrastructure services running" -ForegroundColor Red
        Write-Host " Run: .\stable-infra.ps1 start" -ForegroundColor Yellow
    }
}

function Show-Logs {
    Write-Host " Service Logs:" -ForegroundColor Cyan
    docker-compose logs --tail=20 -f
}

function Test-Health {
    Write-Host " HEALTH CHECK REPORT" -ForegroundColor Cyan
    Write-Host "======================" -ForegroundColor Cyan
    Write-Host ""
    
    $healthTests = @(
        @{ Name="PostgreSQL"; URL="http://localhost:5050"; Expected=200 }
        @{ Name="MongoDB UI"; URL="http://localhost:8081"; Expected=401 }  # Expects auth
        @{ Name="Redis UI"; URL="http://localhost:8082"; Expected=200 }
        @{ Name="Kafka UI"; URL="http://localhost:9021"; Expected=200 }
        @{ Name="RabbitMQ UI"; URL="http://localhost:15672"; Expected=200 }
        @{ Name="API Gateway"; URL="http://localhost:8090/health"; Expected=200 }
        @{ Name="Gateway Management"; URL="http://localhost:8091"; Expected=200 }
    )
    
    foreach ($test in $healthTests) {
        try {
            $response = Invoke-WebRequest -Uri $test.URL -TimeoutSec 5 -UseBasicParsing
            if ($response.StatusCode -eq $test.Expected) {
                Write-Host "   $($test.Name): Healthy" -ForegroundColor Green
            } else {
                Write-Host "    $($test.Name): Unexpected status $($response.StatusCode)" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "   $($test.Name): Not responding" -ForegroundColor Red
        }
    }
}

function Clean-Infrastructure {
    Write-Host " Cleaning up infrastructure..." -ForegroundColor Yellow
    docker-compose down --volumes --remove-orphans
    docker system prune -f
    Write-Host " Cleanup complete" -ForegroundColor Green
}

# Main execution
Write-Banner

switch ($Action.ToLower()) {
    "start" { Start-Infrastructure }
    "stop" { Stop-Infrastructure }
    "restart" { Restart-Infrastructure }
    "status" { Show-Status }
    "logs" { Show-Logs }
    "health" { Test-Health }
    "cleanup" { Clean-Infrastructure }
    default { Show-Status }
}
