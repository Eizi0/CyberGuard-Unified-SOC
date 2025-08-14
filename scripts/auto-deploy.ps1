# 🔍 Détection automatique des ressources et sélection du profil optimal
# CyberGuard Unified SOC - Auto Profile Selector

Write-Host "🔍 Détection des ressources système..." -ForegroundColor Cyan

# Fonction pour obtenir la RAM totale en GB
function Get-TotalRAMInGB {
    $totalRAM = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
    return [Math]::Round($totalRAM / 1GB, 1)
}

# Fonction pour obtenir la RAM disponible en GB
function Get-AvailableRAMInGB {
    $availableRAM = (Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory * 1KB
    return [Math]::Round($availableRAM / 1GB, 1)
}

# Fonction pour obtenir le nombre de cœurs CPU
function Get-CPUCores {
    return (Get-WmiObject -Class Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum
}

# Fonction pour obtenir l'espace disque disponible
function Get-AvailableDiskSpaceInGB {
    $disk = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "C:" }
    return [Math]::Round($disk.FreeSpace / 1GB, 1)
}

# Détection des ressources
$totalRAM = Get-TotalRAMInGB
$availableRAM = Get-AvailableRAMInGB
$cpuCores = Get-CPUCores
$diskSpace = Get-AvailableDiskSpaceInGB

Write-Host "📊 Ressources système détectées :" -ForegroundColor Yellow
Write-Host "   💾 RAM Totale : $totalRAM GB" -ForegroundColor Green
Write-Host "   💾 RAM Disponible : $availableRAM GB" -ForegroundColor Green
Write-Host "   🖥️  Cœurs CPU : $cpuCores" -ForegroundColor Green
Write-Host "   💿 Espace Disque : $diskSpace GB" -ForegroundColor Green
Write-Host ""

# Recommandation de profil basée sur les ressources
$recommendedProfile = ""
$configFile = ""
$warnings = @()

if ($totalRAM -ge 16 -and $cpuCores -ge 8 -and $diskSpace -ge 100) {
    $recommendedProfile = "🚀 COMPLET"
    $configFile = "docker-compose.yml"
    Write-Host "✅ Recommandation : Profil COMPLET" -ForegroundColor Green
    Write-Host "   Tous les 9 outils de sécurité seront déployés" -ForegroundColor White
} elseif ($totalRAM -ge 8 -and $cpuCores -ge 6 -and $diskSpace -ge 50) {
    $recommendedProfile = "⚡ MINIMAL"
    $configFile = "docker-compose.minimal.yml"
    Write-Host "⚠️  Recommandation : Profil MINIMAL" -ForegroundColor Yellow
    Write-Host "   Services core + outils essentiels de sécurité" -ForegroundColor White
    if ($totalRAM -lt 12) { $warnings += "RAM limitée - performances réduites possibles" }
} elseif ($totalRAM -ge 4 -and $cpuCores -ge 4 -and $diskSpace -ge 25) {
    $recommendedProfile = "🏁 DÉVELOPPEMENT"
    $configFile = "docker-compose.dev.yml"
    Write-Host "⚠️  Recommandation : Profil DÉVELOPPEMENT" -ForegroundColor Orange
    Write-Host "   Services essentiels uniquement pour tests" -ForegroundColor White
    $warnings += "Configuration limitée - non recommandée pour production"
    if ($totalRAM -lt 6) { $warnings += "RAM très limitée - instabilité possible" }
} else {
    Write-Host "❌ ERREUR : Ressources insuffisantes" -ForegroundColor Red
    Write-Host "   Minimum requis : 4GB RAM, 4 CPU cores, 25GB disque" -ForegroundColor Red
    Write-Host ""
    Write-Host "🛠️  Solutions recommandées :" -ForegroundColor Yellow
    Write-Host "   1. Augmenter la RAM à 8GB minimum" -ForegroundColor White
    Write-Host "   2. Utiliser une VM avec plus de ressources" -ForegroundColor White
    Write-Host "   3. Déployer sur un serveur dédié" -ForegroundColor White
    exit 1
}

# Affichage des avertissements
if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Avertissements :" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "   • $warning" -ForegroundColor Orange
    }
}

Write-Host ""
Write-Host "🎯 Profil recommandé : $recommendedProfile" -ForegroundColor Cyan
Write-Host "📄 Fichier de configuration : $configFile" -ForegroundColor White

# Menu de choix
Write-Host ""
Write-Host "Que souhaitez-vous faire ?" -ForegroundColor Yellow
Write-Host "1. 🚀 Déployer avec le profil recommandé" -ForegroundColor Green
Write-Host "2. 🔧 Choisir un autre profil manuellement" -ForegroundColor Blue
Write-Host "3. 📊 Voir les détails des profils" -ForegroundColor Cyan
Write-Host "4. ❌ Annuler" -ForegroundColor Red

$choice = Read-Host "Votre choix (1-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🚀 Déploiement du profil $recommendedProfile..." -ForegroundColor Green
        
        # Navigation intelligente vers le dossier docker
        if (Test-Path "docker") {
            Set-Location "docker"
        } elseif (Test-Path "..\docker") {
            Set-Location "..\docker"
        } else {
            Write-Host "❌ Erreur : Dossier docker non trouvé" -ForegroundColor Red
            Write-Host "   Assurez-vous d'être dans le projet CyberGuard" -ForegroundColor White
            exit 1
        }
        
        # Vérifier si Docker est démarré
        try {
            docker version | Out-Null
            Write-Host "✅ Docker est opérationnel" -ForegroundColor Green
        } catch {
            Write-Host "❌ Erreur : Docker n'est pas démarré" -ForegroundColor Red
            Write-Host "   Veuillez démarrer Docker Desktop et réessayer" -ForegroundColor White
            exit 1
        }
        
        # Déployer avec le profil recommandé
        docker-compose -f $configFile up -d
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Déploiement réussi !" -ForegroundColor Green
            Write-Host ""
            Write-Host "🌐 Accès aux services :" -ForegroundColor Cyan
            Write-Host "   Frontend : http://localhost:3000" -ForegroundColor White
            Write-Host "   Backend API : http://localhost:8000" -ForegroundColor White
            if ($configFile -ne "docker-compose.dev.yml") {
                Write-Host "   Graylog : http://localhost:9000" -ForegroundColor White
                Write-Host "   Wazuh : http://localhost:55000" -ForegroundColor White
            }
            
            Write-Host ""
            Write-Host "📝 Commandes utiles :" -ForegroundColor Yellow
            Write-Host "   docker-compose -f $configFile ps" -ForegroundColor Gray
            Write-Host "   docker-compose -f $configFile logs -f" -ForegroundColor Gray
            Write-Host "   docker-compose -f $configFile down" -ForegroundColor Gray
        } else {
            Write-Host "❌ Erreur lors du déploiement" -ForegroundColor Red
            Write-Host "   Consultez les logs : docker-compose -f $configFile logs" -ForegroundColor White
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "🔧 Sélection manuelle du profil :" -ForegroundColor Blue
        Write-Host "1. 🏁 Développement (4-8GB) - docker-compose.dev.yml" -ForegroundColor White
        Write-Host "2. ⚡ Minimal (8-12GB) - docker-compose.minimal.yml" -ForegroundColor White
        Write-Host "3. 🚀 Complet (16GB+) - docker-compose.yml" -ForegroundColor White
        
        $manualChoice = Read-Host "Choisissez un profil (1-3)"
        
        $manualFiles = @{
            "1" = "docker-compose.dev.yml"
            "2" = "docker-compose.minimal.yml" 
            "3" = "docker-compose.yml"
        }
        
        if ($manualFiles.ContainsKey($manualChoice)) {
            $selectedFile = $manualFiles[$manualChoice]
            Write-Host "📄 Profil sélectionné : $selectedFile" -ForegroundColor Green
            
            # Navigation intelligente vers le dossier docker
            if (Test-Path "docker") {
                Set-Location "docker"
            } elseif (Test-Path "..\docker") {
                Set-Location "..\docker"
            } else {
                Write-Host "❌ Erreur : Dossier docker non trouvé" -ForegroundColor Red
                exit 1
            }
            
            docker-compose -f $selectedFile up -d
        } else {
            Write-Host "❌ Choix invalide" -ForegroundColor Red
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "📊 Détails des profils disponibles :" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "🏁 DÉVELOPPEMENT (docker-compose.dev.yml)" -ForegroundColor Yellow
        Write-Host "   RAM : 4-8GB | CPU : 4+ cores | Disque : 25GB" -ForegroundColor Gray
        Write-Host "   Services : Frontend, Backend, MongoDB, Elasticsearch, Wazuh, Graylog" -ForegroundColor Gray
        Write-Host "   Usage : Tests, démonstrations, développement" -ForegroundColor Gray
        Write-Host ""
        Write-Host "⚡ MINIMAL (docker-compose.minimal.yml)" -ForegroundColor Yellow
        Write-Host "   RAM : 8-12GB | CPU : 6+ cores | Disque : 50GB" -ForegroundColor Gray
        Write-Host "   Services : Core + TheHive, configurations optimisées mémoire" -ForegroundColor Gray
        Write-Host "   Usage : PME, environnements contraints, POC" -ForegroundColor Gray
        Write-Host ""
        Write-Host "🚀 COMPLET (docker-compose.yml)" -ForegroundColor Yellow
        Write-Host "   RAM : 16GB+ | CPU : 8+ cores | Disque : 100GB+" -ForegroundColor Gray
        Write-Host "   Services : Tous les 9 outils (Wazuh, Graylog, TheHive, MISP, OpenCTI, etc.)" -ForegroundColor Gray
        Write-Host "   Usage : Production, SOC complet, entreprise" -ForegroundColor Gray
        
        Write-Host ""
        Read-Host "Appuyez sur Entrée pour continuer"
        
        # Relancer le script
        & $MyInvocation.MyCommand.Path
    }
    
    "4" {
        Write-Host "❌ Annulation du déploiement" -ForegroundColor Red
        exit 0
    }
    
    default {
        Write-Host "❌ Choix invalide" -ForegroundColor Red
        exit 1
    }
}
