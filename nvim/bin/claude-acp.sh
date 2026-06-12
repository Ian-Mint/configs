#!/usr/bin/env bash
#
# Wrapper around `claude-agent-acp` (the Zed ACP bridge for Claude Code) used by
# CodeCompanion in Neovim.
#
# Why this exists:
#   The Agent SDK bundled in claude-agent-acp only accepts the permission modes
#   default/acceptEdits/dontAsk/plan/bypassPermissions. If ~/.claude/settings.json
#   sets `permissions.defaultMode` to anything else (e.g. "auto", a newer CLI
#   feature), session/new fails with "Invalid permissions.defaultMode" and the
#   chat reports "Failed to create session".
#
#   To avoid changing the real ~/.claude/settings.json (which the `claude` CLI
#   relies on), this script builds a private config dir that mirrors ~/.claude
#   via symlinks but with a sanitized settings.json, and points the bridge at it
#   through CLAUDE_CONFIG_DIR. Auth (~/.claude/.credentials.json), plugins, etc.
#   are all inherited via the symlinks, so the subscription login keeps working.
#
set -euo pipefail

SRC="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
DEST="${XDG_CACHE_HOME:-$HOME/.cache}/claude-agent-acp/config"

# Rebuild the mirror from scratch on every launch so it never goes stale.
rm -rf "$DEST"
mkdir -p "$DEST"

shopt -s dotglob nullglob
for f in "$SRC"/*; do
  base="$(basename "$f")"
  [ "$base" = "settings.json" ] && continue
  ln -sfn "$f" "$DEST/$base"
done
shopt -u dotglob nullglob

# Sanitize settings.json: copy it verbatim, but rewrite an unsupported
# permissions.defaultMode to a value the bridge's SDK accepts.
if [ -f "$SRC/settings.json" ]; then
  python3 - "$SRC/settings.json" "$DEST/settings.json" <<'PY'
import json, sys
src, dest = sys.argv[1], sys.argv[2]
try:
    with open(src) as fh:
        s = json.load(fh)
except Exception:
    s = {}
VALID = {"default", "acceptedits", "dontask", "plan", "bypasspermissions", "bypass"}
perms = s.get("permissions")
if isinstance(perms, dict):
    mode = perms.get("defaultMode")
    if not isinstance(mode, str) or mode.strip().lower() not in VALID:
        perms["defaultMode"] = "default"
with open(dest, "w") as fh:
    json.dump(s, fh, indent=2)
PY
else
  printf '{}\n' > "$DEST/settings.json"
fi

# Sanitize auth env before launching the bridge.
#
# CodeCompanion's adapter env resolution (is_env_var) treats an env entry whose
# named variable is *unset* as a literal string: it ends up exporting
# CLAUDE_CODE_OAUTH_TOKEN="CLAUDE_CODE_OAUTH_TOKEN" (the var name itself) into
# the child process. The bridge then sends that as a bearer token and the API
# rejects it with "401 Invalid bearer token". Drop any such bogus value so the
# SDK falls back to the subscription OAuth creds in ~/.claude/.credentials.json.
case "${CLAUDE_CODE_OAUTH_TOKEN:-}" in
  "" | "CLAUDE_CODE_OAUTH_TOKEN") unset CLAUDE_CODE_OAUTH_TOKEN ;;
  sk-ant-*) : ;;                       # a genuine token: keep it
  *) unset CLAUDE_CODE_OAUTH_TOKEN ;;  # anything else is not a real token
esac

# We want subscription/OAuth auth, never an API key. Drop any API key so the
# SDK can't silently switch to per-token API billing.
unset ANTHROPIC_API_KEY

export CLAUDE_CONFIG_DIR="$DEST"

# Locate the real bridge. Prefer PATH; fall back to common nvm/global locations
# in case Neovim was launched without the nvm bin on PATH.
BRIDGE="$(command -v claude-agent-acp 2>/dev/null || true)"
if [ -z "$BRIDGE" ]; then
  for cand in \
    "$HOME"/.local/share/nvm/*/bin/claude-agent-acp \
    "$HOME"/.npm-global/bin/claude-agent-acp \
    /usr/local/bin/claude-agent-acp; do
    if [ -x "$cand" ]; then BRIDGE="$cand"; break; fi
  done
fi
if [ -z "$BRIDGE" ]; then
  echo "claude-acp.sh: cannot find claude-agent-acp on PATH" >&2
  exit 127
fi

exec "$BRIDGE" "$@"
