# Infrastructure management shortcuts for PowerShell profile

# Infrastructure shortcuts
function infra-start { 
    param([string]$Service = "all")
    Set-Location "$env:USERPROFILE\dev\local-infrastructure"
    .\manage-infra.ps1 -Action start -Service $Service
}

function infra-stop { 
    param([string]$Service = "all")
    Set-Location "$env:USERPROFILE\dev\local-infrastructure"
    .\manage-infra.ps1 -Action stop -Service $Service
}

function infra-status { 
    Set-Location "$env:USERPROFILE\dev\local-infrastructure"
    .\manage-infra.ps1 -Action status
}

function infra-logs { 
    param([string]$Service = "all")
    Set-Location "$env:USERPROFILE\dev\local-infrastructure"
    .\manage-infra.ps1 -Action logs -Service $Service
}

function infra-test { 
    Set-Location "$env:USERPROFILE\dev\local-infrastructure"
    .\test-connectivity.ps1
}

function infra-clean { 
    Set-Location "$env:USERPROFILE\dev\local-infrastructure"
    .\manage-infra.ps1 -Action clean
}

# Database shortcuts
function db-connect { 
    if (Get-Command psql -ErrorAction SilentlyContinue) {
        $env:PGPASSWORD = "devpass"
        psql -h localhost -p 5432 -U devuser -d devdb
    } else {
        Write-Host "psql client not found. Install PostgreSQL client tools." -ForegroundColor Red
    }
}

function redis-connect { 
    if (Get-Command redis-cli -ErrorAction SilentlyContinue) {
        redis-cli -h localhost -p 6379 -a devpass
    } else {
        Write-Host "redis-cli not found. Install Redis tools." -ForegroundColor Red
    }
}

# Open management UIs
function open-pgadmin { Start-Process "http://localhost:8080" }
function open-kafka-ui { Start-Process "http://localhost:8081" }
function open-redis-ui { Start-Process "http://localhost:8082" }
function open-rabbitmq-ui { Start-Process "http://localhost:15672" }
