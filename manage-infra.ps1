#!/usr/bin/env pwsh
# Local Development Infrastructure Manager
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("start", "stop", "restart", "status", "logs", "clean", "help")]
    [string]$Action,
    [string]$Service = "all",
    [ValidateSet("docker", "k8s")]
    [string]$Platform = "docker"
)

function Show-Help {
    Write-Host "Local Development Infrastructure Manager" -ForegroundColor Cyan
    Write-Host "Actions: start, stop, restart, status, logs, clean, help" -ForegroundColor Yellow
    Write-Host "Services: all, postgres, mongodb, kafka, rabbitmq, redis" -ForegroundColor Yellow
    Write-Host "Platforms: docker, k8s" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Green
    Write-Host "  .\manage-infra.ps1 -Action start" -ForegroundColor White
    Write-Host "  .\manage-infra.ps1 -Action start -Service mongodb" -ForegroundColor White
    Write-Host "  .\manage-infra.ps1 -Action status" -ForegroundColor White
}

function Show-ServiceInfo {
    Write-Host "Local Development Services:" -ForegroundColor Cyan
    Write-Host "PostgreSQL: localhost:5432 (devuser/devpass)" -ForegroundColor White
    Write-Host "PgAdmin: http://localhost:8080" -ForegroundColor White
    Write-Host "MongoDB: localhost:27017 (devuser/devpass)" -ForegroundColor White
    Write-Host "Mongo Express: http://localhost:8083 (admin/admin123)" -ForegroundColor White
    Write-Host "Kafka: localhost:9092" -ForegroundColor White
    Write-Host "Kafka UI: http://localhost:8081" -ForegroundColor White
    Write-Host "RabbitMQ: localhost:5672 (devuser/devpass)" -ForegroundColor White
    Write-Host "RabbitMQ UI: http://localhost:15672" -ForegroundColor White
    Write-Host "Redis: localhost:6379 (devpass)" -ForegroundColor White
    Write-Host "Redis UI: http://localhost:8082" -ForegroundColor White
}

switch ($Action.ToLower()) {
    "help" { Show-Help }
    "start" {
        Write-Host "Starting services..." -ForegroundColor Green
        if ($Platform -eq "k8s") {
            kubectl apply -f k8s/
        } else {
            if ($Service -eq "all") { docker-compose up -d } 
            else { docker-compose up -d $Service }
        }
        Show-ServiceInfo
    }
    "stop" {
        Write-Host "Stopping services..." -ForegroundColor Yellow
        if ($Platform -eq "k8s") {
            kubectl delete -f k8s/
        } else {
            if ($Service -eq "all") { docker-compose down } 
            else { docker-compose stop $Service }
        }
    }
    "status" {
        if ($Platform -eq "k8s") {
            kubectl get all -n local-dev
        } else {
            docker-compose ps
        }
    }
    "logs" {
        if ($Platform -eq "k8s") {
            if ($Service -eq "all") {
                kubectl logs -n local-dev --selector=app --tail=50
            } else {
                kubectl logs -n local-dev -l app=$Service --tail=50
            }
        } else {
            if ($Service -eq "all") { docker-compose logs --tail=50 }
            else { docker-compose logs --tail=50 $Service }
        }
    }
    "restart" {
        & $PSCommandPath -Action stop -Service $Service -Platform $Platform
        Start-Sleep -Seconds 3
        & $PSCommandPath -Action start -Service $Service -Platform $Platform
    }
    "clean" {
        Write-Host "Cleaning environment..." -ForegroundColor Red
        $confirm = Read-Host "This will remove all containers and volumes. Continue? (y/N)"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            docker-compose down -v --remove-orphans
            Write-Host "Environment cleaned!" -ForegroundColor Green
        } else {
            Write-Host "Cancelled" -ForegroundColor Yellow
        }
    }
}
