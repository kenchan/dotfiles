# CLAUDE.md - Guidelines for Dotfiles Repository

## Commands
- Update dotfiles: `rcup -v`
- Add new dotfile: `mkrc ~/.config/some_file`
- List managed files: `lsrc`
- Check fish config: `fish -c exit`
- Lint fish scripts: `fish --no-execute config/fish/config.fish`
- Starship prompt config check: `starship config validate`

## Code Style
- Python: 99 character line length limit (flake8)
- Git: Use signed commits with GPG
- Fish: Organize functions in `config/fish/functions/`
- Config files: Use minimal, focused configurations with comments
- Lua (Neovim): Follow existing plugin setup patterns
- Naming: Use snake_case for fish functions and variables
- Documentation: Add comments for non-obvious configurations
- Error handling: Use set -e in fish scripts when appropriate

## Project Structure
- `/config`: Application configurations
- Keep configurations modular and organized by application
- Follow host-specific configs pattern with *.{darwin,linux,wsl}* suffixes