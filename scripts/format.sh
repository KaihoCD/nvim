#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

STYLUA_BIN=""

if command -v stylua >/dev/null 2>&1; then
  STYLUA_BIN="$(command -v stylua)"
elif [[ -x "$HOME/.local/share/nvim/mason/bin/stylua" ]]; then
  STYLUA_BIN="$HOME/.local/share/nvim/mason/bin/stylua"
fi

if [[ -z "$STYLUA_BIN" ]]; then
  echo "Error: stylua is required but not found." >&2
  echo "Install it with one of the following:" >&2
  echo "  1) Mason: :MasonInstall stylua" >&2
  echo "  2) Homebrew: brew install stylua" >&2
  exit 1
fi

# Format all Lua files in the config.
LUA_FILES=()
while IFS= read -r -d '' file; do
  LUA_FILES+=("$file")
done < <(find "$ROOT_DIR" -type f -name "*.lua" -not -path "*/.git/*" -print0)

if [[ ${#LUA_FILES[@]} -gt 0 ]]; then
  "$STYLUA_BIN" --search-parent-directories "${LUA_FILES[@]}"
  echo "Formatted ${#LUA_FILES[@]} Lua files with stylua ($STYLUA_BIN)."
else
  echo "No Lua files found to format."
fi

LOCK_FILE="$ROOT_DIR/nvim-pack-lock.json"
if [[ -f "$LOCK_FILE" ]]; then
  if command -v prettier >/dev/null 2>&1; then
    prettier --write "$LOCK_FILE" >/dev/null
    echo "Formatted nvim-pack-lock.json with prettier."
  elif command -v jq >/dev/null 2>&1; then
    TMP_FILE="${LOCK_FILE}.tmp"
    jq . "$LOCK_FILE" >"$TMP_FILE"
    mv "$TMP_FILE" "$LOCK_FILE"
    echo "Formatted nvim-pack-lock.json with jq."
  else
    echo "Skipped JSON formatting: install prettier or jq to format nvim-pack-lock.json."
  fi
fi

echo "Done."
