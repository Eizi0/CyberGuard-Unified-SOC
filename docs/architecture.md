# 🏗️ CyberGuard Unified SOC - Architecture Guide

## 📊 Vue d'ensemble de l'architecture

CyberGuard Unified SOC utilise une architecture microservices containerisée qui intègre 9 outils de sécurité dans une plateforme unifiée.

## 🔧 Architecture Technique

### **🎯 Architecture Globale**
```
┌─────────────────────────────────────────────────────────────────┐
│                    CyberGuard Unified SOC                      │
├─────────────────────────────────────────────────────────────────┤
│  Frontend (React)  │  Backend (FastAPI)  │  Security Tools     │
│  Port: 3000        │  Port: 8000         │  Multiple Ports     │
├─────────────────────────────────────────────────────────────────┤
│              Infrastructure Services                           │
│  MongoDB  │  Elasticsearch  │  Redis  │  MySQL               │
└─────────────────────────────────────────────────────────────────┘
```

### **🖥️ Couches d'Architecture**

#### **1. 🌐 Couche Présentation**
- **Frontend React** (Port 3000)
  - Interface utilisateur unifiée
  - Dashboard de sécurité
  - Gestion des incidents
  - Visualisations temps réel

#### **2. 🔧 Couche API**
- **Backend FastAPI** (Port 8000)
  - API REST unifiée
  - Authentification centralisée
  - Orchestration des services
  - Corrélation des données

#### **3. 🛡️ Couche Sécurité**
```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│    SIEM     │   Incidents │    CTI      │  Forensics  │
├─────────────┼─────────────┼─────────────┼─────────────┤
│   Wazuh     │  TheHive    │   MISP      │Velociraptor │
│ Port 55000  │ Port 9001   │ Port 443    │ Port 8889   │
├─────────────┼─────────────┼─────────────┼─────────────┤
│   Graylog   │   OpenCTI   │   Shuffle   │             │
│ Port 9000   │ Port 8080   │ Port 3443   │             │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

#### **4. 💾 Couche Données**
```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│  MongoDB    │Elasticsearch│   Redis     │   MySQL     │
│ Port 27017  │ Port 9200   │ Port 6379   │ Port 3306   │
├─────────────┼─────────────┼─────────────┼─────────────┤
│ Documents   │ Recherche   │ Cache       │ MISP Data   │
│ Principal   │ & Logs      │ & Sessions  │ Relationale │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

## 🚀 Déploiements par Plateforme

### **🪟 Architecture Windows**

#### **Prérequis Windows**
- Windows 10/11 Pro ou Enterprise
- Docker Desktop avec WSL2
- PowerShell 5.1+
- Hyper-V activé

#### **Structure Windows**
```
C:\CyberGuard\
├── docker\                    # Configurations Docker
├── scripts\                   # Scripts PowerShell
│   ├── deploy.ps1            # Déploiement automatisé
│   ├── validate.ps1          # Validation système
│   ├── purge.ps1             # Nettoyage complet
│   └── quick-purge.ps1       # Nettoyage rapide
├── data\                     # Données persistantes
├── logs\                     # Logs applicatifs
└── ssl\                      # Certificats SSL
```

#### **Spécificités Windows**
- **Docker Desktop** : Interface graphique disponible
- **WSL2** : Meilleure performance Linux containers
- **PowerShell** : Scripts natifs Windows
- **Volumes** : Mapping Windows → Containers
- **Networking** : NAT avec port forwarding

### **🐧 Architecture Linux**

#### **Prérequis Linux**
- Ubuntu 20.04+, Debian 11+, CentOS 8+
- Docker Engine 24.x+
- Docker Compose 2.x+
- 16GB+ RAM, 100GB+ stockage

#### **Structure Linux**
```
/opt/cyberguard/
├── docker/                   # Configurations Docker
├── scripts/                  # Scripts Bash
│   ├── install.sh           # Installation complète
│   ├── health-check.sh      # Vérification santé
│   ├── diagnostic.sh        # Diagnostic système
│   ├── purge.sh             # Nettoyage complet
│   ├── quick-purge.sh       # Nettoyage rapide
│   └── selective-purge.sh   # Nettoyage sélectif
├── data/                    # Données persistantes
├── logs/                    # Logs applicatifs
└── ssl/                     # Certificats SSL
```

#### **Spécificités Linux**
- **Performance native** : Containers Linux natifs
- **Systemd** : Gestion des services système
- **Scripts Bash** : Automatisation native Linux
- **Permissions** : Gestion fine avec chmod/chown
- **Networking** : Bridge networking direct

## 🌐 Matrice des Ports et Services

### **📊 Services Principaux**
| Service | Port | Accès | Description | Configuration |
|---------|------|-------|-------------|---------------|
| **Frontend** | 3000 | Public | Interface utilisateur principale | React 18.x |
| **Backend** | 8000 | Interne | API FastAPI | Python 3.11+ |
| **Wazuh** | 55000 | Public | Interface SIEM | API REST |
| **Graylog** | 9000 | Public | Gestion des logs | Web Interface |
| **TheHive** | 9001 | Public | Gestion d'incidents | Scala/Play |
| **MISP** | 443 | Public | Threat Intelligence | HTTPS |
| **OpenCTI** | 8080 | Public | CTI Platform | GraphQL |
| **Velociraptor** | 8889 | Public | Digital Forensics | gRPC |
| **Shuffle** | 3443 | Public | SOAR Platform | HTTPS |

### **💾 Services Infrastructure**
| Service | Port | Type | Utilisation | Persistance |
|---------|------|------|-------------|-------------|
| **MongoDB** | 27017 | Database | Documents principaux | Volume Docker |
| **Elasticsearch** | 9200 | Search | Recherche et indexation | Volume Docker |
| **Redis** | 6379 | Cache | Cache et sessions | Volume Docker |
| **MySQL** | 3306 | Database | Données MISP | Volume Docker |

## 🔄 Flux de Données

### **📈 Architecture de Corrélation**
```
┌─────────────────────────────────────────────────────────────┐
│                    Flux de Données                         │
├─────────────────────────────────────────────────────────────┤
│  Agents → Wazuh → Elasticsearch → Backend → Frontend       │
│  Logs   → Graylog → MongoDB → Backend → Dashboards        │
│  IOCs   → MISP → MySQL → OpenCTI → Correlation Engine     │
│  Alerts → TheHive → Backend → Workflow → Shuffle          │
└─────────────────────────────────────────────────────────────┘
```

### **🔍 Processus de Corrélation**
1. **Collecte** : Agents Wazuh, Syslog, API feeds
2. **Normalisation** : Parsing et standardisation
3. **Enrichissement** : CTI, géolocalisation, réputation
4. **Corrélation** : Règles personnalisées et ML
5. **Alerting** : Notifications et incidents
6. **Response** : Playbooks automatisés via Shuffle

## 🏗️ Modèle de Déploiement

### **🎯 Déploiement Standard (Recommandé)**
```
┌─────────────────────────────────────────────────────────────┐
│                Serveur Unique (16GB+ RAM)                  │
├─────────────────────────────────────────────────────────────┤
│  Docker Host                                               │
│  ├── Network: cyberguard-network (Bridge)                 │
│  ├── Volumes: Données persistantes                        │
│  ├── Services: 9 containers + 4 databases                 │
│  └── Monitoring: Health checks intégrés                   │
└─────────────────────────────────────────────────────────────┘
```

### **🚀 Déploiement Haute Disponibilité**
```
┌─────────────────┬─────────────────┬─────────────────┐
│   Load Balancer │   Application   │   Database      │
│   (HAProxy)     │   Layer         │   Cluster       │
├─────────────────┼─────────────────┼─────────────────┤
│ • Nginx/HAProxy │ • Frontend x3   │ • MongoDB RS    │
│ • SSL Termination│ • Backend x3    │ • Elasticsearch │
│ • Health Checks │ • Security Tools│ • Redis Cluster │
└─────────────────┴─────────────────┴─────────────────┘
```

## 🔧 Configuration par Environnement

### **🧪 Environnement de Développement**
- **Ressources** : 8GB RAM minimum
- **Services** : Core services uniquement
- **Configuration** : Development mode
- **SSL** : Self-signed certificates
- **Logging** : Debug level

### **🏭 Environnement de Production**
- **Ressources** : 32GB+ RAM recommandé
- **Services** : Tous les services actifs
- **Configuration** : Production optimized
- **SSL** : Certificats valides (Let's Encrypt)
- **Logging** : Audit complet
- **Backup** : Automatisé quotidien
- **Monitoring** : Métriques avancées

## 🔐 Architecture de Sécurité

### **🛡️ Couches de Sécurité**
```
┌─────────────────────────────────────────────────────────────┐
│                 Modèle de Sécurité                         │
├─────────────────────────────────────────────────────────────┤
│ 1. Network Security (Firewall, VPN)                       │
│ 2. Container Security (Isolation, Capabilities)           │
│ 3. Application Security (Auth, RBAC)                      │
│ 4. Data Security (Encryption, Backup)                     │
└─────────────────────────────────────────────────────────────┘
```

### **🔑 Authentification et Autorisation**
- **JWT Tokens** : Authentification stateless
- **RBAC** : Role-Based Access Control
- **SSO** : Single Sign-On compatible
- **API Keys** : Accès programmatique sécurisé
- **Audit Trail** : Journalisation complète

### **🔒 Chiffrement**
- **TLS 1.3** : Communication inter-services
- **AES-256** : Chiffrement des données sensibles
- **Secrets Management** : Variables d'environnement
- **Certificate Management** : Auto-renouvellement

## 📈 Scalabilité et Performance

### **⚡ Optimisations Performance**
- **Container Orchestration** : Docker Compose → Kubernetes
- **Database Sharding** : Partitionnement horizontal
- **Caching Strategy** : Redis multi-layer
- **CDN Integration** : Assets statiques
- **Load Balancing** : Round-robin + health checks

### **📊 Métriques de Performance**
| Métrique | Cible | Monitoring |
|----------|-------|------------|
| **Response Time** | < 200ms | Prometheus |
| **Throughput** | 1000+ EPS | Grafana |
| **Availability** | 99.9% | Uptime checks |
| **Error Rate** | < 0.1% | Error tracking |

## 🔧 Maintenance et Surveillance

### **📋 Maintenance Préventive**
- **Backups automatisés** : Quotidiens avec rétention 30j
- **Updates sécurisés** : Staging → Production
- **Health monitoring** : 24/7 avec alertes
- **Performance tuning** : Optimisation continue
- **Capacity planning** : Prévision de croissance

### **🚨 Surveillance Système**
- **System Metrics** : CPU, RAM, Disk, Network
- **Application Metrics** : Response time, throughput
- **Security Events** : Tentatives d'intrusion, anomalies
- **Business Metrics** : Incidents traités, SLA compliance

## 🏗️ Roadmap Technique

### **📅 Phase 1 - Fondations (Q1)**
- ✅ Architecture microservices
- ✅ Déploiement Docker
- ✅ Intégrations de base
- ✅ Interface utilisateur

### **🚀 Phase 2 - Optimisation (Q2)**
- 🔄 Orchestration Kubernetes
- 🔄 CI/CD Pipeline
- 🔄 Monitoring avancé
- 🔄 Auto-scaling

### **🌟 Phase 3 - Intelligence (Q3)**
- 📋 Machine Learning intégré
- 📋 Corrélation avancée
- 📋 Threat Hunting automatisé
- 📋 Compliance framework

## 📚 Ressources Additionnelles

### **🔗 Documentation Technique**
- [Installation Guide](installation.md)
- [Configuration Guide](configuration.md)
- [User Guide](user-guide.md)
- [Troubleshooting](troubleshooting.md)
- [Security Guidelines](security.md)

### **🛠️ Outils de Développement**
- **IDE** : VS Code avec extensions Docker
- **Testing** : Pytest, Jest, Cypress
- **Debugging** : Container logs, APM tools
- **Documentation** : Swagger/OpenAPI, Storybook

### **📞 Support et Communauté**
- **Issues** : GitHub Issues tracker
- **Discussions** : Community forums
- **Wiki** : Documentation collaborative
- **Training** : Guides et tutoriels
    TheHive --> Cassandra[Cassandra]
    MISP --> MariaDB[MariaDB]
    OpenCTI --> MinIO[MinIO]
    OpenCTI --> Redis[Redis]
    OpenCTI --> RabbitMQ[RabbitMQ]
```

## Composants

### 1. Frontend
- Framework : React
- Features :
  - Interface utilisateur unifiée
  - Dashboards personnalisables
  - Visualisation des alertes
  - Gestion des cas
  - Administration système

### 2. Backend
- Framework : FastAPI
- Features :
  - API REST
  - Authentification centralisée
  - Intégration des services
  - Gestion des configurations
  - Automatisation des tâches

### 3. Services Intégrés

#### Wazuh
- SIEM (Security Information and Event Management)
- Détection des menaces
- Gestion des agents
- Analyse des logs

#### Graylog
- Centralisation des logs
- Analyse en temps réel
- Alerting
- Reporting

#### TheHive
- Gestion des cas
- Workflow d'investigation
- Collaboration
- Intégration Cortex

#### MISP
- Threat Intelligence Platform
- Partage d'IoCs
- Analyse des menaces
- Corrélation d'événements

#### OpenCTI
- Threat Intelligence
- Knowledge Base
- Visualisation des menaces
- Analyse des relations

#### Velociraptor
- Digital Forensics
- Response automatisée
- Collection de données
- Hunting

#### Shuffle
- Automatisation
- Orchestration
- Playbooks
- Intégrations

## Stockage

### Bases de Données

1. ElasticSearch
   - Usage : Wazuh, Logs
   - Type : NoSQL
   - Scalabilité : Horizontale

2. MongoDB
   - Usage : Graylog
   - Type : NoSQL
   - Scalabilité : Horizontale

3. Cassandra
   - Usage : TheHive
   - Type : NoSQL
   - Scalabilité : Horizontale

4. MariaDB
   - Usage : MISP
   - Type : SQL
   - Scalabilité : Verticale

5. MinIO
   - Usage : OpenCTI
   - Type : Object Storage
   - Scalabilité : Horizontale

### Cache

1. Redis
   - Usage : OpenCTI, Caching
   - Type : In-memory
   - Scalabilité : Cluster

### Message Queue

1. RabbitMQ
   - Usage : OpenCTI, Communications
   - Type : Message Broker
   - Scalabilité : Cluster

## Sécurité

### Authentication
- OAuth2/OpenID Connect
- MFA
- RBAC

### Communication
- TLS 1.3
- mTLS pour les services internes
- API Keys

### Données
- Chiffrement au repos
- Chiffrement en transit
- Backups chiffrés

## Déploiement

### Conteneurisation
- Docker
- Docker Compose
- Volumes persistants

### Réseau
- Réseaux Docker isolés
- Proxy inverse
- Firewalls

### High Availability
- Réplication des bases de données
- Load balancing
- Failover automatique

## Monitoring

### Métriques
- CPU
- Mémoire
- Stockage
- Réseau

### Health Checks
- Statut des services
- Latence
- Erreurs
- Saturations

### Alerting
- Notifications
- Escalades
- Intégrations

## Performance

### Optimisations
- Caching
- Indexation
- Compression

### Scalabilité
- Horizontale
- Verticale
- Auto-scaling

## Développement

### CI/CD
- Tests automatisés
- Intégration continue
- Déploiement continu

### Versioning
- Semantic versioning
- Git flow
- Release management

### Documentation
- API docs
- Guides utilisateurs
- Guides administrateurs
