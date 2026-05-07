# 🐐 La Chèvrerie du Rocher — Système de gestion Odoo

Déploiement Odoo 17 pour la **Chèvrerie du Rocher** (Couserans, Ariège).  
Couvre la gestion de stock, le point de vente et la vente en ligne.

---

## 🐐 Accès

### Boutique en ligne (clients)

**[thegoat.karpos.pro](https://thegoat.karpos.pro)**

### Backend Odoo (administrateurs)

**[thegoat.karpos.pro/web](https://thegoat.karpos.pro/web)**

| Module | Accès |
|---|---|
| **Point de Vente** | Backend → Point of Sale → Ouvrir la session |
| **Stock / Inventaire** | Backend → Inventory |
| **Boutique en ligne** | Backend → Website |
| **Gestion base de données** | [thegoat.karpos.pro/web/database/manager](https://thegoat.karpos.pro/web/database/manager) |

---

## 🐐 Fonctionnalités

| Module Odoo | Usage |
|---|---|
| **Inventory** | Gestion du stock (fromages, produits laitiers, produits dérivés) |
| **Point of Sale** | Vente directe à la ferme |
| **eCommerce / Website** | Boutique en ligne |

---

## 🐐 Infrastructure

### Stack technique

- **Odoo** : 17.0
- **Base de données** : PostgreSQL 15
- **Orchestration** : Docker Compose (OrbStack, Mac Mini)
- **Exposition** : Cloudflare Tunnel → `thegoat.karpos.pro`
- **Modules custom** : dossier `addons/` (monté dans le conteneur)

### Services Docker

| Conteneur | Image | Rôle |
|---|---|---|
| `the_goat_odoo` | odoo:17.0 | Application web (port 8069 interne) |
| `the_goat_db` | postgres:15 | Base de données |
| `the_goat_cloudflared` | cloudflare/cloudflared | Tunnel Cloudflare (HTTPS public) |

### Démarrage / arrêt

```bash
# Lancer les services
docker compose up -d

# Voir les logs
docker compose logs -f

# Arrêter sans supprimer les données
docker compose down

# Supprimer aussi les volumes (reset complet)
docker compose down -v
```

Les données sont persistées dans les volumes Docker `db_data` (PostgreSQL) et `odoo_data` (fichiers Odoo).

### Tunnel Cloudflare

Le fichier `.env` (non commité) contient le token du tunnel :

```
CLOUDFLARE_TUNNEL_TOKEN=...
```

Dashboard : [dash.cloudflare.com](https://dash.cloudflare.com) → Zero Trust → Networks → Tunnels → `the-goat-odoo`

### Configuration Odoo

`config/odoo.conf` est chargé au démarrage du conteneur. Le fichier est exclu du git (`.gitignore`).  
`proxy_mode = True` est activé pour que Odoo reçoive correctement les IPs via le tunnel Cloudflare.

### Structure du projet

```
the_goat/
├── addons/            # Modules Odoo personnalisés
├── config/
│   └── odoo.conf      # Configuration Odoo (ignoré par git)
├── .env               # Secrets (ignoré par git)
└── docker-compose.yml
```

### Développement de modules

Placer les modules custom dans `addons/`. Ils sont automatiquement disponibles via le chemin `addons_path` configuré.

Après ajout d'un module :
```
Paramètres > Activer le mode développeur > Mettre à jour la liste des applications
```
