# DIAGNOSTIC INTERFACES WEB - CYBERGUARD SOC
# ==========================================

## 🔍 PROBLÈMES INTERFACES GRAPHIQUES

Tous les conteneurs sont installés mais aucune interface ne fonctionne.
Voici un diagnostic complet pour identifier les problèmes.

## 🌐 URLS ET PORTS DES INTERFACES

### Services principaux
- **Frontend React** : http://localhost:3000
- **Backend API** : http://localhost:8000

### Outils de sécurité
- **Wazuh Manager** : http://localhost:55000
- **Graylog** : http://localhost:9000
- **TheHive** : http://localhost:9001
- **MISP** : http://localhost (port 80) ou https://localhost (port 443)
- **OpenCTI** : http://localhost:8080
- **Velociraptor** : http://localhost:8889
- **Shuffle** : http://localhost:3443

### Services de base de données (pas d'interface web)
- **MongoDB** : localhost:27017
- **Elasticsearch** : http://localhost:9200
- **Redis** : localhost:6379
- **MySQL (MISP)** : localhost:3306

## 🔧 DIAGNOSTIC ÉTAPE PAR ÉTAPE

### 1. VÉRIFIER L'ÉTAT DES CONTENEURS
```powershell
# Tous les conteneurs
docker ps -a

# Conteneurs en cours d'exécution
docker ps

# Conteneurs spécifiques
docker ps --filter "name=cyberguard"
docker ps --filter "name=wazuh"
docker ps --filter "name=graylog"
```

### 2. VÉRIFIER LES PORTS
```powershell
# Ports exposés par Docker
docker port <nom_conteneur>

# Exemples
docker port cyberguard-frontend
docker port cyberguard-backend
docker port wazuh-manager
docker port cyberguard-graylog
```

### 3. TESTER LA CONNECTIVITÉ RÉSEAU
```powershell
# Test ping des conteneurs
Test-NetConnection localhost -Port 3000
Test-NetConnection localhost -Port 8000
Test-NetConnection localhost -Port 9000
Test-NetConnection localhost -Port 9001
Test-NetConnection localhost -Port 8080
Test-NetConnection localhost -Port 8889
Test-NetConnection localhost -Port 3443

# Ou avec telnet
telnet localhost 3000
telnet localhost 8000
```

### 4. VÉRIFIER LES LOGS DES CONTENEURS
```powershell
# Logs du frontend
docker logs cyberguard-frontend

# Logs du backend
docker logs cyberguard-backend

# Logs des services spécifiques
docker logs wazuh-manager
docker logs cyberguard-graylog
docker logs thehive
docker logs misp
docker logs cyberguard-opencti
docker logs velociraptor
docker logs shuffle
```

## ⚠️ CAUSES POSSIBLES

### 1. CONTENEURS NON DÉMARRÉS
- Vérifier : `docker ps` vs `docker ps -a`
- Solution : `docker-compose up -d`

### 2. PORTS NON EXPOSÉS
- Vérifier le docker-compose.yml
- Redémarrer avec : `docker-compose down && docker-compose up -d`

### 3. SERVICES EN COURS D'INITIALISATION
- Certains services prennent du temps à démarrer
- Attendre 2-5 minutes après le démarrage

### 4. PROBLÈMES DE RÉSEAU DOCKER
- Vérifier : `docker network ls`
- Recréer le réseau : `docker-compose down && docker-compose up -d`

### 5. CONFIGURATION INCOMPLÈTE
- Variables d'environnement manquantes
- Fichiers de configuration corrompus

### 6. CONFLITS DE PORTS
- D'autres services utilisent les mêmes ports
- Vérifier : `netstat -an | findstr :3000`

## 🚀 SOLUTIONS RAPIDES

### Solution 1 : Redémarrage complet
```powershell
cd docker
docker-compose down
docker-compose pull
docker-compose up -d
```

### Solution 2 : Vérification des services critiques
```powershell
# Démarrer uniquement les services de base
docker-compose up -d mongodb elasticsearch redis

# Puis les services principaux
docker-compose up -d backend frontend

# Enfin les outils de sécurité
docker-compose up -d wazuh-manager graylog thehive misp opencti velociraptor shuffle
```

### Solution 3 : Debug en mode interactif
```powershell
# Démarrer en mode debug (voir les logs en temps réel)
docker-compose up frontend backend
```

## 🔍 SCRIPT DE DIAGNOSTIC AUTOMATIQUE

Créons un script pour tester toutes les interfaces automatiquement.
