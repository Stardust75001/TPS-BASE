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
```

---

## Aliases utiles

- `dev316` → va dans `/Users/asc/Shopify/TPS-BASE-316` + `git status -sb`
- `tmpok`  → va dans `/Users/asc/TPS-BASE-TEMP-OK` + `git status -sb`

---

## Scripts

- `autocommit.sh` : loop qui commit + push vers GitHub + Shopify toutes les 60s
- `start-watchers.sh` : lance les watchers sur DEV et TEMP-OK
- `stop-watchers.sh`  : stoppe tous les watchers actifs

---

## CI / QA

- `shopify theme dev` : serveur local
- `npm run qa`        : Theme Check + ESLint + Stylelint + Locales
- `npm run perf`      : Lighthouse CI

---

## Sécurité

- Ne commitez jamais `.env` → utilisez `.env.example`
- Faites rotate des tokens Shopify si exposés
