#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
[ -f ".env" ] && set -a && . ./.env && set +a
mkdir -p .logs
echo "[$(date '+%F %T')] tick THEME_ID=${THEME_ID:-unset}" >> .logs/autocommit.log
git add -A || true
git commit -m "auto: $(date '+%F %T')" || true
git branch -M temp-ok 2>/dev/null || true
git push -u origin temp-ok || true
if command -v shopify >/dev/null; then
  shopify theme push --store "$SHOPIFY_FLAG_STORE" --theme "$THEME_ID" --nodelete \
    --ignore "node_modules/*" --ignore ".git/*" --ignore ".logs/*" || true
fi
sleep 60
exec "$0"
