# AWS API Gateway Local Development - Test Script
# Tests both the API Gateway Simulator and AWS SAM Local (when available)

Write-Host " Testing AWS API Gateway Local Development Environment" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Test API Gateway Simulator (Port 3000)
Write-Host "`n Testing API Gateway Simulator (Port 3000)..." -ForegroundColor Yellow

try {
    $health = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method GET
    Write-Host " Health Check: $($health.status)" -ForegroundColor Green
    Write-Host "   Service: $($health.service)" -ForegroundColor Cyan
    Write-Host "   Endpoints Available: $($health.endpoints.Count)" -ForegroundColor Cyan
} catch {
    Write-Host " Health Check Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Hello endpoint
try {
    $hello = Invoke-RestMethod -Uri "http://localhost:3000/hello" -Method GET
    Write-Host " Hello Endpoint: $($hello.message)" -ForegroundColor Green
} catch {
    Write-Host " Hello Endpoint Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Users endpoint
try {
    $users = Invoke-RestMethod -Uri "http://localhost:3000/users" -Method GET
    Write-Host " Users List: Found $($users.count) users" -ForegroundColor Green
    foreach ($user in $users.users) {
        Write-Host "   - $($user.id): $($user.name) ($($user.email))" -ForegroundColor Cyan
    }
} catch {
    Write-Host " Users List Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Create User
try {
    $newUser = @{
        name = "Test User"
        email = "test@example.com"
    } | ConvertTo-Json
    
    $created = Invoke-RestMethod -Uri "http://localhost:3000/users" -Method POST -Body $newUser -ContentType "application/json"
    Write-Host " Create User: $($created.message)" -ForegroundColor Green
    Write-Host "   Created: $($created.user.name) with ID $($created.user.id)" -ForegroundColor Cyan
    $testUserId = $created.user.id
} catch {
    Write-Host " Create User Failed: $($_.Exception.Message)" -ForegroundColor Red
    $testUserId = "1"  # fallback for other tests
}

# Test Get Specific User
try {
    $user = Invoke-RestMethod -Uri "http://localhost:3000/users/$testUserId" -Method GET
    Write-Host " Get User $testUserId : $($user.user.name)" -ForegroundColor Green
} catch {
    Write-Host " Get User Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Update User
try {
    $updateUser = @{
        name = "Updated Test User"
        email = "updated@example.com"
    } | ConvertTo-Json
    
    $updated = Invoke-RestMethod -Uri "http://localhost:3000/users/$testUserId" -Method PUT -Body $updateUser -ContentType "application/json"
    Write-Host " Update User: $($updated.message)" -ForegroundColor Green
} catch {
    Write-Host " Update User Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test AWS SAM Local (Port 3002) if available
Write-Host "`n Testing AWS SAM Local (Port 3002)..." -ForegroundColor Yellow

try {
    $samHealth = Invoke-RestMethod -Uri "http://localhost:3002/health" -Method GET -TimeoutSec 5
    Write-Host " SAM Local Health: Available" -ForegroundColor Green
    
    try {
        $samHello = Invoke-RestMethod -Uri "http://localhost:3002/hello" -Method GET
        Write-Host " SAM Local Hello: $($samHello.message)" -ForegroundColor Green
    } catch {
        Write-Host " SAM Local Hello Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
} catch {
    Write-Host "  SAM Local: Not available (Port 3002 not responding)" -ForegroundColor Yellow
    Write-Host "   This is expected if SAM Local setup is still in progress" -ForegroundColor Gray
}

Write-Host "`n Test Summary:" -ForegroundColor Green
Write-Host "- API Gateway Simulator (Port 3000): Primary local development environment" -ForegroundColor Cyan
Write-Host "- AWS SAM Local (Port 3002): Advanced serverless simulation (when ready)" -ForegroundColor Cyan
Write-Host "- Both services provide the same REST API endpoints for seamless development" -ForegroundColor Cyan

Write-Host "`n Available Endpoints:" -ForegroundColor Green
Write-Host "GET    http://localhost:3000/health      - Health check" -ForegroundColor Cyan
Write-Host "GET    http://localhost:3000/hello       - Hello World" -ForegroundColor Cyan
Write-Host "GET    http://localhost:3000/users       - List users" -ForegroundColor Cyan
Write-Host "POST   http://localhost:3000/users       - Create user" -ForegroundColor Cyan
Write-Host "GET    http://localhost:3000/users/{id}  - Get user" -ForegroundColor Cyan
Write-Host "PUT    http://localhost:3000/users/{id}  - Update user" -ForegroundColor Cyan
Write-Host "DELETE http://localhost:3000/users/{id}  - Delete user" -ForegroundColor Cyan
