#!/bin/zsh
set -euo pipefail

# 0) S’assurer que le workflow est exécutable
chmod +x ./tps-workflow.sh

# 1) Créer un package.json minimal si besoin
[ -f package.json ] || npm init -y -y

# 2) Ajouter/mettre à jour les scripts npm (via jq si dispo, sinon fallback Node)
if command -v jq >/dev/null 2>&1; then
  tmpfile="$(mktemp)"
  jq '.scripts += {
    "dev": "zsh ./tps-workflow.sh dev",
    "deploy": "zsh ./tps-workflow.sh deploy",
    "dev:deploy": "zsh ./tps-workflow.sh dev+deploy",
    "preview": "zsh ./tps-workflow.sh preview",
    "publish": "zsh ./tps-workflow.sh publish",
    "qa": "zsh ./tps-workflow.sh qa",
    "pull": "shopify theme pull --store $SHOPIFY_FLAG_STORE --password $SHOPIFY_CLI_THEME_TOKEN",
    "theme:check": "theme-check",
    "full:ci": "npm run qa && npm run deploy && npm run preview",
    "full:ci:live": "npm run qa && npm run deploy && printf \"oui\\n\" | zsh ./tps-workflow.sh publish"
  }' package.json > "$tmpfile" && mv "$tmpfile" package.json
else
  node -e '
    const fs=require("fs");
    const p=JSON.parse(fs.readFileSync("package.json","utf8"));
    p.scripts = Object.assign({}, p.scripts, {
      dev: "zsh ./tps-workflow.sh dev",
      deploy: "zsh ./tps-workflow.sh deploy",
      "dev:deploy": "zsh ./tps-workflow.sh dev+deploy",
      preview: "zsh ./tps-workflow.sh preview",
      publish: "zsh ./tps-workflow.sh publish",
      qa: "zsh ./tps-workflow.sh qa",
      pull: "shopify theme pull --store $SHOPIFY_FLAG_STORE --password $SHOPIFY_CLI_THEME_TOKEN",
      "theme:check": "theme-check",
      "full:ci": "npm run qa && npm run deploy && npm run preview",
      "full:ci:live": "npm run qa && npm run deploy && printf \"oui\\n\" | zsh ./tps-workflow.sh publish"
    });
    fs.writeFileSync("package.json", JSON.stringify(p,null,2));
  '
fi

echo "✅ Scripts npm ajoutés/mis à jour :
  npm run dev
  npm run deploy
  npm run dev:deploy
  npm run preview
  npm run publish
  npm run qa
  npm run pull
  npm run theme:check
  npm run full:ci
  npm run full:ci:live"
