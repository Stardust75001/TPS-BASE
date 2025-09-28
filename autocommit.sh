# se placer dans le dossier du script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# charger le .env local s'il existe
[ -f ".env" ] && set -a && . ./.env && set +a

# log de contrôle
mkdir -p .logs
echo "[$(date '+%Y-%m-%d %H:%M:%S')] autocommit lancé dans $(pwd) THEME_ID=${THEME_ID:-unset}" >> .logs/autocommit.log
