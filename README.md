# claude-setup

My personal Claude Code / OpenCode / Codex setup, packaged so I can bootstrap a new machine in one command.

## What's in this repo

| Path | Goes to | What |
|---|---|---|
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global Claude Code instructions |
| `claude/settings.json` | `~/.claude/settings.json` | Claude Code settings (sanitized — project-specific allow rules stripped) |
| `claude/installed_plugins.json` | reference | List of plugins to reinstall via `/plugins install` |
| `claude/skills/graphify/` | `~/.claude/skills/graphify/` | `/graphify` custom skill |
| `opencode/agent/wshobson/` | `~/.config/opencode/agent/wshobson/` | 120 wshobson community agents (vendored from [wshobson/agents](https://github.com/wshobson/agents)) |
| `codex/AGENTS.md` | `~/.codex/AGENTS.md` | Codex global agents |

## What's NOT in here (you'll set these up manually)

- **Auth tokens** — `~/.claude/.credentials.json`, `~/.codex/auth.json`. Run `claude login` / `codex auth` after install.
- **Project memory** — `~/.claude/projects/<project>/memory/` is per-machine, per-project. It rebuilds itself as you work.
- **Machine-specific permissions** — `~/.claude/settings.local.json`. Add as you go.
- **Plugins** — `claude/installed_plugins.json` is just the list; install them after first run via `/plugins`.
- **MCP servers** — Linear / Slack / Figma etc. need re-authenticating per machine.

## Install on a fresh machine

```bash
git clone --depth 1 git@github.com:<YOUR-GH-USERNAME>/claude-setup.git ~/claude-setup
cd ~/claude-setup
./install.sh
```

`install.sh` will:
1. Back up any existing `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, `~/.claude/skills/graphify/`, `~/.config/opencode/agent/wshobson/`, `~/.codex/AGENTS.md` to `<file>.backup-<timestamp>`.
2. Copy this repo's files into the right locations.
3. Print the post-install checklist (auth login, plugin re-install, etc.).

The script is idempotent — running it twice won't lose your existing setup; it'll just overwrite with the latest.

## Updating

Made changes on this machine? Sync them back to the repo:

```bash
cd ~/claude-setup
./pull-from-system.sh   # copies your live files INTO the repo
git diff                 # review what changed
git add -A && git commit -m "sync: <what you changed>" && git push
```

Then on your other machine: `git pull && ./install.sh`.

## Notes

- **Vendored, not submoduled:** wshobson agents are committed directly. If wshobson updates upstream, run `./refresh-wshobson.sh` to pull the latest from [wshobson/agents](https://github.com/wshobson/agents).
- **Sanitization:** `claude/settings.json` had 54 project-specific `Bash(...)` rules pinned to `~/Desktop/devstuff/pnow-ats-v2/` paths. They're stripped. The remaining 200 rules are generic.
- **Privacy:** this repo should stay **private** — the settings.json still has rule patterns that describe my workflow.
