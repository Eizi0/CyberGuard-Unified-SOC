# 👥 Guide de l'Utilisateur CyberGuard Unified SOC

<div align="center">
  <img src="../Logo/CSU Logo.png" alt="CSU Logo" width="150"/>
  
  **Guide Complet d'Utilisation - Interface Unifiée**
</div>

---

## 🚀 Démarrage Rapide

### **🔐 Première Connexion**

1. **Accès à l'interface** : http://localhost:3000
2. **Page de connexion** avec logo CSU proéminent
3. **Identifiants par défaut** :
   - Utilisateur : `admin`
   - Mot de passe : `admin` (à changer immédiatement)

### **🎯 Interface Principale**

L'interface CyberGuard arbore le **logo CSU** dans :
- **🔝 Barre de navigation** : Logo + titre complet
- **📱 Menu latéral** : Logo compact + "CSU SOC"
- **🏠 Dashboard** : Logo proéminent avec description
- **👤 Profil utilisateur** : Message de bienvenue personnalisé

---

## 📊 Dashboard Principal

### **🎨 Vue d'Ensemble avec Branding CSU**

Le dashboard principal affiche :
- **🏢 En-tête CSU** : Logo 60px + "CyberGuard Unified SOC"
- **📈 Métriques temps réel** :
  - Total Agents Wazuh : 25
  - Alertes Critiques : 3  
  - Cas Actifs : 7
  - IoCs Totaux : 152

### **📋 Sections Disponibles**

#### **🛡️ Statut Sécurité**
```
┌─────────────────────────────────────────┐
│  🟢 Wazuh Manager    │ Opérationnel     │
│  🟢 Graylog         │ 1.2K logs/min    │
│  🟡 TheHive         │ 3 cas ouverts    │
│  🟢 MISP            │ 152 IoCs actifs  │
└─────────────────────────────────────────┘
```

#### **⚡ Services Rapides**
- **🔍 Recherche globale** dans tous les outils
- **🚨 Centre d'alertes** unifié
- **📊 Rapports express** 
- **⚙️ Configuration système**

---

## 🛠️ Navigation par Service

### **🔍 Wazuh SIEM (Port 55000)**

#### **Accès via Menu CSU**
1. Cliquer sur **"Wazuh"** dans le menu latéral
2. Interface intégrée ou redirection vers http://localhost:55000

#### **Fonctionnalités**
- **👥 Gestion des agents** : Déploiement et monitoring
- **🚨 Alertes de sécurité** : Détection temps réel
- **📊 Tableaux de bord** : Métriques et visualisations
- **🔧 Configuration** : Règles et politiques

### **📋 Graylog (Port 9000)**

#### **Navigation CSU**
- Menu : **"Graylog"** → Interface de gestion des logs
- **Connexion** : admin / admin (par défaut)

#### **Utilisation**
- **📥 Collecte de logs** : Sources multiples (Syslog, GELF)
- **🔍 Recherche avancée** : Requêtes complexes
- **📊 Dashboards** : Visualisations personnalisées
- **⚠️ Alertes** : Conditions et notifications

### **🐝 TheHive (Port 9001)**

#### **Gestion des Incidents**
- **📝 Création de cas** : Workflow structuré
- **👥 Collaboration** : Équipes SOC
- **📋 Tâches** : Attribution et suivi
- **📄 Rapports** : Documentation complète

#### **Workflow Typique**
1. **🆕 Nouveau cas** : Détection ou signalement
2. **🔍 Investigation** : Collecte de preuves
3. **📊 Analyse** : Corrélation des données
4. **⚡ Actions** : Mesures correctives
5. **📄 Clôture** : Rapport final

### **🔗 MISP (Port 443)**

#### **Threat Intelligence**
- **🌐 Partage d'IoCs** : Communauté globale
- **📊 Analyse** : Attributs et taxonomies
- **🔄 Synchronisation** : Feeds automatiques
- **🎯 Hunting** : Recherche proactive

### **🧠 OpenCTI (Port 8080)**

#### **Cyber Threat Intelligence**
- **🗺️ Cartographie** : Acteurs et campagnes
- **📚 Knowledge Base** : STIX/TAXII
- **🔗 Relations** : Liens entre entités
- **📈 Tendances** : Évolution des menaces

---

## 🔧 Utilisation par Profil de Déploiement

### **🏁 Profil Développement**

#### **Services Disponibles**
- ✅ **Frontend CSU** avec authentification
- ✅ **Backend API** avec documentation
- ✅ **Wazuh** (API uniquement)
- ✅ **Graylog** (configuration légère)
- ✅ **Elasticsearch** pour recherche

#### **Cas d'Usage**
- **🧪 Tests** de règles Wazuh
- **📊 Développement** de dashboards
- **🎓 Formation** équipes SOC
- **💡 Proof of Concept**

### **⚡ Profil Minimal**

#### **Services Supplémentaires**
- ✅ **TheHive** pour gestion d'incidents
- ✅ **Redis** pour cache optimisé
- ✅ **Configurations optimisées** mémoire

#### **Utilisation PME**
- **🏢 SOC de base** pour PME
- **🚨 Gestion d'incidents** structurée
- **📊 Reporting** essentiel
- **💰 Coût optimisé**

### **🚀 Profil Complet**

#### **Tous les Services**
- ✅ **9 outils** de sécurité intégrés
- ✅ **Infrastructure complète**
- ✅ **Threat Intelligence** avancée
- ✅ **Forensics** et automation

#### **SOC Enterprise**
- **🏭 Organisation complexe**
- **🔄 Workflows avancés**
- **🤖 Automation** SOAR
- **📈 Scalabilité** complète

---

## 📱 Interface Mobile et Responsive

### **🔧 Adaptation Multi-Écrans**

L'interface CSU s'adapte automatiquement :
- **💻 Desktop** : Interface complète avec logo 60px
- **📱 Tablet** : Navigation compacte avec logo 40px
- **📱 Mobile** : Menu hamburger avec logo 32px

### **⚡ Fonctionnalités Mobiles**
- **🚨 Notifications push** : Alertes critiques
- **📊 Dashboards tactiques** : Métriques essentielles
- **🔐 Authentification** : Touch ID / Face ID
- **📱 Mode hors-ligne** : Consultation des rapports

---

## 🎯 Workflows Recommandés

### **🚨 Gestion d'Incident Type**

#### **1️⃣ Détection**
```
Wazuh → Alerte → Dashboard CSU → Notification
```

#### **2️⃣ Triage Initial**
```
Dashboard CSU → TheHive → Création Cas → Attribution
```

#### **3️⃣ Investigation**
```
Graylog → Recherche logs → Corrélation → Preuves
```

#### **4️⃣ Enrichissement**
```
MISP → IoCs → OpenCTI → Contexte menace
```

#### **5️⃣ Response**
```
Shuffle → Playbook → Actions → Containment
```

#### **6️⃣ Documentation**
```
TheHive → Rapport → Velociraptor → Forensics
```

### **🔍 Threat Hunting Proactif**

#### **Méthode CSU**
1. **🎯 Hypothèse** : Définir la menace recherchée
2. **📊 Données** : Collecter via Graylog + Wazuh
3. **🔗 Corrélation** : Analyser avec OpenCTI
4. **💎 IoCs** : Enrichir via MISP
5. **⚡ Automation** : Créer playbook Shuffle
6. **📄 Documentation** : Partager via TheHive

---

## 🔐 Gestion des Utilisateurs

### **👥 Rôles et Permissions**

#### **🔧 Administrateur CSU**
- **⚙️ Configuration** complète du système
- **👥 Gestion** des utilisateurs et rôles
- **🔧 Maintenance** des services
- **📊 Reporting** global

#### **🕵️ Analyste SOC**
- **🚨 Gestion** des alertes et incidents
- **🔍 Investigation** et analyse
- **📄 Création** de rapports
- **🎯 Threat Hunting**

#### **👀 Observateur**
- **📊 Consultation** des dashboards
- **📄 Lecture** des rapports
- **👁️ Monitoring** des métriques
- **🔍 Recherche** limitée

### **🔑 Authentification Avancée**

#### **Configuration SSO**
```yaml
# Configuration LDAP/Active Directory
auth:
  type: ldap
  server: ldap://your-domain.com
  base_dn: dc=company,dc=com
  user_filter: (sAMAccountName={username})
```

#### **2FA Integration**
- **📱 TOTP** : Google Authenticator
- **📧 Email** : Codes par email
- **📱 SMS** : Messages texte
- **🔐 Hardware** : Clés de sécurité

---

## 📞 Support Utilisateur

### **🛠️ Auto-Diagnostic Interface**

Accessible via le menu CSU :
- **⚡ Status Dashboard** : État temps réel des services
- **📊 Health Check** : Validation automatique
- **🔧 Troubleshooting** : Guide interactif
- **📄 Logs Viewer** : Consultation directe

### **📚 Documentation Contextuelle**

Chaque section inclut :
- **❓ Aide contextuelle** : Tooltips et guides
- **🎥 Tutoriels vidéo** : Workflows étape par étape
- **📖 Knowledge Base** : Articles techniques
- **💬 Chat Support** : Assistance en ligne

### **🐛 Signalement de Problèmes**

Interface intégrée pour :
- **📝 Tickets** : Création automatique
- **📊 Diagnostics** : Export des logs
- **📷 Screenshots** : Capture d'écran
- **📧 Notification** : Suivi par email

---

<div align="center">
  
  **🎉 Profitez de votre CyberGuard Unified SOC !**
  
  Interface moderne avec logo CSU intégré pour une expérience professionnelle
  
</div>

### MISP
- Consultation des IoCs
- Ajout d'indicateurs
- Partage d'informations
- Analyses des tendances

### OpenCTI
- Base de connaissances
- Visualisation des menaces
- Relations entre entités
- Rapports d'analyse

## Digital Forensics

### Velociraptor
1. Collection de données
2. Analyse des artefacts
3. Timeline des événements
4. Extraction des preuves

## Automatisation

### Playbooks Shuffle
1. Déclencheurs
2. Actions
3. Conditions
4. Résultats

## Reporting

### Types de Rapports
- Rapports d'incidents
- Analyses de tendances
- Métriques de performance
- Rapports de conformité

### Génération
1. Sélection du type
2. Configuration des paramètres
3. Génération
4. Export (PDF, CSV, etc.)

## Bonnes Pratiques

### Gestion des Alertes
1. Priorisation
2. Documentation
3. Escalade si nécessaire
4. Suivi

### Investigation
1. Méthodologie structurée
2. Collection des preuves
3. Documentation détaillée
4. Chaîne de custody

### Communication
1. Clarté
2. Précision
3. Professionnalisme
4. Confidentialité

## Annexes

### Raccourcis Clavier
| Action | Raccourci |
|--------|-----------|
| Nouvelle alerte | Ctrl+N |
| Recherche | Ctrl+F |
| Actualiser | F5 |
| Aide | F1 |

### Glossaire
- SIEM : Security Information and Event Management
- IoC : Indicator of Compromise
- SOC : Security Operations Center
- CTI : Cyber Threat Intelligence
