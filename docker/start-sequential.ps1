# Script PowerShell de démarrage séquentiel pour CyberGuard Unified SOC
# =====================================================================

param(
    [switch]$Force,
    [switch]$SkipChecks
)

function Write-Header {
    param($Message)
    Write-Host "`n" -NoNewline
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Yellow
    Write-Host "=" * 60 -ForegroundColor Cyan
}

function Wait-ForService {
    param($ServiceName, $Port, $MaxAttempts = 30)
    
    Write-Host "⏳ Attente de $ServiceName sur le port $Port..." -ForegroundColor Blue
    
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:$Port" -TimeoutSec 5 -ErrorAction Stop
            Write-Host "✅ $ServiceName est prêt" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "   Tentative $attempt/$MaxAttempts..." -ForegroundColor Gray
            Start-Sleep -Seconds 10
        }
    }
    
    Write-Host "❌ $ServiceName n'est pas prêt après $MaxAttempts tentatives" -ForegroundColor Red
    return $false
}

Write-Header "Démarrage de CyberGuard Unified SOC"

# Vérifier Docker
try {
    docker --version | Out-Null
    docker-compose --version | Out-Null
}
catch {
    Write-Host "❌ Docker ou Docker Compose non disponible" -ForegroundColor Red
    exit 1
}

# Naviguer vers le dossier docker
$dockerPath = Join-Path $PSScriptRoot ""
if (-not (Test-Path $dockerPath)) {
    Write-Host "❌ Dossier docker non trouvé" -ForegroundColor Red
    exit 1
}

Set-Location $dockerPath

# Arrêter les services existants si Force
if ($Force) {
    Write-Header "Arrêt des services existants"
    docker-compose down
}

# Étape 1: Services de base de données
Write-Header "ÉTAPE 1 - Services de base de données"
Write-Host "🗄️  Démarrage des bases de données..." -ForegroundColor Blue

docker-compose up -d mongodb elasticsearch redis misp-db

Write-Host "⏳ Attente de l'initialisation des bases de données..." -ForegroundColor Blue
Start-Sleep -Seconds 30

if (-not $SkipChecks) {
    if (-not (Wait-ForService "Elasticsearch" "9200")) {
        Write-Host "❌ Échec du démarrage d'Elasticsearch" -ForegroundColor Red
        exit 1
    }
}

# Étape 2: Services principaux
Write-Header "ÉTAPE 2 - Services principaux"
Write-Host "🎯 Démarrage du backend..." -ForegroundColor Blue

docker-compose up -d backend

if (-not $SkipChecks) {
    if (-not (Wait-ForService "Backend API" "8000")) {
        Write-Host "❌ Échec du démarrage du Backend" -ForegroundColor Red
        exit 1
    }
}

Write-Host "🌐 Démarrage du frontend..." -ForegroundColor Blue
docker-compose up -d frontend

if (-not $SkipChecks) {
    if (-not (Wait-ForService "Frontend" "3000")) {
        Write-Host "❌ Échec du démarrage du Frontend" -ForegroundColor Red
        exit 1
    }
}

# Étape 3: Outils de sécurité
Write-Header "ÉTAPE 3 - Outils de sécurité"

$securityServices = @(
    @{ Name = "Wazuh Manager"; Service = "wazuh-manager"; Port = "55000"; Wait = 15 },
    @{ Name = "Graylog"; Service = "graylog"; Port = "9000"; Wait = 20 },
    @{ Name = "TheHive"; Service = "thehive"; Port = "9001"; Wait = 15 },
    @{ Name = "MISP"; Service = "misp"; Port = "80"; Wait = 20 },
    @{ Name = "OpenCTI"; Service = "opencti"; Port = "8080"; Wait = 20 },
    @{ Name = "Velociraptor"; Service = "velociraptor"; Port = "8889"; Wait = 15 },
    @{ Name = "Shuffle"; Service = "shuffle"; Port = "3443"; Wait = 20 }
)

foreach ($service in $securityServices) {
    Write-Host "🛡️  Démarrage de $($service.Name)..." -ForegroundColor Blue
    docker-compose up -d $service.Service
    Start-Sleep -Seconds $service.Wait
}

# Vérification finale
Write-Header "Vérification finale"
Write-Host "📊 État des conteneurs:" -ForegroundColor Blue
docker-compose ps

Write-Header "Interfaces Web disponibles"
$urls = @(
    "Frontend (React)     : http://localhost:3000",
    "Backend API          : http://localhost:8000",
    "Wazuh Manager        : http://localhost:55000",
    "Graylog              : http://localhost:9000",
    "TheHive              : http://localhost:9001",
    "MISP                 : http://localhost (port 80/443)",
    "OpenCTI              : http://localhost:8080",
    "Velociraptor         : http://localhost:8889",
    "Shuffle              : http://localhost:3443",
    "Elasticsearch        : http://localhost:9200"
)

foreach ($url in $urls) {
    Write-Host $url -ForegroundColor Green
}

Write-Host "`n✅ Démarrage terminé !" -ForegroundColor Green
Write-Host "💡 Utilisez .\diagnose-containers.bat pour vérifier l'état des services" -ForegroundColor Blue
