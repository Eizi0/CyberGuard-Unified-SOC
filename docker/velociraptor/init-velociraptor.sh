#!/bin/bash

# Script d'initialisation pour Velociraptor
set -e

echo "🚀 Initialisation de Velociraptor..."

# Vérifier que les répertoires existent
mkdir -p /opt/velociraptor/data /var/log

# Vérifier la configuration
if [ ! -f "/etc/velociraptor/server.config.yaml" ]; then
    echo "❌ Configuration non trouvée: /etc/velociraptor/server.config.yaml"
    exit 1
fi

echo "✅ Configuration trouvée"

# Générer les certificats si nécessaire
if [ ! -f "/opt/velociraptor/data/server.pem" ]; then
    echo "🔑 Génération des certificats..."
    /velociraptor --config /etc/velociraptor/server.config.yaml config generate --merge_file /etc/velociraptor/server.config.yaml > /tmp/merged_config.yaml
    mv /tmp/merged_config.yaml /etc/velociraptor/server.config.yaml
fi

# Créer un utilisateur admin par défaut si nécessaire
echo "👤 Création de l'utilisateur admin..."
/velociraptor --config /etc/velociraptor/server.config.yaml user add admin --password admin --role administrator || true

# Démarrer le frontend
echo "🌐 Démarrage du frontend Velociraptor..."
exec /velociraptor --config /etc/velociraptor/server.config.yaml frontend
