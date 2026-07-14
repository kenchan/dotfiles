# kenchan's dotfiles

Managed with [mise](https://mise.jdx.dev/) (`[dotfiles]` section + `mise dotfiles`).

## Requirements

- [mise](https://mise.jdx.dev/)

## Install

```bash
# Install mise
curl https://mise.run | sh

# Clone this repository (ghq root layout)
git clone https://github.com/kenchan/dotfiles.git ~/src/github.com/kenchan/dotfiles

cd ~/src/github.com/kenchan/dotfiles
mise trust
mise dotfiles apply
```

## Layout

| Repository | Target | Mode |
|---|---|---|
| `config/` | `~/.config/` | symlink-each |
| `nvim/` | `~/.config/nvim` | symlink (whole directory) |
| `claude/` | `~/.claude/` | symlink-each |
| `bin/` | `~/.local/bin/` | symlink-each |

With `symlink-each`, directories are created as real directories and each
managed file becomes a symlink into this repository. Files created by
applications alongside them are left alone and never enter the repository.

`~/.claude/settings.json` is intentionally **not** managed here: it holds
machine- and work-local state.

## Usage

Deployed files are symlinks into this repository, so just edit them in
place (either path is the same file) and commit here.

```bash
# Check deployment state
mise dotfiles status

# Start managing a new file
mise dotfiles add ~/.config/newfile

# Create links for files newly added to the repository
mise dotfiles apply
```

## Migration History

- Managed with [thoughtbot/rcm](https://github.com/thoughtbot/rcm), migrated to [chezmoi](https://www.chezmoi.io/) on 2026-01-05 preserving full git history.
- Migrated from chezmoi to mise `[dotfiles]` on 2026-07-14.

## License

[MIT License](LICENSE)
