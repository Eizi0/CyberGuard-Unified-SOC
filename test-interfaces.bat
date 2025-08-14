@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo  DIAGNOSTIC INTERFACES WEB - CYBERGUARD SOC
echo ==========================================

:: Couleurs pour les messages
:: Impossible en batch pur, on utilise des symboles

echo.
echo [ETAPE 1] VERIFICATION DE L'ETAT DES CONTENEURS
echo ===============================================

echo.
echo Tous les conteneurs:
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>nul
if !errorlevel! neq 0 (
    echo [ERREUR] Docker non accessible
    goto :docker_error
)

echo.
echo Conteneurs en cours d'execution:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>nul

echo.
echo [ETAPE 2] TEST DE CONNECTIVITE DES INTERFACES
echo =============================================

:: Définir les services et leurs ports
set "services[0]=Frontend React:3000:/health"
set "services[1]=Backend API:8000:/health"
set "services[2]=Wazuh Manager:55000:/api"
set "services[3]=Graylog:9000/"
set "services[4]=TheHive:9001/"
set "services[5]=MISP:80/"
set "services[6]=OpenCTI:8080/"
set "services[7]=Velociraptor:8889/health"
set "services[8]=Shuffle:3443/health"
set "services[9]=Elasticsearch:9200/"

echo.
for /l %%i in (0,1,9) do (
    call :test_service "!services[%%i]!"
)

echo.
echo [ETAPE 3] VERIFICATION DES LOGS RECENTS
echo =======================================

echo.
echo Logs du Frontend:
docker logs --tail 5 cyberguard-frontend 2>nul

echo.
echo Logs du Backend:
docker logs --tail 5 cyberguard-backend 2>nul

echo.
echo [ETAPE 4] VERIFICATION DES VOLUMES ET RESEAUX
echo =============================================

echo.
echo Reseaux Docker:
docker network ls 2>nul

echo.
echo Volumes Docker:
docker volume ls 2>nul

echo.
echo [ETAPE 5] COMMANDES DE DEPANNAGE
echo ================================

echo.
echo Si aucune interface ne fonctionne, essayez:
echo.
echo 1. Redemarrage complet:
echo    cd docker
echo    docker-compose down
echo    docker-compose up -d
echo.
echo 2. Demarrage en mode debug:
echo    docker-compose up frontend backend
echo.
echo 3. Verification des ports utilises:
echo    netstat -an ^| findstr :3000
echo    netstat -an ^| findstr :8000
echo    netstat -an ^| findstr :9000
echo.
echo 4. Reconstruction des images:
echo    docker-compose build
echo    docker-compose up -d
echo.
echo 5. Verifier les logs detailles:
echo    docker-compose logs frontend
echo    docker-compose logs backend

goto :end

:test_service
:: Fonction pour tester un service
:: Format: "Nom:Port:Endpoint"
set "service_info=%~1"
for /f "tokens=1,2,3 delims=:" %%a in ("%service_info%") do (
    set "name=%%a"
    set "port=%%b"
    set "endpoint=%%c"
)

echo Teste %name% sur port %port%...
curl -s -f -m 5 "http://localhost:%port%%endpoint%" >nul 2>&1
if !errorlevel! == 0 (
    echo [OK] %name% accessible sur http://localhost:%port%
) else (
    echo [!] %name% non accessible sur port %port%
    
    :: Vérifier si le port est occupé
    netstat -an | findstr ":%port% " >nul 2>&1
    if !errorlevel! == 0 (
        echo     ^> Port %port% est occupe
    ) else (
        echo     ^> Port %port% libre - service probablement arrete
    )
)
goto :eof

:docker_error
echo.
echo [ERREUR CRITIQUE] Docker n'est pas accessible
echo.
echo Solutions possibles:
echo 1. Docker Desktop n'est pas demarre
echo 2. Docker n'est pas installe
echo 3. Permissions insuffisantes
echo.
echo Verifiez que Docker Desktop est lance et accessible.

:end
echo.
echo ==========================================
echo  DIAGNOSTIC TERMINE
echo ==========================================
pause
