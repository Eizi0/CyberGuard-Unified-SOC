# Guide d'Installation CyberGuard Unified SOC

Ce guide détaille l'installation complète de CyberGuard Unified SOC sur différents systèmes Linux.

## Prérequis Système

### Systèmes d'Exploitation Supportés
- Ubuntu 20.04 LTS ou supérieur
- Debian 11 ou supérieur  
- CentOS 8 ou supérieur
- RHEL 8 ou supérieur
- Rocky Linux 8 ou supérieur

### Configuration Matérielle Minimale
- **CPU** : 8 cœurs
- **RAM** : 16 Go
- **Stockage** : 100 Go d'espace libre
- **Réseau** : 1 Gbps

### Configuration Matérielle Recommandée
- **CPU** : 16 cœurs ou plus
- **RAM** : 32 Go ou plus
- **Stockage** : 500 Go SSD
- **Réseau** : 10 Gbps

### Logiciels Requis
- **Docker Engine** : 24.x ou supérieur
- **Docker Compose** : 2.x ou supérieur
- **Git** : Version récente
- **OpenSSL** : Pour la génération de certificats
- **Curl/Wget** : Pour les téléchargements

### Ports Réseau Requis
| Service | Port | Protocole | Usage |
|---------|------|-----------|-------|
| Frontend | 3000 | TCP | Interface utilisateur web |
| Backend API | 8000 | TCP | API REST |
| MongoDB | 27017 | TCP | Base de données principale |
| Elasticsearch | 9200 | TCP | Moteur de recherche |
| Redis | 6379 | TCP | Cache et sessions |
| Wazuh Manager | 55000 | TCP | API Wazuh |
| Wazuh Agent | 1514 | UDP | Communication agents |
| Graylog Web | 9000 | TCP | Interface Graylog |
| Graylog Syslog | 1514 | UDP | Réception logs |
| Graylog GELF | 12201 | UDP | Réception logs GELF |
| TheHive | 9001 | TCP | Gestion des incidents |
| MISP | 443 | TCP | Threat Intelligence |
| MISP HTTP | 80 | TCP | Redirection HTTPS |
| OpenCTI | 8080 | TCP | CTI Platform |
| Velociraptor | 8889 | TCP | Digital Forensics |
| Shuffle | 3443 | TCP | Automatisation SOAR |

## Installation Automatisée (Recommandée)

### 1. Téléchargement et Préparation
```bash
# Cloner le repository
git clone https://github.com/votre-org/cyberguard-unified-soc.git
cd cyberguard-unified-soc

# Rendre le script exécutable
chmod +x scripts/install.sh
```

### 2. Exécution de l'Installation
```bash
# Exécuter en tant que root (ou avec sudo)
sudo ./scripts/install.sh
```

Le script automatisé effectue les actions suivantes :
- Détection automatique du système d'exploitation
- Vérification des prérequis système
- Installation de Docker et Docker Compose
- Configuration du système (limits, sysctl)
- Création de la structure de projet
- Configuration des variables d'environnement
- Génération des certificats SSL
- Construction et démarrage des services
- Vérification de l'installation

## Installation Manuelle

### 1. Préparation du Système

#### Ubuntu/Debian
```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation des dépendances
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget \
    unzip \
    git \
    htop \
    net-tools \
    openssl
```

#### CentOS/RHEL/Rocky Linux
```bash
# Mise à jour du système
sudo yum update -y

# Installation des dépendances
sudo yum install -y \
    curl \
    wget \
    unzip \
    git \
    htop \
    net-tools \
    openssl \
    yum-utils \
    device-mapper-persistent-data \
    lvm2
```

### 2. Installation de Docker

#### Ubuntu/Debian
```bash
# Suppression des anciennes versions
sudo apt remove -y docker docker-engine docker.io containerd runc

# Ajout de la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Configuration du repository Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation de Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### CentOS/RHEL/Rocky Linux
```bash
# Suppression des anciennes versions
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# Ajout du repository Docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Installation de Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 3. Configuration de Docker
```bash
# Démarrage et activation de Docker
sudo systemctl start docker
sudo systemctl enable docker

# Ajout de l'utilisateur au groupe docker
sudo usermod -aG docker $USER

# Configuration du daemon Docker pour de meilleures performances
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json << EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "storage-driver": "overlay2"
}
EOF

sudo systemctl restart docker
```

### 4. Installation de Docker Compose (si nécessaire)
```bash
# Vérifier si Docker Compose plugin est disponible
if ! docker compose version &> /dev/null; then
    # Installation de Docker Compose standalone
    LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${LATEST_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi
```

### 5. Configuration Système
```bash
# Augmentation des limites pour Elasticsearch
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Augmentation des limites de fichiers
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf
```

### 6. Clone et Configuration du Projet
```bash
# Clone du repository
git clone https://github.com/votre-org/cyberguard-unified-soc.git
cd cyberguard-unified-soc

# Configuration des variables d'environnement
cp .env.example .env

# Édition du fichier .env (personnaliser selon vos besoins)
nano .env
```

### 7. Génération des Certificats SSL
```bash
# Création du répertoire SSL
mkdir -p ssl

# Génération de certificats auto-signés
openssl req -x509 -newkey rsa:4096 -keyout ssl/key.pem -out ssl/cert.pem -days 365 -nodes \
    -subj "/C=FR/ST=Region/L=City/O=Organization/OU=SOC/CN=localhost"
```

### 8. Déploiement des Services
```bash
cd docker

# Construction des images
docker compose build --no-cache

# Démarrage des bases de données
docker compose up -d mongodb elasticsearch redis misp-db

# Attente de l'initialisation des bases de données
sleep 60

# Démarrage des services principaux
docker compose up -d backend frontend

# Démarrage des outils de sécurité
docker compose up -d wazuh-manager graylog thehive misp opencti velociraptor shuffle
```

## Configuration Post-Installation

### 1. Vérification de l'État des Services
```bash
# Vérifier l'état des conteneurs
docker compose ps

# Vérifier les logs
docker compose logs -f [service_name]
```

### 2. Accès aux Interfaces Web
Une fois tous les services démarrés (environ 5-10 minutes), vous pouvez accéder aux interfaces :

| Service | URL | Utilisateur | Mot de passe |
|---------|-----|-------------|--------------|
| **Frontend Principal** | http://localhost:3000 | - | - |
| **Backend API** | http://localhost:8000/docs | - | - |
| **Graylog** | http://localhost:9000 | admin | admin |
| **TheHive** | http://localhost:9001 | admin@thehive.local | secret |
| **MISP** | https://localhost:443 | admin@admin.test | admin |
| **OpenCTI** | http://localhost:8080 | admin@cyberguard.local | cyberguard_admin |
| **Velociraptor** | http://localhost:8889 | admin | cyberguard_velociraptor_password |
| **Shuffle** | https://localhost:3443 | admin | cyberguard_shuffle_secret |

### 3. Configuration Initiale des Services

#### Graylog
1. Accéder à http://localhost:9000
2. Se connecter avec admin/admin
3. Configurer les inputs pour recevoir les logs
4. Créer des dashboards personnalisés

#### TheHive
1. Accéder à http://localhost:9001
2. Créer le premier utilisateur administrateur
3. Configurer les organisations et utilisateurs
4. Paramétrer les intégrations

#### MISP
1. Accéder à https://localhost:443
2. Se connecter avec admin@admin.test/admin
3. Configurer l'organisation
4. Importer les flux de threat intelligence

#### OpenCTI
1. Accéder à http://localhost:8080
2. Se connecter avec les credentials configurés
3. Configurer les connecteurs
4. Importer les données de référence

### 4. Sécurisation (OBLIGATOIRE pour la production)

```bash
# Modifier tous les mots de passe par défaut
# Éditer le fichier .env avec des valeurs sécurisées
nano .env

# Générer des mots de passe sécurisés
openssl rand -base64 32  # Pour les secrets

# Redémarrer les services avec les nouvelles configurations
docker compose down
docker compose up -d
```

## Maintenance et Supervision

### Commandes Utiles
```bash
# Voir l'état des services
docker compose ps

# Voir les logs
docker compose logs -f [service_name]

# Redémarrer un service
docker compose restart [service_name]

# Voir l'utilisation des ressources
docker stats

# Sauvegarder les données
docker compose exec mongodb mongodump --out /backup/
```

### Sauvegarde
```bash
# Créer un script de sauvegarde
./scripts/backup.sh

# Programmer une sauvegarde quotidienne
echo "0 2 * * * /path/to/cyberguard/scripts/backup.sh" | sudo crontab -
```

## Résolution des Problèmes Courants

### Problème 1 : Services qui ne démarrent pas
```bash
# Vérifier l'état des conteneurs
docker compose ps

# Vérifier les logs détaillés
docker compose logs [service_name]

# Vérifier les ressources système
df -h          # Espace disque
free -m        # Mémoire
docker stats   # Utilisation des conteneurs
```

**Solutions courantes :**
- Vérifier l'espace disque disponible (minimum 100GB)
- Augmenter la mémoire allouée à Docker
- Vérifier que les ports ne sont pas déjà utilisés
- Redémarrer Docker : `sudo systemctl restart docker`

### Problème 2 : Elasticsearch ne démarre pas
```bash
# Vérifier la configuration vm.max_map_count
sysctl vm.max_map_count

# Si inférieur à 262144, l'augmenter
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

### Problème 3 : Problèmes de permissions
```bash
# Corriger les permissions des volumes
sudo chown -R 1000:1000 data/
sudo chmod -R 755 data/

# Pour Elasticsearch spécifiquement
sudo chown -R 1000:1000 data/elasticsearch/
```

### Problème 4 : Services lents ou qui timeout
```bash
# Augmenter les timeouts Docker Compose
export COMPOSE_HTTP_TIMEOUT=300
export DOCKER_CLIENT_TIMEOUT=300

# Ou éditer le fichier docker-compose.yml pour ajouter des healthchecks
```

### Problème 5 : Erreurs de connectivité réseau
```bash
# Vérifier les réseaux Docker
docker network ls
docker network inspect docker_default

# Recréer les réseaux si nécessaire
docker compose down
docker network prune
docker compose up -d
```

### Problème 6 : Images qui ne se construisent pas
```bash
# Nettoyer le cache Docker
docker system prune -a

# Construire les images une par une
docker compose build --no-cache [service_name]

# Vérifier les Dockerfiles pour des erreurs
```

## Support et Documentation

### Ressources Disponibles
- **Documentation complète** : `docs/`
- **Guide utilisateur** : `docs/user-guide.md`  
- **Configuration avancée** : `docs/configuration.md`
- **Architecture** : `docs/architecture.md`
- **Sécurité** : `docs/security.md`
- **Dépannage** : `docs/troubleshooting.md`

### Obtenir de l'Aide
1. **Logs détaillés** : `docker compose logs -f [service]`
2. **Issues GitHub** : Créer une issue avec les logs
3. **Documentation** : Consulter les guides spécialisés
4. **Community** : Forums et discussions

### Commandes de Diagnostic
```bash
# Rapport complet du système
./scripts/diagnostic.sh

# Vérification de la santé des services
./scripts/health-check.sh

# Export des logs pour analyse
docker compose logs > system-logs.txt
```

## Notes Importantes

### Sécurité en Production
⚠️ **ATTENTION** : Cette installation est configurée pour un environnement de développement/test.

Pour un déploiement en production :
1. **Modifier TOUS les mots de passe par défaut**
2. **Configurer des certificats SSL valides**
3. **Configurer un firewall approprié**
4. **Activer l'authentification forte (2FA)**
5. **Configurer des sauvegardes automatiques**
6. **Mettre en place une supervision**
7. **Durcir les configurations de sécurité**

### Performance
- **RAM minimum** : 16GB pour tous les services
- **RAM recommandée** : 32GB+ pour de meilleures performances
- **Stockage** : SSD recommandé pour de meilleures performances
- **Réseau** : Bande passante suffisante pour le volume de logs

### Mise à Jour
```bash
# Sauvegarder avant mise à jour
./scripts/backup.sh

# Mettre à jour le code
git pull origin main

# Reconstruire et redéployer
docker compose down
docker compose build --no-cache
docker compose up -d
```

---

**Version du guide** : 2.0  
**Dernière mise à jour** : Août 2025  
**Testé sur** : Ubuntu 22.04, Debian 12, Rocky Linux 9
