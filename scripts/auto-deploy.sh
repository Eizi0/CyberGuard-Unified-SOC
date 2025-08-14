#!/bin/bash

# 🔍 Détection automatique des ressources et sélection du profil optimal
# CyberGuard Unified SOC - Auto Profile Selector (Linux)

echo "🔍 Détection des ressources système..."

# Fonction pour obtenir la RAM totale en GB
get_total_ram_gb() {
    local ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    echo "scale=1; $ram_kb / 1024 / 1024" | bc
}

# Fonction pour obtenir la RAM disponible en GB
get_available_ram_gb() {
    local ram_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    echo "scale=1; $ram_kb / 1024 / 1024" | bc
}

# Fonction pour obtenir le nombre de cœurs CPU
get_cpu_cores() {
    nproc
}

# Fonction pour obtenir l'espace disque disponible en GB
get_available_disk_gb() {
    df / | awk 'NR==2 {print int($4/1024/1024)}'
}

# Détection des ressources
total_ram=$(get_total_ram_gb)
available_ram=$(get_available_ram_gb)
cpu_cores=$(get_cpu_cores)
disk_space=$(get_available_disk_gb)

echo -e "\033[1;33m📊 Ressources système détectées :\033[0m"
echo -e "\033[1;32m   💾 RAM Totale : ${total_ram} GB\033[0m"
echo -e "\033[1;32m   💾 RAM Disponible : ${available_ram} GB\033[0m"
echo -e "\033[1;32m   🖥️  Cœurs CPU : ${cpu_cores}\033[0m"
echo -e "\033[1;32m   💿 Espace Disque : ${disk_space} GB\033[0m"
echo ""

# Recommandation de profil basée sur les ressources
recommended_profile=""
config_file=""
warnings=()

# Comparaison numérique avec bc
if (( $(echo "$total_ram >= 16" | bc -l) )) && (( cpu_cores >= 8 )) && (( disk_space >= 100 )); then
    recommended_profile="🚀 COMPLET"
    config_file="docker-compose.yml"
    echo -e "\033[1;32m✅ Recommandation : Profil COMPLET\033[0m"
    echo -e "\033[0;37m   Tous les 9 outils de sécurité seront déployés\033[0m"
elif (( $(echo "$total_ram >= 8" | bc -l) )) && (( cpu_cores >= 6 )) && (( disk_space >= 50 )); then
    recommended_profile="⚡ MINIMAL"
    config_file="docker-compose.minimal.yml"
    echo -e "\033[1;33m⚠️  Recommandation : Profil MINIMAL\033[0m"
    echo -e "\033[0;37m   Services core + outils essentiels de sécurité\033[0m"
    if (( $(echo "$total_ram < 12" | bc -l) )); then
        warnings+=("RAM limitée - performances réduites possibles")
    fi
elif (( $(echo "$total_ram >= 4" | bc -l) )) && (( cpu_cores >= 4 )) && (( disk_space >= 25 )); then
    recommended_profile="🏁 DÉVELOPPEMENT"
    config_file="docker-compose.dev.yml"
    echo -e "\033[1;33m⚠️  Recommandation : Profil DÉVELOPPEMENT\033[0m"
    echo -e "\033[0;37m   Services essentiels uniquement pour tests\033[0m"
    warnings+=("Configuration limitée - non recommandée pour production")
    if (( $(echo "$total_ram < 6" | bc -l) )); then
        warnings+=("RAM très limitée - instabilité possible")
    fi
else
    echo -e "\033[1;31m❌ ERREUR : Ressources insuffisantes\033[0m"
    echo -e "\033[1;31m   Minimum requis : 4GB RAM, 4 CPU cores, 25GB disque\033[0m"
    echo ""
    echo -e "\033[1;33m🛠️  Solutions recommandées :\033[0m"
    echo -e "\033[0;37m   1. Augmenter la RAM à 8GB minimum\033[0m"
    echo -e "\033[0;37m   2. Utiliser une VM avec plus de ressources\033[0m"
    echo -e "\033[0;37m   3. Déployer sur un serveur dédié\033[0m"
    exit 1
fi

# Affichage des avertissements
if [ ${#warnings[@]} -gt 0 ]; then
    echo ""
    echo -e "\033[1;33m⚠️  Avertissements :\033[0m"
    for warning in "${warnings[@]}"; do
        echo -e "\033[0;33m   • $warning\033[0m"
    done
fi

echo ""
echo -e "\033[1;36m🎯 Profil recommandé : $recommended_profile\033[0m"
echo -e "\033[0;37m📄 Fichier de configuration : $config_file\033[0m"

# Menu de choix
echo ""
echo -e "\033[1;33mQue souhaitez-vous faire ?\033[0m"
echo -e "\033[1;32m1. 🚀 Déployer avec le profil recommandé\033[0m"
echo -e "\033[1;34m2. 🔧 Choisir un autre profil manuellement\033[0m"
echo -e "\033[1;36m3. 📊 Voir les détails des profils\033[0m"
echo -e "\033[1;31m4. ❌ Annuler\033[0m"

read -p "Votre choix (1-4): " choice

case $choice in
    1)
        echo ""
        echo -e "\033[1;32m🚀 Déploiement du profil $recommended_profile...\033[0m"
        
        # Navigation intelligente vers le dossier docker
        if [ -d "docker" ]; then
            cd docker
        elif [ -d "../docker" ]; then
            cd ../docker
        else
            echo -e "\033[1;31m❌ Erreur : Dossier docker non trouvé\033[0m"
            echo -e "\033[0;37m   Assurez-vous d'être dans le projet CyberGuard\033[0m"
            exit 1
        fi
        
        # Vérifier si Docker est démarré
        if docker version &>/dev/null; then
            echo -e "\033[1;32m✅ Docker est opérationnel\033[0m"
        else
            echo -e "\033[1;31m❌ Erreur : Docker n'est pas démarré\033[0m"
            echo -e "\033[0;37m   Veuillez démarrer Docker et réessayer\033[0m"
            echo -e "\033[0;37m   sudo systemctl start docker\033[0m"
            exit 1
        fi
        
        # Déployer avec le profil recommandé
        docker-compose -f "$config_file" up -d
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "\033[1;32m✅ Déploiement réussi !\033[0m"
            echo ""
            echo -e "\033[1;36m🌐 Accès aux services :\033[0m"
            echo -e "\033[0;37m   Frontend : http://localhost:3000\033[0m"
            echo -e "\033[0;37m   Backend API : http://localhost:8000\033[0m"
            if [ "$config_file" != "docker-compose.dev.yml" ]; then
                echo -e "\033[0;37m   Graylog : http://localhost:9000\033[0m"
                echo -e "\033[0;37m   Wazuh : http://localhost:55000\033[0m"
            fi
            
            echo ""
            echo -e "\033[1;33m📝 Commandes utiles :\033[0m"
            echo -e "\033[0;90m   docker-compose -f $config_file ps\033[0m"
            echo -e "\033[0;90m   docker-compose -f $config_file logs -f\033[0m"
            echo -e "\033[0;90m   docker-compose -f $config_file down\033[0m"
        else
            echo -e "\033[1;31m❌ Erreur lors du déploiement\033[0m"
            echo -e "\033[0;37m   Consultez les logs : docker-compose -f $config_file logs\033[0m"
        fi
        ;;
    
    2)
        echo ""
        echo -e "\033[1;34m🔧 Sélection manuelle du profil :\033[0m"
        echo -e "\033[0;37m1. 🏁 Développement (4-8GB) - docker-compose.dev.yml\033[0m"
        echo -e "\033[0;37m2. ⚡ Minimal (8-12GB) - docker-compose.minimal.yml\033[0m"
        echo -e "\033[0;37m3. 🚀 Complet (16GB+) - docker-compose.yml\033[0m"
        
        read -p "Choisissez un profil (1-3): " manual_choice
        
        case $manual_choice in
            1) selected_file="docker-compose.dev.yml" ;;
            2) selected_file="docker-compose.minimal.yml" ;;
            3) selected_file="docker-compose.yml" ;;
            *) echo -e "\033[1;31m❌ Choix invalide\033[0m"; exit 1 ;;
        esac
        
        echo -e "\033[1;32m📄 Profil sélectionné : $selected_file\033[0m"
        
        # Navigation intelligente vers le dossier docker
        if [ -d "docker" ]; then
            cd docker
        elif [ -d "../docker" ]; then
            cd ../docker
        else
            echo -e "\033[1;31m❌ Erreur : Dossier docker non trouvé\033[0m"
            exit 1
        fi
        
        docker-compose -f "$selected_file" up -d
        ;;
    
    3)
        echo ""
        echo -e "\033[1;36m📊 Détails des profils disponibles :\033[0m"
        echo ""
        echo -e "\033[1;33m🏁 DÉVELOPPEMENT (docker-compose.dev.yml)\033[0m"
        echo -e "\033[0;90m   RAM : 4-8GB | CPU : 4+ cores | Disque : 25GB\033[0m"
        echo -e "\033[0;90m   Services : Frontend, Backend, MongoDB, Elasticsearch, Wazuh, Graylog\033[0m"
        echo -e "\033[0;90m   Usage : Tests, démonstrations, développement\033[0m"
        echo ""
        echo -e "\033[1;33m⚡ MINIMAL (docker-compose.minimal.yml)\033[0m"
        echo -e "\033[0;90m   RAM : 8-12GB | CPU : 6+ cores | Disque : 50GB\033[0m"
        echo -e "\033[0;90m   Services : Core + TheHive, configurations optimisées mémoire\033[0m"
        echo -e "\033[0;90m   Usage : PME, environnements contraints, POC\033[0m"
        echo ""
        echo -e "\033[1;33m🚀 COMPLET (docker-compose.yml)\033[0m"
        echo -e "\033[0;90m   RAM : 16GB+ | CPU : 8+ cores | Disque : 100GB+\033[0m"
        echo -e "\033[0;90m   Services : Tous les 9 outils (Wazuh, Graylog, TheHive, MISP, OpenCTI, etc.)\033[0m"
        echo -e "\033[0;90m   Usage : Production, SOC complet, entreprise\033[0m"
        
        echo ""
        read -p "Appuyez sur Entrée pour continuer..."
        
        # Relancer le script
        exec "$0"
        ;;
    
    4)
        echo -e "\033[1;31m❌ Annulation du déploiement\033[0m"
        exit 0
        ;;
    
    *)
        echo -e "\033[1;31m❌ Choix invalide\033[0m"
        exit 1
        ;;
esac
