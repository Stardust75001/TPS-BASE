#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

[ -f ".env" ] && set -a && . ./.env && set +a

mkdir -p .logs
echo "[$(date '+%F %T')] autocommit lancé dans $(pwd) THEME_ID=${THEME_ID:-unset}" >> .logs/autocommit.log

while true; do
  {
    echo "[$(date '+%F %T')] tick THEME_ID=${THEME_ID:-unset}"

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      git add -A || true
      git commit -m "auto: $(date '+%F %T')" || true
      BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo temp-ok)"
      [ -n "$BRANCH" ] || BRANCH="temp-ok"
      git push -u origin "$BRANCH" || true
    else
      echo "git: pas un repo, skip"
    fi

    if command -v shopify >/dev/null 2>&1 && [ -n "${SHOPIFY_FLAG_STORE:-}" ] && [ -n "${THEME_ID:-}" ]; then
      shopify theme push \
        --store "$SHOPIFY_FLAG_STORE" \
        --theme "$THEME_ID" \
        --nodelete \
        --ignore "node_modules/*" \
        --ignore ".git/*" \
        --ignore ".logs/*" \
        --json >/dev/null 2>&1 || true
    fi
  } >> .logs/autocommit.log 2>&1

  sleep 60
done
