# Guide d'Installation

Ce guide détaille l'installation de CyberGuard Unified SOC sur un nouveau serveur.

## Prérequis Système

### Configuration Matérielle Minimale
- CPU : 8 cœurs
- RAM : 16 Go
- Stockage : 100 Go
- Réseau : 1 Gbps

### Configuration Matérielle Recommandée
- CPU : 16 cœurs
- RAM : 32 Go
- Stockage : 500 Go SSD
- Réseau : 10 Gbps

### Logiciels Requis
- Docker Engine 24.x ou supérieur
- Docker Compose 2.x ou supérieur
- Git
- Make (optionnel)

### Ports Requis
| Service | Port | Usage |
|---------|------|-------|
| Frontend | 3000 | Interface utilisateur |
| Backend API | 8000 | API REST |
| Wazuh | 55000 | SIEM |
| Graylog | 9000 | Gestion des logs |
| TheHive | 9001 | Gestion des cas |
| MISP | 443 | Threat Intelligence |
| OpenCTI | 8080 | CTI Platform |
| Velociraptor | 8889 | Digital Forensics |
| Shuffle | 3443 | Automatisation |

## Installation

1. Préparation du système :
```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation des dépendances
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

2. Installation de Docker :
```bash
# Ajout de la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Configuration du repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation de Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

3. Installation de Docker Compose :
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

4. Clone du projet :
```bash
git clone https://github.com/votre-username/cyberguard-unified-soc.git
cd cyberguard-unified-soc
```

5. Configuration :
```bash
cp .env.example .env
# Éditer .env avec les paramètres appropriés
```

6. Démarrage :
```bash
docker-compose up -d
```

## Vérification de l'Installation

1. Vérifier que tous les conteneurs sont en cours d'exécution :
```bash
docker-compose ps
```

2. Vérifier les logs :
```bash
docker-compose logs
```

3. Tester l'accès aux interfaces web :
- Frontend : http://localhost:3000
- Backend API : http://localhost:8000/docs
- Wazuh : http://localhost:55000
- Graylog : http://localhost:9000
- TheHive : http://localhost:9001
- MISP : https://localhost
- OpenCTI : http://localhost:8080
- Velociraptor : http://localhost:8889
- Shuffle : http://localhost:3443

## Résolution des Problèmes Courants

### Problème 1 : Conteneur qui ne démarre pas
```bash
# Vérifier les logs du conteneur
docker-compose logs [service_name]
```

### Problème 2 : Problèmes de mémoire
```bash
# Vérifier l'utilisation de la mémoire
docker stats
```

### Problème 3 : Problèmes de stockage
```bash
# Vérifier l'espace disque
df -h
```

## Support

Pour toute assistance supplémentaire :
- Créer une issue sur GitHub
- Consulter la documentation complète
- Contacter l'équipe support
