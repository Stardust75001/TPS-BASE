#!/bin/zsh
set -euo pipefail

[[ -f .env ]] || { echo "❌ .env manquant"; exit 1; }
set -a; source .env; set +a
: ${SHOPIFY_FLAG_STORE:?"❌ SHOPIFY_FLAG_STORE manquant"}
: ${SHOPIFY_CLI_THEME_TOKEN:?"❌ SHOPIFY_CLI_THEME_TOKEN manquant"}

ARG="${1:-}"
[[ -n "$ARG" ]] || { echo "Usage: ./deploy-to.sh <THEME_ID|NOM_DE_THEME>"; exit 1; }

require() { command -v "$1" >/dev/null 2>&1 || { echo "❌ Manque: $1"; exit 1; }; }
require shopify

resolve_id() {
  local arg="$1"
  if [[ "$arg" =~ ^[0-9]+$ ]]; then
    echo "$arg"
  else
    require jq
    shopify theme list --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --json \
      | jq -r --arg NAME "$arg" '.[] | select(.name==$NAME and .role!="live") | .id' | tail -n1
  fi
}

THEME_ID="$(resolve_id "$ARG")"
[[ -n "$THEME_ID" && "$THEME_ID" != "null" ]] || { echo "❌ Thème '$ARG' introuvable."; exit 1; }

echo "🚀 Push vers thème $THEME_ID…"
shopify theme push --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --theme "$THEME_ID"

URL="https://${SHOPIFY_FLAG_STORE}/?preview_theme_id=${THEME_ID}"
echo "🔗 Preview: $URL"
(command -v open >/dev/null && open "$URL") || true
