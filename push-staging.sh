#!/bin/zsh
# Déploiement staging Shopify + ouverture auto dans le navigateur

# Variables
STORE="f6d72e-0f"
THEME_ID="187147125084"

echo "🚀 Push du thème $THEME_ID vers la boutique $STORE..."
shopify theme push --store "$STORE" --theme "$THEME_ID" --force

if [ $? -eq 0 ]; then
  echo "✅ Push réussi ! Ouverture de la preview..."
  open "https://$STORE.myshopify.com/?preview_theme_id=$THEME_ID"
else
  echo "❌ Erreur pendant le push, pas d'ouverture de preview."
fi
