#!/bin/bash

# Script de purge complète pour CyberGuard Unified SOC - Linux
# Nettoie tous les résidus des déploiements échoués

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${RED}$1${NC}"
}

print_step() {
    echo -e "\n${CYAN}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_header "=== CyberGuard Unified SOC - Purge Complète ==="
echo -e "${YELLOW}Ce script va supprimer TOUS les conteneurs, images, volumes et réseaux Docker${NC}"
echo -e "${YELLOW}Êtes-vous sûr de vouloir continuer? (y/N)${NC}"
read -r confirmation

if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
    echo -e "${GREEN}Opération annulée.${NC}"
    exit 0
fi

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    print_error "Docker n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Déterminer la commande docker compose
if docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    print_warning "Docker Compose non trouvé, purge Docker uniquement"
    COMPOSE_CMD=""
fi

print_step "ÉTAPE 1: Arrêt des services Docker Compose"
if [[ -n "$COMPOSE_CMD" ]]; then
    # Chercher les fichiers docker-compose.yml
    for compose_file in docker/docker-compose.yml docker-compose.yml */docker-compose.yml; do
        if [[ -f "$compose_file" ]]; then
            echo "Arrêt des services dans $(dirname "$compose_file")..."
            cd "$(dirname "$compose_file")" || continue
            $COMPOSE_CMD down -v --remove-orphans 2>/dev/null || true
            cd - >/dev/null || true
        fi
    done
    print_success "Services Docker Compose arrêtés"
else
    print_warning "Docker Compose non disponible, passage à l'étape suivante"
fi

print_step "ÉTAPE 2: Arrêt de tous les conteneurs"
running_containers=$(docker ps -q 2>/dev/null)
if [[ -n "$running_containers" ]]; then
    echo "Arrêt des conteneurs en cours..."
    docker stop $running_containers 2>/dev/null || true
    print_success "Conteneurs arrêtés"
else
    print_success "Aucun conteneur en cours d'exécution"
fi

print_step "ÉTAPE 3: Suppression de tous les conteneurs"
all_containers=$(docker ps -aq 2>/dev/null)
if [[ -n "$all_containers" ]]; then
    echo "Suppression de tous les conteneurs..."
    docker rm -f $all_containers 2>/dev/null || true
    print_success "Conteneurs supprimés"
else
    print_success "Aucun conteneur à supprimer"
fi

print_step "ÉTAPE 4: Suppression de toutes les images Docker"
all_images=$(docker images -q 2>/dev/null)
if [[ -n "$all_images" ]]; then
    echo "Suppression de toutes les images Docker..."
    docker rmi -f $all_images 2>/dev/null || true
    print_success "Images supprimées"
else
    print_success "Aucune image à supprimer"
fi

print_step "ÉTAPE 5: Suppression de tous les volumes"
all_volumes=$(docker volume ls -q 2>/dev/null)
if [[ -n "$all_volumes" ]]; then
    echo "Suppression de tous les volumes..."
    docker volume rm -f $all_volumes 2>/dev/null || true
    print_success "Volumes supprimés"
else
    print_success "Aucun volume à supprimer"
fi

print_step "ÉTAPE 6: Suppression de tous les réseaux personnalisés"
custom_networks=$(docker network ls --filter "type=custom" -q 2>/dev/null)
if [[ -n "$custom_networks" ]]; then
    echo "Suppression des réseaux personnalisés..."
    docker network rm $custom_networks 2>/dev/null || true
    print_success "Réseaux supprimés"
else
    print_success "Aucun réseau personnalisé à supprimer"
fi

print_step "ÉTAPE 7: Nettoyage système Docker"
echo "Nettoyage complet du système Docker..."
docker system prune -af --volumes 2>/dev/null || true
print_success "Nettoyage système terminé"

print_step "ÉTAPE 8: Suppression des fichiers de données locales"
# Supprimer les dossiers de données
for dir in data logs ssl backups; do
    if [[ -d "$dir" ]]; then
        echo "Suppression du dossier $dir..."
        rm -rf "$dir" 2>/dev/null || sudo rm -rf "$dir" 2>/dev/null || true
        print_success "Dossier $dir supprimé"
    else
        print_success "Aucun dossier $dir à supprimer"
    fi
done

# Supprimer les fichiers de log et de cache éventuels
for file in docker-compose.override.yml .docker-sync .env.local; do
    if [[ -f "$file" ]]; then
        echo "Suppression de $file..."
        rm -f "$file" 2>/dev/null || true
        print_success "Fichier $file supprimé"
    fi
done

print_step "ÉTAPE 9: Nettoyage des logs système Docker"
if command -v journalctl &> /dev/null; then
    echo "Nettoyage des logs Docker dans journalctl..."
    sudo journalctl --vacuum-time=1d --unit=docker 2>/dev/null || true
    print_success "Logs système nettoyés"
fi

print_step "ÉTAPE 10: Redémarrage du service Docker"
if systemctl is-active --quiet docker; then
    echo "Redémarrage du service Docker..."
    sudo systemctl restart docker 2>/dev/null || true
    sleep 5
    
    if systemctl is-active --quiet docker; then
        print_success "Service Docker redémarré avec succès"
    else
        print_error "Échec du redémarrage de Docker"
        print_warning "Veuillez redémarrer Docker manuellement: sudo systemctl restart docker"
    fi
else
    print_warning "Service Docker non actif, tentative de démarrage..."
    sudo systemctl start docker 2>/dev/null || true
fi

print_step "ÉTAPE 11: Vérification finale"
echo -e "${YELLOW}Conteneurs restants:${NC}"
docker ps -a 2>/dev/null || echo "Aucun conteneur"

echo -e "\n${YELLOW}Images restantes:${NC}"
docker images 2>/dev/null || echo "Aucune image"

echo -e "\n${YELLOW}Volumes restants:${NC}"
docker volume ls 2>/dev/null || echo "Aucun volume"

echo -e "\n${YELLOW}Réseaux restants:${NC}"
docker network ls 2>/dev/null || echo "Réseaux par défaut uniquement"

echo -e "\n${YELLOW}Espace disque Docker:${NC}"
docker system df 2>/dev/null || echo "Informations non disponibles"

echo -e "\n${YELLOW}Espace disque système:${NC}"
df -h . 2>/dev/null || echo "Informations non disponibles"

print_step "PURGE TERMINÉE"
print_success "Votre environnement Docker est maintenant complètement nettoyé!"
print_success "Vous pouvez maintenant relancer un déploiement propre."

print_step "PROCHAINES ÉTAPES"
echo -e "${CYAN}1. Vérifiez que Docker fonctionne:${NC} docker --version"
echo -e "${CYAN}2. Testez Docker:${NC} docker run hello-world"
echo -e "${CYAN}3. Relancez l'installation:${NC} sudo ./scripts/install.sh"
echo -e "${CYAN}4. Validez l'installation:${NC} ./scripts/health-check.sh"

# Vérification finale de Docker
print_step "TEST DOCKER"
if docker --version &>/dev/null; then
    DOCKER_VERSION=$(docker --version)
    print_success "Docker opérationnel: $DOCKER_VERSION"
    
    if docker run --rm hello-world &>/dev/null; then
        print_success "Test Docker réussi"
    else
        print_warning "Test Docker échoué - vérifiez les permissions"
        echo -e "${YELLOW}Essayez: sudo usermod -aG docker \$USER && newgrp docker${NC}"
    fi
else
    print_error "Docker ne fonctionne pas correctement"
fi

echo -e "\n${GREEN}=== PURGE COMPLÈTE TERMINÉE ===${NC}"
