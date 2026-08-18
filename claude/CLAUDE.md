# Personal Preferences

- Respond in Japanese
- Where explanations go (t-wada): How → the code itself. What → tests, and API docs. Why → the commit log. Why not (why not the obvious alternative) → a code comment. Anything else: no comment.
- Use `/commit-commands:commit` skill for git commits
- Send Slack messages as drafts. Confirm content with user before creating the draft.
- Always use ghq to manage git repositories (clone with `ghq get`, stored under `ghq root`)
- Dotfiles are managed with mise (`[dotfiles]` in the repo-root mise.toml of ~/src/github.com/kenchan/dotfiles); deployed files are symlinks into that repo
- For Google Workspace operations (Gmail, Google Calendar, Google Drive, etc.), use the gws CLI and its related skills (gws-gmail, gws-calendar, gws-drive, etc.). Do not use MCP auth tools (claude.ai Gmail/Google Calendar/Google Drive)
- Parallel agent work and diff review are built on herdr + hunk — see the "herdr / hunk" section below

# herdr / hunk

herdr (terminal multiplexer for coding agents) + hunk (hunkdiff, terminal diff viewer) are the primary tools for parallel agent work and diff review.

- For any herdr operation (launching parallel agents, running commands in panes, worktrees), load the `herdr` skill and follow it — proactively, not only when the user names herdr. The installed binary's help (`herdr agent`, `herdr pane`, ...) is the authority for syntax
- Use a herdr pane agent when the user may want to watch or steer the work mid-flight; use the Agent tool (subagent) when only the result matters
- Agents editing files in parallel get separate checkouts via `herdr worktree create`
- To show the user a diff ("diffをみせて"): launch hunk in a split pane (`hunk diff -- <path>`, `hunk diff --staged`, `hunk show`) and leave the pane open for them; to understand a diff yourself, read plain `git diff` instead. Never run hunk's TUI directly in a bare shell (renders as unusable raw ANSI)
- When work requires touching a different directory/repo than the current cwd, don't just `cd` there — create a new workspace with `herdr workspace create --cwd`, start an agent in it (`herdr agent start`), hand off full context via `herdr agent prompt` (background, what's already been done, what to do, what not to touch), then wait for completion and have it report back
