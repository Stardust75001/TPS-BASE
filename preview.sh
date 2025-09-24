#!/bin/zsh
set -euo pipefail

[[ -f .env ]] || { echo "❌ .env manquant"; exit 1; }
set -a; source .env; set +a
: ${SHOPIFY_FLAG_STORE:?"❌ SHOPIFY_FLAG_STORE manquant"}
: ${SHOPIFY_CLI_THEME_TOKEN:?"❌ SHOPIFY_CLI_THEME_TOKEN manquant"}

require() { command -v "$1" >/dev/null 2>&1 || { echo "❌ Manque: $1"; exit 1; }; }
require shopify
require jq

THEME_ID="$(shopify theme list --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --json \
  | jq -r '[.[] | select(.role=="unpublished")] | last | .id')"

[[ -n "$THEME_ID" && "$THEME_ID" != "null" ]] || { echo "❌ Aucun thème non publié trouvé."; exit 1; }

URL="https://${SHOPIFY_FLAG_STORE}/?preview_theme_id=${THEME_ID}"
echo "🔗 Preview: $URL"
(command -v open >/dev/null && open "$URL") || true
