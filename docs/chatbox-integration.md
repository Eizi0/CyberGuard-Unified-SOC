# Guide d'Intégration du Chatbox IA

## Vue d'Ensemble

Le Chatbox IA est un composant intégré qui permet d'interagir avec différents modèles d'IA (OpenAI et Anthropic) via une interface graphique ou une API.

## Configuration

### Variables d'Environnement

```env
# Configuration IA
AI_PROVIDER=openai # ou anthropic
OPENAI_API_KEY=your_openai_api_key
ANTHROPIC_API_KEY=your_anthropic_api_key

# Configuration Chatbox
CHATBOX_HISTORY_RETENTION=30 # jours
CHATBOX_MAX_TOKENS=2000
CHATBOX_TEMPERATURE=0.7
```

### Configuration des Modèles

```yaml
# config/chatbox.yaml
providers:
  openai:
    models:
      - name: gpt-4
        max_tokens: 4096
        temperature_range: [0.1, 1.0]
      - name: gpt-3.5-turbo
        max_tokens: 2048
        temperature_range: [0.1, 1.0]
        
  anthropic:
    models:
      - name: claude-2
        max_tokens: 8192
        temperature_range: [0.1, 1.0]
      - name: claude-instant-1
        max_tokens: 4096
        temperature_range: [0.1, 1.0]

defaults:
  provider: openai
  model: gpt-3.5-turbo
  temperature: 0.7
  max_tokens: 2000
```

## Interface API

### Endpoints

#### Configuration du Provider
```http
POST /api/v1/chatbox/config
Content-Type: application/json

{
    "provider": "openai",
    "api_key": "your_api_key",
    "default_model": "gpt-4",
    "temperature": 0.7,
    "max_tokens": 2000
}
```

#### Envoi de Message
```http
POST /api/v1/chatbox/chat
Content-Type: application/json

{
    "message": "Votre message ici",
    "context": "Contexte optionnel",
    "model": "gpt-4",  // optionnel
    "temperature": 0.7  // optionnel
}
```

#### Historique des Conversations
```http
GET /api/v1/chatbox/history
```

#### Effacement de l'Historique
```http
DELETE /api/v1/chatbox/history
```

## Interface Graphique

### Configuration via GUI

1. Accédez à l'interface d'administration
2. Naviguez vers "Configuration → Chatbox IA"
3. Configurez les paramètres :
   - Sélection du provider (OpenAI/Anthropic)
   - Saisie de l'API key
   - Choix du modèle par défaut
   - Réglages de température et tokens

### Utilisation du Chatbox

1. Ouvrez l'interface du chatbox
2. Options disponibles :
   - Sélection du modèle
   - Ajustement des paramètres
   - Historique des conversations
   - Export des conversations

## Intégration Backend

### Structure des Fichiers

```plaintext
backend/
├── chatbox/
│   ├── __init__.py
│   ├── routes.py
│   ├── models.py
│   ├── services.py
│   └── providers/
│       ├── __init__.py
│       ├── base.py
│       ├── openai.py
│       └── anthropic.py
```

### Base de Données

```sql
-- Table des configurations
CREATE TABLE chatbox_config (
    id SERIAL PRIMARY KEY,
    provider VARCHAR(50),
    api_key VARCHAR(255),
    default_model VARCHAR(50),
    temperature FLOAT,
    max_tokens INTEGER,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Table de l'historique
CREATE TABLE chatbox_history (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    message TEXT,
    response TEXT,
    model VARCHAR(50),
    created_at TIMESTAMP
);
```

## Sécurité

### Stockage Sécurisé des API Keys

- Chiffrement des clés API en base de données
- Utilisation de Vault pour la gestion des secrets
- Rotation périodique des clés

### Limitations et Contrôles

```yaml
# config/chatbox_security.yaml
rate_limiting:
  max_requests_per_minute: 60
  max_tokens_per_day: 100000

content_filtering:
  enabled: true
  forbidden_keywords: []
  content_moderation: true

access_control:
  roles:
    admin:
      - configure_provider
      - view_all_history
      - delete_history
    user:
      - send_messages
      - view_own_history
```

## Monitoring

### Métriques

- Nombre de requêtes par provider
- Temps de réponse
- Taux d'erreur
- Consommation de tokens

### Alertes

```yaml
# config/chatbox_monitoring.yaml
alerts:
  - name: high_error_rate
    threshold: 10
    window: 5m
    
  - name: high_latency
    threshold: 5000  # ms
    window: 5m
    
  - name: token_limit_approaching
    threshold: 90  # pourcentage
    window: 24h
```

## Exemples d'Utilisation

### Via API

```python
import requests

# Configuration
response = requests.post(
    "http://localhost:8000/api/v1/chatbox/config",
    json={
        "provider": "openai",
        "api_key": "your_api_key",
        "default_model": "gpt-4"
    }
)

# Envoi de message
response = requests.post(
    "http://localhost:8000/api/v1/chatbox/chat",
    json={
        "message": "Analysez ces logs de sécurité",
        "context": "Analyse de logs"
    }
)
```

### Via Interface Web

1. Accès à l'interface :
   ```
   https://soc.example.com/chatbox
   ```

2. Actions disponibles :
   - Configuration du provider
   - Envoi de messages
   - Visualisation de l'historique
   - Export des conversations

## Maintenance

### Nettoyage des Données

```bash
# Nettoyage de l'historique ancien
./scripts/cleanup-chatbox-history.sh

# Rotation des logs
./scripts/rotate-chatbox-logs.sh
```

### Backups

```bash
# Sauvegarde des configurations et historique
./scripts/backup-chatbox-data.sh
```

## Dépannage

### Problèmes Courants

1. Erreurs d'API
   - Vérifier la validité des clés API
   - Vérifier les quotas

2. Problèmes de Performance
   - Vérifier la configuration rate limiting
   - Optimiser les requêtes

3. Problèmes de Connexion
   - Vérifier la connectivité réseau
   - Vérifier les logs d'erreur
