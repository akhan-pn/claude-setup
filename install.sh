#!/usr/bin/env bash
# install.sh — bootstrap Claude Code / OpenCode / Codex setup on a new machine.
# Idempotent: backs up existing files before overwriting.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
info() { printf '  • %s\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }

backup_then_copy() {
  local src="$1" dst="$2"
  if [[ -e "$dst" ]]; then
    local bak="${dst}.backup-${TS}"
    cp -r "$dst" "$bak"
    info "backed up existing $dst → $bak"
  fi
  mkdir -p "$(dirname "$dst")"
  if [[ -d "$src" ]]; then
    rm -rf "$dst"
    cp -r "$src" "$dst"
  else
    cp "$src" "$dst"
  fi
  ok "installed $dst"
}

bold "Installing from $REPO_DIR"
echo

bold "1. Claude Code globals"
backup_then_copy "$REPO_DIR/claude/CLAUDE.md"        "$HOME/.claude/CLAUDE.md"
backup_then_copy "$REPO_DIR/claude/settings.json"    "$HOME/.claude/settings.json"
backup_then_copy "$REPO_DIR/claude/skills/graphify"  "$HOME/.claude/skills/graphify"
echo

bold "2. OpenCode agents (user-global)"
backup_then_copy "$REPO_DIR/opencode/agent/wshobson" "$HOME/.config/opencode/agent/wshobson"
echo

bold "3. Codex globals"
if [[ -f "$REPO_DIR/codex/AGENTS.md" ]]; then
  backup_then_copy "$REPO_DIR/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
fi
echo

bold "Install complete."
echo
bold "Manual steps still needed:"
cat <<'EOM'
  1. Auth:
       claude  →  /login
       codex   →  codex auth login   (or whichever your CLI uses)
  2. Plugins (see claude/installed_plugins.json for the list):
       claude  →  /plugins  (install each marketplace + plugin shown)
  3. MCP servers (Linear / Slack / Figma / etc.):
       claude  →  /mcp  (re-authenticate each you use)
  4. Local-only overrides go in ~/.claude/settings.local.json — not tracked in this repo.
  5. Project-specific memory rebuilds itself as you work; no action needed.
EOM
