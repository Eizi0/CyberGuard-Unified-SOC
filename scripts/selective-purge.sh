#!/bin/bash

# Script de purge sélective pour CyberGuard Unified SOC - Linux
# Permet de choisir quoi supprimer

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_menu() {
    echo -e "${CYAN}=== PURGE SÉLECTIVE CYBERGUARD ===${NC}"
    echo -e "${YELLOW}Que souhaitez-vous purger ?${NC}"
    echo ""
    echo "1) Conteneurs uniquement"
    echo "2) Images du projet uniquement"
    echo "3) Volumes de données"
    echo "4) Réseaux personnalisés"
    echo "5) Fichiers locaux (data, logs, ssl)"
    echo "6) Purge complète (tout)"
    echo "7) Afficher l'état actuel"
    echo "0) Quitter"
    echo ""
}

show_status() {
    echo -e "${CYAN}=== ÉTAT ACTUEL ===${NC}"
    
    echo -e "\n${YELLOW}Conteneurs:${NC}"
    docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "Aucun conteneur"
    
    echo -e "\n${YELLOW}Images:${NC}"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" 2>/dev/null || echo "Aucune image"
    
    echo -e "\n${YELLOW}Volumes:${NC}"
    docker volume ls 2>/dev/null || echo "Aucun volume"
    
    echo -e "\n${YELLOW}Réseaux:${NC}"
    docker network ls 2>/dev/null || echo "Aucun réseau"
    
    echo -e "\n${YELLOW}Espace disque:${NC}"
    docker system df 2>/dev/null || echo "Informations non disponibles"
    
    echo -e "\n${YELLOW}Dossiers locaux:${NC}"
    for dir in data logs ssl backups; do
        if [[ -d "$dir" ]]; then
            size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            echo "✓ $dir ($size)"
        else
            echo "✗ $dir (absent)"
        fi
    done
}

purge_containers() {
    echo -e "${CYAN}Purge des conteneurs...${NC}"
    
    # Arrêter docker-compose
    if [[ -f "docker/docker-compose.yml" ]]; then
        cd docker && (docker compose down -v || docker-compose down -v) 2>/dev/null && cd .. || true
    fi
    
    # Arrêter tous les conteneurs
    running=$(docker ps -q 2>/dev/null)
    if [[ -n "$running" ]]; then
        docker stop $running 2>/dev/null || true
        echo -e "${GREEN}✓ Conteneurs arrêtés${NC}"
    fi
    
    # Supprimer tous les conteneurs
    all_containers=$(docker ps -aq 2>/dev/null)
    if [[ -n "$all_containers" ]]; then
        docker rm -f $all_containers 2>/dev/null || true
        echo -e "${GREEN}✓ Conteneurs supprimés${NC}"
    else
        echo -e "${GREEN}✓ Aucun conteneur à supprimer${NC}"
    fi
}

purge_project_images() {
    echo -e "${CYAN}Purge des images du projet...${NC}"
    
    # Supprimer les images du projet
    project_images=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -E "(cyberguard|wazuh|graylog|thehive|misp|opencti|velociraptor|shuffle|docker_)" 2>/dev/null)
    
    if [[ -n "$project_images" ]]; then
        echo "$project_images" | xargs docker rmi -f 2>/dev/null || true
        echo -e "${GREEN}✓ Images du projet supprimées${NC}"
    else
        echo -e "${GREEN}✓ Aucune image de projet trouvée${NC}"
    fi
    
    # Supprimer les images orphelines
    docker image prune -f 2>/dev/null || true
    echo -e "${GREEN}✓ Images orphelines supprimées${NC}"
}

purge_volumes() {
    echo -e "${CYAN}Purge des volumes...${NC}"
    
    # Supprimer les volumes du projet
    project_volumes=$(docker volume ls --format "{{.Name}}" | grep -E "(cyberguard|docker_|mongo|elastic|graylog|wazuh|thehive|misp|opencti|velociraptor|shuffle)" 2>/dev/null)
    
    if [[ -n "$project_volumes" ]]; then
        echo "$project_volumes" | xargs docker volume rm -f 2>/dev/null || true
        echo -e "${GREEN}✓ Volumes du projet supprimés${NC}"
    fi
    
    # Supprimer les volumes orphelins
    docker volume prune -f 2>/dev/null || true
    echo -e "${GREEN}✓ Volumes orphelins supprimés${NC}"
}

purge_networks() {
    echo -e "${CYAN}Purge des réseaux...${NC}"
    
    # Supprimer les réseaux du projet
    project_networks=$(docker network ls --format "{{.Name}}" | grep -E "(cyberguard|docker_)" 2>/dev/null)
    
    if [[ -n "$project_networks" ]]; then
        echo "$project_networks" | xargs docker network rm 2>/dev/null || true
        echo -e "${GREEN}✓ Réseaux du projet supprimés${NC}"
    fi
    
    # Supprimer les réseaux orphelins
    docker network prune -f 2>/dev/null || true
    echo -e "${GREEN}✓ Réseaux orphelins supprimés${NC}"
}

purge_local_files() {
    echo -e "${CYAN}Purge des fichiers locaux...${NC}"
    
    for dir in data logs ssl backups; do
        if [[ -d "$dir" ]]; then
            size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            rm -rf "$dir" 2>/dev/null || sudo rm -rf "$dir" 2>/dev/null || true
            echo -e "${GREEN}✓ $dir supprimé ($size libérés)${NC}"
        else
            echo -e "${GREEN}✓ $dir (déjà absent)${NC}"
        fi
    done
    
    # Supprimer les fichiers temporaires
    for file in docker-compose.override.yml .env.local .docker-sync; do
        if [[ -f "$file" ]]; then
            rm -f "$file" 2>/dev/null || true
            echo -e "${GREEN}✓ $file supprimé${NC}"
        fi
    done
}

purge_all() {
    echo -e "${RED}PURGE COMPLÈTE EN COURS...${NC}"
    purge_containers
    purge_project_images
    purge_volumes
    purge_networks
    purge_local_files
    
    # Nettoyage final
    docker system prune -af --volumes 2>/dev/null || true
    
    # Redémarrer Docker
    echo -e "${CYAN}Redémarrage de Docker...${NC}"
    sudo systemctl restart docker 2>/dev/null || true
    sleep 3
    
    echo -e "${GREEN}✓ Purge complète terminée${NC}"
}

# Menu principal
while true; do
    print_menu
    read -p "Votre choix: " choice
    
    case $choice in
        1)
            purge_containers
            ;;
        2)
            purge_project_images
            ;;
        3)
            purge_volumes
            ;;
        4)
            purge_networks
            ;;
        5)
            purge_local_files
            ;;
        6)
            echo -e "${YELLOW}Êtes-vous sûr de vouloir tout purger? (y/N)${NC}"
            read -r confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                purge_all
            else
                echo -e "${GREEN}Annulé${NC}"
            fi
            ;;
        7)
            show_status
            ;;
        0)
            echo -e "${GREEN}Au revoir!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Choix invalide${NC}"
            ;;
    esac
    
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
    clear
done
