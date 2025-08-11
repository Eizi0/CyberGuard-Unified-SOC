# CyberGuard Unified SOC

CyberGuard Unified SOC est une solution open source de Security Operations Center (SOC) qui intègre plusieurs outils de sécurité populaires dans une interface unifiée et facile à utiliser.

## Composants

- Wazuh - SIEM & XDR
- Graylog - Log Management
- TheHive - Case Management
- MISP - Threat Intelligence Platform
- OpenCTI - Cyber Threat Intelligence
- Velociraptor - Digital Forensics
- Shuffle - Security Orchestration & Automation

## Architecture

Le projet est construit avec une architecture microservices utilisant Docker :

```
CyberGuard-Unified-SOC/
├── docker/           # Configurations Docker pour chaque composant
├── backend/          # API Backend (FastAPI)
├── frontend/        # Interface utilisateur React
└── docs/           # Documentation
```

## Installation

1. Prérequis :
   - Docker et Docker Compose
   - Git
   - Make (optionnel)

2. Clone du dépôt :
```bash
git clone https://github.com/votre-username/cyberguard-unified-soc.git
cd cyberguard-unified-soc
```

3. Configuration :
```bash
cp .env.example .env
# Modifier les variables dans .env selon votre environnement
```

4. Démarrage :
```bash
docker-compose up -d
```

## Configuration

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
