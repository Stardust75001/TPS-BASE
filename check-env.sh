#!/bin/zsh
set -euo pipefail

# Charger .env
set -a
source .env
set +a

echo "🔍 Vérification des variables :"
echo "STORE=$SHOPIFY_FLAG_STORE"
if [[ -n "${SHOPIFY_CLI_THEME_TOKEN:-}" ]]; then
  echo "TOKEN=***OK***"
else
  echo "TOKEN=ABSENT"
fi
echo "DEFAULT_THEME_ID=${DEFAULT_THEME_ID:-non défini}"
echo "DEFAULT_START_PORT=${DEFAULT_START_PORT:-non défini}"

echo ""
echo "🌐 Test connexion Shopify…"
if command -v shopify >/dev/null 2>&1; then
  shopify theme list --store "$SHOPIFY_FLAG_STORE" --password "$SHOPIFY_CLI_THEME_TOKEN" --json | jq -r '.[].name' || {
    echo "❌ Erreur : impossible d’interroger Shopify"
    exit 1
  }
  echo "✅ Connexion Shopify OK"
else
  echo "❌ Shopify CLI non trouvé (installe-le d’abord)"
  exit 1
fi
