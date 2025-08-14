# ⚡ Guide de Démarrage Rapide - CyberGuard Unified SOC

<div align="center">
  <img src="../Logo/CSU Logo.png" alt="CSU Logo" width="200"/>
  
  # 🚀 Déploiement en 5 Minutes
  **Guide Express pour Installation et Premier Lancement**
</div>

---

## 🎯 Choix Express de Profil

**⚠️ Pas sûr de quel profil choisir ? Utilisez la détection automatique !**

### **🤖 Option 1 : Auto-Détection (RECOMMANDÉE)**

#### **🪟 Windows**
```powershell
# 1. Télécharger le projet
git clone https://github.com/Eizi0/CyberGuard-Unified-SOC.git
cd "CyberGuard Unified SOC"

# 2. Lancement automatique avec détection des ressources
powershell -ExecutionPolicy Bypass -File scripts\auto-deploy.ps1
```

#### **🐧 Linux**
```bash
# 1. Télécharger le projet
git clone https://github.com/Eizi0/CyberGuard-Unified-SOC.git
cd "CyberGuard Unified SOC"

# 2. Lancement automatique avec détection des ressources
sudo ./scripts/auto-deploy.sh
```

### **⚡ Option 2 : Sélection Manuelle Rapide**

| Si vous avez... | Utilisez ce profil | Commande |
|-----------------|-------------------|----------|
| **4-8GB RAM** | 🏁 Développement | `docker-compose -f docker/docker-compose.dev.yml up -d` |
| **8-12GB RAM** | ⚡ Minimal | `docker-compose -f docker/docker-compose.minimal.yml up -d` |
| **16GB+ RAM** | 🚀 Complet | `docker-compose -f docker/docker-compose.yml up -d` |

---

## 📊 Que Fait l'Auto-Détection ?

### **🔍 Analyse Système**
```
🔍 Détection des ressources système...
📊 Ressources système détectées :
   💾 RAM Totale : 16.0 GB        ✅
   💾 RAM Disponible : 12.8 GB     ✅
   🖥️  Cœurs CPU : 8               ✅
   💿 Espace Disque : 250.5 GB     ✅

✅ Recommandation : Profil COMPLET
   Tous les 9 outils de sécurité seront déployés
```

### **🎯 Menu Interactif**
```
Que souhaitez-vous faire ?
1. 🚀 Déployer avec le profil recommandé    [RAPIDE]
2. 🔧 Choisir un autre profil manuellement
3. 📊 Voir les détails des profils
4. ❌ Annuler

Votre choix (1-4): 1
```

### **⚡ Déploiement Automatique**
- ✅ **Vérification Docker** : S'assure que Docker fonctionne
- ✅ **Configuration optimale** : Applique les paramètres selon vos ressources
- ✅ **Lancement des services** : Démarre les containers appropriés
- ✅ **Validation** : Vérifie que tout fonctionne
- ✅ **URLs d'accès** : Affiche les liens directs

---

## 🌐 Accès Immédiat Après Installation

### **🔗 URLs Principales**
| Service | URL | Description |
|---------|-----|-------------|
| **🏠 Interface CSU** | http://localhost:3000 | **Page principale avec logo** |
| **🔧 API Backend** | http://localhost:8000 | Documentation Swagger |

### **🛡️ Outils Sécurité (selon profil)**
| Outil | URL | Profil Minimum |
|-------|-----|----------------|
| **📊 Graylog** | http://localhost:9000 | 🏁 Développement |
| **🔍 Wazuh** | http://localhost:55000 | 🏁 Développement |
| **🐝 TheHive** | http://localhost:9001 | ⚡ Minimal |
| **🔗 MISP** | https://localhost:443 | 🚀 Complet |
| **🧠 OpenCTI** | http://localhost:8080 | 🚀 Complet |
| **🔬 Velociraptor** | http://localhost:8889 | 🚀 Complet |
| **⚡ Shuffle** | https://localhost:3443 | 🚀 Complet |

---

## 🔐 Premiers Pas sur l'Interface

### **1️⃣ Page de Connexion**
- **🎨 Logo CSU proéminent** (100px)
- **👤 Utilisateur** : `admin`
- **🔑 Mot de passe** : `admin`
- **⚠️ À changer immédiatement !**

### **2️⃣ Dashboard Principal**
- **🏢 En-tête CSU** : Logo + "CyberGuard Unified SOC"
- **📊 Métriques temps réel** :
  ```
  ┌─────────────────────────────────────────┐
  │ Total Agents    │ Critical Alerts │ 25 │ 3 │
  │ Active Cases    │ Total IoCs      │ 7  │152│
  └─────────────────────────────────────────┘
  ```

### **3️⃣ Navigation**
- **📱 Menu latéral** : Logo CSU compact + liste des services
- **🔝 Barre supérieure** : Logo blanc + nom complet + déconnexion
- **🌙 Thème sombre** : Design moderne et professionnel

---

## ⚡ Tests Rapides Post-Installation

### **✅ Validation Express**

#### **🪟 Windows**
```powershell
# Test rapide des services
docker-compose ps

# Validation complète (optionnel)
powershell -ExecutionPolicy Bypass -File scripts\validate.ps1
```

#### **🐧 Linux**
```bash
# Test rapide des services
docker-compose ps

# Validation complète (optionnel)
sudo ./scripts/health-check.sh
```

### **🔍 Vérification Manuelle**

1. **🌐 Frontend** : Ouvrir http://localhost:3000
   - ✅ Logo CSU visible
   - ✅ Page de connexion fonctionnelle
   
2. **📊 Backend** : Ouvrir http://localhost:8000
   - ✅ Documentation Swagger accessible
   - ✅ Endpoint `/health` retourne 200

3. **🛡️ Services Sécurité** : Tester selon votre profil
   - ✅ Graylog : http://localhost:9000 (admin/admin)
   - ✅ Wazuh : http://localhost:55000

---

## 🚨 Dépannage Express

### **❌ Problème : Services ne démarrent pas**
```bash
# Solution universelle
docker-compose down -v
docker system prune -f
docker-compose up -d
```

### **❌ Problème : Pas assez de RAM**
```bash
# Changer pour profil plus léger
docker-compose down
docker-compose -f docker/docker-compose.dev.yml up -d
```

### **❌ Problème : Port occupé**
```bash
# Windows
netstat -an | findstr :3000

# Linux
sudo lsof -i :3000

# Solution : Arrêter le processus ou changer le port dans .env
```

### **❌ Problème : Docker non démarré**

#### **🪟 Windows**
1. Ouvrir **Docker Desktop**
2. Attendre le démarrage complet
3. Relancer le script

#### **🐧 Linux**
```bash
# Démarrer Docker
sudo systemctl start docker
sudo systemctl enable docker

# Relancer l'installation
sudo ./scripts/auto-deploy.sh
```

---

## 🔄 Commandes de Gestion Rapide

### **🛠️ Gestion des Services**
```bash
# Voir les services actifs
docker-compose ps

# Logs en temps réel
docker-compose logs -f

# Redémarrer un service
docker-compose restart [service_name]

# Arrêter tout
docker-compose down
```

### **📊 Monitoring Rapide**
```bash
# Utilisation des ressources
docker stats --no-stream

# Espace disque utilisé
docker system df

# Nettoyage léger
docker system prune
```

---

## 🎯 Prochaines Étapes

### **🔧 Configuration Avancée**
1. **🔐 Changer les mots de passe** dans `.env`
2. **📧 Configurer les notifications** email
3. **👥 Créer des utilisateurs** supplémentaires
4. **🎨 Personnaliser** les dashboards

### **📚 Apprentissage**
- **📖 Lire** : `docs/user-guide.md`
- **🏗️ Comprendre** : `docs/architecture.md`
- **🔐 Sécuriser** : `docs/security.md`
- **🛠️ Maintenir** : `docs/maintenance.md`

### **🚀 Mise en Production**
1. **🔒 Sécuriser** les configurations
2. **📊 Configurer** le monitoring
3. **💾 Planifier** les sauvegardes
4. **👥 Former** les équipes

---

<div align="center">
  
  **🎉 Félicitations ! Votre CSU est opérationnel !**
  
  **En moins de 5 minutes, vous avez déployé une plateforme SOC complète**
  
  ![CSU Logo](../Logo/CSU Logo.png)
  
  **Prochaine étape :** Explorer l'interface et personnaliser votre installation
  
</div>
