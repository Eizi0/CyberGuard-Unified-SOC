<div align="center">
  <img src="Logo/CSU Logo.png" alt="CSU Logo" width="200"/>
  
  # CyberGuard Unified SOC
  
  **🚀 Plateforme de Sécurité Unifiée - Security Operations Center**
  
  [![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)](https://docker.com)
  [![React](https://img.shields.io/badge/Frontend-React-61DAFB?logo=react)](https://reactjs.org)
  [![FastAPI](https://img.shields.io/badge/Backend-FastAPI-009688?logo=fastapi)](https://fastapi.tiangolo.com)
  [![Python](https://img.shields.io/badge/Python-3.11+-3776AB?logo=python)](https://python.org)
  
  ![License](https://img.shields.io/badge/License-Enterprise-green)
  ![Version](https://img.shields.io/badge/Version-1.0.0-orange)
  ![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Linux-lightgrey)
  
</div>

---

## 🔒 Description
CyberGuard Unified SOC est une plateforme de sécurité unifiée qui intègre plusieurs outils de cybersécurité open source pour fournir une vue d'ensemble complète de la sécurité de votre infrastructure.

## 🏗️ Architecture
La plateforme intègre les outils suivants dans une architecture containerisée :

### **🖥️ Core Services**
- **Frontend** : Interface utilisateur React (port 3000)
- **Backend** : API FastAPI Python (port 8000)

### **🛡️ Security Tools**
- **Wazuh** : SIEM & détection d'intrusion (port 55000)
- **Graylog** : Gestion et analyse des logs (port 9000)
- **TheHive** : Gestion des incidents (port 9001)
- **MISP** : Threat Intelligence Platform (port 443)
- **OpenCTI** : Cyber Threat Intelligence (port 8080)
- **Velociraptor** : Digital forensics (port 8889)
- **Shuffle** : SOAR - Orchestration (port 3443)

### **💾 Infrastructure**
- **MongoDB** : Base de données principale (port 27017)
- **Elasticsearch** : Moteur de recherche (port 9200)
- **Redis** : Cache et sessions (port 6379)
- **MySQL** : Base de données MISP (port 3306)

---

## 🎨 Interface Utilisateur

<div align="center">
  
  ### **🌟 Design Moderne avec Logo CSU Intégré**
  
  Notre interface utilisateur arbore fièrement le logo CSU dans toutes les sections principales :
  
  | Section | Description | Logo |
  |---------|-------------|------|
  | 🔐 **Page de Connexion** | Authentification sécurisée | Logo 100px centré |
  | 📱 **Navigation** | Barre supérieure avec menu | Logo 40px + titre |
  | 📋 **Menu Latéral** | Navigation entre services | Logo 32px compact |
  | 🏠 **Dashboard** | Page d'accueil principale | Logo 60px + description |
  
  **✨ Fonctionnalités UI :**
  - 🎨 Design Material-UI moderne
  - 🌙 Thème sombre adaptatif
  - 📱 Interface responsive
  - 🔐 Système d'authentification intégré
  - 🚪 Déconnexion sécurisée
  
</div>

---

## 🖥️ Prérequis

### **Configuration Matérielle**

CyberGuard Unified SOC propose plusieurs profils de déploiement selon vos ressources :

#### **🏁 Profil Développement (4-8GB RAM)**
| Composant | Minimum | Services Inclus |
|-----------|---------|-----------------|
| **CPU** | 4 cœurs | Backend, Frontend, Wazuh, Graylog, Elasticsearch |
| **RAM** | 4 GB | Configuration allégée pour tests |
| **Stockage** | 50 GB | Données de développement |
| **Réseau** | 100 Mbps | Tests locaux |

#### **⚡ Profil Minimal Production (8-12GB RAM)**
| Composant | Minimum | Services Inclus |
|-----------|---------|-----------------|
| **CPU** | 6 cœurs | Core services + 3 outils sécurité |
| **RAM** | 8 GB | Configuration optimisée mémoire |
| **Stockage** | 100 GB | Données limitées |
| **Réseau** | 1 Gbps | PME/Petits environnements |

#### **🚀 Profil Complet Recommandé (16GB+ RAM)**
| Composant | Minimum | Recommandé | Services Inclus |
|-----------|---------|------------|-----------------|
| **CPU** | 8 cœurs | 16+ cœurs | Tous les 9 outils intégrés |
| **RAM** | 16 GB | 32+ GB | Performance optimale |
| **Stockage** | 100 GB | 500+ GB SSD | Rétention étendue |
| **Réseau** | 1 Gbps | 10+ Gbps | Entreprise/SOC complet |

### **🔍 Pourquoi 16GB Minimum pour le Profil Complet ?**

#### **📊 Répartition Mémoire Détaillée :**
```
┌─────────────────────────────────────────────────────────────┐
│              Consommation RAM par Service                   │
├─────────────────────────────────────────────────────────────┤
│ Elasticsearch    │ 1-2GB  │ Index + Search + JVM Heap      │
│ Graylog         │ 1-2GB  │ Log Processing + JVM           │
│ MongoDB         │ 1-2GB  │ Database + Cache               │
│ Wazuh Manager   │ 0.5-1GB│ SIEM Rules + Agent Management  │
│ OpenCTI         │ 0.5-1GB│ Threat Intel + GraphQL         │
│ TheHive         │ 0.5-1GB│ Case Management + Scala        │
│ MISP            │ 0.5-1GB│ Threat Sharing + PHP           │
│ MySQL           │ 256MB  │ MISP Database                  │
│ Redis           │ 128MB  │ Cache Layer                    │
│ Velociraptor    │ 256MB  │ Digital Forensics              │
│ Shuffle         │ 256MB  │ SOAR Workflows                 │
│ Frontend        │ 256MB  │ React Dev Server               │
│ Backend         │ 256MB  │ FastAPI                        │
├─────────────────────────────────────────────────────────────┤
│ Total Services  │ ~8-12GB│ Tous les containers            │
│ Docker Overhead │ 1-2GB  │ Engine + Networking            │
│ Host OS         │ 2-4GB  │ Système d'exploitation         │
│ Buffer Sécurité │ 2GB    │ Pics de charge + Évolutivité   │
├─────────────────────────────────────────────────────────────┤
│ TOTAL REQUIS    │ 16GB   │ Fonctionnement stable          │
└─────────────────────────────────────────────────────────────┘
```

### **Systèmes Supportés**

#### **🪟 Windows**
- Windows 10/11 (64-bit)
- Windows Server 2019/2022
- Docker Desktop pour Windows
- PowerShell 5.1+

#### **🐧 Linux**
- Ubuntu 20.04+ LTS
- Debian 11+
- CentOS/RHEL 8+
- Rocky Linux 8+
- Docker Engine 24.x+

### **Logiciels Requis**
- **Docker** : 24.x ou supérieur
- **Docker Compose** : 2.x ou supérieur
- **Git** : Version récente

### **🚀 Installation**

#### **📋 Choix du Profil de Déploiement**

Selon vos ressources disponibles, choisissez le profil approprié :

```bash
# 🤖 OPTION 1 : Auto-détection intelligente (RECOMMANDÉE)
# Windows
powershell -ExecutionPolicy Bypass -File scripts\auto-deploy.ps1

# Linux  
sudo ./scripts/auto-deploy.sh

# 📋 OPTION 2 : Sélection manuelle par profil
# 🏁 Profil Développement (4-8GB RAM) - Services essentiels
docker-compose -f docker/docker-compose.dev.yml up -d

# ⚡ Profil Minimal (8-12GB RAM) - Core + sécurité de base  
docker-compose -f docker/docker-compose.minimal.yml up -d

# 🚀 Profil Complet (16GB+ RAM) - Tous les services
docker-compose -f docker/docker-compose.yml up -d
```

### **⚡ Démarrage Rapide (5 minutes)**

**Nouveau utilisateur ?** Suivez notre [**Guide de Démarrage Rapide**](docs/quick-start.md) pour une installation en 5 minutes avec détection automatique des ressources !

### **🪟 Installation Windows**

#### **1. Prérequis**
```powershell
# Vérifier Docker
docker --version
docker-compose --version

# Vérifier PowerShell
$PSVersionTable.PSVersion
```

#### **2. Déploiement Automatisé**
```powershell
# Cloner le projet
git clone https://github.com/votre-org/cyberguard-unified-soc.git
cd "CyberGuard Unified SOC"

# Déploiement complet
powershell -ExecutionPolicy Bypass -File scripts\deploy.ps1
```

#### **3. Validation**
```powershell
# Vérifier l'installation
powershell -ExecutionPolicy Bypass -File scripts\validate.ps1
```

### **🐧 Installation Linux**

#### **1. Installation Automatisée**
```bash
# Cloner le projet
git clone https://github.com/votre-org/cyberguard-unified-soc.git
cd cyberguard-unified-soc

# Rendre les scripts exécutables
chmod +x scripts/*.sh

# Installation complète
sudo ./scripts/install.sh
```

#### **2. Validation**
```bash
# Vérifier l'installation
./scripts/health-check.sh

# Diagnostic complet
./scripts/diagnostic.sh
```

### **🛠️ Installation Manuelle (Multi-plateforme)**

#### **1. Configuration Docker**
```bash
# Linux
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Windows (Docker Desktop doit être démarré)
```

#### **2. Variables d'environnement**
```bash
# Vérifier/éditer le fichier .env
cp .env.example .env
nano .env  # Linux
notepad .env  # Windows
```

#### **3. Déploiement par étapes**
```bash
cd docker

# Étape 1: Bases de données
docker compose up -d mongodb elasticsearch redis misp-db

# Étape 2: Services principaux (attendre 60s)
docker compose up -d backend frontend

# Étape 3: Outils de sécurité
docker compose up -d wazuh-manager graylog thehive misp opencti velociraptor shuffle
```

## 🌐 Accès aux Services

| Service | URL | Utilisateur | Mot de passe |
|---------|-----|-------------|--------------|
| **🎯 Frontend Principal** | http://localhost:3000 | - | - |
| **🔧 Backend API** | http://localhost:8000/docs | - | - |
| **📊 Graylog** | http://localhost:9000 | admin | admin |
| **🎫 TheHive** | http://localhost:9001 | admin@thehive.local | secret |
| **🔍 MISP** | https://localhost:443 | admin@admin.test | admin |
| **🧠 OpenCTI** | http://localhost:8080 | admin@cyberguard.local | cyberguard_admin |
| **🔎 Velociraptor** | http://localhost:8889 | admin | cyberguard_velociraptor_password |
| **🤖 Shuffle** | https://localhost:3443 | admin | cyberguard_shuffle_secret |

## 🧹 Maintenance

### **🪟 Scripts Windows**
```powershell
# Nettoyage complet
powershell -ExecutionPolicy Bypass -File scripts\purge.ps1

# Nettoyage rapide
powershell -ExecutionPolicy Bypass -File scripts\quick-purge.ps1

# Validation système
powershell -ExecutionPolicy Bypass -File scripts\validate.ps1
```

### **🐧 Scripts Linux**
```bash
# Nettoyage complet
sudo ./scripts/purge.sh

# Nettoyage rapide
sudo ./scripts/quick-purge.sh

# Nettoyage sélectif (interactif)
sudo ./scripts/selective-purge.sh

# Diagnostic système
./scripts/diagnostic.sh

# Vérification santé
./scripts/health-check.sh
```

### **🔧 Commandes Docker Universelles**
```bash
# Voir l'état des services
docker compose ps

# Voir les logs
docker compose logs -f [service_name]

# Redémarrer un service
docker compose restart [service_name]

# Arrêter tous les services
docker compose down

# Démarrer tous les services
docker compose up -d

# Voir l'utilisation des ressources
docker stats
```

## 🔧 Dépannage

### **❌ Services qui ne démarrent pas**
```bash
# Multi-plateforme
docker compose ps
docker compose logs [service_name]
docker stats

# Nettoyer et redémarrer
docker compose down -v
docker system prune -f
docker compose up -d
```

### **💾 Problèmes de ressources**
```bash
# Vérifier l'espace disque
df -h          # Linux
Get-WmiObject -Class Win32_LogicalDisk  # Windows

# Vérifier la mémoire
free -h        # Linux
Get-WmiObject -Class Win32_ComputerSystem  # Windows

# Nettoyer Docker
docker system prune -af --volumes
```

### **🔄 Réinitialisation complète**

#### **Windows :**
```powershell
powershell -ExecutionPolicy Bypass -File scripts\purge.ps1
powershell -ExecutionPolicy Bypass -File scripts\deploy.ps1
```

#### **Linux :**
```bash
sudo ./scripts/purge.sh
sudo ./scripts/install.sh
```

---

## 🎨 Identité Visuelle et Branding

<div align="center">
  
  ### **🏢 CSU - CyberGuard Unified SOC**
  
  ![CSU Logo](Logo/CSU Logo.png)
  
</div>

### **🎯 Charte Graphique**

| Élément | Spécification | Utilisation |
|---------|---------------|-------------|
| **Logo Principal** | `Logo/CSU Logo.png` | Interface principale |
| **Logo Frontend** | `frontend/src/assets/csu-logo.png` | Application web |
| **Couleurs** | Material-UI Dark Theme | Interface utilisateur |
| **Typographie** | Roboto, sans-serif | Textes et titres |

### **📱 Intégration Logo**

- ✅ **Page de Connexion** - Logo proéminent 100px
- ✅ **Barre de Navigation** - Logo 40px avec filtre blanc
- ✅ **Menu Latéral** - Logo 32px avec titre abrégé
- ✅ **Dashboard** - Logo 60px avec en-tête complet
- ✅ **Documentation** - Logo dans README et docs

### **🔧 Personnalisation**

Pour personnaliser le logo :

1. **Remplacer** le fichier `Logo/CSU Logo.png`
2. **Copier** vers `frontend/src/assets/csu-logo.png`
3. **Redéployer** le frontend

```bash
# Automatique avec nos scripts
npm run build        # Frontend
docker compose up -d # Déploiement
```

---

## 📚 Documentation

- **📖 [Guide d'Installation Détaillé](docs/installation.md)**
- **⚙️ [Configuration Avancée](docs/configuration.md)**
- **👥 [Guide Utilisateur](docs/user-guide.md)**
- **🛠️ [Dépannage](docs/troubleshooting.md)**
- **🏗️ [Architecture](docs/architecture.md)**
- **🔒 [Sécurité](docs/security.md)**

## ⚠️ Sécurité

### **🔒 Actions Obligatoires pour la Production**
1. **Modifier TOUS les mots de passe par défaut**
2. **Configurer des certificats SSL valides**
3. **Configurer un firewall approprié**
4. **Activer l'authentification forte (2FA)**
5. **Mettre en place des sauvegardes automatiques**
6. **Durcir les configurations de sécurité**

### **🛡️ Variables d'environnement sensibles**
```bash
# Modifier dans le fichier .env
GRAYLOG_PASSWORD_SECRET=votre_secret_securise
GRAYLOG_ROOT_PASSWORD_SHA2=votre_hash_sha2
OPENCTI_TOKEN=votre_token_securise
# ... autres variables
```

## 🤝 Support

### **📞 Obtenir de l'aide**
1. **Documentation** : Consultez le dossier `docs/`
2. **Issues GitHub** : Créez une issue avec les logs
3. **Diagnostic** : Utilisez les scripts de diagnostic
4. **Community** : Forums et discussions

### **🐛 Signaler un problème**
```bash
# Générer un rapport de diagnostic
./scripts/diagnostic.sh  # Linux
# ou consultez les logs Docker
docker compose logs > system-logs.txt
```

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

**🔧 Version** : 2.0  
**📅 Dernière mise à jour** : Août 2025  
**🧪 Testé sur** : Windows 11, Ubuntu 22.04, Docker 24.x  
**👥 Équipe** : CyberGuard SOC Team

Chaque composant nécessite une configuration spécifique :

1. Wazuh :
   - Port : 55000
   - Configuration dans `docker/wazuh/config/ossec.conf`

2. Graylog :
   - Port : 9000
   - Configuration dans `docker/graylog/config/graylog.conf`

3. TheHive :
   - Port : 9001
   - Configuration dans `docker/thehive/config/application.conf`

4. MISP :
   - Port : 443
   - Configuration dans `docker/misp/config/config.php`

5. OpenCTI :
   - Port : 8080
   - Configuration dans `docker/opencti/config/production.json`

6. Velociraptor :
   - Port : 8889
   - Configuration dans `docker/velociraptor/config/server.config.yaml`

7. Shuffle :
   - Port : 3443
   - Configuration dans `docker/shuffle/config/shuffle-config.yaml`

## Utilisation

1. Accès à l'interface web :
   - URL : http://localhost:3000
   - Identifiants par défaut : admin/changeme

2. API Documentation :
   - Swagger UI : http://localhost:8000/docs
   - ReDoc : http://localhost:8000/redoc

3. Fonctionnalités principales :
   - Dashboard unifié
   - Gestion des alertes
   - Gestion des cas
   - Threat Intelligence
   - Automatisation des workflows
   - Corrélation d'événements
   - Reporting

## Développement

1. Configuration de l'environnement de développement :
```bash
# Backend
cd backend
python -m venv venv
source venv/bin/activate  # ou venv\Scripts\activate sous Windows
pip install -r requirements.txt

# Frontend
cd frontend
npm install
```

2. Lancement en mode développement :
```bash
# Backend
cd backend
uvicorn app.main:app --reload

# Frontend
cd frontend
npm start
```

3. Tests :
```bash
# Backend
cd backend
pytest

# Frontend
cd frontend
npm test
```

## Sécurité

1. Authentification :
   - JWT pour l'API
   - Authentification locale ou LDAP

2. Autorisation :
   - RBAC (Role-Based Access Control)
   - Groupes d'utilisateurs

3. Chiffrement :
   - TLS pour toutes les communications
   - Chiffrement des données sensibles

## Maintenance

1. Sauvegarde :
```bash
./scripts/backup.sh
```

2. Mise à jour :
```bash
git pull
docker-compose pull
docker-compose up -d
```

3. Logs :
```bash
docker-compose logs -f
```

## � Documentation Complète

<div align="center">
  
  ### **🎯 Guides par Objectif**
  
  | Guide | Description | Temps | Utilisateur |
  |-------|-------------|-------|-------------|
  | **[⚡ Démarrage Rapide](docs/quick-start.md)** | Installation en 5 minutes avec auto-détection | ⏱️ 5 min | 🆕 Nouveau |
  | **[🚀 Installation Complète](docs/installation.md)** | Guide détaillé multi-plateforme avec profils | ⏱️ 30 min | 🔧 Admin |
  | **[👥 Guide Utilisateur](docs/user-guide.md)** | Interface et workflows avec logo CSU | ⏱️ 15 min | 👤 Utilisateur |
  | **[🏗️ Architecture](docs/architecture.md)** | Spécifications techniques Windows/Linux | ⏱️ 20 min | 🏗️ Architecte |
  | **[🎨 Branding](docs/branding.md)** | Guidelines identité visuelle CSU | ⏱️ 10 min | 🎨 Designer |
  
</div>

### **📖 Documentation Technique**

- **[🔧 Configuration](docs/configuration.md)** - Paramétrage avancé des services
- **[🔐 Sécurité](docs/security.md)** - Hardening et bonnes pratiques
- **[🛠️ Maintenance](docs/maintenance.md)** - Sauvegarde, mise à jour, monitoring
- **[🚨 Dépannage](docs/troubleshooting.md)** - Résolution des problèmes courants
- **[📋 Administration](docs/administration.md)** - Gestion utilisateurs et permissions

---

## �📞 Support et Communauté

<div align="center">
  
  ### 🛠️ Aide et Documentation
  
  | Ressource | Description | Lien |
  |-----------|-------------|------|
  | 📚 **Documentation** | Guides complets d'installation et configuration | [`./docs/`](./docs/) |
  | 🐛 **Issues GitHub** | Rapporter des bugs et demander des fonctionnalités | [Issues](https://github.com/votre-username/cyberguard-unified-soc/issues) |
  | 📖 **Wiki** | Base de connaissances collaborative | [Wiki](https://github.com/votre-username/cyberguard-unified-soc/wiki) |
  | 💬 **Discussions** | Forum communautaire | [Discussions](https://github.com/votre-username/cyberguard-unified-soc/discussions) |
  
</div>

## 🤝 Contribution

<div align="center">
  
  **Nous accueillons toutes les contributions à CyberGuard Unified SOC !**
  
</div>

### **📋 Processus de Contribution**

1. **🍴 Fork** du projet
2. **🌿 Création** d'une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. **💾 Commit** des changements (`git commit -am 'Ajout d'une nouvelle fonctionnalité'`)
4. **📤 Push** vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. **🔄 Création** d'une Pull Request

### **🎯 Types de Contributions**

- 🐛 **Bug fixes** - Corrections de bugs
- ✨ **Features** - Nouvelles fonctionnalités
- 📚 **Documentation** - Améliorations de la documentation
- 🧪 **Tests** - Ajout de tests unitaires
- 🎨 **UI/UX** - Améliorations de l'interface

## 📄 Licence

<div align="center">
  
  **Ce projet est sous licence MIT**
  
  ![CSU Logo](Logo/CSU Logo.png)
  
  © 2025 **CyberGuard Unified SOC** - Tous droits réservés
  
  Voir le fichier [`LICENSE`](./LICENSE) pour plus de détails.
  
</div>

---

<div align="center">
  
  **⭐ Si ce projet vous aide, n'hésitez pas à lui donner une étoile ! ⭐**
  
  Made with ❤️ for the cybersecurity community
  
</div>
