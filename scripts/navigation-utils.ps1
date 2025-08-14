# Fonctions utilitaires pour la navigation intelligente - CyberGuard Unified SOC
# Source: scripts\navigation-utils.ps1

# Fonction pour naviguer intelligemment vers le dossier docker
function Navigate-ToDocker {
    if (Test-Path "docker") {
        Write-Host "🗂️  Navigation vers .\docker" -ForegroundColor Cyan
        Set-Location "docker"
        return $true
    } elseif (Test-Path "..\docker") {
        Write-Host "🗂️  Navigation vers ..\docker" -ForegroundColor Cyan
        Set-Location "..\docker"
        return $true
    } else {
        Write-Host "❌ Erreur : Dossier docker non trouvé" -ForegroundColor Red
        Write-Host "   Structure attendue :" -ForegroundColor White
        Write-Host "   - Si vous êtes à la racine : .\docker\" -ForegroundColor White
        Write-Host "   - Si vous êtes dans scripts\ : ..\docker\" -ForegroundColor White
        return $false
    }
}

# Fonction pour naviguer vers le dossier de sauvegarde
function Navigate-ToBackups {
    if (Test-Path "backups") {
        Write-Host "🗂️  Utilisation de .\backups" -ForegroundColor Cyan
        return $true
    } elseif (Test-Path "..\backups") {
        Write-Host "🗂️  Utilisation de ..\backups" -ForegroundColor Cyan
        return $true
    } else {
        Write-Host "🗂️  Création du dossier backups" -ForegroundColor Cyan
        try {
            if (Test-Path ".") {
                New-Item -ItemType Directory -Path "backups" -Force | Out-Null
            } elseif (Test-Path "..") {
                New-Item -ItemType Directory -Path "..\backups" -Force | Out-Null
            }
            return $true
        } catch {
            Write-Host "❌ Erreur : Impossible de créer le dossier backups" -ForegroundColor Red
            return $false
        }
    }
}

# Fonction pour retourner à la racine du projet
function Navigate-ToRoot {
    if ((Test-Path "README.md") -and (Test-Path "scripts") -and (Test-Path "docker")) {
        Write-Host "🗂️  Déjà à la racine du projet" -ForegroundColor Cyan
        return $true
    } elseif ((Test-Path "..\README.md") -and (Test-Path "..\scripts") -and (Test-Path "..\docker")) {
        Write-Host "🗂️  Navigation vers la racine du projet" -ForegroundColor Cyan
        Set-Location ".."
        return $true
    } else {
        Write-Host "❌ Erreur : Impossible de localiser la racine du projet" -ForegroundColor Red
        return $false
    }
}

# Fonction pour détecter la position actuelle
function Get-ProjectLocation {
    if ((Test-Path "README.md") -and (Test-Path "scripts") -and (Test-Path "docker")) {
        return "root"
    } elseif ((Test-Path "..\README.md") -and (Test-Path "..\scripts") -and (Test-Path "..\docker")) {
        return "subdirectory"
    } else {
        return "unknown"
    }
}

# Fonction pour afficher l'aide de navigation
function Show-NavigationHelp {
    Write-Host "📍 AIDE NAVIGATION" -ForegroundColor Blue
    Write-Host "Structure du projet CyberGuard Unified SOC :" -ForegroundColor White
    Write-Host "├── scripts\     # Scripts d'automatisation" -ForegroundColor White
    Write-Host "├── docker\      # Configurations Docker" -ForegroundColor White
    Write-Host "├── backups\     # Sauvegardes (auto-créé)" -ForegroundColor White
    Write-Host "└── README.md    # Documentation" -ForegroundColor White
    Write-Host ""
    Write-Host "Exécution recommandée :" -ForegroundColor White
    Write-Host " - Depuis la racine : .\scripts\script-name.ps1" -ForegroundColor White
    Write-Host " - Les scripts naviguent automatiquement" -ForegroundColor White
}
