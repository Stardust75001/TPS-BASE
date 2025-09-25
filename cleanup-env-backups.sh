#!/usr/bin/env bash
set -euo pipefail

# cleanup-env-backups.sh
# Safely remove local .env backup files without tripping over shell globs.
#
# Patterns removed (files only):
#   .env.save, .env.bak, .env.*.bak, .env.*.save
#
# Usage:
#   ./cleanup-env-backups.sh [options] [path]
#
# Options:
#   -n, --dry-run     List matches only, do not delete
#   -y, --yes         Do not prompt for confirmation
#   -r, --recursive   Scan subdirectories too (default: current dir only)
#   -q, --quiet       Reduce output
#   -h, --help        Show this help
#
# Examples:
#   ./cleanup-env-backups.sh -n           # see what would be removed
#   ./cleanup-env-backups.sh -y           # delete in current folder (no prompt)
#   ./cleanup-env-backups.sh -r -n ..     # dry-run from parent, recursively

DRY_RUN=0
YES=0
RECURSIVE=0
QUIET=0
TARGET_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)   DRY_RUN=1; shift;;
    -y|--yes)       YES=1; shift;;
    -r|--recursive) RECURSIVE=1; shift;;
    -q|--quiet)     QUIET=1; shift;;
    -h|--help)
      sed -n '1,40p' "$0" | sed -n '1,40p' | awk 'NR==1, /Examples:/{print}'; exit 0;
      ;;
    *)
      TARGET_DIR="$1"; shift;;
  esac
done

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "❌ Not a directory: $TARGET_DIR" >&2
  exit 1
fi

# Build find expression
DEPTH_OPTS=( )
if [[ "$RECURSIVE" -eq 0 ]]; then
  DEPTH_OPTS=( -maxdepth 1 )
fi

readarray_supported=0
if command -v readarray >/dev/null 2>&1; then readarray_supported=1; fi

files=()
if (( readarray_supported )); then
  # Bash >=4 supports readarray -d ''
  while IFS= read -r -d '' f; do files+=("$f"); done < <(
    find "$TARGET_DIR" "${DEPTH_OPTS[@]}" -type f \
      \( -name '.env.save' -o -name '.env.bak' -o -name '.env.*.bak' -o -name '.env.*.save' \) \
      -print0
  )
else
  # macOS bash 3.x: use while+process substitution (still works) with -d ''
  while IFS= read -r -d '' f; do files+=("$f"); done < <(
    find "$TARGET_DIR" "${DEPTH_OPTS[@]}" -type f \
      \( -name '.env.save' -o -name '.env.bak' -o -name '.env.*.bak' -o -name '.env.*.save' \) \
      -print0
  )
fi

count=${#files[@]}
if [[ "$count" -eq 0 ]]; then
  [[ "$QUIET" -eq 1 ]] || echo "No .env backup files found in $TARGET_DIR"
  exit 0
fi

[[ "$QUIET" -eq 1 ]] || {
  echo "Found $count .env backup file(s):"
  printf '  %s\n' "${files[@]}"
}

if [[ "$DRY_RUN" -eq 1 ]]; then
  [[ "$QUIET" -eq 1 ]] || echo "Dry-run: nothing deleted."
  exit 0
fi

if [[ "$YES" -ne 1 ]]; then
  echo -n "Delete these $count file(s)? [y/N] "
  read -r ans
  case "${ans:-}" in
    y|Y|yes|YES) :;;
    *) echo "Aborted."; exit 0;;
  esac
fi

# Delete safely with null-delimited list
printf '%s\0' "${files[@]}" | xargs -0 rm -f --
[[ "$QUIET" -eq 1 ]] || echo "Removed $count file(s)."
