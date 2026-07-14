# Personal Preferences

- Respond in Japanese
- Comments should explain "why" only, not "what"
- Use `/commit-commands:commit` skill for git commits
- Send Slack messages as drafts. Confirm content with user before creating the draft.
- Always use ghq to manage git repositories (clone with `ghq get`, stored under `ghq root`)
- Dotfiles are managed with mise (`[dotfiles]` in the repo-root mise.toml of ~/src/github.com/kenchan/dotfiles); deployed files are symlinks into that repo
- For Google Workspace operations (Gmail, Google Calendar, Google Drive, etc.), use the gws CLI and its related skills (gws-gmail, gws-calendar, gws-drive, etc.). Do not use MCP auth tools (claude.ai Gmail/Google Calendar/Google Drive)
- When running `difit` on WSL2, always pass `--host 0.0.0.0` so the server is accessible from the browser (e.g. `git diff ... | difit --host 0.0.0.0`)
