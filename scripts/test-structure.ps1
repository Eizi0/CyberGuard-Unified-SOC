# 🔍 Script de Test Rapide - CyberGuard Unified SOC (Windows)
# Vérification de la structure et des fichiers avant déploiement

Write-Host "🔍 Vérification de la structure du projet..." -ForegroundColor Cyan

# Fonction pour vérifier un fichier
function Test-FileExists {
    param([string]$Path)
    if (Test-Path $Path -PathType Leaf) {
        Write-Host "   ✅ $Path" -ForegroundColor Green
        return $true
    } else {
        Write-Host "   ❌ $Path (MANQUANT)" -ForegroundColor Red
        return $false
    }
}

# Fonction pour vérifier un dossier
function Test-DirectoryExists {
    param([string]$Path)
    if (Test-Path $Path -PathType Container) {
        Write-Host "   ✅ $Path\" -ForegroundColor Green
        return $true
    } else {
        Write-Host "   ❌ $Path\ (MANQUANT)" -ForegroundColor Red
        return $false
    }
}

# Vérifier le répertoire actuel
$currentDir = Split-Path -Leaf (Get-Location)
if ($currentDir -eq "scripts") {
    Write-Host "📁 Vous êtes dans le dossier scripts" -ForegroundColor Yellow
    Write-Host "   Remontée vers le dossier parent..." -ForegroundColor Yellow
    Set-Location ".."
} elseif ($currentDir -like "*CyberGuard*") {
    Write-Host "📁 Vous êtes dans le dossier racine du projet" -ForegroundColor Green
} else {
    Write-Host "❌ Attention : Vous n'êtes pas dans le bon répertoire" -ForegroundColor Red
    Write-Host "   Assurez-vous d'être dans le dossier CyberGuard Unified SOC" -ForegroundColor Red
}

Write-Host ""
Write-Host "📂 Vérification de la structure des dossiers :" -ForegroundColor Yellow

# Compteur d'erreurs
$errorCount = 0

# Vérification des dossiers principaux
if (-not (Test-DirectoryExists "docker")) { $errorCount++ }
if (-not (Test-DirectoryExists "scripts")) { $errorCount++ }
if (-not (Test-DirectoryExists "frontend")) { $errorCount++ }
if (-not (Test-DirectoryExists "backend")) { $errorCount++ }
if (-not (Test-DirectoryExists "docs")) { $errorCount++ }
if (-not (Test-DirectoryExists "Logo")) { $errorCount++ }

Write-Host ""
Write-Host "📄 Vérification des fichiers de configuration Docker :" -ForegroundColor Yellow

if (-not (Test-FileExists "docker\docker-compose.yml")) { $errorCount++ }
if (-not (Test-FileExists "docker\docker-compose.minimal.yml")) { $errorCount++ }
if (-not (Test-FileExists "docker\docker-compose.dev.yml")) { $errorCount++ }

Write-Host ""
Write-Host "🔧 Vérification des scripts d'automatisation :" -ForegroundColor Yellow

if (-not (Test-FileExists "scripts\auto-deploy.sh")) { $errorCount++ }
if (-not (Test-FileExists "scripts\auto-deploy.ps1")) { $errorCount++ }
if (-not (Test-FileExists "scripts\install.sh")) { $errorCount++ }
if (-not (Test-FileExists "scripts\health-check.sh")) { $errorCount++ }

Write-Host ""
Write-Host "⚙️ Vérification des fichiers de configuration :" -ForegroundColor Yellow

if (-not (Test-FileExists ".env")) { $errorCount++ }
if (-not (Test-FileExists "README.md")) { $errorCount++ }
if (-not (Test-FileExists "frontend\package.json")) { $errorCount++ }
if (-not (Test-FileExists "backend\requirements.txt")) { $errorCount++ }

Write-Host ""
Write-Host "🎨 Vérification des assets logo :" -ForegroundColor Yellow

if (-not (Test-FileExists "Logo\CSU Logo.png")) { $errorCount++ }
if (-not (Test-FileExists "frontend\src\assets\csu-logo.png")) { $errorCount++ }

Write-Host ""
Write-Host "🐳 Vérification de Docker :" -ForegroundColor Yellow

try {
    $dockerVersion = docker --version 2>$null
    if ($dockerVersion) {
        Write-Host "   ✅ Docker est installé" -ForegroundColor Green
        
        try {
            docker version | Out-Null
            Write-Host "   ✅ Docker est démarré et opérationnel" -ForegroundColor Green
            
            # Vérifier docker-compose
            $composeVersion = docker-compose --version 2>$null
            if ($composeVersion) {
                Write-Host "   ✅ Docker Compose est disponible" -ForegroundColor Green
            } else {
                Write-Host "   ❌ Docker Compose n'est pas installé" -ForegroundColor Red
                $errorCount++
            }
        } catch {
            Write-Host "   ❌ Docker n'est pas démarré" -ForegroundColor Red
            Write-Host "      Démarrez Docker Desktop et réessayez" -ForegroundColor White
            $errorCount++
        }
    } else {
        Write-Host "   ❌ Docker n'est pas installé" -ForegroundColor Red
        $errorCount++
    }
} catch {
    Write-Host "   ❌ Docker n'est pas installé ou accessible" -ForegroundColor Red
    $errorCount++
}

Write-Host ""
Write-Host "📊 Résumé de la vérification :" -ForegroundColor Yellow

if ($errorCount -eq 0) {
    Write-Host "🎉 Toutes les vérifications sont passées !" -ForegroundColor Green
    Write-Host "   Votre projet est prêt pour le déploiement." -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Commandes de déploiement disponibles :" -ForegroundColor Cyan
    Write-Host "   powershell -ExecutionPolicy Bypass -File scripts\auto-deploy.ps1    # Déploiement intelligent" -ForegroundColor White
    Write-Host "   powershell -ExecutionPolicy Bypass -File scripts\deploy.ps1         # Déploiement Windows" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Profils disponibles :" -ForegroundColor Cyan
    Write-Host "   docker-compose -f docker\docker-compose.dev.yml up -d      # Développement" -ForegroundColor White
    Write-Host "   docker-compose -f docker\docker-compose.minimal.yml up -d  # Minimal" -ForegroundColor White
    Write-Host "   docker-compose -f docker\docker-compose.yml up -d          # Complet" -ForegroundColor White
} else {
    Write-Host "❌ $errorCount problème(s) détecté(s)" -ForegroundColor Red
    Write-Host "   Corrigez les problèmes avant de continuer." -ForegroundColor Red
    
    if ($errorCount -gt 5) {
        Write-Host ""
        Write-Host "💡 Il semble que des fichiers importants soient manquants." -ForegroundColor Yellow
        Write-Host "   Assurez-vous d'avoir cloné le repository complet :" -ForegroundColor Yellow
        Write-Host "   git clone https://github.com/Eizi0/CyberGuard-Unified-SOC.git" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "📱 Pour plus d'aide :" -ForegroundColor Cyan
Write-Host "   - Documentation : docs\README.md" -ForegroundColor White
Write-Host "   - Guide rapide : docs\quick-start.md" -ForegroundColor White
Write-Host "   - Dépannage : docs\troubleshooting.md" -ForegroundColor White
