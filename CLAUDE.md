# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### chezmoi Management
- Edit a dotfile: `chezmoi edit ~/.config/fish/config.fish`
- Apply changes: `chezmoi apply`
- Preview changes: `chezmoi diff`
- Add new dotfile: `chezmoi add ~/.config/newfile`
- Update from remote: `chezmoi update`
- Pull and preview: `chezmoi git pull -- --autostash --rebase && chezmoi diff`
- Verify all files: `chezmoi verify`
- List managed files: `chezmoi managed`

### Shell Configuration Testing
- Validate fish config: `fish -c exit`
- Lint fish scripts: `fish --no-execute private_dot_config/fish/config.fish`
- Test starship prompt: `starship config validate`

### mise Tasks
- Run custom tasks: `mise run <task-name>`
- Available tasks defined in: `private_dot_config/mise/tasks/`

## Architecture Overview

This is a dotfiles repository managed by **chezmoi**. Migrated from rcm on 2026-01-05 with full git history preserved.

### chezmoi Naming Conventions
- `dot_` prefix → `.` in home directory (e.g., `dot_bashrc` → `~/.bashrc`)
- `private_` prefix → chmod 600 (files) or 700 (directories)
- `private_dot_config/` → `~/.config/` with permissions 700

### Configuration Structure
- **All configurations** stored in `private_dot_config/` (maps to `~/.config/`)
- **Platform-specific configs** use runtime detection patterns (not file suffixes)
- **Toolchain management** via mise (replaces asdf/rtx)

### Key Patterns

**Fish Shell** (`private_dot_config/fish/config.fish`):
- Conditional command checking pattern before setting aliases/abbreviations
- Uses `command -v` checks to ensure tools exist
- mise activation for runtime management
- Integrates: direnv, starship, fzf, wsl2-ssh-agent

**Tmux** (`private_dot_config/tmux/`):
- Base config in `tmux.conf`
- Platform-specific overlays loaded conditionally at runtime:
  - `tmux.darwin.conf` - macOS specific (clipboard via pbcopy/pbpaste)
  - `tmux.wayland.conf` - Wayland specific (clipboard via wl-copy/wl-paste)
  - `tmux.wsl-vscode-terminal.conf` - WSL + VS Code specific
- Detection via `if` statements in main config (uname, command checks)

**Neovim** (`private_dot_config/nvim/`):
- Lazy.nvim plugin manager
- Modular plugin config in `lua/plugins/` directory
- Each plugin in separate file for maintainability

**Git** (`private_dot_config/git/config`):
- GPG signing with SSH keys
- Config includes `config.local` for machine-specific settings (not tracked)

**mise** (`private_dot_config/mise/`):
- Global tool version management in `config.toml`
- Custom tasks in `tasks/` directory (executable scripts)
- Supports idiomatic version files (.ruby-version, .node-version)

### Modern Toolchain
All managed via mise (`config.toml`):
- Languages: ruby, python, nodejs, go, rust, deno, bun
- Cloud: gcloud, awscli, terraform
- CLI tools: gh, kubectl, docker, fzf, starship, direnv
- Package managers: pnpm, uv, bundle

### Development Workflow
1. Edit dotfiles: Use `chezmoi edit` (never edit files in `~/.config/` directly)
2. Test changes: Apply and test in current session
3. Commit: Work in `~/.local/share/chezmoi` git repository
4. Apply: `chezmoi apply` to deploy changes to home directory

### Platform Detection Pattern
Instead of file suffixes, configs use runtime detection:
```fish
# Fish example
if command -v hub > /dev/null
  alias git hub
end
```

```tmux
# Tmux example
if '[ `uname` = "Darwin" ]' 'source-file ~/.config/tmux/tmux.darwin.conf'
```

This allows single files to adapt to different environments rather than maintaining separate platform-specific variants.
