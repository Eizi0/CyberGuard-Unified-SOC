#!/bin/bash

# Script de purge rapide pour CyberGuard Unified SOC - Linux
# Nettoyage rapide sans confirmations

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}=== PURGE RAPIDE CYBERGUARD ===${NC}"

# Fonction de nettoyage silencieux
cleanup() {
    $1 2>/dev/null || true
}

# Arrêter et supprimer tout Docker
echo -e "${YELLOW}Arrêt des services...${NC}"
cleanup "docker-compose down -v --remove-orphans"
cleanup "docker compose down -v --remove-orphans"

echo -e "${YELLOW}Suppression des conteneurs...${NC}"
cleanup "docker stop \$(docker ps -aq)"
cleanup "docker rm -f \$(docker ps -aq)"

echo -e "${YELLOW}Suppression des images...${NC}"
cleanup "docker rmi -f \$(docker images -q)"

echo -e "${YELLOW}Suppression des volumes...${NC}"
cleanup "docker volume rm -f \$(docker volume ls -q)"

echo -e "${YELLOW}Suppression des réseaux...${NC}"
cleanup "docker network rm \$(docker network ls --filter 'type=custom' -q)"

echo -e "${YELLOW}Nettoyage système...${NC}"
cleanup "docker system prune -af --volumes"

echo -e "${YELLOW}Suppression des dossiers locaux...${NC}"
cleanup "rm -rf data logs ssl backups"
cleanup "sudo rm -rf data logs ssl backups"

echo -e "${YELLOW}Redémarrage Docker...${NC}"
cleanup "sudo systemctl restart docker"

echo -e "${GREEN}✓ Purge rapide terminée!${NC}"
echo -e "${GREEN}Vous pouvez maintenant redéployer.${NC}"
