#!/bin/bash

# Script de démarrage séquentiel pour CyberGuard Unified SOC
# =========================================================

set -e

echo "🚀 Démarrage de CyberGuard Unified SOC"
echo "======================================"

cd "$(dirname "$0")"

# Fonction pour attendre qu'un service soit prêt
wait_for_service() {
    local service_name=$1
    local port=$2
    local max_attempts=30
    local attempt=1
    
    echo "⏳ Attente de $service_name sur le port $port..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f "http://localhost:$port" >/dev/null 2>&1; then
            echo "✅ $service_name est prêt"
            return 0
        fi
        
        echo "   Tentative $attempt/$max_attempts..."
        sleep 10
        attempt=$((attempt + 1))
    done
    
    echo "❌ $service_name n'est pas prêt après $max_attempts tentatives"
    return 1
}

# Étape 1: Services de base de données
echo ""
echo "📊 [ÉTAPE 1] Démarrage des services de base de données"
echo "====================================================="
docker-compose up -d mongodb elasticsearch redis misp-db

echo "⏳ Attente de l'initialisation des bases de données..."
sleep 30

# Vérifier Elasticsearch
wait_for_service "Elasticsearch" "9200"

# Étape 2: Services principaux
echo ""
echo "🎯 [ÉTAPE 2] Démarrage des services principaux"
echo "=============================================="
docker-compose up -d backend

# Attendre le backend
wait_for_service "Backend API" "8000"

# Démarrer le frontend
docker-compose up -d frontend

# Attendre le frontend
wait_for_service "Frontend" "3000"

# Étape 3: Outils de sécurité
echo ""
echo "🛡️  [ÉTAPE 3] Démarrage des outils de sécurité"
echo "=============================================="

# Démarrer Wazuh
echo "🔍 Démarrage de Wazuh Manager..."
docker-compose up -d wazuh-manager
sleep 15

# Démarrer Graylog
echo "📊 Démarrage de Graylog..."
docker-compose up -d graylog
sleep 20

# Démarrer TheHive
echo "🕵️  Démarrage de TheHive..."
docker-compose up -d thehive
sleep 15

# Démarrer MISP
echo "🧬 Démarrage de MISP..."
docker-compose up -d misp
sleep 20

# Démarrer OpenCTI
echo "🧠 Démarrage d'OpenCTI..."
docker-compose up -d opencti
sleep 20

# Démarrer Velociraptor
echo "🏃 Démarrage de Velociraptor..."
docker-compose up -d velociraptor
sleep 15

# Démarrer Shuffle
echo "🔄 Démarrage de Shuffle..."
docker-compose up -d shuffle
sleep 20

# Vérification finale
echo ""
echo "🔍 [VÉRIFICATION] État des services"
echo "=================================="

docker-compose ps

echo ""
echo "🌐 [INTERFACES WEB] URLs d'accès"
echo "==============================="
echo "Frontend (React)     : http://localhost:3000"
echo "Backend API          : http://localhost:8000"
echo "Wazuh Manager        : http://localhost:55000"
echo "Graylog              : http://localhost:9000"
echo "TheHive              : http://localhost:9001"
echo "MISP                 : http://localhost (port 80/443)"
echo "OpenCTI              : http://localhost:8080"
echo "Velociraptor         : http://localhost:8889"
echo "Shuffle              : http://localhost:3443"
echo "Elasticsearch        : http://localhost:9200"

echo ""
echo "✅ Démarrage terminé !"
echo "💡 Utilisez './check-services.sh' pour vérifier l'état des services"
