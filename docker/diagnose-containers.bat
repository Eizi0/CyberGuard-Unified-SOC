@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo  CyberGuard SOC - Diagnostic Velociraptor ^& Shuffle
echo ==========================================

echo.
echo [VERIFICATION DOCKER]
docker --version >nul 2>&1
if !errorlevel! == 0 (
    echo [OK] Docker installe
    docker info >nul 2>&1
    if !errorlevel! == 0 (
        echo [OK] Docker daemon accessible
    ) else (
        echo [ERREUR] Docker daemon non accessible
        goto :end
    )
) else (
    echo [ERREUR] Docker non installe
    goto :end
)

echo.
echo [VERIFICATION DOCKER COMPOSE]
docker-compose --version >nul 2>&1
if !errorlevel! == 0 (
    echo [OK] Docker Compose installe
) else (
    echo [ERREUR] Docker Compose non installe
)

echo.
echo [VERIFICATION FICHIERS]
echo Velociraptor:
if exist "velociraptor\Dockerfile" (
    echo [OK] Dockerfile
) else (
    echo [!] Dockerfile manquant
)

if exist "velociraptor\config\server.config.yaml" (
    echo [OK] Configuration
) else (
    echo [!] Configuration manquante
)

if exist "velociraptor\init-velociraptor.sh" (
    echo [OK] Script d'initialisation
) else (
    echo [!] Script d'initialisation manquant
)

echo.
echo Shuffle:
if exist "shuffle\Dockerfile" (
    echo [OK] Dockerfile
) else (
    echo [!] Dockerfile manquant
)

if exist "shuffle\config\shuffle-config.yaml" (
    echo [OK] Configuration
) else (
    echo [!] Configuration manquante
)

if exist "shuffle\init-shuffle.sh" (
    echo [OK] Script d'initialisation
) else (
    echo [!] Script d'initialisation manquant
)

echo.
echo [ETAT DES CONTENEURS]
docker ps -a --format "table {{.Names}}\t{{.Status}}" 2>nul | findstr /i "velociraptor shuffle"

echo.
echo [TEST DE CONNECTIVITE]
echo Test Velociraptor (port 8889)...
curl -s -f http://localhost:8889/health >nul 2>&1
if !errorlevel! == 0 (
    echo [OK] Velociraptor accessible
) else (
    echo [!] Velociraptor non accessible
)

echo Test Shuffle (port 3443)...
curl -s -f http://localhost:3443/health >nul 2>&1
if !errorlevel! == 0 (
    echo [OK] Shuffle accessible
) else (
    echo [!] Shuffle non accessible
)

echo.
echo ==========================================
echo  COMMANDES DE DEPANNAGE
echo ==========================================
echo Reconstruire les images:
echo   docker-compose build velociraptor shuffle
echo.
echo Redemarrer les services:
echo   docker-compose restart velociraptor shuffle
echo.
echo Voir les logs:
echo   docker-compose logs velociraptor
echo   docker-compose logs shuffle
echo.
echo Demarrer en mode debug:
echo   docker-compose up velociraptor shuffle
echo ==========================================

:end
pause
