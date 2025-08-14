# Script d'installation et test du frontend CyberGuard SOC
# Frontend Setup and Test Script

param(
    [switch]$Install,
    [switch]$Build,
    [switch]$Start,
    [switch]$CheckDeps,
    [switch]$All
)

$frontendPath = Join-Path $PSScriptRoot "frontend"
$nodeVersion = "20.x"

function Write-Header {
    param($Message)
    Write-Host "`n" -NoNewline
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Yellow
    Write-Host "=" * 60 -ForegroundColor Cyan
}

function Test-NodeInstallation {
    Write-Header "Vérification de Node.js"
    
    try {
        $nodeVersionOutput = node --version 2>$null
        $npmVersionOutput = npm --version 2>$null
        
        if ($nodeVersionOutput -and $npmVersionOutput) {
            Write-Host "✅ Node.js: $nodeVersionOutput" -ForegroundColor Green
            Write-Host "✅ npm: $npmVersionOutput" -ForegroundColor Green
            return $true
        }
    }
    catch {
        # Ignore error
    }
    
    Write-Host "❌ Node.js/npm non trouvé" -ForegroundColor Red
    Write-Host "📥 Téléchargez Node.js $nodeVersion depuis: https://nodejs.org/" -ForegroundColor Yellow
    Write-Host "   Ou utilisez winget: winget install OpenJS.NodeJS" -ForegroundColor Yellow
    return $false
}

function Install-Dependencies {
    Write-Header "Installation des dépendances"
    
    if (-not (Test-Path $frontendPath)) {
        Write-Host "❌ Dossier frontend non trouvé: $frontendPath" -ForegroundColor Red
        return $false
    }
    
    Push-Location $frontendPath
    try {
        Write-Host "📦 Installation des dépendances npm..." -ForegroundColor Blue
        npm install
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Dépendances installées avec succès" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ Erreur lors de l'installation des dépendances" -ForegroundColor Red
            return $false
        }
    }
    finally {
        Pop-Location
    }
}

function Build-Frontend {
    Write-Header "Build du frontend"
    
    Push-Location $frontendPath
    try {
        Write-Host "🔨 Build du frontend..." -ForegroundColor Blue
        npm run build
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Build réussi" -ForegroundColor Green
            
            $buildPath = Join-Path $frontendPath "build"
            if (Test-Path $buildPath) {
                $buildSize = (Get-ChildItem $buildPath -Recurse | Measure-Object -Property Length -Sum).Sum
                $buildSizeMB = [math]::Round($buildSize / 1MB, 2)
                Write-Host "📊 Taille du build: $buildSizeMB MB" -ForegroundColor Blue
            }
            return $true
        } else {
            Write-Host "❌ Erreur lors du build" -ForegroundColor Red
            return $false
        }
    }
    finally {
        Pop-Location
    }
}

function Start-DevServer {
    Write-Header "Démarrage du serveur de développement"
    
    Push-Location $frontendPath
    try {
        Write-Host "🚀 Démarrage du serveur de développement..." -ForegroundColor Blue
        Write-Host "   URL: http://localhost:3000" -ForegroundColor Yellow
        Write-Host "   Appuyez sur Ctrl+C pour arrêter" -ForegroundColor Yellow
        npm start
    }
    finally {
        Pop-Location
    }
}

function Show-ProjectStatus {
    Write-Header "État du projet frontend"
    
    # Vérifier les fichiers essentiels
    $essentialFiles = @(
        "frontend/package.json",
        "frontend/src/App.jsx",
        "frontend/src/index.js",
        "frontend/public/index.html",
        "frontend/public/manifest.json"
    )
    
    foreach ($file in $essentialFiles) {
        $fullPath = Join-Path $PSScriptRoot $file
        if (Test-Path $fullPath) {
            Write-Host "✅ $file" -ForegroundColor Green
        } else {
            Write-Host "❌ $file" -ForegroundColor Red
        }
    }
    
    # Vérifier node_modules
    $nodeModulesPath = Join-Path $frontendPath "node_modules"
    if (Test-Path $nodeModulesPath) {
        Write-Host "✅ node_modules (dépendances installées)" -ForegroundColor Green
    } else {
        Write-Host "❌ node_modules (dépendances non installées)" -ForegroundColor Red
    }
    
    # Vérifier le dossier build
    $buildPath = Join-Path $frontendPath "build"
    if (Test-Path $buildPath) {
        Write-Host "✅ build (frontend compilé)" -ForegroundColor Green
    } else {
        Write-Host "❌ build (frontend non compilé)" -ForegroundColor Yellow
    }
}

# Main execution
Write-Host "🛡️  CyberGuard Unified SOC - Frontend Setup" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

if ($CheckDeps -or $All) {
    if (-not (Test-NodeInstallation)) {
        exit 1
    }
}

if ($Install -or $All) {
    if (-not (Test-NodeInstallation)) {
        Write-Host "❌ Node.js requis pour l'installation" -ForegroundColor Red
        exit 1
    }
    
    if (-not (Install-Dependencies)) {
        exit 1
    }
}

if ($Build -or $All) {
    if (-not (Test-NodeInstallation)) {
        Write-Host "❌ Node.js requis pour le build" -ForegroundColor Red
        exit 1
    }
    
    if (-not (Build-Frontend)) {
        exit 1
    }
}

if ($Start) {
    if (-not (Test-NodeInstallation)) {
        Write-Host "❌ Node.js requis pour démarrer le serveur" -ForegroundColor Red
        exit 1
    }
    
    Start-DevServer
}

if (-not ($Install -or $Build -or $Start -or $CheckDeps -or $All)) {
    Show-ProjectStatus
    Write-Host "`n📖 Usage:" -ForegroundColor Yellow
    Write-Host "  .\frontend-setup.ps1 -CheckDeps    # Vérifier Node.js/npm" -ForegroundColor White
    Write-Host "  .\frontend-setup.ps1 -Install      # Installer les dépendances" -ForegroundColor White
    Write-Host "  .\frontend-setup.ps1 -Build        # Compiler le frontend" -ForegroundColor White
    Write-Host "  .\frontend-setup.ps1 -Start        # Démarrer le serveur dev" -ForegroundColor White
    Write-Host "  .\frontend-setup.ps1 -All          # Tout faire (CheckDeps + Install + Build)" -ForegroundColor White
}

Write-Host "`n✅ Script terminé" -ForegroundColor Green
