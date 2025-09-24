#!/bin/zsh
set -euo pipefail

# ========= Config par défaut =========
DEFAULT_THEME_ID="187147125084"   # ton thème de préprod existant
DEFAULT_START_PORT=9292

# ========= Helpers =========
require_bin() { command -v "$1" >/dev/null 2>&1 || { echo "❌ Binaire manquant: $1"; exit 1; }; }

free_port() {
  local p="$DEFAULT_START_PORT"
  while lsof -i ":$p" >/dev/null 2>&1; do p=$((p+1)); done
  echo "$p"
}

load_env() {
  [[ -f .env ]] || { echo "❌ .env manquant (ajoute SHOPIFY_FLAG_STORE et SHOPIFY_CLI_THEME_TOKEN)"; exit 1; }
  set -a
  source .env
  set +a
  : ${SHOPIFY_FLAG_STORE:?"❌ SHOPIFY_FLAG_STORE manquant dans .env"}
  : ${SHOPIFY_CLI_THEME_TOKEN:?"❌ SHOPIFY_CLI_THEME_TOKEN manquant dans .env"}
}

resolve_theme_id() {
  local arg="${1:-$DEFAULT_THEME_ID}"
  if [[ "$arg" =~ ^[0-9]+$ ]]; then
    echo "$arg"
  else
    require_bin jq
    local id
    id="$(shopify theme list --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --json \
      | jq -r --arg NAME "$arg" '.[] | select(.name==$NAME and .role!="live") | .id' | tail -n1)"
    [[ -n "$id" && "$id" != "null" ]] || { echo "❌ Thème '$arg' introuvable (non publié)."; exit 1; }
    echo "$id"
  fi
}

preview_url() {
  echo "https://${SHOPIFY_FLAG_STORE}/?preview_theme_id=${1}"
}

# ========= Actions =========
do_dev() {
  load_env
  require_bin shopify
  local port; port="$(free_port)"
  echo "🧩 Dev local sur $SHOPIFY_FLAG_STORE (port $port)…"
  shopify theme dev --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --port "$port"
}

do_deploy() {
  load_env
  require_bin shopify
  local id; id="$(resolve_theme_id "${1:-$DEFAULT_THEME_ID}")"
  echo "🚀 Push vers thème $id…"
  shopify theme push --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --theme "$id"
  local url; url="$(preview_url "$id")"
  echo "🔗 Preview: $url"
  (command -v open >/dev/null && open "$url") || true
}

do_dev_deploy() {
  load_env
  require_bin shopify
  local id; id="$(resolve_theme_id "${1:-$DEFAULT_THEME_ID}")"
  local port; port="$(free_port)"

  echo "🧩 Dev local (port $port)…"
  ( shopify theme dev --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --port "$port" ) &
  local dev_pid=$!
  sleep 2

  echo "🚀 Push vers thème $id…"
  shopify theme push --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --theme "$id"

  local url; url="$(preview_url "$id")"
  echo "🔗 Preview: $url"
  (command -v open >/dev/null && open "$url") || true

  echo "ℹ️ Dev tourne (pid: $dev_pid). Ctrl+C pour arrêter."
  wait $dev_pid
}

do_preview() {
  load_env
  require_bin shopify
  require_bin jq
  local id
  id="$(shopify theme list --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --json \
    | jq -r '[.[] | select(.role == "unpublished")] | last | .id')"
  [[ -n "$id" && "$id" != "null" ]] || { echo "❌ Aucun thème non publié trouvé."; exit 1; }
  local url; url="$(preview_url "$id")"
  echo "🔗 Preview: $url"
  (command -v open >/dev/null && open "$url") || true
}

do_publish() {
  load_env
  require_bin shopify
  local id; id="$(resolve_theme_id "${1:-$DEFAULT_THEME_ID}")"
  read "?⚠️ Publier le thème $id en LIVE ? (oui/non) " ans
  [[ "${ans:-}" == "oui" ]] || { echo "⏭️  Annulé."; exit 0; }
  shopify theme publish --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --theme "$id"
  echo "✅ Publié: https://${SHOPIFY_FLAG_STORE}"
}

do_qa() {
  load_env
  echo "�� QA…"
  if command -v theme-check >/dev/null 2>&1; then
    theme-check || { echo "❌ Theme Check a détecté des erreurs."; exit 1; }
  else
    echo "• Theme Check non installé (npm i -D @shopify/theme-check)."
  fi
  if command -v eslint >/dev/null 2>&1; then
    eslint "assets/**/*.js" --max-warnings=0 || { echo "❌ ESLint KO."; exit 1; }
  else
    echo "• ESLint non installé (npm i -D eslint)."
  fi
  if command -v stylelint >/dev/null 2>&1; then
    stylelint "**/*.{css,scss}" || { echo "❌ Stylelint KO."; exit 1; }
  else
    echo "• Stylelint non installé (npm i -D stylelint)."
  fi
  if npx -y @lhci/cli --help >/dev/null 2>&1; then
    echo "• Lighthouse CI…"
    npx -y @lhci/cli autorun || echo "⚠️ Lighthouse a des alertes (consulte le rapport)."
  else
    echo "• Lighthouse CI non configuré (npm i -D @lhci/cli)."
  fi
  echo "✅ QA terminée."
}

# ========= Router =========
case "${1:-}" in
  dev)           shift; do_dev "$@";;
  deploy)        shift; do_deploy "$@";;
  dev+deploy)    shift; do_dev_deploy "$@";;
  preview)       shift; do_preview "$@";;
  publish)       shift; do_publish "$@";;
  qa)            shift; do_qa "$@";;
  *)
    cat <<USAGE
Usage:
  ./tps-workflow.sh dev                 # dev local (port auto libre)
  ./tps-workflow.sh deploy [ID|NOM]     # push vers thème (ID ou nom). Défaut: $DEFAULT_THEME_ID
  ./tps-workflow.sh dev+deploy [ID|NOM] # dev en fond + push + ouverture preview
  ./tps-workflow.sh preview             # ouvre le dernier thème non publié
  ./tps-workflow.sh publish [ID|NOM]    # publier en LIVE (confirmation)
  ./tps-workflow.sh qa                  # QA (Theme Check + ESLint + Stylelint + Lighthouse si dispo)
USAGE
    exit 1;;
esac
