# TPS-BASE (Shopify theme)

## Environnements

- **DEV — TPS-BASE-316**
  - Branche active de développement (`dev-YYYYMMDD-HHMMSS`).
  - Watcher `autocommit.sh` → push GitHub + Shopify  
    THEME_ID = `187147125084`

- **TEMP-OK — TPS-BASE-TEMP-OK**
  - Sandbox intermédiaire pour valider avant merge/push vers DEV ou LIVE.
  - Watcher `autocommit.sh` → push GitHub (`temp-ok`) + Shopify  
    THEME_ID = `187321811292`

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
👉 Ça écrase ton `README.md` avec la version propre.  
Ensuite, tu peux vérifier :  

```bash
head -20 README.md
cat > README.md <<'EOF'
# TPS-BASE (Shopify theme)

## Environnements

- **DEV — TPS-BASE-316**
  - Branche active de développement (`dev-YYYYMMDD-HHMMSS`).
  - Watcher `autocommit.sh` → push GitHub + Shopify  
    THEME_ID = `187147125084`

- **TEMP-OK — TPS-BASE-TEMP-OK**
  - Sandbox intermédiaire pour valider avant merge/push vers DEV ou LIVE.
  - Watcher `autocommit.sh` → push GitHub (`temp-ok`) + Shopify  
    THEME_ID = `187321811292`

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
