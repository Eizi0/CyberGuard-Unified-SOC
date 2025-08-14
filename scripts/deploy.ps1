# Script de déploiement PowerShell pour CyberGuard Unified SOC
# Compatible avec Windows

Write-Host "=== CyberGuard Unified SOC Deployment Script ===" -ForegroundColor Green

# Vérification des prérequis
Write-Host "Vérification de Docker..." -ForegroundColor Yellow
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Erreur: Docker n'est pas installé" -ForegroundColor Red
    exit 1
}

Write-Host "Vérification de Docker Compose..." -ForegroundColor Yellow
if (!(Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "Erreur: Docker Compose n'est pas installé" -ForegroundColor Red
    exit 1
}

# Vérification du fichier .env
if (!(Test-Path ".env")) {
    Write-Host "Erreur: Fichier .env non trouvé" -ForegroundColor Red
    exit 1
}

# Arrêt des services existants
Write-Host "Arrêt des services existants..." -ForegroundColor Yellow

# Navigation intelligente vers le dossier docker
if (Test-Path "docker") {
    Set-Location "docker"
} elseif (Test-Path "..\docker") {
    Set-Location "..\docker"
} else {
    Write-Host "Erreur: Dossier docker non trouvé" -ForegroundColor Red
    exit 1
}

docker-compose down -v

# Nettoyage des volumes orphelins
Write-Host "Nettoyage des volumes orphelins..." -ForegroundColor Yellow
docker volume prune -f

# Construction des images
Write-Host "Construction des images Docker..." -ForegroundColor Yellow
docker-compose build --no-cache

# Démarrage des services de base de données
Write-Host "Démarrage des services de base de données..." -ForegroundColor Yellow
docker-compose up -d mongodb elasticsearch redis misp-db
Start-Sleep -Seconds 45

# Vérification de l'état des bases de données
Write-Host "Vérification de l'état des bases de données..." -ForegroundColor Yellow
$mongoStatus = docker-compose exec -T mongodb mongo --eval "db.adminCommand('ping')" 2>$null
$elasticStatus = Invoke-RestMethod -Uri "http://localhost:9200/_cluster/health" -Method GET -ErrorAction SilentlyContinue

if ($mongoStatus -and $elasticStatus) {
    Write-Host "Bases de données prêtes" -ForegroundColor Green
} else {
    Write-Host "Attente supplémentaire pour les bases de données..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
}

# Démarrage du backend
Write-Host "Démarrage du backend..." -ForegroundColor Yellow
docker-compose up -d backend
Start-Sleep -Seconds 20

# Démarrage du frontend
Write-Host "Démarrage du frontend..." -ForegroundColor Yellow
docker-compose up -d frontend
Start-Sleep -Seconds 15

# Démarrage des autres services
Write-Host "Démarrage des services de sécurité..." -ForegroundColor Yellow
docker-compose up -d wazuh-manager graylog thehive misp opencti velociraptor shuffle

# Vérification finale
Write-Host "Vérification finale des services..." -ForegroundColor Yellow
Start-Sleep -Seconds 30
docker-compose ps

Write-Host "=== Déploiement terminé ===" -ForegroundColor Green
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host "Backend API: http://localhost:8000" -ForegroundColor Cyan
Write-Host "Graylog: http://localhost:9000" -ForegroundColor Cyan
Write-Host "TheHive: http://localhost:9001" -ForegroundColor Cyan
Write-Host "MISP: https://localhost:443" -ForegroundColor Cyan
Write-Host "OpenCTI: http://localhost:8080" -ForegroundColor Cyan
Write-Host "Velociraptor: http://localhost:8889" -ForegroundColor Cyan
Write-Host "Shuffle: https://localhost:3443" -ForegroundColor Cyan

# Retour au répertoire d'origine
if (Test-Path "..\scripts\deploy.ps1") {
    Set-Location ".."
} elseif (Test-Path "..\..\scripts\deploy.ps1") {
    Set-Location "..\.."
}
