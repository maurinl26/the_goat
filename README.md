# 🐐 La Chèvrerie du Rocher — Système de gestion Odoo

Déploiement Odoo 17 pour la **Chèvrerie du Rocher** (Couserans, Ariège).  
Couvre la gestion de stock, le point de vente et la vente en ligne.

## 🐐 Fonctionnalités visées

| Module Odoo | Usage |
|---|---|
| **Inventory** | Gestion du stock (fromages, produits laitiers, produits dérivés) |
| **Point of Sale** | Vente directe à la ferme |
| **eCommerce / Website** | Boutique en ligne |

## 🐐 Stack technique

- **Odoo** : 17.0
- **Base de données** : PostgreSQL 15
- **Orchestration** : Docker Compose
- **Modules custom** : dossier `addons/` (monté dans le conteneur)

## 🐐 Démarrage rapide

```bash
# Cloner le dépôt
git clone <url-du-repo> the_goat
cd the_goat

# Lancer les services
docker compose up -d

# Accéder à l'interface
open http://localhost:8069
```

Au premier démarrage, créer la base de données depuis l'interface web (`/web/database/manager`).

## 🐐 Structure du projet

```
the_goat/
├── addons/            # Modules Odoo personnalisés
├── config/
│   └── odoo.conf      # Configuration Odoo
└── docker-compose.yml
```

## 🐐 Configuration

Le fichier `config/odoo.conf` est chargé au démarrage du conteneur.  
Le mot de passe administrateur (`admin_passwd`) est défini dans ce fichier — ne pas le committer en clair en production.

## 🐐 Développement de modules

Placer les modules custom dans `addons/`. Ils sont automatiquement disponibles dans Odoo via le chemin `addons_path` configuré.

Après ajout d'un module :

```bash
# Mettre à jour la liste des applications dans Odoo
# Paramètres > Activer le mode développeur > Mettre à jour la liste des applications
```

## 🐐 Arrêt et données

```bash
# Arrêter sans supprimer les données
docker compose down

# Supprimer aussi les volumes (reset complet)
docker compose down -v
```

Les données sont persistées dans les volumes Docker `db_data` (PostgreSQL) et `odoo_data` (fichiers Odoo).
