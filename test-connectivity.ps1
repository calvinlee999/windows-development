#!/usr/bin/env pwsh
# Infrastructure Connectivity Test Script
Write-Host "Testing Local Development Infrastructure..." -ForegroundColor Cyan

# Test Database Connections
Write-Host "`nTesting Database Connections:" -ForegroundColor Yellow

# PostgreSQL Test
try {
    $pgResult = Test-NetConnection -ComputerName localhost -Port 5432 -WarningAction SilentlyContinue
    if ($pgResult.TcpTestSucceeded) {
        Write-Host " PostgreSQL: Connected (localhost:5432)" -ForegroundColor Green
    } else {
        Write-Host " PostgreSQL: Failed to connect" -ForegroundColor Red
    }
} catch {
    Write-Host " PostgreSQL: Connection error" -ForegroundColor Red
}

# MongoDB Test
try {
    $mongoResult = Test-NetConnection -ComputerName localhost -Port 27017 -WarningAction SilentlyContinue
    if ($mongoResult.TcpTestSucceeded) {
        Write-Host " MongoDB: Connected (localhost:27017)" -ForegroundColor Green
    } else {
        Write-Host " MongoDB: Failed to connect" -ForegroundColor Red
    }
} catch {
    Write-Host " MongoDB: Connection error" -ForegroundColor Red
}

# Test Message Brokers
Write-Host "`nTesting Message Brokers:" -ForegroundColor Yellow

# Kafka Test
try {
    $kafkaResult = Test-NetConnection -ComputerName localhost -Port 9092 -WarningAction SilentlyContinue
    if ($kafkaResult.TcpTestSucceeded) {
        Write-Host " Kafka: Connected (localhost:9092)" -ForegroundColor Green
    } else {
        Write-Host " Kafka: Failed to connect" -ForegroundColor Red
    }
} catch {
    Write-Host " Kafka: Connection error" -ForegroundColor Red
}

# RabbitMQ Test
try {
    $rabbitResult = Test-NetConnection -ComputerName localhost -Port 5672 -WarningAction SilentlyContinue
    if ($rabbitResult.TcpTestSucceeded) {
        Write-Host " RabbitMQ: Connected (localhost:5672)" -ForegroundColor Green
    } else {
        Write-Host " RabbitMQ: Failed to connect" -ForegroundColor Red
    }
} catch {
    Write-Host " RabbitMQ: Connection error" -ForegroundColor Red
}

# Redis Test
try {
    $redisResult = Test-NetConnection -ComputerName localhost -Port 6379 -WarningAction SilentlyContinue
    if ($redisResult.TcpTestSucceeded) {
        Write-Host " Redis: Connected (localhost:6379)" -ForegroundColor Green
    } else {
        Write-Host " Redis: Failed to connect" -ForegroundColor Red
    }
} catch {
    Write-Host " Redis: Connection error" -ForegroundColor Red
}

# Test Web UIs
Write-Host "`nTesting Web Management UIs:" -ForegroundColor Yellow

$webServices = @(
    @{ Name = "PgAdmin"; Port = 8080; Url = "http://localhost:8080" },
    @{ Name = "Mongo Express"; Port = 8083; Url = "http://localhost:8083" },
    @{ Name = "Kafka UI"; Port = 8081; Url = "http://localhost:8081" },
    @{ Name = "RabbitMQ UI"; Port = 15672; Url = "http://localhost:15672" },
    @{ Name = "Redis UI"; Port = 8082; Url = "http://localhost:8082" }
)

foreach ($service in $webServices) {
    try {
        $webResult = Test-NetConnection -ComputerName localhost -Port $service.Port -WarningAction SilentlyContinue
        if ($webResult.TcpTestSucceeded) {
            Write-Host " $($service.Name): Available at $($service.Url)" -ForegroundColor Green
        } else {
            Write-Host " $($service.Name): Not accessible" -ForegroundColor Red
        }
    } catch {
        Write-Host " $($service.Name): Connection error" -ForegroundColor Red
    }
}

Write-Host "`nInfrastructure test completed!" -ForegroundColor Cyan
