# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### dotfiles Management (mise)

Run inside this repository (the `[dotfiles]` section lives in the repo-root `mise.toml`):

- Check deployment state: `mise dotfiles status`
- Apply (create missing links): `mise dotfiles apply`
- Start managing a new file: `mise dotfiles add ~/.config/newfile`
- Full machine setup: `mise bootstrap`

**Caution**: `mise dotfiles add` only matches exact `[dotfiles]` keys. For a new
file inside a directory already managed with `symlink-each` (e.g. a new file
under `~/.claude` or `~/.config`), it won't recognize the existing mapping —
it creates a separate entry instead (seeding a new `~/.dotfiles/` tree and
writing to the global mise config). Don't use `add` for these; instead place
the file directly under the matching source directory in this repo (e.g.
`claude/skills/<name>/SKILL.md`) and run `mise dotfiles apply`.

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
| `claude/` | `~/.claude/` | `symlink-each` (excludes `settings.json`) |
| `claude/settings.json` | `~/.claude/settings.json` | `merge = true` (owns only its keys) |
| `bin/` | `~/.local/bin/` | `symlink-each` |
| `apm/` | `~/.apm/` | `symlink-each` |

OS-specific files live under `os/wsl/` and `os/macos/` (same layout as the
common directories, e.g. `os/wsl/config/git/config.os`) and are deployed by
single-file or per-directory `[dotfiles]` entries in `mise.linux.toml` /
`mise.macos.toml`. mise loads the file for the current OS via platform
environments (`auto_env = true`, set in the repo-root `.miserc.toml` and in
`config/mise/miserc.toml` → `~/.config/mise/miserc.toml`; it has no effect in
`mise.toml`). `linux` is treated as WSL because WSL is the only Linux
environment in use. OS-specific mise tools go in `config/mise/config.<os>.toml`.

Current OS-specific files: `~/.config/git/config.os` (1Password SSH signer,
included from `config/git/config`), `~/.config/fish/conf.d/os.fish` (also
the `c`/`cc` Claude abbreviations, with `--chrome` only on WSL), (macOS only)
`~/.config/ghostty/config`, and (WSL only) `~/.claude/skills/wsl2-clipboard/`
and `~/.config/fish/functions/claude.fish`.

Key properties:

- `symlink-each` recreates directories as real directories and links each
  managed file individually. Application-generated files next to them stay in
  the real directories and never show up in this repository.
- `nvim/` is deployed as a whole-directory symlink so that `nvim-pack-lock.json`
  rewrites are reliably captured (Neovim writes it into `$XDG_CONFIG_HOME/nvim/`).
  It lives outside `config/` in the repository to keep the two dotfiles entries'
  sources from overlapping.
- Deployed files ARE the repository files (same inode via symlink). Edit either
  path, then commit here — there is no separate "apply" step for edits to
  already-managed files. `mise dotfiles apply` is only needed when files are
  added to or removed from the repository.

### ~/.claude/settings.json is merged, not linked

`~/.claude/settings.json` is a regular file on each machine. `claude/settings.json`
holds only the shared keys, and `mise dotfiles apply` merges them in
(`"~/.claude/settings.json/shared"` with `merge = true`): nested objects merge
key by key, arrays and scalars are replaced, and keys not in the source are
never touched. Keep it that way because other writers own the rest of the file:

- herdr's `herdr integration install claude` (run by `update-world`) adds a
  `hooks.SessionStart` entry with an absolute path (`/home/kenchan` on WSL,
  `/Users/kenchan` on macOS) and re-adds it if the command differs, so
  `hooks.SessionStart` must not be in `claude/settings.json`.
- Claude Code rewrites the file via `/config`, plugin installs, etc. Those
  changes stay local; copy a setting into `claude/settings.json` to share it.

Removing a key from `claude/settings.json` does not remove it from machines.
On a machine where `~/.claude/settings.json` is still the old symlink into this
repository, run `mise dotfiles apply` right after pulling (it replaces the
symlink with a copy), then `herdr integration install claude` — before that,
herdr would write its hook into the repository through the symlink.
Work-internal settings (plugin marketplaces, plugins, hooks) come from
server-managed settings (`~/.claude/remote-settings.json`) and must not be added
here. Hook commands must work on both GNU and BSD userlands (use `perl -pi`
rather than `sed -i`).

### Key Patterns

**Fish Shell** (`config/fish/config.fish`):
- Conditional command checking pattern before setting aliases/abbreviations
- Uses `command -v` checks to ensure tools exist
- mise activation for runtime management
- Integrates: direnv, starship, fzf
- OS-specific setup (wsl2-ssh-agent on WSL; Homebrew PATH and the 1Password
  SSH agent on macOS) lives in `os/<os>/config/fish/conf.d/os.fish`

**Neovim** (`nvim/`):
- Single `init.lua`; no plugin-manager bootstrap. Requires Neovim >= 0.12
- Plugins via the built-in `vim.pack`; `:lua vim.pack.update()` to update

**Git** (`config/git/config`):
- GPG signing with SSH keys (1Password); the signer path comes from the
  per-OS `config.os` include
- HTTPS credentials via `bin/git-credential-gh` (gh tokens, per
  `credential.username` account)
- Config includes `config.local` for machine-specific settings (not tracked)

**mise** (`config/mise/`):
- Global tool version management in `config.toml` (OS-only tools in
  `config.<os>.toml`)
- Custom tasks in `tasks/` directory (executable scripts)

### Development Workflow

1. Edit dotfiles directly (deployed paths are symlinks into this repository)
2. Test changes in the current session
3. Commit and push in this repository (`~/src/github.com/kenchan/dotfiles`)
4. On other machines: `git pull` — symlinked files pick up changes immediately;
   run `mise dotfiles apply` only if files were added or removed
