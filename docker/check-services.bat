@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo  VERIFICATION DES SERVICES CYBERGUARD SOC
echo ==========================================

echo.
echo [ETAT DES CONTENEURS]
echo ====================
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo [TEST DES INTERFACES WEB]
echo ========================

set "services[0]=Frontend React:3000"
set "services[1]=Backend API:8000"
set "services[2]=Wazuh Manager:55000"
set "services[3]=Graylog:9000"
set "services[4]=TheHive:9001"
set "services[5]=MISP:80"
set "services[6]=OpenCTI:8080"
set "services[7]=Velociraptor:8889"
set "services[8]=Shuffle:3443"
set "services[9]=Elasticsearch:9200"

for /l %%i in (0,1,9) do (
    call :test_interface "!services[%%i]!"
)

echo.
echo [LOGS RECENTS DES SERVICES PRINCIPAUX]
echo ====================================

echo.
echo Frontend (dernières 3 lignes):
docker logs --tail 3 cyberguard-frontend 2>nul

echo.
echo Backend (dernières 3 lignes):
docker logs --tail 3 cyberguard-backend 2>nul

echo.
echo [COMMANDES UTILES]
echo ================
echo Voir tous les logs du frontend:
echo   docker logs cyberguard-frontend
echo.
echo Voir tous les logs du backend:
echo   docker logs cyberguard-backend
echo.
echo Redemarrer un service:
echo   docker-compose restart [nom_service]
echo.
echo Reconstruire et redemarrer:
echo   docker-compose build [nom_service]
echo   docker-compose up -d [nom_service]

goto :end

:test_interface
set "service_info=%~1"
for /f "tokens=1,2 delims=:" %%a in ("%service_info%") do (
    set "name=%%a"
    set "port=%%b"
)

echo Teste %name% (port %port%)...
curl -s -f -m 5 "http://localhost:%port%" >nul 2>&1
if !errorlevel! == 0 (
    echo [OK] %name% - http://localhost:%port%
) else (
    echo [!] %name% - Non accessible sur port %port%
    
    :: Vérifier si le conteneur est en cours d'exécution
    for /f "tokens=*" %%c in ('docker ps --format "{{.Names}}" 2^>nul') do (
        echo %%c | findstr /i "%name%" >nul
        if !errorlevel! == 0 (
            echo     ^> Conteneur en cours d'execution
        )
    )
)
goto :eof

:end
echo.
echo ==========================================
pause
