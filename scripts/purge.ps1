# Script de purge complète pour CyberGuard Unified SOC
# Nettoie tous les résidus des déploiements échoués

Write-Host "=== CyberGuard Unified SOC - Purge Complète ===" -ForegroundColor Red
Write-Host "Ce script va supprimer TOUS les conteneurs, images, volumes et réseaux Docker" -ForegroundColor Yellow
Write-Host "Êtes-vous sûr de vouloir continuer? (y/N)" -ForegroundColor Yellow
$confirmation = Read-Host

if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    Write-Host "Opération annulée." -ForegroundColor Green
    exit
}

Write-Host "`n=== ÉTAPE 1: Arrêt de tous les conteneurs ===" -ForegroundColor Cyan
try {
    # Arrêter tous les conteneurs en cours d'exécution
    $runningContainers = docker ps -q
    if ($runningContainers) {
        Write-Host "Arrêt des conteneurs en cours..." -ForegroundColor Yellow
        docker stop $runningContainers
        Write-Host "✓ Conteneurs arrêtés" -ForegroundColor Green
    } else {
        Write-Host "✓ Aucun conteneur en cours d'exécution" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Erreur lors de l'arrêt des conteneurs: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== ÉTAPE 2: Suppression de tous les conteneurs ===" -ForegroundColor Cyan
try {
    # Supprimer tous les conteneurs (même arrêtés)
    $allContainers = docker ps -aq
    if ($allContainers) {
        Write-Host "Suppression de tous les conteneurs..." -ForegroundColor Yellow
        docker rm -f $allContainers
        Write-Host "✓ Conteneurs supprimés" -ForegroundColor Green
    } else {
        Write-Host "✓ Aucun conteneur à supprimer" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Erreur lors de la suppression des conteneurs: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== ÉTAPE 3: Suppression de toutes les images Docker ===" -ForegroundColor Cyan
try {
    # Supprimer toutes les images
    $allImages = docker images -q
    if ($allImages) {
        Write-Host "Suppression de toutes les images Docker..." -ForegroundColor Yellow
        docker rmi -f $allImages
        Write-Host "✓ Images supprimées" -ForegroundColor Green
    } else {
        Write-Host "✓ Aucune image à supprimer" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Erreur lors de la suppression des images: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== ÉTAPE 4: Suppression de tous les volumes ===" -ForegroundColor Cyan
try {
    # Supprimer tous les volumes
    $allVolumes = docker volume ls -q
    if ($allVolumes) {
        Write-Host "Suppression de tous les volumes..." -ForegroundColor Yellow
        docker volume rm -f $allVolumes
        Write-Host "✓ Volumes supprimés" -ForegroundColor Green
    } else {
        Write-Host "✓ Aucun volume à supprimer" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Erreur lors de la suppression des volumes: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== ÉTAPE 5: Suppression de tous les réseaux ===" -ForegroundColor Cyan
try {
    # Supprimer tous les réseaux personnalisés
    $customNetworks = docker network ls --filter "type=custom" -q
    if ($customNetworks) {
        Write-Host "Suppression des réseaux personnalisés..." -ForegroundColor Yellow
        docker network rm $customNetworks
        Write-Host "✓ Réseaux supprimés" -ForegroundColor Green
    } else {
        Write-Host "✓ Aucun réseau personnalisé à supprimer" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Erreur lors de la suppression des réseaux: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== ÉTAPE 6: Nettoyage système Docker ===" -ForegroundColor Cyan
try {
    Write-Host "Nettoyage complet du système Docker..." -ForegroundColor Yellow
    docker system prune -af --volumes
    Write-Host "✓ Nettoyage système terminé" -ForegroundColor Green
} catch {
    Write-Host "⚠ Erreur lors du nettoyage système: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== ÉTAPE 7: Suppression des fichiers de données locales ===" -ForegroundColor Cyan
try {
    # Supprimer le dossier data s'il existe
    if (Test-Path "data") {
        Write-Host "Suppression du dossier data..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force "data"
        Write-Host "✓ Dossier data supprimé" -ForegroundColor Green
    } else {
        Write-Host "✓ Aucun dossier data à supprimer" -ForegroundColor Green
    }
    
    # Supprimer le dossier logs s'il existe
    if (Test-Path "logs") {
        Write-Host "Suppression du dossier logs..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force "logs"
        Write-Host "✓ Dossier logs supprimé" -ForegroundColor Green
    } else {
        Write-Host "✓ Aucun dossier logs à supprimer" -ForegroundColor Green
    }
    
    # Supprimer le dossier ssl s'il existe
    if (Test-Path "ssl") {
        Write-Host "Suppression du dossier ssl..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force "ssl"
        Write-Host "✓ Dossier ssl supprimé" -ForegroundColor Green
    } else {
        Write-Host "✓ Aucun dossier ssl à supprimer" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Erreur lors de la suppression des fichiers: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== ÉTAPE 8: Redémarrage du service Docker ===" -ForegroundColor Cyan
try {
    Write-Host "Redémarrage du service Docker..." -ForegroundColor Yellow
    Restart-Service docker -Force
    Start-Sleep -Seconds 10
    Write-Host "✓ Service Docker redémarré" -ForegroundColor Green
} catch {
    Write-Host "⚠ Impossible de redémarrer Docker automatiquement" -ForegroundColor Red
    Write-Host "Veuillez redémarrer Docker Desktop manuellement" -ForegroundColor Yellow
}

Write-Host "`n=== ÉTAPE 9: Vérification finale ===" -ForegroundColor Cyan
Write-Host "Conteneurs restants:" -ForegroundColor Yellow
docker ps -a

Write-Host "`nImages restantes:" -ForegroundColor Yellow
docker images

Write-Host "`nVolumes restants:" -ForegroundColor Yellow
docker volume ls

Write-Host "`nRéseaux restants:" -ForegroundColor Yellow
docker network ls

Write-Host "`nEspace disque libéré:" -ForegroundColor Yellow
docker system df

Write-Host "`n=== PURGE TERMINÉE ===" -ForegroundColor Green
Write-Host "Votre environnement Docker est maintenant complètement nettoyé!" -ForegroundColor Green
Write-Host "Vous pouvez maintenant relancer un déploiement propre." -ForegroundColor Green

Write-Host "`n=== PROCHAINES ÉTAPES ===" -ForegroundColor Cyan
Write-Host "1. Vérifiez que Docker fonctionne: docker --version" -ForegroundColor White
Write-Host "2. Relancez le déploiement: powershell -ExecutionPolicy Bypass -File scripts\deploy.ps1" -ForegroundColor White
Write-Host "3. Validez l'installation: powershell -ExecutionPolicy Bypass -File scripts\validate.ps1" -ForegroundColor White
