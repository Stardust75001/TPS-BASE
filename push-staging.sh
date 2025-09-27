#!/bin/bash
set -e

# === Configuration ===
STORE="f6d72e-0f"              # ton store permanent (ne pas mettre le vanity domain)
THEME_ID="187147125084"        # ID du thème staging

# === Déploiement ===
echo "🚀 Pushing theme $THEME_ID to store $STORE..."
shopify theme push --store "$STORE" --theme "$THEME_ID" --force
echo "✅ Deploy done!"
