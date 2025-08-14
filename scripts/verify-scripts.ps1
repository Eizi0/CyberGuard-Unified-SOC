# Script de vérification de la cohérence des scripts CyberGuard Unified SOC
# Vérifie que tous les scripts respectent la structure d'arborescence

# Colors
function Write-Header { param($Message) Write-Host "`n=== $Message ===" -ForegroundColor Blue }
function Write-Success { param($Message) Write-Host "[OK] $Message" -ForegroundColor Green }
function Write-Warning { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }

# Compteurs
$TotalScripts = 0
$CorrectScripts = 0
$IncorrectScripts = 0

Write-Header "VÉRIFICATION DE LA COHÉRENCE DES SCRIPTS"

# Fonction pour vérifier un script
function Test-Script {
    param(
        [string]$ScriptFile,
        [string]$ScriptType
    )
    
    $script:TotalScripts++
    
    if (-not (Test-Path $ScriptFile)) {
        Write-Error "Script non trouvé: $ScriptFile"
        $script:IncorrectScripts++
        return
    }
    
    Write-Host "`nVérification: $ScriptFile" -ForegroundColor Yellow
    
    $issues = 0
    $content = Get-Content $ScriptFile -Raw
    
    if ($ScriptType -eq "powershell") {
        # Vérifier les références au dossier docker (accepter la navigation intelligente)
        if ($content -match 'Set-Location\s+"docker"' -and $content -notmatch 'Test-Path.*docker.*Set-Location') {
            Write-Error "Utilise 'Set-Location `"docker`"' sans navigation intelligente"
            $issues++
        } elseif ($content -match 'Test-Path.*docker.*Set-Location.*docker') {
            Write-Success "Utilise la navigation intelligente vers docker"
        }
        
        # Vérifier les chemins Windows
        if ($content -match 'docker\\') {
            Write-Success "Utilise les bons séparateurs de chemin Windows"
        }
        
        # Vérifier docker-compose
        if ($content -match 'docker-compose') {
            Write-Success "Utilise docker-compose"
        }
        
    } elseif ($ScriptType -eq "bash") {
        # Vérifier les références au dossier docker (accepter la navigation intelligente)
        if ($content -match 'cd docker[^/]' -and $content -notmatch 'if.*-d.*docker.*cd docker') {
            Write-Error "Utilise 'cd docker' sans navigation intelligente"
            $issues++
        } elseif ($content -match 'if.*-d.*docker.*cd docker') {
            Write-Success "Utilise la navigation intelligente vers docker"
        }
        
        # Vérifier les chemins relatifs vers les backups (accepter la navigation intelligente)
        if ($content -match '\./backups' -and $content -notmatch '\.\./backups') {
            Write-Warning "Utilise './backups' au lieu de '../backups'"
            $issues++
        }
    }
    
    if ($issues -eq 0) {
        Write-Success "Script conforme à la structure"
        $script:CorrectScripts++
    } else {
        Write-Error "Script avec $issues problème(s)"
        $script:IncorrectScripts++
    }
}

# Vérification des scripts PowerShell
Write-Header "SCRIPTS POWERSHELL (.ps1)"
Get-ChildItem "scripts\*.ps1" | Where-Object { $_.Name -ne "verify-scripts.ps1" } | ForEach-Object {
    Test-Script $_.FullName "powershell"
}

# Vérification des scripts Bash
Write-Header "SCRIPTS BASH (.sh)"
Get-ChildItem "scripts\*.sh" | Where-Object { $_.Name -ne "verify-scripts.sh" } | ForEach-Object {
    Test-Script $_.FullName "bash"
}

# Vérification de la structure de fichiers
Write-Header "VÉRIFICATION DE LA STRUCTURE DE FICHIERS"

# Vérifier que le dossier docker existe
if (Test-Path "docker") {
    Write-Success "Dossier docker\ existe"
    
    # Vérifier les fichiers docker-compose
    $composeFiles = @("docker-compose.yml", "docker-compose.minimal.yml", "docker-compose.dev.yml")
    foreach ($composeFile in $composeFiles) {
        if (Test-Path "docker\$composeFile") {
            Write-Success "Fichier docker\$composeFile trouvé"
        } else {
            Write-Error "Fichier docker\$composeFile manquant"
        }
    }
} else {
    Write-Error "Dossier docker\ manquant"
}

# Vérifier que le dossier scripts existe
if (Test-Path "scripts") {
    Write-Success "Dossier scripts\ existe"
} else {
    Write-Error "Dossier scripts\ manquant"
}

# Vérifier que le dossier backups peut être créé
try {
    if (-not (Test-Path "backups")) {
        New-Item -ItemType Directory -Path "backups" -Force | Out-Null
    }
    Write-Success "Dossier backups\ accessible"
} catch {
    Write-Error "Impossible de créer le dossier backups\"
}

# Résumé final
Write-Header "RÉSUMÉ DE LA VÉRIFICATION"
Write-Host "Scripts vérifiés: $TotalScripts"
Write-Host "Scripts conformes: $CorrectScripts" -ForegroundColor Green
Write-Host "Scripts non-conformes: $IncorrectScripts" -ForegroundColor Red

if ($IncorrectScripts -eq 0) {
    Write-Host "`nTOUS LES SCRIPTS SONT CONFORMES !" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n$IncorrectScripts SCRIPT(S) NECESSITENT DES CORRECTIONS" -ForegroundColor Red
    exit 1
}
