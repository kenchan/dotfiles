# Personal Preferences

- Respond in Japanese
- Where explanations go (t-wada): How → the code itself. What → tests, and API docs. Why → the commit log. Why not (why not the obvious alternative) → a code comment. Anything else: no comment.
- Use `/commit-commands:commit` skill for git commits
- Send Slack messages as drafts. Confirm content with user before creating the draft.
- Always use ghq to manage git repositories (clone with `ghq get`, stored under `ghq root`)
- To investigate code on GitHub / GHES / GHEC, clone the repository with ghq and read it locally. Use the gh CLI for issue/PR operations and search (`gh search`), not for fetching file contents via `gh api .../contents`
- Dotfiles are managed with mise (`[dotfiles]` in the repo-root mise.toml of ~/src/github.com/kenchan/dotfiles); deployed files are symlinks into that repo
- For Google Workspace operations (Gmail, Google Calendar, Google Drive, etc.), use the gws CLI and its related skills (gws-gmail, gws-calendar, gws-drive, etc.). Do not use MCP auth tools (claude.ai Gmail/Google Calendar/Google Drive)
- Parallel agent work and diff review are built on hc + herdr-app + hunk — see the "hc / herdr-app / hunk" section below

# hc / herdr-app / hunk

hc (herdr-core: programs and coding agents in terminals that stay alive) + herdr-app (the desktop window that shows them as spaces, tabs and panes) + hunk (hunkdiff, terminal diff viewer) are the primary tools for parallel agent work and diff review. The older TUI multiplexer `herdr` is not used.

- For starting, reading, messaging or waiting on agents and programs, load the `herdr-core` skill and follow it — proactively, not only when the user names hc. `hc --skill`, `herdr-app --skill` and `hc <command> --help` are the authority for syntax
- Use a child agent (`hc run --bg`, per the `handoff` skill) when the user may want to watch or steer the work mid-flight; use the Agent tool (subagent) when only the result matters
- Run slow commands (builds, test suites, CI watches) in an hc terminal and wait with `hc wait`, so you stay reachable for messages and children's reports
- Agents editing the same repository in parallel get separate checkouts via `git worktree add`
- To show the user a diff ("diffをみせて"): split hunk next to your own pane and leave it open for them — `herdr-app do pane.split '{"direction":"right","pane":"<your pane>","argv":["hunk","diff","--","<path>"]}'` (your pane is the one whose terminal is `$HC_TERMINAL_ID` in `herdr-app ls`; also `hunk diff --staged`, `hunk show`). To understand a diff yourself, read plain `git diff` instead. Never run hunk's TUI in your own shell (renders as unusable raw ANSI)
- When work requires touching a different directory/repo than the current cwd, or you are asked to hand a request to a separate agent, don't just `cd` there — follow the `handoff` skill: one request = one child agent of yours, cwd decided first
