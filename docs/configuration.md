# Guide de Configuration

Ce guide détaille la configuration complète du CyberGuard Unified SOC.

## Configuration Globale

### Variables d'Environnement (.env)

```env
# Configuration Générale
DOMAIN=soc.example.com
TIMEZONE=Europe/Paris

# Configuration Base de Données
DB_HOST=postgres
DB_PORT=5432
DB_USER=admin
DB_PASSWORD=secure_password
DB_NAME=cyberguard

# Configuration Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=secure_redis_password

# Configuration Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=alerts@example.com
SMTP_PASSWORD=secure_smtp_password

# Configurations JWT
JWT_SECRET=your_secure_jwt_secret
JWT_EXPIRATION=3600
```

## Configuration des Services

### 1. Backend (FastAPI)

```yaml
# config/backend.yaml
server:
  host: 0.0.0.0
  port: 8000
  workers: 4
  reload: false

logging:
  level: INFO
  format: '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
  
security:
  allowed_origins:
    - http://localhost:3000
    - https://soc.example.com
  
database:
  pool_size: 20
  max_overflow: 10
  timeout: 30
```

### 2. Frontend (React)

```yaml
# config/frontend.yaml
server:
  port: 3000
  
api:
  baseUrl: http://localhost:8000
  timeout: 5000

features:
  enableDarkMode: true
  enableNotifications: true
  enableAutoRefresh: true
```

### 3. Wazuh

```yaml
# config/wazuh.yaml
manager:
  port: 55000
  max_threads: 128
  
alerts:
  log_level: 3
  email_notification: true
  
rules:
  frequency: 120
  timeframe: 300
  
active_response:
  enabled: true
  timeout: 300
```

### 4. Graylog

```yaml
# config/graylog.yaml
http:
  bind_address: 0.0.0.0:9000
  
password_secret: "your_secure_password_secret"
root_password_sha2: "your_hashed_password"

elasticsearch:
  hosts: "http://elasticsearch:9200"
  
mongodb:
  uri: "mongodb://mongodb:27017/graylog"
```

### 5. TheHive

```yaml
# config/thehive.yaml
play.http.secret.key: "your_secret_key"

storage:
  provider: localfs
  localfs.location: /opt/thp/thehive/data

datastore:
  provider: cassandra
  cassandra:
    servers:
      - "cassandra:9042"
```

### 6. MISP

```yaml
# config/misp.yaml
debug: false
site:
  baseurl: https://localhost
  secure_auth: true
  
database:
  host: mariadb
  port: 3306
  username: misp
  password: secure_password
  
redis:
  host: redis
  port: 6379
```

## Configuration de la Sécurité

### 1. SSL/TLS

```nginx
# config/nginx/ssl.conf
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
ssl_prefer_server_ciphers off;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;
```

### 2. Authentification

```yaml
# config/auth.yaml
oauth2:
  enabled: true
  providers:
    - name: google
      client_id: your_client_id
      client_secret: your_client_secret
    
    - name: microsoft
      client_id: your_client_id
      client_secret: your_client_secret

mfa:
  enabled: true
  methods:
    - totp
    - email
```

### 3. CORS

```yaml
# config/cors.yaml
allowed_origins:
  - https://soc.example.com
  
allowed_methods:
  - GET
  - POST
  - PUT
  - DELETE
  - OPTIONS
  
allowed_headers:
  - Authorization
  - Content-Type
  - X-Requested-With
```

## Configuration du Monitoring

### 1. Prometheus

```yaml
# config/prometheus.yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'backend'
    static_configs:
      - targets: ['backend:8000']
  
  - job_name: 'wazuh'
    static_configs:
      - targets: ['wazuh:55000']
```

### 2. Grafana

```yaml
# config/grafana.yaml
server:
  http_port: 3000
  domain: grafana.soc.example.com

security:
  admin_user: admin
  admin_password: secure_admin_password

auth:
  disable_login_form: false
```

## Configuration des Sauvegardes

```yaml
# config/backup.yaml
schedule:
  frequency: daily
  time: "02:00"
  retention_days: 30

targets:
  - name: database
    type: postgres
    compression: true
    
  - name: elasticsearch
    type: snapshot
    compression: true
    
  - name: files
    type: filesystem
    paths:
      - /data/thehive
      - /data/misp
      - /data/wazuh

storage:
  type: s3
  bucket: backups-soc
  region: eu-west-1
  access_key: your_access_key
  secret_key: your_secret_key
```

## Configuration des Notifications

```yaml
# config/notifications.yaml
channels:
  email:
    enabled: true
    from: alerts@soc.example.com
    smtp_settings:
      host: smtp.gmail.com
      port: 587
      
  slack:
    enabled: true
    webhook_url: https://hooks.slack.com/services/xxx
    
  teams:
    enabled: true
    webhook_url: https://outlook.office.com/webhook/xxx

alerts:
  high_priority:
    channels:
      - email
      - slack
      - teams
    
  medium_priority:
    channels:
      - slack
      - teams
    
  low_priority:
    channels:
      - slack
```
