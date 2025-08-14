#!/bin/bash

# Script d'initialisation pour Wazuh Manager
set -e

echo "🚀 Initialisation de Wazuh Manager..."

# Vérifier que les répertoires existent
mkdir -p /var/ossec/logs /var/ossec/queue

# Configurer les permissions
chown -R ossec:ossec /var/ossec/logs /var/ossec/queue 2>/dev/null || true

# Vérifier la configuration
if [ ! -f "/var/ossec/etc/ossec.conf" ]; then
    echo "❌ Configuration non trouvée: /var/ossec/etc/ossec.conf"
    exit 1
fi

echo "✅ Configuration trouvée"

# Initialiser Wazuh si nécessaire
if [ ! -f "/var/ossec/.initialized" ]; then
    echo "🆕 Première initialisation de Wazuh..."
    
    # Créer un agent par défaut si nécessaire
    /var/ossec/bin/manage_agents -a -n default-agent -i 001 -k default || true
    
    touch /var/ossec/.initialized
    echo "✅ Wazuh initialisé"
fi

echo "🌐 Démarrage de Wazuh Manager..."

# Démarrer Wazuh en mode foreground
exec /var/ossec/bin/wazuh-control foreground
