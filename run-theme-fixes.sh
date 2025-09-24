#!/bin/zsh
set -euo pipefail
setopt interactivecomments

echo "🔧 Préparation…"
# 1) Theme Check (Ruby) — installe si absent
if ! command -v theme-check >/dev/null 2>&1; then
  if command -v gem >/dev/null 2>&1; then
    echo "👉 Installation de theme-check (gem)…"
    gem install theme-check --no-document
  else
    echo "❌ RubyGems (gem) introuvable. Installe Ruby (ou 'brew install ruby') puis relance."
    exit 1
  fi
fi

# 2) Auto-fix Theme Check (le binaire Ruby)
echo "🧹 theme-check --fix (auto-correction maximale)…"
theme-check --fix || true
echo "🔎 theme-check -a (rapport)…"
theme-check -a || true

# 3) Dépréciations img_url → image_url
echo "�� Remplacement du filtre déprécié img_url → image_url…"
find sections templates snippets -type f -name '*.liquid' -print0 \
| xargs -0 sed -i '' -E 's/\|\s*img_url\s*:/| image_url: /g'

# 4) Crée un template article minimal si manquant
if [ ! -f templates/article.json ]; then
  echo "📝 Création templates/article.json (minimal)…"
  mkdir -p templates
  cat > templates/article.json <<'JSON'
{
  "name": "Article",
  "sections": {
    "main": { "type": "article-template", "settings": {} }
  },
  "order": ["main"]
}
JSON
fi

echo "✅ Fini. Relance:
  theme-check -a
ou
  shopify theme check
pour voir le nouveau rapport."
