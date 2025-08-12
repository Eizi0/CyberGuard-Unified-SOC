# Script de validation pour CyberGuard Unified SOC
# Compatible avec Windows PowerShell

Write-Host "=== Validation des Services CyberGuard ===" -ForegroundColor Green

Set-Location docker

# Fonction pour tester un service HTTP
function Test-ServiceHealth {
    param(
        [string]$ServiceName,
        [string]$Url,
        [int]$ExpectedStatusCode = 200
    )
    
    try {
        $response = Invoke-WebRequest -Uri $Url -Method GET -TimeoutSec 10 -UseBasicParsing
        if ($response.StatusCode -eq $ExpectedStatusCode) {
            Write-Host "✓ $ServiceName - OK" -ForegroundColor Green
            return $true
        } else {
            Write-Host "✗ $ServiceName - Status Code: $($response.StatusCode)" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "✗ $ServiceName - Erreur: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Vérification de l'état des conteneurs
Write-Host "`n--- État des Conteneurs ---" -ForegroundColor Yellow
$containers = docker-compose ps --format "table {{.Name}}\t{{.State}}\t{{.Ports}}"
Write-Host $containers

# Tests de santé des services
Write-Host "`n--- Tests de Santé ---" -ForegroundColor Yellow

$services = @(
    @{Name="Backend API"; Url="http://localhost:8000/health"},
    @{Name="Frontend"; Url="http://localhost:3000"},
    @{Name="Graylog"; Url="http://localhost:9000"},
    @{Name="TheHive"; Url="http://localhost:9001"},
    @{Name="OpenCTI"; Url="http://localhost:8080"},
    @{Name="Velociraptor"; Url="http://localhost:8889"},
    @{Name="Elasticsearch"; Url="http://localhost:9200"},
    @{Name="MongoDB"; Url="http://localhost:27017"; ExpectedStatusCode=200}
)

$healthyServices = 0
$totalServices = $services.Count

foreach ($service in $services) {
    if (Test-ServiceHealth -ServiceName $service.Name -Url $service.Url -ExpectedStatusCode ($service.ExpectedStatusCode ?? 200)) {
        $healthyServices++
    }
    Start-Sleep -Seconds 1
}

# Résumé
Write-Host "`n--- Résumé ---" -ForegroundColor Yellow
Write-Host "Services fonctionnels: $healthyServices/$totalServices" -ForegroundColor $(if ($healthyServices -eq $totalServices) { "Green" } else { "Red" })

if ($healthyServices -eq $totalServices) {
    Write-Host "`n✓ Tous les services sont opérationnels !" -ForegroundColor Green
} else {
    Write-Host "`n⚠ Certains services nécessitent une attention" -ForegroundColor Yellow
    Write-Host "Consultez les logs avec: docker-compose logs [service_name]" -ForegroundColor Cyan
}

# Informations d'accès
Write-Host "`n--- Accès aux Services ---" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:3000"
Write-Host "Backend API: http://localhost:8000"
Write-Host "API Docs: http://localhost:8000/docs"
Write-Host "Graylog: http://localhost:9000 (admin/admin)"
Write-Host "TheHive: http://localhost:9001"
Write-Host "MISP: https://localhost:443"
Write-Host "OpenCTI: http://localhost:8080"
Write-Host "Velociraptor: http://localhost:8889"
Write-Host "Shuffle: https://localhost:3443"

Set-Location ..
