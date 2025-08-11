# Guide de Dépannage

Ce guide fournit des solutions aux problèmes courants rencontrés dans CyberGuard Unified SOC.

## Problèmes de Démarrage

### 1. Les Services ne Démarrent pas

#### Symptômes
- Les conteneurs ne démarrent pas
- Erreurs dans les logs Docker
- Services inaccessibles

#### Solutions
```bash
# 1. Vérifier l'état des conteneurs
docker-compose ps

# 2. Vérifier les logs
docker-compose logs [service_name]

# 3. Vérifier les ressources système
df -h  # Espace disque
free -m  # Mémoire
top  # CPU

# 4. Redémarrer les services
docker-compose down
docker-compose up -d
```

### 2. Problèmes de Base de Données

#### Symptômes
- Erreurs de connexion
- Performances dégradées
- Erreurs d'écriture/lecture

#### Solutions
```bash
# 1. Vérifier la connexion
docker-compose exec postgres pg_isready

# 2. Vérifier les logs
docker-compose logs postgres

# 3. Réparer la base de données
docker-compose exec postgres pg_repair

# 4. Restaurer depuis une sauvegarde
./scripts/restore.sh [backup_file]
```

## Problèmes de Performance

### 1. Lenteur Générale

#### Diagnostic
```bash
# 1. Vérifier l'utilisation des ressources
docker stats

# 2. Vérifier les logs système
tail -f /var/log/syslog

# 3. Analyser les performances réseau
nethogs
```

#### Solutions
1. Augmenter les ressources allouées
2. Optimiser les configurations
3. Nettoyer les données anciennes

### 2. Problèmes de Mémoire

#### Symptômes
- Services qui crashent
- Erreurs "Out of Memory"
- Performances dégradées

#### Solutions
```bash
# 1. Libérer le cache système
sync; echo 3 > /proc/sys/vm/drop_caches

# 2. Nettoyer Docker
docker system prune -af
docker volume prune -f

# 3. Ajuster les limites de mémoire
vim docker-compose.yml
# Modifier les limites dans les sections "deploy"
```

## Problèmes Réseau

### 1. Problèmes de Connectivité

#### Diagnostic
```bash
# 1. Vérifier les réseaux Docker
docker network ls
docker network inspect [network_name]

# 2. Tester la connectivité
docker-compose exec [service] ping [target]

# 3. Vérifier les ports
netstat -tulpn
```

#### Solutions
1. Redémarrer le réseau Docker
2. Recréer les réseaux
3. Vérifier les règles de firewall

### 2. Problèmes SSL/TLS

#### Symptômes
- Erreurs de certificat
- Connexions refusées
- Avertissements de sécurité

#### Solutions
```bash
# 1. Vérifier les certificats
openssl x509 -text -noout -in [cert.pem]

# 2. Renouveler les certificats
./scripts/renew-certs.sh

# 3. Vérifier la configuration
nginx -t
```

## Problèmes d'Authentification

### 1. Échecs de Connexion

#### Diagnostic
1. Vérifier les logs d'authentification
2. Tester les paramètres OAuth
3. Vérifier la configuration LDAP

#### Solutions
```bash
# 1. Réinitialiser les secrets
./scripts/reset-secrets.sh

# 2. Vérifier la configuration OAuth
vim config/auth.yaml

# 3. Tester LDAP
ldapsearch -x -H ldap://server
```

### 2. Problèmes de Sessions

#### Symptômes
- Déconnexions fréquentes
- Sessions invalides
- Erreurs de token

#### Solutions
1. Vérifier la configuration Redis
2. Nettoyer les sessions expirées
3. Régénérer les clés JWT

## Problèmes de Stockage

### 1. Espace Disque Insuffisant

#### Diagnostic
```bash
# 1. Analyser l'utilisation du disque
du -sh /*
ncdu /

# 2. Vérifier les volumes Docker
docker system df -v
```

#### Solutions
```bash
# 1. Nettoyer les logs
journalctl --vacuum-time=7d

# 2. Nettoyer Docker
docker system prune -af
docker volume prune -f

# 3. Archiver les anciennes données
./scripts/archive-data.sh
```

### 2. Corruption de Données

#### Symptômes
- Erreurs d'intégrité
- Fichiers corrompus
- Incohérences dans les données

#### Solutions
```bash
# 1. Vérifier l'intégrité des fichiers
fsck -f /dev/[device]

# 2. Restaurer depuis une sauvegarde
./scripts/restore.sh [backup_file]

# 3. Réparer les bases de données
./scripts/repair-db.sh
```

## Problèmes d'Intégration

### 1. Échecs des Webhooks

#### Diagnostic
1. Vérifier les logs d'intégration
2. Tester les endpoints
3. Vérifier les authentifications

#### Solutions
```bash
# 1. Tester les webhooks
curl -X POST [webhook_url]

# 2. Renouveler les tokens
./scripts/renew-tokens.sh

# 3. Vérifier la configuration
vim config/integrations.yaml
```

### 2. Problèmes API

#### Symptômes
- Timeouts
- Erreurs 4xx/5xx
- Réponses incorrectes

#### Solutions
1. Vérifier les logs API
2. Tester les endpoints manuellement
3. Vérifier les permissions

## Maintenance d'Urgence

### 1. Mode de Secours

```bash
# 1. Arrêter les services non essentiels
docker-compose stop [service]

# 2. Démarrer en mode debug
docker-compose up -d --scale [service]=1

# 3. Activer les logs détaillés
./scripts/enable-debug.sh
```

### 2. Récupération de Données

```bash
# 1. Créer une sauvegarde d'urgence
./scripts/emergency-backup.sh

# 2. Restaurer des données spécifiques
./scripts/selective-restore.sh [component]

# 3. Vérifier l'intégrité
./scripts/check-integrity.sh
```

## Procédures de Support

### 1. Collecte d'Informations

```bash
# 1. Générer un rapport de diagnostic
./scripts/generate-report.sh

# 2. Collecter les logs
./scripts/collect-logs.sh

# 3. Créer un snapshot système
./scripts/create-snapshot.sh
```

### 2. Escalade

1. Niveau 1 : Support local
2. Niveau 2 : Support technique
3. Niveau 3 : Support développeur

## Annexes

### Commandes Utiles

```bash
# Vérification rapide du système
./scripts/health-check.sh

# Nettoyage du système
./scripts/cleanup.sh

# Reset d'urgence
./scripts/emergency-reset.sh
```

### Logs Importants

1. `/var/log/syslog`
2. `/var/log/docker/`
3. `/var/log/nginx/`
4. Service-specific logs in Docker volumes
