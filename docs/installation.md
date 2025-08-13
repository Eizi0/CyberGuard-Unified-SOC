# 🚀 Guide d'Installation CyberGuard Unified SOC

<div align="center">
  <img src="../Logo/CSU Logo.png" alt="CSU Logo" width="150"/>
  
  **Guide d'Installation Complet - Multi-Plateforme**
</div>

---

## 🖥️ Systèmes Supportés

### **🪟 Windows**
- Windows 10/11 Pro (64-bit)
- Windows Server 2019/2022
- Docker Desktop avec WSL2
- PowerShell 5.1+

### **🐧 Linux**
- Ubuntu 20.04+ LTS
- Debian 11+
- CentOS/RHEL 8+
- Rocky Linux 8+
- Docker Engine 24.x+

---

## 📊 Profils de Déploiement

CyberGuard Unified SOC propose **3 profils** selon vos ressources disponibles :

### **🏁 Profil Développement**
```
RAM : 4-8GB | CPU : 4+ cores | Disque : 25GB
Services : Core + Wazuh + Graylog
Usage : Tests, démonstrations, développement
```

### **⚡ Profil Minimal Production**
```
RAM : 8-12GB | CPU : 6+ cores | Disque : 50GB  
Services : Core + 5 outils sécurité
Usage : PME, environnements contraints, POC
```

### **🚀 Profil Complet Enterprise**
```
RAM : 16GB+ | CPU : 8+ cores | Disque : 100GB+
Services : Tous les 9 outils + infrastructure complète
Usage : Production, SOC complet, entreprise
```

---

## 🤖 Installation Automatisée Intelligente (RECOMMANDÉE)

### **🪟 Windows - Déploiement Intelligent**

#### **1️⃣ Préparation**
```powershell
# Cloner le projet
git clone https://github.com/votre-org/cyberguard-unified-soc.git
Set-Location "CyberGuard Unified SOC"

# Vérifier les prérequis
docker --version
docker-compose --version
```

#### **2️⃣ Déploiement avec Auto-Détection**
```powershell
# 🎯 OPTION 1 : Auto-détection et déploiement intelligent
powershell -ExecutionPolicy Bypass -File scripts\auto-deploy.ps1
```

**Le script auto-deploy.ps1 :**
- 🔍 **Détecte automatiquement** vos ressources (RAM, CPU, disque)
- 🎯 **Recommande le profil optimal** selon votre configuration
- ⚙️ **Configure automatiquement** l'environnement
- 🚀 **Déploie les services** avec le profil choisi
- ✅ **Valide l'installation** et affiche les URLs d'accès

#### **3️⃣ Déploiement Manuel par Profil**
```powershell
# 🏁 Profil Développement (4-8GB)
docker-compose -f docker\docker-compose.dev.yml up -d

# ⚡ Profil Minimal (8-12GB)  
docker-compose -f docker\docker-compose.minimal.yml up -d

# 🚀 Profil Complet (16GB+)
docker-compose -f docker\docker-compose.yml up -d
```

#### **4️⃣ Validation Windows**
```powershell
# Vérifier l'installation
powershell -ExecutionPolicy Bypass -File scripts\validate.ps1
```

### **🐧 Linux - Déploiement Intelligent**

#### **1️⃣ Préparation**
```bash
# Cloner le projet
git clone https://github.com/votre-org/cyberguard-unified-soc.git
cd "CyberGuard Unified SOC"

# Rendre les scripts exécutables
chmod +x scripts/*.sh
```

#### **2️⃣ Déploiement avec Auto-Détection**
```bash
# 🎯 OPTION 1 : Auto-détection et déploiement intelligent
sudo ./scripts/auto-deploy.sh
```

**Le script auto-deploy.sh :**
- 🔍 **Analyse les ressources** système automatiquement
- 📊 **Calcule le profil optimal** avec des seuils intelligents
- ⚠️ **Affiche des avertissements** pour les configurations limites
- 🛠️ **Installe Docker** si nécessaire (Linux)
- 🚀 **Lance le déploiement** avec validation

#### **3️⃣ Installation Complète Linux**
```bash
# 🎯 OPTION 2 : Installation complète avec détection OS
sudo ./scripts/install.sh
```

**Le script install.sh :**
- 🐧 **Détecte l'OS** (Ubuntu, Debian, CentOS, etc.)
- 📦 **Installe Docker** et dépendances automatiquement
- ⚙️ **Configure le système** (limits, sysctl, firewall)
- 🔐 **Génère les certificats** SSL automatiquement
- 🚀 **Déploie avec le profil** approprié

#### **4️⃣ Validation Linux**
```bash
# Vérifier l'installation
sudo ./scripts/health-check.sh
```

---

## 🎛️ Interface de Sélection Interactive

Les scripts proposent un **menu interactif** :

```
🔍 Détection des ressources système...
📊 Ressources système détectées :
   💾 RAM Totale : 16.0 GB
   💾 RAM Disponible : 12.8 GB  
   🖥️  Cœurs CPU : 8
   💿 Espace Disque : 250.5 GB

✅ Recommandation : Profil COMPLET
   Tous les 9 outils de sécurité seront déployés

Que souhaitez-vous faire ?
1. 🚀 Déployer avec le profil recommandé
2. 🔧 Choisir un autre profil manuellement  
3. 📊 Voir les détails des profils
4. ❌ Annuler

Votre choix (1-4): _
```

---

## 📋 Comparaison des Profils

| Fonctionnalité | 🏁 Développement | ⚡ Minimal | 🚀 Complet |
|----------------|------------------|------------|------------|
| **Frontend React** | ✅ | ✅ | ✅ |
| **Backend FastAPI** | ✅ | ✅ | ✅ |
| **MongoDB** | ✅ | ✅ | ✅ |
| **Elasticsearch** | ✅ (256MB) | ✅ (512MB) | ✅ (2GB) |
| **Wazuh SIEM** | ✅ (API only) | ✅ | ✅ |
| **Graylog** | ✅ (256MB heap) | ✅ (512MB heap) | ✅ (1GB heap) |
| **TheHive** | ❌ | ✅ | ✅ |
| **MISP** | ❌ | ❌ | ✅ |
| **OpenCTI** | ❌ | ❌ | ✅ |
| **Velociraptor** | ❌ | ❌ | ✅ |
| **Shuffle** | ❌ | ❌ | ✅ |
| **Redis** | ✅ (64MB) | ✅ (128MB) | ✅ (256MB) |
| **MySQL** | ❌ | ❌ | ✅ |

---

## 🌐 Accès aux Services Après Installation

### **📱 Interfaces Principales**
| Service | URL | Profil | Description |
|---------|-----|--------|-------------|
| **🏠 Frontend** | http://localhost:3000 | Tous | Interface principale avec logo CSU |
| **🔧 Backend API** | http://localhost:8000 | Tous | API REST + documentation Swagger |

### **🛡️ Outils de Sécurité**
| Service | URL | Profil | Identifiants par défaut |
|---------|-----|--------|-------------------------|
| **📊 Graylog** | http://localhost:9000 | Tous | admin / admin |
| **🔍 Wazuh** | http://localhost:55000 | Tous | wazuh-api / changeme |
| **🐝 TheHive** | http://localhost:9001 | Minimal+ | Configuration requise |
| **🔗 MISP** | https://localhost:443 | Complet | admin@cyberguard.local |
| **🧠 OpenCTI** | http://localhost:8080 | Complet | admin@cyberguard.local |
| **🔬 Velociraptor** | http://localhost:8889 | Complet | admin / cyberguard_password |
| **⚡ Shuffle** | https://localhost:3443 | Complet | Configuration requise |

### **💾 Services Infrastructure**
| Service | Port | Profil | Usage |
|---------|------|--------|-------|
| **MongoDB** | 27017 | Tous | Base de données principale |
| **Elasticsearch** | 9200 | Tous | Moteur de recherche et indexation |
| **Redis** | 6379 | Tous | Cache et sessions |
| **MySQL** | 3306 | Complet | Base de données MISP |

---

## 🛠️ Post-Installation

### **✅ Validation de l'Installation**

#### **Windows**
```powershell
# Validation complète
powershell -ExecutionPolicy Bypass -File scripts\validate.ps1

# Vérification manuelle des services
docker-compose ps
docker stats --no-stream
```

#### **Linux**
```bash
# Validation complète
sudo ./scripts/health-check.sh

# Diagnostic approfondi  
sudo ./scripts/diagnostic.sh

# Vérification manuelle
docker-compose ps
docker stats --no-stream
```

### **🔧 Commandes de Gestion**

#### **Gestion des Services**
```bash
# Voir les logs en temps réel
docker-compose logs -f

# Redémarrer un service spécifique
docker-compose restart [service_name]

# Voir l'utilisation des ressources
docker stats

# Arrêter tous les services
docker-compose down
```

#### **Maintenance**
```bash
# Mise à jour des images
docker-compose pull
docker-compose up -d

# Nettoyage du système
docker system prune -f

# Sauvegarde des données
./scripts/backup.sh  # Linux
scripts\backup.ps1   # Windows
```

---

## 🚨 Dépannage

### **❌ Problèmes Courants**

#### **Services qui ne démarrent pas**
```bash
# Diagnostic des erreurs
docker-compose ps
docker-compose logs [service_name]

# Redémarrage complet
docker-compose down -v
docker-compose up -d
```

#### **Manque de ressources**
```bash
# Windows - Vérifier les ressources
Get-WmiObject -Class Win32_ComputerSystem
docker stats

# Linux - Vérifier les ressources  
free -h
df -h
docker stats
```

#### **Problèmes de ports**
```bash
# Vérifier les ports utilisés
netstat -tulpn | grep :3000
ss -tulpn | grep :3000

# Windows
netstat -an | findstr :3000
```

### **🔄 Réinitialisation Complète**

#### **Windows**
```powershell
# Nettoyage complet
powershell -ExecutionPolicy Bypass -File scripts\purge.ps1

# Redéploiement
powershell -ExecutionPolicy Bypass -File scripts\auto-deploy.ps1
```

#### **Linux**  
```bash
# Nettoyage complet
sudo ./scripts/purge.sh

# Redéploiement
sudo ./scripts/auto-deploy.sh
```

---

## 🔐 Configuration de Sécurité

### **🔑 Changement des Mots de Passe**

Modifiez le fichier `.env` avant le déploiement :

```bash
# Éditeur de votre choix
nano .env          # Linux
notepad .env       # Windows
```

**Variables importantes à changer :**
```env
# MongoDB
MONGO_INITDB_ROOT_PASSWORD=votre_mot_de_passe_mongodb

# Graylog
GRAYLOG_PASSWORD_SECRET=votre_secret_graylog_64_caracteres
GRAYLOG_ROOT_PASSWORD_SHA2=votre_hash_sha2_du_mot_de_passe

# OpenCTI
OPENCTI_ADMIN_PASSWORD=votre_mot_de_passe_opencti
OPENCTI_TOKEN=votre_token_securise_opencti

# Autres services
THEHIVE_SECRET=votre_secret_thehive
SHUFFLE_AUTH_SECRET=votre_secret_shuffle
```

### **🔒 Génération de Mots de Passe Sécurisés**

#### **Windows**
```powershell
# Générer un mot de passe aléatoire
[System.Web.Security.Membership]::GeneratePassword(32, 8)

# Hash SHA2 pour Graylog
echo -n "votre_mot_de_passe" | openssl sha256
```

#### **Linux**
```bash
# Générer un mot de passe aléatoire
openssl rand -base64 32

# Hash SHA2 pour Graylog
echo -n "votre_mot_de_passe" | sha256sum
```

---

## 📞 Support et Assistance

### **🛠️ Auto-Diagnostic**
```bash
# Windows
powershell -ExecutionPolicy Bypass -File scripts\diagnostic.ps1

# Linux  
sudo ./scripts/diagnostic.sh
```

### **📚 Documentation**
- **Architecture** : `docs/architecture.md`
- **Configuration** : `docs/configuration.md`
- **Dépannage** : `docs/troubleshooting.md`
- **Sécurité** : `docs/security.md`

### **🐛 Signalement de Problèmes**
- **Issues GitHub** : https://github.com/votre-org/cyberguard-unified-soc/issues
- **Logs système** : Toujours inclure les logs Docker
- **Configuration** : Spécifier le profil utilisé et les ressources système

---

<div align="center">
  
  **✅ Installation Terminée avec Succès !**
  
  Votre **CyberGuard Unified SOC** est maintenant opérationnel avec le logo CSU intégré 🎉
  
  ![CSU Logo](../Logo/CSU Logo.png)
  
</div>
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
