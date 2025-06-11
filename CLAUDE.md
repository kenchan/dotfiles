# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands
- Update dotfiles: `rcup -v`
- Add new dotfile: `mkrc ~/.config/some_file`
- List managed files: `lsrc`
- Check fish config: `fish -c exit`
- Lint fish scripts: `fish --no-execute config/fish/config.fish`
- Starship prompt config check: `starship config validate`
- Install dotfiles: `env RCRC=$HOME/src/github.com/kenchan/dotfiles/rcrc rcup`

## Architecture Overview

This is a dotfiles repository managed by **rcm** with modular configuration patterns:

### Configuration Management
- Uses `rcm` for symlink management (`rcrc` configuration)
- Files in `/config/` are symlinked to `~/.config/`
- Host-specific configs use `*.{darwin,linux,wsl}*` suffix pattern
- Conditional loading based on runtime environment detection

### Key Patterns
- **Fish Shell**: Conditional command checking before setting aliases/abbreviations
- **Tmux**: Platform-specific overlay configs (darwin, wayland, wsl-vscode-terminal)
- **Neovim**: Lazy.nvim plugin management with modular `/lua/plugins/` structure
- **Git**: GPG signing with SSH keys, platform-specific credential management

### Modern Toolchain Integration
- `mise` for runtime/language version management
- `starship` for shell prompt customization  
- `fisher` for fish plugin management
- `direnv` for project-specific environments
- `fzf` integration throughout shell experience

## Code Style
- Python: 99 character line length limit (flake8)
- Git: Use signed commits with GPG
- Fish: Use snake_case for functions/variables, conditional command checking pattern
- Config files: Minimal, focused configurations with comments for non-obvious parts
- Lua (Neovim): Follow lazy.nvim plugin patterns with separate config files
- Always check if commands exist before configuring them

## Project Structure
- `/config/`: Application configurations (symlinked to `~/.config/`)
- Keep configurations modular by application
- Use host-specific suffixes for platform differences
- Fish plugins managed via `config/fish/fish_plugins`
- Neovim plugins in `/config/nvim/lua/plugins/` directory