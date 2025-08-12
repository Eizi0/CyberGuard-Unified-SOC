# CyberGuard Unified SOC

## Description
CyberGuard Unified SOC est une plateforme de sécurité unifiée qui intègre plusieurs outils de cybersécurité pour fournir une vue d'ensemble complète de la sécurité de votre infrastructure.

## Architecture
La plateforme intègre les outils suivants :
- **Frontend** : Interface utilisateur React
- **Backend** : API FastAPI Python
- **Wazuh** : Système de détection d'intrusion
- **Graylog** : Gestion et analyse des logs
- **TheHive** : Gestion des incidents
- **MISP** : Partage d'informations sur les menaces
- **OpenCTI** : Plateforme de Threat Intelligence
- **Velociraptor** : Collecte d'artefacts numériques
- **Shuffle** : Orchestration et automatisation

## Prérequis
- Windows 10/11 ou Windows Server 2019+
- Docker Desktop pour Windows
- Docker Compose v2.0+
- PowerShell 5.1+
- Au moins 16 GB de RAM
- 100 GB d'espace disque libre

## Installation Rapide

### 1. Vérification des prérequis
```powershell
# Vérifier Docker
docker --version
docker-compose --version

# Vérifier PowerShell
$PSVersionTable.PSVersion
```

### 2. Configuration
```powershell
# Cloner le projet
git clone [URL_DU_REPO]
cd "CyberGuard Unified SOC"

# Vérifier le fichier .env (déjà configuré)
Get-Content .env
```

### 3. Déploiement
```powershell
# Exécuter le script de déploiement
powershell -ExecutionPolicy Bypass -File scripts\deploy.ps1

# Ou déploiement manuel
cd docker
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

### 4. Validation
```powershell
# Exécuter le script de validation
powershell -ExecutionPolicy Bypass -File scripts\validate.ps1

# Ou vérification manuelle
docker-compose ps
```

## Accès aux Services

| Service | URL | Utilisateur | Mot de passe |
|---------|-----|-------------|--------------|
| Frontend | http://localhost:3000 | - | - |
| Backend API | http://localhost:8000 | - | - |
| Graylog | http://localhost:9000 | admin | admin |
| TheHive | http://localhost:9001 | admin@thehive.local | secret |
| MISP | https://localhost:443 | admin@admin.test | admin |
| OpenCTI | http://localhost:8080 | admin@cyberguard.local | cyberguard_admin |
| Velociraptor | http://localhost:8889 | admin | cyberguard_velociraptor_password |
| Shuffle | https://localhost:3443 | admin | cyberguard_shuffle_secret |

## Dépannage

### Services qui ne démarrent pas
```powershell
# Vérifier l'état des conteneurs
docker-compose ps

# Consulter les logs
docker-compose logs [service_name]

# Redémarrer un service spécifique
docker-compose restart [service_name]
```

### Problèmes de ressources
```powershell
# Vérifier l'utilisation des ressources
docker stats

# Nettoyer les ressources inutilisées
docker system prune -f
docker volume prune -f
```

### Réinitialisation complète
```powershell
# Arrêter tous les services
docker-compose down -v

# Supprimer toutes les images
docker rmi $(docker images -q)

# Redéployer
powershell -ExecutionPolicy Bypass -File scripts\deploy.ps1
```

## Documentation
- [Guide d'Installation](docs/installation.md)
- [Configuration](docs/configuration.md)
- [Guide Utilisateur](docs/user-guide.md)
- [Dépannage](docs/troubleshooting.md)
- [Architecture](docs/architecture.md)

## Support
Pour obtenir de l'aide :
1. Consultez la documentation dans le dossier `docs/`
2. Vérifiez les issues sur GitHub
3. Contactez l'équipe de support

## Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

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

## Support

- Issues GitHub : https://github.com/votre-username/cyberguard-unified-soc/issues
- Documentation : ./docs/
- Wiki : https://github.com/votre-username/cyberguard-unified-soc/wiki

## Contribution

1. Fork du projet
2. Création d'une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit des changements (`git commit -am 'Ajout d'une nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Création d'une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.
