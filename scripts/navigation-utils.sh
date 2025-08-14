#!/bin/bash

# Fonctions utilitaires pour la navigation intelligente - CyberGuard Unified SOC
# Source: scripts/navigation-utils.sh

# Fonction pour naviguer intelligemment vers le dossier docker
navigate_to_docker() {
    if [ -d "docker" ]; then
        echo "🗂️  Navigation vers ./docker"
        cd docker
        return 0
    elif [ -d "../docker" ]; then
        echo "🗂️  Navigation vers ../docker"
        cd ../docker
        return 0
    else
        echo -e "\033[1;31m❌ Erreur : Dossier docker non trouvé\033[0m"
        echo -e "\033[0;37m   Structure attendue :\033[0m"
        echo -e "\033[0;37m   - Si vous êtes à la racine : ./docker/\033[0m"
        echo -e "\033[0;37m   - Si vous êtes dans scripts/ : ../docker/\033[0m"
        return 1
    fi
}

# Fonction pour naviguer vers le dossier de sauvegarde
navigate_to_backups() {
    if [ -d "backups" ]; then
        echo "🗂️  Utilisation de ./backups"
        return 0
    elif [ -d "../backups" ]; then
        echo "🗂️  Utilisation de ../backups"
        return 0
    else
        echo "🗂️  Création du dossier backups"
        if [ -w "." ]; then
            mkdir -p backups
        elif [ -w ".." ]; then
            mkdir -p ../backups
        else
            echo -e "\033[1;31m❌ Erreur : Impossible de créer le dossier backups\033[0m"
            return 1
        fi
        return 0
    fi
}

# Fonction pour retourner à la racine du projet
navigate_to_root() {
    if [ -f "README.md" ] && [ -d "scripts" ] && [ -d "docker" ]; then
        echo "🗂️  Déjà à la racine du projet"
        return 0
    elif [ -f "../README.md" ] && [ -d "../scripts" ] && [ -d "../docker" ]; then
        echo "🗂️  Navigation vers la racine du projet"
        cd ..
        return 0
    else
        echo -e "\033[1;31m❌ Erreur : Impossible de localiser la racine du projet\033[0m"
        return 1
    fi
}

# Fonction pour détecter la position actuelle
detect_project_location() {
    local location=""
    
    if [ -f "README.md" ] && [ -d "scripts" ] && [ -d "docker" ]; then
        location="root"
    elif [ -f "../README.md" ] && [ -d "../scripts" ] && [ -d "../docker" ]; then
        location="subdirectory"
    else
        location="unknown"
    fi
    
    echo "$location"
}

# Fonction pour afficher l'aide de navigation
show_navigation_help() {
    echo -e "\033[1;34m📍 AIDE NAVIGATION\033[0m"
    echo -e "\033[0;37mStructure du projet CyberGuard Unified SOC :\033[0m"
    echo -e "\033[0;37m├── scripts/     # Scripts d'automatisation\033[0m"
    echo -e "\033[0;37m├── docker/      # Configurations Docker\033[0m"
    echo -e "\033[0;37m├── backups/     # Sauvegardes (auto-créé)\033[0m"
    echo -e "\033[0;37m└── README.md    # Documentation\033[0m"
    echo ""
    echo -e "\033[0;37mExécution recommandée :\033[0m"
    echo -e "\033[0;37m - Depuis la racine : ./scripts/script-name.sh\033[0m"
    echo -e "\033[0;37m - Les scripts naviguent automatiquement\033[0m"
}

# Export des fonctions pour utilisation externe
export -f navigate_to_docker
export -f navigate_to_backups  
export -f navigate_to_root
export -f detect_project_location
export -f show_navigation_help
