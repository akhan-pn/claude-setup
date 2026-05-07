#!/usr/bin/env bash
# refresh-wshobson.sh — pull the latest wshobson/agents from upstream into this repo.
# Use when wshobson publishes new/updated agents.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap "rm -rf $TMP" EXIT

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }

bold "Cloning upstream wshobson/agents to a temp dir"
git clone --depth 1 https://github.com/wshobson/agents "$TMP/agents"
ok "cloned"

bold "Replacing repo's vendored copy"
rm -rf "$REPO_DIR/opencode/agent/wshobson"
mkdir -p "$REPO_DIR/opencode/agent/wshobson"
# wshobson's repo lays the agents at the root as *.md files
cp "$TMP/agents"/*.md "$REPO_DIR/opencode/agent/wshobson/" 2>/dev/null || true
# Fallback: if upstream restructured, copy whatever .md files exist anywhere
if [[ -z "$(ls "$REPO_DIR/opencode/agent/wshobson"/*.md 2>/dev/null)" ]]; then
  find "$TMP/agents" -name '*.md' -not -path '*/.git/*' -exec cp {} "$REPO_DIR/opencode/agent/wshobson/" \;
fi
ok "vendored: $(ls "$REPO_DIR/opencode/agent/wshobson"/*.md 2>/dev/null | wc -l | tr -d ' ') agents"

echo
bold "Done. Review with: git -C $REPO_DIR diff opencode/agent/wshobson"
