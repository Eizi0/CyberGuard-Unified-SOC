# Script de diagnostic PowerShell pour Velociraptor et Shuffle
# ===========================================================

param(
    [switch]$Verbose,
    [switch]$FixPermissions,
    [switch]$Rebuild
)

function Write-Header {
    param($Message)
    Write-Host "`n" -NoNewline
    Write-Host "=" * 50 -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Yellow
    Write-Host "=" * 50 -ForegroundColor Cyan
}

function Test-DockerService {
    param($ServiceName, $ContainerName, $Port, $HealthEndpoint = "/health")
    
    Write-Header "Diagnostic $ServiceName ($ContainerName)"
    
    # Vérifier si le conteneur existe
    $containerExists = docker ps -a --format "{{.Names}}" | Where-Object { $_ -eq $ContainerName }
    
    if ($containerExists) {
        Write-Host "✅ Conteneur trouvé: $ContainerName" -ForegroundColor Green
        
        # Vérifier l'état
        $containerStatus = docker inspect --format='{{.State.Status}}' $ContainerName 2>$null
        Write-Host "📊 État: $containerStatus" -ForegroundColor Blue
        
        if ($containerStatus -eq "running") {
            Write-Host "✅ Conteneur en cours d'exécution" -ForegroundColor Green
            
            # Tester la connectivité
            try {
                $response = Invoke-WebRequest -Uri "http://localhost:$Port$HealthEndpoint" -TimeoutSec 5 -ErrorAction Stop
                Write-Host "✅ Service accessible sur le port $Port" -ForegroundColor Green
            }
            catch {
                Write-Host "❌ Service non accessible sur le port $Port" -ForegroundColor Red
                Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Yellow
            }
            
        } elseif ($containerStatus -eq "exited") {
            Write-Host "❌ Conteneur arrêté" -ForegroundColor Red
            Write-Host "📜 Derniers logs:" -ForegroundColor Yellow
            docker logs --tail 10 $ContainerName
            
        } else {
            Write-Host "⚠️  État inconnu: $containerStatus" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "❌ Conteneur non trouvé: $ContainerName" -ForegroundColor Red
    }
}

function Test-FileStructure {
    Write-Header "Vérification de la structure des fichiers"
    
    $files = @(
        @{ Path = "velociraptor\Dockerfile"; Name = "Velociraptor Dockerfile" },
        @{ Path = "velociraptor\config\server.config.yaml"; Name = "Velociraptor Config" },
        @{ Path = "velociraptor\init-velociraptor.sh"; Name = "Velociraptor Init Script" },
        @{ Path = "shuffle\Dockerfile"; Name = "Shuffle Dockerfile" },
        @{ Path = "shuffle\config\shuffle-config.yaml"; Name = "Shuffle Config" },
        @{ Path = "shuffle\init-shuffle.sh"; Name = "Shuffle Init Script" }
    )
    
    foreach ($file in $files) {
        if (Test-Path $file.Path) {
            Write-Host "✅ $($file.Name)" -ForegroundColor Green
            if ($Verbose) {
                $size = (Get-Item $file.Path).Length
                Write-Host "   Taille: $size bytes" -ForegroundColor Gray
            }
        } else {
            Write-Host "❌ $($file.Name) - $($file.Path)" -ForegroundColor Red
        }
    }
}

function Test-DockerEnvironment {
    Write-Header "Environnement Docker"
    
    # Vérifier Docker
    try {
        $dockerVersion = docker --version 2>$null
        Write-Host "✅ Docker: $dockerVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Docker non installé ou non accessible" -ForegroundColor Red
        return $false
    }
    
    # Vérifier Docker Compose
    try {
        $composeVersion = docker-compose --version 2>$null
        Write-Host "✅ Docker Compose: $composeVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Docker Compose non installé" -ForegroundColor Red
    }
    
    # Vérifier le daemon Docker
    try {
        docker info 2>$null | Out-Null
        Write-Host "✅ Docker daemon accessible" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Docker daemon non accessible" -ForegroundColor Red
        return $false
    }
}

function Show-ContainerSummary {
    Write-Header "Résumé des conteneurs"
    
    Write-Host "Conteneurs liés à Velociraptor et Shuffle:" -ForegroundColor Blue
    docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | Select-String -Pattern "(velociraptor|shuffle)"
    
    Write-Host "`nTous les conteneurs:" -ForegroundColor Blue
    docker ps -a --format "table {{.Names}}\t{{.Status}}"
}

function Fix-Permissions {
    Write-Header "Correction des permissions"
    
    if ($FixPermissions) {
        Write-Host "🔧 Correction des permissions des scripts..." -ForegroundColor Blue
        
        $scripts = @(
            "velociraptor\init-velociraptor.sh",
            "shuffle\init-shuffle.sh"
        )
        
        foreach ($script in $scripts) {
            if (Test-Path $script) {
                # Sur Windows, on ne peut pas vraiment changer les permissions Unix
                # mais on peut vérifier que le fichier existe et est lisible
                Write-Host "✅ Script trouvé: $script" -ForegroundColor Green
            }
        }
    }
}

function Rebuild-Images {
    if ($Rebuild) {
        Write-Header "Reconstruction des images"
        
        Write-Host "🔨 Reconstruction de l'image Velociraptor..." -ForegroundColor Blue
        docker-compose build velociraptor
        
        Write-Host "🔨 Reconstruction de l'image Shuffle..." -ForegroundColor Blue
        docker-compose build shuffle
        
        Write-Host "✅ Images reconstruites" -ForegroundColor Green
    }
}

function Show-TroubleshootingCommands {
    Write-Header "Commandes de dépannage"
    
    Write-Host "📋 Commandes utiles:" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Reconstruire les images:" -ForegroundColor Yellow
    Write-Host "  docker-compose build velociraptor shuffle" -ForegroundColor White
    Write-Host ""
    Write-Host "Redémarrer les services:" -ForegroundColor Yellow
    Write-Host "  docker-compose restart velociraptor shuffle" -ForegroundColor White
    Write-Host ""
    Write-Host "Voir les logs:" -ForegroundColor Yellow
    Write-Host "  docker-compose logs velociraptor" -ForegroundColor White
    Write-Host "  docker-compose logs shuffle" -ForegroundColor White
    Write-Host ""
    Write-Host "Démarrer en mode debug:" -ForegroundColor Yellow
    Write-Host "  docker-compose up velociraptor shuffle" -ForegroundColor White
    Write-Host ""
    Write-Host "Arrêter et supprimer les conteneurs:" -ForegroundColor Yellow
    Write-Host "  docker-compose down" -ForegroundColor White
    Write-Host "  docker-compose up -d velociraptor shuffle" -ForegroundColor White
}

# Main execution
Write-Host "🛡️  CyberGuard Unified SOC - Diagnostic Velociraptor & Shuffle" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# Vérifier l'environnement Docker
if (-not (Test-DockerEnvironment)) {
    Write-Host "❌ Environnement Docker non disponible. Installation requise." -ForegroundColor Red
    exit 1
}

# Vérifier la structure des fichiers
Test-FileStructure

# Corriger les permissions si demandé
Fix-Permissions

# Reconstruire les images si demandé
Rebuild-Images

# Tester les services
Test-DockerService "Velociraptor" "velociraptor" "8889"
Test-DockerService "Shuffle" "shuffle" "3443"

# Résumé des conteneurs
Show-ContainerSummary

# Commandes de dépannage
Show-TroubleshootingCommands

Write-Host "`n✅ Diagnostic terminé" -ForegroundColor Green
Write-Host "💡 Utilisez les commandes ci-dessus pour résoudre les problèmes identifiés" -ForegroundColor Blue
