# Guide de Sécurité

Ce guide détaille les mesures de sécurité et les bonnes pratiques pour CyberGuard Unified SOC.

## Sécurité Système

### 1. Durcissement du Système

#### OS Level
```bash
# Mise à jour du système
apt update && apt upgrade -y

# Configuration du pare-feu
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

# Désactivation des services non essentiels
systemctl disable [service_name]
```

#### Docker Security
```bash
# Configuration sécurisée de Docker
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "userns-remap": "default",
    "no-new-privileges": true,
    "seccomp-profile": "/etc/docker/seccomp-profile.json"
}
```

### 2. Gestion des Accès

#### Utilisateurs et Groupes
```bash
# Création des groupes
groupadd soc-admin
groupadd soc-user
groupadd soc-readonly

# Gestion des permissions
chmod 600 /etc/[config_file]
chown root:soc-admin /etc/[config_file]
```

#### SSH Security
```bash
# Configuration SSH
Port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AllowGroups soc-admin
Protocol 2
```

## Sécurité des Applications

### 1. Authentification

#### Configuration OAuth2
```yaml
oauth2:
  providers:
    google:
      client_id: your_client_id
      client_secret: your_client_secret
      redirect_uri: https://soc.example.com/auth/callback
    
    microsoft:
      client_id: your_client_id
      client_secret: your_client_secret
      redirect_uri: https://soc.example.com/auth/callback

  settings:
    token_expiration: 3600
    refresh_token_expiration: 2592000
    session_expiration: 86400
```

#### MFA Configuration
```yaml
mfa:
  enabled: true
  methods:
    - totp
    - email
    - sms
  
  settings:
    max_attempts: 3
    lockout_duration: 300
    recovery_codes: 10
```

### 2. Autorisation

#### RBAC Configuration
```yaml
roles:
  admin:
    permissions:
      - all
    
  analyst:
    permissions:
      - read:alerts
      - write:cases
      - read:reports
    
  viewer:
    permissions:
      - read:alerts
      - read:cases
      - read:reports
```

#### ACL Configuration
```yaml
acl:
  resources:
    alerts:
      - action: read
        roles: [admin, analyst, viewer]
      - action: write
        roles: [admin, analyst]
      
    cases:
      - action: read
        roles: [admin, analyst, viewer]
      - action: write
        roles: [admin, analyst]
```

## Sécurité des Communications

### 1. TLS/SSL

#### Nginx Configuration
```nginx
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
ssl_prefer_server_ciphers off;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
```

#### Certificate Management
```bash
# Génération des certificats
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/soc.key \
    -out /etc/ssl/certs/soc.crt

# Renouvellement automatique (Let's Encrypt)
certbot renew --dry-run
```

### 2. API Security

#### API Gateway Configuration
```yaml
security:
  rate_limiting:
    enabled: true
    window_size: 3600
    max_requests: 1000
  
  jwt:
    enabled: true
    secret: your_secure_jwt_secret
    expiration: 3600
  
  cors:
    allowed_origins:
      - https://soc.example.com
    allowed_methods:
      - GET
      - POST
      - PUT
      - DELETE
```

## Sécurité des Données

### 1. Chiffrement

#### Data at Rest
```yaml
encryption:
  algorithm: AES-256-GCM
  key_rotation: 90
  backup_encryption: true
  
storage:
  encrypted_volumes:
    - /data/sensitive
    - /data/backups
  
databases:
  postgres:
    encryption: true
    tde_key: /etc/keys/db.key
```

#### Data in Transit
```yaml
transport:
  protocols:
    - TLSv1.2
    - TLSv1.3
  
  cipher_suites:
    - ECDHE-ECDSA-AES128-GCM-SHA256
    - ECDHE-RSA-AES128-GCM-SHA256
```

### 2. Gestion des Secrets

#### Vault Configuration
```yaml
vault:
  addr: "https://vault.soc.example.com"
  token: "your_vault_token"
  
  paths:
    secrets: "secret/soc"
    certificates: "pki/soc"
    
  policies:
    - name: "soc-admin"
      path: "secret/soc/*"
      capabilities: ["create", "read", "update", "delete", "list"]
    
    - name: "soc-user"
      path: "secret/soc/*"
      capabilities: ["read", "list"]
```

## Audit et Logging

### 1. Audit Logs

#### Configuration Auditd
```bash
# /etc/audit/auditd.conf
log_file = /var/log/audit/audit.log
log_format = RAW
log_group = adm
priority_boost = 4
flush = INCREMENTAL_ASYNC
freq = 50
num_logs = 5
disp_qos = lossy
dispatcher = /sbin/audispd
name_format = NONE
max_log_file = 6
max_log_file_action = ROTATE
space_left = 75
space_left_action = SYSLOG
action_mail_acct = root
admin_space_left = 50
admin_space_left_action = SUSPEND
disk_full_action = SUSPEND
disk_error_action = SUSPEND
```

#### Audit Rules
```bash
# /etc/audit/rules.d/audit.rules
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k identity
-w /var/log/auth.log -p wa -k auth
```

### 2. Monitoring

#### SIEM Integration
```yaml
wazuh:
  manager:
    alerts:
      log_level: 3
      email_notification: true
  
  agent:
    modules:
      - syscollector
      - rootcheck
      - syscheck
```

## Sécurité Opérationnelle

### 1. Gestion des Incidents

#### Procédure d'Incident
1. Détection
2. Isolation
3. Investigation
4. Remédiation
5. Documentation
6. Post-mortem

#### Playbooks
```yaml
incident_response:
  malware:
    - isolate_host
    - collect_evidence
    - analyze_malware
    - remove_threat
    - restore_system
  
  breach:
    - block_access
    - reset_credentials
    - audit_logs
    - notify_stakeholders
    - implement_fixes
```

### 2. Continuité d'Activité

#### Backup Strategy
```yaml
backup:
  frequency: daily
  retention: 30
  type: incremental
  
  targets:
    - databases
    - configurations
    - certificates
    
  encryption:
    enabled: true
    algorithm: AES-256-GCM
```

#### Disaster Recovery
```yaml
dr:
  rpo: 4h
  rto: 2h
  
  procedures:
    - failover
    - data_sync
    - service_restoration
    
  testing:
    frequency: quarterly
    type: full
```

## Annexes

### 1. Check-lists de Sécurité

#### Déploiement
- [ ] Durcissement système
- [ ] Configuration TLS
- [ ] Configuration pare-feu
- [ ] Configuration audit
- [ ] Test sécurité

#### Maintenance
- [ ] Mise à jour systèmes
- [ ] Rotation des secrets
- [ ] Vérification backups
- [ ] Scan vulnérabilités
- [ ] Test restauration

### 2. Contacts d'Urgence

```yaml
emergency:
  security_team:
    phone: +XX-XXX-XXX-XXX
    email: security@example.com
  
  providers:
    - name: Support Provider
      phone: +XX-XXX-XXX-XXX
      email: support@provider.com
```

### 3. Références

- CIS Benchmarks
- NIST Cybersecurity Framework
- ISO 27001
- SOC 2
- GDPR
