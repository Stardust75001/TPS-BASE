# TPS-BASE (Shopify theme)

## Environnements

- **DEV — TPS-BASE-316**
  - Branche active de développement (`dev-YYYYMMDD-HHMMSS`).
  - Watcher `autocommit.sh` → push GitHub + Shopify  
    THEME_ID (.env) = `187147125084`
  - Admin : https://admin.shopify.com/store/f6d72e-0f/themes/187272462684  
  - Preview : https://f6d72e-0f.myshopify.com/?preview_theme_id=187272462684

- **TEMP-OK — TPS-BASE-TEMP-OK**
  - Sandbox intermédiaire pour valider avant merge/push vers DEV ou LIVE.
  - Watcher `autocommit.sh` → push GitHub (`temp-ok`) + Shopify  
    THEME_ID (.env) = `187321811292`
  - Admin : https://admin.shopify.com/store/f6d72e-0f/themes/187321811292  
  - Preview : https://f6d72e-0f.myshopify.com/?preview_theme_id=187321811292

- **LIVE — TPS-BASE-LIVE**
  - Production  
  ⚠️ **Jamais de push direct !**  
  Déploiement uniquement via l’Admin Shopify → **Publish**.

---

## Fichiers `.env`

Chaque dossier de thème doit contenir son propre `.env` :

```bash
SHOPIFY_FLAG_STORE=f6d72e-0f.myshopify.com
THEME_ID=<ID_DU_THEME>
# (optionnel) si utilisé :
# SHOPIFY_CLI_THEME_TOKEN=xxxxxxxxxxxxxxxx
