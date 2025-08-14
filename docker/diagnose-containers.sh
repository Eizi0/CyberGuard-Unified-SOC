#!/bin/bash

# Script de diagnostic pour Velociraptor et Shuffle
# =================================================

echo "🔍 DIAGNOSTIC VELOCIRAPTOR & SHUFFLE"
echo "===================================="

# Fonction pour vérifier un service
check_service() {
    local service_name=$1
    local container_name=$2
    local port=$3
    local health_endpoint=$4
    
    echo ""
    echo "📋 Vérification de $service_name ($container_name)"
    echo "=================================================="
    
    # Vérifier si le conteneur existe
    if docker ps -a --format "table {{.Names}}" | grep -q "^$container_name$"; then
        echo "✅ Conteneur trouvé: $container_name"
        
        # Vérifier l'état du conteneur
        container_status=$(docker inspect --format='{{.State.Status}}' $container_name)
        echo "📊 État: $container_status"
        
        if [ "$container_status" = "running" ]; then
            echo "✅ Conteneur en cours d'exécution"
            
            # Vérifier le port
            if docker port $container_name | grep -q ":$port"; then
                echo "✅ Port $port exposé"
                
                # Tester la connectivité
                if curl -f "http://localhost:$port$health_endpoint" >/dev/null 2>&1; then
                    echo "✅ Service accessible sur le port $port"
                else
                    echo "❌ Service non accessible sur le port $port"
                fi
            else
                echo "❌ Port $port non exposé"
            fi
            
        else
            echo "❌ Conteneur arrêté"
            echo "📜 Derniers logs:"
            docker logs --tail 20 $container_name
        fi
        
    else
        echo "❌ Conteneur non trouvé: $container_name"
    fi
}

# Vérifier Docker
echo "🐳 Vérification de Docker"
echo "========================="
if command -v docker >/dev/null 2>&1; then
    echo "✅ Docker installé"
    if docker info >/dev/null 2>&1; then
        echo "✅ Docker daemon en cours d'exécution"
    else
        echo "❌ Docker daemon non accessible"
        exit 1
    fi
else
    echo "❌ Docker non installé"
    exit 1
fi

# Vérifier Docker Compose
if command -v docker-compose >/dev/null 2>&1; then
    echo "✅ Docker Compose installé"
else
    echo "❌ Docker Compose non installé"
fi

# Vérifier les services
check_service "Velociraptor" "velociraptor" "8889" "/health"
check_service "Shuffle" "shuffle" "3443" "/health"

echo ""
echo "📊 RÉSUMÉ DES CONTENEURS"
echo "======================="
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(velociraptor|shuffle)"

echo ""
echo "🔍 DIAGNOSTIC DES FICHIERS"
echo "=========================="

# Vérifier les fichiers Velociraptor
echo ""
echo "📁 Velociraptor"
echo "--------------"
if [ -f "./velociraptor/Dockerfile" ]; then
    echo "✅ Dockerfile présent"
else
    echo "❌ Dockerfile manquant"
fi

if [ -f "./velociraptor/config/server.config.yaml" ]; then
    echo "✅ Configuration présente"
else
    echo "❌ Configuration manquante"
fi

if [ -f "./velociraptor/init-velociraptor.sh" ]; then
    echo "✅ Script d'initialisation présent"
else
    echo "❌ Script d'initialisation manquant"
fi

# Vérifier les fichiers Shuffle
echo ""
echo "📁 Shuffle"
echo "----------"
if [ -f "./shuffle/Dockerfile" ]; then
    echo "✅ Dockerfile présent"
else
    echo "❌ Dockerfile manquant"
fi

if [ -f "./shuffle/config/shuffle-config.yaml" ]; then
    echo "✅ Configuration présente"
else
    echo "❌ Configuration manquante"
fi

if [ -f "./shuffle/init-shuffle.sh" ]; then
    echo "✅ Script d'initialisation présent"
else
    echo "❌ Script d'initialisation manquant"
fi

echo ""
echo "🚀 COMMANDES DE DÉPANNAGE"
echo "========================="
echo "Pour reconstruire les images:"
echo "  docker-compose build velociraptor shuffle"
echo ""
echo "Pour redémarrer les services:"
echo "  docker-compose restart velociraptor shuffle"
echo ""
echo "Pour voir les logs:"
echo "  docker-compose logs velociraptor"
echo "  docker-compose logs shuffle"
echo ""
echo "Pour démarrer en mode débug:"
echo "  docker-compose up velociraptor shuffle"
