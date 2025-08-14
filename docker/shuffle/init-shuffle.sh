#!/bin/bash

# Script d'initialisation pour Shuffle
set -e

echo "🚀 Initialisation de Shuffle..."

# Variables d'environnement par défaut
export SHUFFLE_OPENSEARCH_URL=${SHUFFLE_OPENSEARCH_URL:-"http://elasticsearch:9200"}
export SHUFFLE_REDIS_URL=${SHUFFLE_REDIS_URL:-"redis://redis:6379"}
export DATASTORE_EMULATION=${DATASTORE_EMULATION:-"true"}
export SHUFFLE_ELASTIC=${SHUFFLE_ELASTIC:-"true"}

# Créer les répertoires nécessaires
mkdir -p /shuffle/data /shuffle/logs /shuffle/apps /shuffle/workflows /shuffle/files

# Attendre que les services dépendants soient prêts
echo "⏳ Attente des services dépendants..."

# Attendre Elasticsearch
echo "🔍 Vérification d'Elasticsearch..."
for i in {1..30}; do
    if curl -f "$SHUFFLE_OPENSEARCH_URL/_cluster/health" >/dev/null 2>&1; then
        echo "✅ Elasticsearch est prêt"
        break
    fi
    echo "⏳ Elasticsearch non prêt, tentative $i/30..."
    sleep 10
done

# Attendre Redis
echo "🔍 Vérification de Redis..."
for i in {1..30}; do
    if redis-cli -u "$SHUFFLE_REDIS_URL" ping >/dev/null 2>&1; then
        echo "✅ Redis est prêt"
        break
    fi
    echo "⏳ Redis non prêt, tentative $i/30..."
    sleep 5
done

# Initialiser la base de données si nécessaire
echo "🗄️ Initialisation de la base de données..."
if [ ! -f "/shuffle/data/db_initialized" ]; then
    echo "🆕 Première initialisation détectée"
    
    # Créer un utilisateur admin par défaut
    cat > /shuffle/data/admin_user.json << EOF
{
    "username": "admin",
    "password": "admin",
    "email": "admin@shuffle.local",
    "role": "admin",
    "active": true,
    "created": $(date +%s)
}
EOF
    
    touch /shuffle/data/db_initialized
    echo "✅ Base de données initialisée"
fi

# Configurer les permissions
chown -R shuffle:shuffle /shuffle/data /shuffle/logs /shuffle/apps 2>/dev/null || true

echo "🌐 Démarrage de Shuffle..."

# Démarrer Shuffle
exec /app/shuffle-backend
