# kenchan's dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Requirements

- [chezmoi](https://www.chezmoi.io/)

## Install

### Quick Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kenchan
```

### Manual Install

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize with this repository
chezmoi init https://github.com/kenchan/dotfiles.git

# Review changes
chezmoi diff

# Apply dotfiles
chezmoi apply -v
```

## Usage

### Edit a dotfile

```bash
chezmoi edit ~/.config/fish/config.fish
```

### Apply changes

```bash
chezmoi apply
```

### Check what would change

```bash
chezmoi diff
```

### Add a new dotfile

```bash
chezmoi add ~/.config/newfile
```

### Update from the repository

```bash
chezmoi update
```

### Pull the latest changes and see what would change

```bash
chezmoi git pull -- --autostash --rebase && chezmoi diff
```

## Migration History

Previously managed with [thoughtbot/rcm](https://github.com/thoughtbot/rcm). Migrated to chezmoi on 2026-01-05 while preserving full git history.

## License

[MIT License](LICENSE)
