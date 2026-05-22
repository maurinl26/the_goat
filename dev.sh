#!/usr/bin/env bash
# Toolkit dev — La Chèvrerie du Rocher
# Usage : ./dev.sh <command> [args]

set -e

DB="${DB:-db}"
MODULE="chevrerie_website"

cmd="${1:-help}"
shift || true

case "$cmd" in

  # ---------- état & inspection ----------
  ls)
    docker compose exec -T db psql -U odoo -l
    ;;

  modules)
    # Liste les modules installés (filtrable : ./dev.sh modules theme)
    pattern="${1:-}"
    if [ -n "$pattern" ]; then
      docker compose exec -T db psql -U odoo -d "$DB" -c \
        "SELECT name, state FROM ir_module_module WHERE state='installed' AND name ILIKE '%${pattern}%' ORDER BY name;"
    else
      docker compose exec -T db psql -U odoo -d "$DB" -c \
        "SELECT name, state FROM ir_module_module WHERE state='installed' ORDER BY name;"
    fi
    ;;

  logs)
    docker compose logs -f odoo
    ;;

  # ---------- modules ----------
  install)
    # Installe un module : ./dev.sh install <module>
    mod="${1:?usage: ./dev.sh install <module>}"
    docker compose exec -T db psql -U odoo -d "$DB" -c \
      "UPDATE ir_module_module SET state='to install' WHERE name='${mod}' AND state='uninstalled';"
    docker compose restart odoo
    echo "→ Installation de ${mod} en cours, suis les logs : ./dev.sh logs"
    ;;

  uninstall)
    # Désinstalle un module proprement via l'API Odoo
    mod="${1:?usage: ./dev.sh uninstall <module>}"
    docker compose exec -T odoo odoo shell --no-http -d "$DB" <<PYEOF
m = env['ir.module.module'].search([('name', '=', '${mod}'), ('state', '=', 'installed')])
if m:
    m.button_immediate_uninstall()
    env.cr.commit()
    print("→ ${mod} désinstallé.")
else:
    print("→ ${mod} non installé, rien à faire.")
PYEOF
    docker compose restart odoo
    ;;

  reload)
    # Recharge notre module (SCSS/XML/Python) après édition
    mod="${1:-$MODULE}"
    docker compose exec -T odoo odoo --no-http --stop-after-init \
      -d "$DB" -u "$mod"
    docker compose restart odoo
    echo "→ ${mod} rechargé."
    ;;

  update-list)
    # Met à jour la liste des modules disponibles (équiv. "Update Apps List")
    docker compose exec -T odoo odoo --no-http --stop-after-init \
      -d "$DB" -u base --load-language=fr_FR 2>&1 | tail -5
    echo "→ Liste des modules mise à jour."
    ;;

  # ---------- raccourcis spécifiques au projet ----------
  untheme)
    # Désinstalle tous les thèmes de démo (modules theme_*)
    # et nettoie les ir_asset orphelins qui pointent encore vers eux
    docker compose exec -T odoo odoo shell --no-http -d "$DB" <<'PYEOF'
themes = env['ir.module.module'].search([
    ('name', 'like', 'theme_'),
    ('state', '=', 'installed'),
])
if themes:
    for t in themes:
        print(f"→ Désinstallation de {t.name}")
    themes.button_immediate_uninstall()
    env.cr.commit()
else:
    print("→ Aucun thème de démo installé.")

# Nettoie les ir_asset orphelins (références SCSS/JS vers les thèmes désinstallés)
env.cr.execute("""
    DELETE FROM ir_asset
    WHERE path ~ '(^|/)theme_[a-z_]+/'
""")
deleted = env.cr.rowcount
env.cr.commit()
if deleted:
    print(f"→ {deleted} asset(s) orphelin(s) supprimé(s).")
PYEOF
    docker compose restart odoo
    ;;

  set-logo)
    # Injecte un logo dans res.company (encodé base64) + le pousse sur
    # website.logo si la table existe. Usage : ./dev.sh set-logo <path>
    path="${1:?usage: ./dev.sh set-logo <chemin_vers_logo>}"
    if [ ! -f "$path" ]; then
      echo "✗ Fichier introuvable : $path" >&2
      exit 1
    fi
    # On copie le fichier dans le conteneur Odoo pour qu'il puisse le lire
    fname=$(basename "$path")
    docker compose cp "$path" "odoo:/tmp/${fname}"
    docker compose exec -T odoo odoo shell --no-http -d "$DB" <<PYEOF
import base64
with open('/tmp/${fname}', 'rb') as f:
    data = base64.b64encode(f.read())

# Logo de la société (utilisé partout par défaut)
company = env['res.company'].search([], limit=1)
company.logo = data
print(f"→ Logo société '{company.name}' mis à jour.")

# Logo du site web (override possible)
website = env['website'].search([], limit=1)
if website and 'logo' in website._fields:
    website.logo = data
    print(f"→ Logo du site '{website.name}' mis à jour.")

env.cr.commit()
PYEOF
    docker compose exec -T odoo rm -f "/tmp/${fname}"
    echo "→ Vider le cache navigateur (Cmd+Shift+R) pour voir le nouveau logo."
    ;;

  reset-home)
    # Vide la page d'accueil (garde le header/footer du site)
    docker compose exec -T odoo odoo shell --no-http -d "$DB" <<'PYEOF'
page = env['website.page'].search([('url', '=', '/')], limit=1)
if not page:
    print("→ Aucune page '/' trouvée.")
else:
    page.view_id.arch_db = '''<t name="Accueil" t-name="website.homepage"><t t-call="website.layout"><div id="wrap" class="oe_structure oe_empty"/></t></t>'''
    env.cr.commit()
    print("→ Page d'accueil vidée. Rafraîchis le navigateur.")
PYEOF
    ;;

  shell)
    # Ouvre un shell Odoo (REPL Python avec env Odoo)
    docker compose exec odoo odoo shell -d "$DB" --no-http
    ;;

  psql)
    docker compose exec db psql -U odoo -d "$DB"
    ;;

  # ---------- aide ----------
  help|*)
    cat <<EOF
Usage : ./dev.sh <commande> [args]

  État
    ls                       Liste les bases
    modules [pattern]        Modules installés (filtre optionnel)
    logs                     Logs Odoo en tail -f

  Modules
    install <mod>            Installe un module
    uninstall <mod>          Désinstalle proprement
    reload [mod]             Recharge le module (défaut: $MODULE)
    update-list              Met à jour la liste des apps

  Projet
    untheme                  Désinstalle tous les thèmes de démo
    set-logo <path>          Injecte un logo (res.company + website)
    reset-home               Vide la page d'accueil
    shell                    Shell Python Odoo
    psql                     Console PostgreSQL

Variable : DB=$DB (override : DB=autre ./dev.sh ...)
EOF
    ;;
esac
