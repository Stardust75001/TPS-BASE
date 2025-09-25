#!/bin/zsh
set -euo pipefail

# ===============================
# Shopify Dev + Preprod Deployer
# ===============================

# 0) Charger .env si présent (prioritaire)
if [[ -f .env ]]; then
  export $(grep -v '^#' .env | xargs)
fi

# 1) Variables par défaut (fallback si pas dans .env)
: ${SHOPIFY_FLAG_STORE:="f6d72e-0f.myshopify.com"}
# Require a Theme Access token to be provided via .env or environment; do not default to a real-looking value
if [[ -z "${SHOPIFY_CLI_THEME_TOKEN:-}" ]]; then
  echo "❌ SHOPIFY_CLI_THEME_TOKEN is not set. Add it to .env or export it in your shell."
  echo "   Example (.env): SHOPIFY_CLI_THEME_TOKEN=shptka_XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  exit 1
fi

# 2) Petites fonctions utilitaires
preview_url() {
  local theme_id="$1"
  echo "https://${SHOPIFY_FLAG_STORE}/?preview_theme_id=${theme_id}"
}

deploy_unpublished() {
  local name="tps-base-$(date +%Y%m%d-%H%M)"
  echo "🚀 Push vers un thème NON publié: ${name}"
  # Essaye JSON + jq pour récupérer l'ID ; fallback en texte sinon
  if command -v jq >/dev/null 2>&1; then
    local id
    id=$(shopify theme push --unpublished --name "${name}" --json | jq -r '.id')
    echo "✅ Thème créé: ${id}"
    echo "🔗 Preview: $(preview_url "${id}")"
  else
    echo "ℹ️ jq non trouvé, push sans extraction d'ID…"
    shopify theme push --unpublished --name "${name}"
    echo "👉 Va dans l’Admin pour récupérer l’ID si besoin."
  fi
}

# 3) Menu simple
case "${1:-dev}" in
  dev)
    echo "🧩 Lancement DEV sur ${SHOPIFY_FLAG_STORE}…"
    shopify theme dev --store "${SHOPIFY_FLAG_STORE}"
    ;;
  deploy)
    echo "🧪 Déploiement préprod (non publié) sur ${SHOPIFY_FLAG_STORE}…"
    deploy_unpublished
    ;;
  dev+deploy)
    echo "🧩 DEV puis 🧪 PREPROD…"
    shopify theme dev --store "${SHOPIFY_FLAG_STORE}" &
    DEV_PID=$!
    sleep 3
    deploy_unpublished
    echo "ℹ️ Dev tourne en arrière-plan (pid: ${DEV_PID}). Ctrl+C pour arrêter."
    wait ${DEV_PID}
    ;;
  *)
    echo "Usage: $0 [dev|deploy|dev+deploy]"
    exit 1
    ;;
esac
