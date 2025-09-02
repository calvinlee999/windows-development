# AWS SAM Local API Gateway Test Script
# Test all the API endpoints

Write-Host " Testing AWS SAM Local API Gateway" -ForegroundColor Green
Write-Host "Base URL: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""

# Test Hello World GET
Write-Host "1. Testing Hello World GET..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/hello" -Method GET
    Write-Host " SUCCESS: $($response.message)" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host " FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test Hello World POST
Write-Host "2. Testing Hello World POST..." -ForegroundColor Yellow
try {
    $body = @{
        name = "Developer"
        message = "Testing SAM Local"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:3000/hello" -Method POST -Body $body -ContentType "application/json"
    Write-Host " SUCCESS: $($response.message)" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host " FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test Health Check
Write-Host "3. Testing Health Check..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method GET
    Write-Host " SUCCESS: Status is $($response.status)" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host " FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test User Management APIs
Write-Host "4. Testing User APIs..." -ForegroundColor Yellow

# Get all users
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/users" -Method GET
    Write-Host " Get All Users: Found $($response.data.Count) users" -ForegroundColor Green
} catch {
    Write-Host " Get All Users FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Get specific user
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/users/1" -Method GET
    Write-Host " Get User 1: $($response.data.name)" -ForegroundColor Green
} catch {
    Write-Host " Get User 1 FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

# Create new user
try {
    $newUser = @{
        name = "Test User"
        email = "test@example.com"
        role = "tester"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:3000/users" -Method POST -Body $newUser -ContentType "application/json"
    Write-Host " Create User: Created user with ID $($response.data.id)" -ForegroundColor Green
} catch {
    Write-Host " Create User FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host " AWS SAM Local API Gateway testing completed!" -ForegroundColor Green
Write-Host "API Endpoints available:" -ForegroundColor Cyan
Write-Host "   GET  /hello" -ForegroundColor White
Write-Host "   POST /hello" -ForegroundColor White  
Write-Host "   GET  /health" -ForegroundColor White
Write-Host "   GET  /users" -ForegroundColor White
Write-Host "   GET  /users/{id}" -ForegroundColor White
Write-Host "   POST /users" -ForegroundColor White
Write-Host "   PUT  /users/{id}" -ForegroundColor White
Write-Host "   DELETE /users/{id}" -ForegroundColor White
