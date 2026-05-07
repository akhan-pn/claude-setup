#!/usr/bin/env bash
# pull-from-system.sh — sync changes from your live ~/.claude, ~/.config/opencode, ~/.codex BACK INTO this repo.
# Run after you've tweaked agents / skills / settings on this machine and want to commit them.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }

bold "Pulling current system state into $REPO_DIR"
echo

if [[ -f "$HOME/.claude/CLAUDE.md" ]]; then
  cp "$HOME/.claude/CLAUDE.md" "$REPO_DIR/claude/CLAUDE.md"
  ok "claude/CLAUDE.md"
fi

if [[ -f "$HOME/.claude/settings.json" ]]; then
  # Re-sanitize: strip absolute paths to ~/Desktop/devstuff (project-specific Bash allow rules)
  python3 - "$HOME/.claude/settings.json" "$REPO_DIR/claude/settings.json" <<'PY'
import json, sys
src, dst = sys.argv[1], sys.argv[2]
d = json.load(open(src))
allow = d.get("permissions", {}).get("allow", [])
filtered = [r for r in allow if "pnow-ats-v2" not in r and "/Desktop/devstuff/" not in r]
d["permissions"]["allow"] = filtered
with open(dst, "w") as f:
    json.dump(d, f, indent=2)
print(f"  sanitized: {len(allow)} → {len(filtered)} allow rules")
PY
  ok "claude/settings.json (sanitized)"
fi

if [[ -d "$HOME/.claude/skills/graphify" ]]; then
  rm -rf "$REPO_DIR/claude/skills/graphify"
  cp -r "$HOME/.claude/skills/graphify" "$REPO_DIR/claude/skills/graphify"
  ok "claude/skills/graphify"
fi

if [[ -f "$HOME/.claude/plugins/installed_plugins.json" ]]; then
  cp "$HOME/.claude/plugins/installed_plugins.json" "$REPO_DIR/claude/installed_plugins.json"
  ok "claude/installed_plugins.json"
fi

if [[ -d "$HOME/.config/opencode/agent/wshobson" ]]; then
  rm -rf "$REPO_DIR/opencode/agent/wshobson"
  cp -r "$HOME/.config/opencode/agent/wshobson" "$REPO_DIR/opencode/agent/wshobson"
  ok "opencode/agent/wshobson ($(ls "$REPO_DIR/opencode/agent/wshobson" | wc -l | tr -d ' ') agents)"
fi

if [[ -f "$HOME/.codex/AGENTS.md" ]]; then
  cp "$HOME/.codex/AGENTS.md" "$REPO_DIR/codex/AGENTS.md"
  ok "codex/AGENTS.md"
fi

echo
bold "Done. Review with: git -C $REPO_DIR status && git -C $REPO_DIR diff"
