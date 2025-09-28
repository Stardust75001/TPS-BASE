#!/usr/bin/env bash
set -euo pipefail

# se placer dans le dossier du script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# charger .env local si présent
[ -f ".env" ] && set -a && . ./.env && set +a

# lock portable (macOS-friendly)
if ! mkdir .autocommit.lockdir 2>/dev/null; then
  echo "déjà lancé"; exit 0
fi
trap 'rmdir .autocommit.lockdir' EXIT

# logs
mkdir -p .logs
LOG=".logs/autocommit.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] autocommit lancé dans $(pwd) THEME_ID=${THEME_ID:-unset}" >> "$LOG"

while true; do
  {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] tick THEME_ID=${THEME_ID:-unset}"

    # Git (silencieux si pas un repo)
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      git add -A || true
      git commit -m "auto: $(date '+%F %T')" || true
      BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo temp-ok)"
      [ -n "$BRANCH" ] || BRANCH="temp-ok"
      git push -u origin "$BRANCH" || true
    else
      echo "git: pas un repo, skip"
    fi

    # Shopify (silencieux si CLI absente)
    if command -v shopify >/dev/null 2>&1 \
       && [ -n "${SHOPIFY_FLAG_STORE:-}" ] && [ -n "${THEME_ID:-}" ]; then
      shopify theme push \
        --store "$SHOPIFY_FLAG_STORE" \
        --theme "$THEME_ID" \
        --nodelete \
        --ignore "node_modules/*" \
        --ignore ".git/*" \
        --ignore ".logs/*" \
        --json >/dev/null 2>&1 || true
    fi
  } >> "$LOG" 2>&1
  sleep 60
done
