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
    # Désinstalle un module proprement via odoo-bin
    mod="${1:?usage: ./dev.sh uninstall <module>}"
    docker compose exec -T odoo odoo --no-http --stop-after-init \
      -d "$DB" --uninstall "$mod"
    docker compose restart odoo
    echo "→ ${mod} désinstallé."
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
    # Désinstalle tous les thèmes de démo (sauf le nôtre)
    themes=$(docker compose exec -T db psql -U odoo -d "$DB" -tA -c \
      "SELECT name FROM ir_module_module WHERE state='installed' AND name LIKE 'theme_%';")
    if [ -z "$themes" ]; then
      echo "Aucun thème de démo installé."
      exit 0
    fi
    for t in $themes; do
      echo "→ Désinstallation de $t"
      docker compose exec -T odoo odoo --no-http --stop-after-init \
        -d "$DB" --uninstall "$t"
    done
    docker compose restart odoo
    echo "→ Thèmes de démo supprimés."
    ;;

  reset-home)
    # Vide la page d'accueil (garde le menu/header/footer du site)
    docker compose exec -T db psql -U odoo -d "$DB" -c \
      "UPDATE website_page SET arch_db = '<t name=\"Accueil\" t-name=\"website.homepage\"><t t-call=\"website.layout\"><div id=\"wrap\" class=\"oe_structure oe_empty\"/></t></t>' WHERE url='/';"
    echo "→ Page d'accueil vidée. Rafraîchis le navigateur."
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
    reset-home               Vide la page d'accueil
    shell                    Shell Python Odoo
    psql                     Console PostgreSQL

Variable : DB=$DB (override : DB=autre ./dev.sh ...)
EOF
    ;;
esac
