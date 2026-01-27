---
name: consolidate-permissions
description: This skill should be used when the user asks to "consolidate permissions", "add permissions to user-level", "sync claude settings", "remove duplicate permissions", "manage allow list", or wants to unify Claude Code permission settings across user and project levels.
argument-hint: [new-permissions...]
disable-model-invocation: true
user-invocable: true
---

# Claude Code Permission Consolidation

Consolidate Claude Code permission settings by adding common permissions to user-level (`~/.claude/settings.json`) and removing duplicates from project-level configurations.

## Policy

- Add only safe, common commands to user-level
- Keep destructive commands (rm, mv, chmod, etc.) project-specific
- Remove duplicate settings from each project

## Execution Steps

### Step 1: Check Current Settings

1. Read `~/.claude/settings.json`
2. If managed by chezmoi, also read `~/.local/share/chezmoi/dot_claude/settings.json`

### Step 2: Search for Project Settings Files

```bash
fd 'settings.local.json' ~/.claude/projects/ --type f
fd 'settings.local.json' ~/src --type f
```

### Step 3: Add Specified Permissions

Add permissions from $ARGUMENTS to the user-level `allow` array.

Invocation example:
```
/consolidate-permissions Bash(python:*) Bash(uv:*) mcp__terraform
```

Valid permission formats:
- `Bash(command:*)` - Shell command permission
- `mcp__server` - MCP server permission
- `Edit(**)`, `Read(**)` - File operation permissions

### Step 4: Remove Duplicate Settings

Remove entries from each project's `settings.local.json` that exist in user-level:
- Delete files with empty `allow` arrays
- Keep only project-specific settings

### Step 5: Verify Changes

If managed by chezmoi:
```bash
chezmoi diff
```

### Step 6: Safety Checklist

Verify before committing:
- [ ] Changes affect only `.claude/` files
- [ ] Added commands are standard development tools
- [ ] No system file write permissions (/etc, /usr, etc.)
- [ ] No credential access (.env, credentials, etc.)

### Step 7: User Confirmation

Present options via AskUserQuestion:
1. Apply and commit/push
2. Apply only (no commit)
3. Cancel

### Step 8: Apply and Commit

On approval:

```bash
chezmoi apply
cd ~/.local/share/chezmoi
git add dot_claude/settings.json
git commit -m "feat(claude): add common development tool permissions"
git push
```

## Prohibited Permissions

Never add to user-level:
- Destructive commands: `rm`, `mv`, `chmod`, `chown`
- Credential access patterns: `.env`, `credentials`, `secrets`
- System paths: `/etc/*`, `/usr/*`, `/var/*`

Always run `chezmoi diff` before applying changes.
