#!/bin/bash

# 🔍 Script de Test Rapide - CyberGuard Unified SOC
# Vérification de la structure et des fichiers avant déploiement

echo "🔍 Vérification de la structure du projet..."

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour vérifier un fichier
check_file() {
    if [ -f "$1" ]; then
        echo -e "   ✅ $1"
        return 0
    else
        echo -e "   ❌ $1 ${RED}(MANQUANT)${NC}"
        return 1
    fi
}

# Fonction pour vérifier un dossier
check_dir() {
    if [ -d "$1" ]; then
        echo -e "   ✅ $1/"
        return 0
    else
        echo -e "   ❌ $1/ ${RED}(MANQUANT)${NC}"
        return 1
    fi
}

# Vérifier le répertoire actuel
current_dir=$(basename "$(pwd)")
if [[ "$current_dir" == "scripts" ]]; then
    echo -e "${YELLOW}📁 Vous êtes dans le dossier scripts${NC}"
    echo -e "${YELLOW}   Remontée vers le dossier parent...${NC}"
    cd ..
elif [[ "$current_dir" =~ "CyberGuard" ]]; then
    echo -e "${GREEN}📁 Vous êtes dans le dossier racine du projet${NC}"
else
    echo -e "${RED}❌ Attention : Vous n'êtes pas dans le bon répertoire${NC}"
    echo -e "${RED}   Assurez-vous d'être dans le dossier CyberGuard Unified SOC${NC}"
fi

echo ""
echo "📂 Vérification de la structure des dossiers :"

# Vérification des dossiers principaux
error_count=0

check_dir "docker" || ((error_count++))
check_dir "scripts" || ((error_count++))
check_dir "frontend" || ((error_count++))
check_dir "backend" || ((error_count++))
check_dir "docs" || ((error_count++))
check_dir "Logo" || ((error_count++))

echo ""
echo "📄 Vérification des fichiers de configuration Docker :"

check_file "docker/docker-compose.yml" || ((error_count++))
check_file "docker/docker-compose.minimal.yml" || ((error_count++))
check_file "docker/docker-compose.dev.yml" || ((error_count++))

echo ""
echo "🔧 Vérification des scripts d'automatisation :"

check_file "scripts/auto-deploy.sh" || ((error_count++))
check_file "scripts/auto-deploy.ps1" || ((error_count++))
check_file "scripts/install.sh" || ((error_count++))
check_file "scripts/health-check.sh" || ((error_count++))

echo ""
echo "⚙️ Vérification des fichiers de configuration :"

check_file ".env" || ((error_count++))
check_file "README.md" || ((error_count++))
check_file "frontend/package.json" || ((error_count++))
check_file "backend/requirements.txt" || ((error_count++))

echo ""
echo "🎨 Vérification des assets logo :"

check_file "Logo/CSU Logo.png" || ((error_count++))
check_file "frontend/src/assets/csu-logo.png" || ((error_count++))

echo ""
echo "🐳 Vérification de Docker :"

if command -v docker &> /dev/null; then
    echo -e "   ✅ Docker est installé"
    if docker version &> /dev/null; then
        echo -e "   ✅ Docker est démarré et opérationnel"
        
        # Vérifier docker-compose
        if command -v docker-compose &> /dev/null; then
            echo -e "   ✅ Docker Compose est disponible"
        else
            echo -e "   ❌ Docker Compose n'est pas installé"
            ((error_count++))
        fi
    else
        echo -e "   ❌ Docker n'est pas démarré"
        echo -e "      Démarrez Docker avec : sudo systemctl start docker"
        ((error_count++))
    fi
else
    echo -e "   ❌ Docker n'est pas installé"
    ((error_count++))
fi

echo ""
echo "📊 Résumé de la vérification :"

if [ $error_count -eq 0 ]; then
    echo -e "${GREEN}🎉 Toutes les vérifications sont passées !${NC}"
    echo -e "${GREEN}   Votre projet est prêt pour le déploiement.${NC}"
    echo ""
    echo "🚀 Commandes de déploiement disponibles :"
    echo "   ./scripts/auto-deploy.sh          # Déploiement intelligent"
    echo "   ./scripts/install.sh              # Installation complète"
    echo ""
    echo "📋 Profils disponibles :"
    echo "   docker-compose -f docker/docker-compose.dev.yml up -d      # Développement"
    echo "   docker-compose -f docker/docker-compose.minimal.yml up -d  # Minimal"
    echo "   docker-compose -f docker/docker-compose.yml up -d          # Complet"
else
    echo -e "${RED}❌ $error_count problème(s) détecté(s)${NC}"
    echo -e "${RED}   Corrigez les problèmes avant de continuer.${NC}"
    
    if [ $error_count -gt 5 ]; then
        echo ""
        echo -e "${YELLOW}💡 Il semble que des fichiers importants soient manquants.${NC}"
        echo -e "${YELLOW}   Assurez-vous d'avoir cloné le repository complet :${NC}"
        echo "   git clone https://github.com/Eizi0/CyberGuard-Unified-SOC.git"
    fi
fi

echo ""
echo "📱 Pour plus d'aide :"
echo "   - Documentation : docs/README.md"
echo "   - Guide rapide : docs/quick-start.md"
echo "   - Dépannage : docs/troubleshooting.md"
