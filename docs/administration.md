# Guide d'Administration

Ce guide détaille l'administration et la maintenance du CyberGuard Unified SOC.

## Gestion des Services

### Commandes Docker Compose Essentielles

1. Démarrer tous les services :
```bash
docker-compose up -d
```

2. Arrêter tous les services :
```bash
docker-compose down
```

3. Redémarrer un service spécifique :
```bash
docker-compose restart [service_name]
```

4. Voir les logs :
```bash
docker-compose logs -f [service_name]
```

## Maintenance

### Sauvegardes

Les sauvegardes sont automatisées via le script `scripts/backup.sh`. Par défaut, elles sont effectuées quotidiennement.

1. Effectuer une sauvegarde manuelle :
```bash
./scripts/backup.sh
```

2. Restaurer depuis une sauvegarde :
```bash
./scripts/restore.sh [backup_file]
```

### Mises à Jour

1. Mettre à jour tous les conteneurs :
```bash
docker-compose pull
docker-compose up -d
```

2. Mettre à jour un service spécifique :
```bash
docker-compose pull [service_name]
docker-compose up -d [service_name]
```

## Surveillance

### Métriques Système

- CPU
- Mémoire
- Stockage
- Réseau

### Alertes

1. Configuration des alertes dans Wazuh
2. Configuration des alertes dans Graylog
3. Intégration avec les systèmes de notification externes

## Sécurité

### Bonnes Pratiques

1. Gestion des accès
   - Utilisation de mots de passe forts
   - Rotation régulière des secrets
   - Authentification à deux facteurs

2. Mise à jour des composants
   - Mises à jour de sécurité régulières
   - Suivi des CVE

3. Sauvegardes
   - Test régulier des sauvegardes
   - Conservation hors site

### Audit

1. Logs d'accès
2. Logs d'actions
3. Rapports d'audit

## Intégration

### APIs

Les endpoints principaux :

1. Backend API : `http://localhost:8000`
   - Documentation : `/docs`
   - Status : `/health`

2. Services intégrés
   - Wazuh API
   - TheHive API
   - MISP API
   - OpenCTI API

### Webhooks

Configuration des webhooks pour :
- Alertes
- Notifications
- Intégrations externes

## Dépannage

### Problèmes Courants

1. Services indisponibles
   ```bash
   # Vérifier l'état des services
   docker-compose ps
   
   # Vérifier les logs
   docker-compose logs [service_name]
   ```

2. Problèmes de performance
   ```bash
   # Vérifier l'utilisation des ressources
   docker stats
   ```

3. Problèmes de stockage
   ```bash
   # Vérifier l'espace disque
   df -h
   
   # Nettoyer les volumes Docker inutilisés
   docker volume prune
   ```

### Logs

Localisation des logs :
- Container logs : `docker-compose logs`
- Application logs : `/var/log/`
- Service-specific logs : Dans les volumes Docker

## Personnalisation

### Configuration

1. Variables d'environnement
   - `.env` pour les configurations globales
   - `docker-compose.override.yml` pour les surcharges locales

2. Fichiers de configuration
   - Configuration Wazuh
   - Configuration Graylog
   - Configuration TheHive

### Extensions

1. Ajout de règles Wazuh
2. Création de dashboards personnalisés
3. Développement de playbooks d'automatisation

## Support et Documentation

- Documentation officielle des composants
- Support communautaire
- Canaux de support commerciaux
