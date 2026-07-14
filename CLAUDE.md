# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### dotfiles Management (mise)

Run inside this repository (the `[dotfiles]` section lives in the repo-root `mise.toml`):

- Check deployment state: `mise dotfiles status`
- Apply (create missing links): `mise dotfiles apply`
- Start managing a new file: `mise dotfiles add ~/.config/newfile`
- Full machine setup: `mise bootstrap`

### Shell Configuration Testing

- Validate fish config: `fish -c exit`
- Lint fish scripts: `fish --no-execute config/fish/config.fish`
- Test starship prompt: `starship print-config`

### mise Tasks

- Run custom tasks: `mise run <task-name>`
- Available tasks defined in: `config/mise/tasks/` (file tasks must be executable)

## Architecture Overview

This is a dotfiles repository managed by **mise** (`[dotfiles]` in `mise.toml`).
History: rcm → chezmoi (2026-01-05) → mise dotfiles (2026-07-14), full git history preserved.

### Deployment Layout

| Repository | Target | Mode |
|---|---|---|
| `config/` | `~/.config/` | `symlink-each` |
| `nvim/` | `~/.config/nvim` | `symlink` (whole directory) |
| `claude/` | `~/.claude/` | `symlink-each` |
| `bin/` | `~/.local/bin/` | `symlink-each` |

Key properties:

- `symlink-each` recreates directories as real directories and links each
  managed file individually. Application-generated files next to them stay in
  the real directories and never show up in this repository.
- `nvim/` is deployed as a whole-directory symlink so that `lazy-lock.json`
  rewrites are reliably captured. It lives outside `config/` in the repository
  to keep the two dotfiles entries' sources from overlapping.
- Deployed files ARE the repository files (same inode via symlink). Edit either
  path, then commit here — there is no separate "apply" step for edits to
  already-managed files. `mise dotfiles apply` is only needed when files are
  added to or removed from the repository.

### IMPORTANT: ~/.claude/settings.json is unmanaged

`~/.claude/settings.json` is intentionally NOT managed by this repository.
It contains machine- and work-local state (internal plugin marketplaces,
local hooks) that must not be committed to this public repository. Never add
it to `[dotfiles]` or commit its contents here.

### Key Patterns

**Fish Shell** (`config/fish/config.fish`):
- Conditional command checking pattern before setting aliases/abbreviations
- Uses `command -v` checks to ensure tools exist
- mise activation for runtime management
- Integrates: direnv, starship, fzf, wsl2-ssh-agent

**Neovim** (`nvim/`):
- Lazy.nvim plugin manager
- Modular plugin config in `lua/plugins/` directory

**Git** (`config/git/config`):
- GPG signing with SSH keys (1Password)
- Config includes `config.local` for machine-specific settings (not tracked)

**mise** (`config/mise/`):
- Global tool version management in `config.toml`
- Custom tasks in `tasks/` directory (executable scripts)

### Development Workflow

1. Edit dotfiles directly (deployed paths are symlinks into this repository)
2. Test changes in the current session
3. Commit and push in this repository (`~/src/github.com/kenchan/dotfiles`)
4. On other machines: `git pull` — symlinked files pick up changes immediately;
   run `mise dotfiles apply` only if files were added or removed
