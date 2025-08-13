# Script de purge rapide en une commande
# À utiliser si vous voulez un nettoyage rapide sans confirmations

Write-Host "=== PURGE RAPIDE CYBERGUARD ===" -ForegroundColor Red

# Arrêter et supprimer tout en une seule fois
docker stop $(docker ps -aq) 2>$null
docker rm -f $(docker ps -aq) 2>$null
docker rmi -f $(docker images -q) 2>$null
docker volume rm -f $(docker volume ls -q) 2>$null
docker network rm $(docker network ls --filter "type=custom" -q) 2>$null
docker system prune -af --volumes

# Supprimer les dossiers locaux
if (Test-Path "data") { Remove-Item -Recurse -Force "data" }
if (Test-Path "logs") { Remove-Item -Recurse -Force "logs" }
if (Test-Path "ssl") { Remove-Item -Recurse -Force "ssl" }

Write-Host "✓ Purge rapide terminée!" -ForegroundColor Green
