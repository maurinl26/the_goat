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

### 📖 Guides utilisateur

Fiches pratiques pour l'usage quotidien (Marie & Véronique) — voir [`docs/`](docs/README.md) :

- [Modifier le site (textes / photos)](docs/site-modifier.md)
- [Tenir une session de marché](docs/point-de-vente-marche.md)
- [Ajouter un article à l'inventaire](docs/inventaire-articles.md)
- [Gérer les clients du point de vente](docs/clients.md)

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
├── addons/
│   └── chevrerie_website/   # Thème custom (cf. section dédiée)
├── config/
│   └── odoo.conf            # Configuration Odoo (ignoré par git)
├── .env                     # Secrets (ignoré par git)
├── dev.sh                   # Toolkit dev (cf. section dédiée)
└── docker-compose.yml
```

---

## 🐐 Thème custom — `chevrerie_website`

Module qui habille le site avec l'identité visuelle de la Chèvrerie. Il **ne remplace pas** la page d'accueil par défaut : il pose le style global et fournit des **snippets** à glisser dans l'éditeur du site.

### Identité visuelle

| Token | Valeur | Rôle |
|---|---|---|
| `--chev-bg` | `#FAF8F3` | Lin / papier non blanchi (surface principale) |
| `--chev-bg-soft` | `#F1EDE4` | Surface secondaire (cards) |
| `--chev-forest` | `#2F4A37` | Vert sapin (accent principal) |
| `--chev-terre` | `#A0522D` | Terre cuite (CTA, boutons primaires) |
| `--chev-or` | `#C9A24B` | Doré (liserés, ornements) |
| `--chev-text` | `#3D3A33` | Gris-brun chaud (jamais de noir pur) |

Typographie : **Fraunces** (serif éditorial, titres) + **Inter** (sans, corps de texte), chargées via Google Fonts.

### Structure du module

```
addons/chevrerie_website/
├── __manifest__.py
├── views/
│   ├── layout.xml             # Injection Google Fonts dans <head>
│   └── snippets.xml           # Définition & enregistrement des snippets
└── static/src/scss/
    ├── _variables.scss        # Design tokens (palette, typo, radii)
    ├── theme.scss             # Styles globaux (body, h1-h6, boutons, header, cards)
    ├── hero.scss              # Snippet "Hero éditorial"
    └── markets.scss           # Snippet "Marchés"
```

### Snippets disponibles

| Snippet | Catégorie éditeur | Usage |
|---|---|---|
| **Hero éditorial** | Structure | Composition magazine : photo plein cadre + cartouche typographique chevauchant l'image |
| **Marchés** | Content | Cartes des marchés où la Chèvrerie est présente (jour, horaires, adresse) |

Pour les utiliser : sur n'importe quelle page → **Modifier** → onglet **Blocs** → drag.

### ⚠️ Ne pas installer de thème de démo Odoo

Les thèmes Odoo (theme_artists, theme_wool, theme_bookstore, etc.) **écrasent** notre style. Si l'un est actif (couleurs flashy, contenu démo "Laine & Passion" ou similaire) :

```bash
./dev.sh untheme    # désinstalle tous les theme_*
./dev.sh reload     # réapplique notre style
```

---

## 🐐 Toolkit `dev.sh`

Stratégie : **scripter au maximum** pour éviter les allers-retours dans l'UI Odoo. Toute action dev répétitive doit avoir sa commande dans `./dev.sh`.

### Commandes

```bash
# État
./dev.sh ls                       # Liste les bases PostgreSQL
./dev.sh modules [pattern]        # Modules installés (filtre optionnel)
./dev.sh logs                     # Logs Odoo en tail -f

# Modules
./dev.sh install <module>         # Installe un module
./dev.sh uninstall <module>       # Désinstalle proprement
./dev.sh reload [module]          # Recharge (défaut: chevrerie_website) après édition SCSS/XML
./dev.sh update-list              # Met à jour la liste des apps disponibles

# Raccourcis projet
./dev.sh untheme                  # Désinstalle tous les thèmes de démo Odoo
./dev.sh setup-company            # Société + adresse + Instagram (footer)
./dev.sh set-logo <path>          # Injecte un logo (res.company + website)
./dev.sh set-favicon <path>       # Injecte un favicon (website.favicon)
./dev.sh reset-home               # Vide la page d'accueil
./dev.sh init-home                # Pose la composition Chèvrerie sur la home
./dev.sh dump-home [path]         # Exporte le contenu actuel de la home en XML
./dev.sh shell                    # Shell Python avec env Odoo (REPL)
./dev.sh psql                     # Console PostgreSQL
```

### Édition de la home : code vs UI

La home fonctionne désormais en **deux temps** :

1. **Init (côté code)** : la composition est définie dans `./dev.sh init-home` (liste de snippets en haut du `case`). Une fois exécutée, les snippets sont rendus et inlinés dans `website_page.arch_db`. Le module ne touche plus à la home après cette étape.
2. **Édition (côté UI)** : Marie/Véronique cliquent sur une image dans l'éditeur Odoo (Modifier → clic sur l'image → **Remplacer**), changent un texte, déplacent un bloc. Ces modifs persistent en base et **ne sont pas écrasées** par `./dev.sh reload`.

Pour repartir de zéro côté composition : `./dev.sh reset-home && ./dev.sh init-home`.

Pour versionner un état UI dans le repo : `./dev.sh dump-home addons/chevrerie_website/views/home_snapshot.xml`.

La base cible est `db` par défaut. Pour une autre :

```bash
DB=ma_base ./dev.sh reload
```

### Workflow vibe coding

1. Éditer SCSS/XML/Python dans `addons/chevrerie_website/`
2. `./dev.sh reload` — recharge le module et redémarre Odoo
3. Rafraîchir le navigateur (vider le cache si besoin : `Cmd+Shift+R`)

Pour ajouter une commande au toolkit : éditer `dev.sh`, ajouter un `case` au switch.
