---
name: consolidate-permissions
description: This skill should be used when the user asks to "consolidate permissions", "add permissions to user-level", "sync claude settings", "remove duplicate permissions", "manage allow list", or wants to unify Claude Code permission settings across user and project levels.
argument-hint: "[new-permissions...]"
user-invocable: true
---

# Claude Code Permission Consolidation

Consolidate Claude Code permission settings by adding common permissions to user-level (`~/.claude/settings.json`) and removing duplicates from project-level configurations.

## Policy

- Add only safe, common commands to user-level
- Keep destructive commands (rm, mv, chmod, etc.) project-specific
- Remove duplicate settings from each project
- Keep environment-variable-prefixed commands project-specific (e.g., `GH_HOST=... gh`, `PLAMO_MOCK_MODE=...`)
- Keep project-specific scripts (e.g., `./test.sh`, `bin/setup`)
- Preserve MCP server configurations even when permissions are empty

## Execution Steps

### Step 1: Check Current Settings

Read `~/.claude/settings.json` to understand the current user-level permissions.

If managed by chezmoi, also read `~/.local/share/chezmoi/dot_claude/settings.json` as the source of truth.

### Step 2: Search for Project Settings Files

Locate all project-level settings by finding `.claude` directories across the home directory:

```bash
# Find all .claude directories (including hidden)
fd -H '\.claude$' ~/ --type d

# Then check for settings.local.json in each directory
for dir in $(fd -H '\.claude$' ~/ --type d 2>/dev/null); do
  if [ -f "$dir/settings.local.json" ]; then
    echo "=== $dir/settings.local.json ==="
    cat "$dir/settings.local.json"
  fi
done
```

**Important**: Project settings exist in each project's `.claude/settings.local.json`, not just in `~/.claude/projects/`.

### Step 3: Add Specified Permissions

Add permissions from $ARGUMENTS to the user-level `allow` array.

**Invocation example:**
```
/consolidate-permissions Bash(python:*) Bash(uv:*) mcp__terraform
```

**Valid permission formats:**
- `Bash(command:*)` - Shell command permission
- `mcp__server` - MCP server permission
- `Edit(**)`, `Read(**)` - File operation permissions

### Step 4: Remove Duplicate Settings

Remove entries from each project's `settings.local.json` that exist in user-level.

**Duplicate Detection Rules:**

1. **Exact match**: `Bash(mkdir:*)` in user-level → remove `Bash(mkdir:*)` from project
2. **Wildcard subsumption**: `Bash(git:*)` in user-level → remove `Bash(git add:*)`, `Bash(git commit:*)`, etc.
3. **MCP server subsumption**: `mcp__GHE` in user-level → remove `mcp__GHE__search_code`, `mcp__GHE__get_file_contents`, etc.
4. **Command prefix match**: `Bash(chezmoi:*)` in user-level → remove `Bash(chezmoi apply:*)`, `Bash(chezmoi diff:*)`

**Common duplicates to check:**
- `mkdir`, `ls`, `find`, `cat`, `rg`, `grep`, `awk`, `sed` → often in user-level
- `git`, `gh`, `python`, `npm`, `npx`, `uv`, `pip` → often in user-level
- `mcp__GHE__*`, `mcp__terraform__*` → check if parent MCP server is allowed

**File handling:**
- Delete files where `allow` array becomes empty AND no other settings exist
- Keep files with MCP settings (`enabledMcpjsonServers`, `enableAllProjectMcpServers`) even if `allow` is empty
- Keep only project-specific permissions (destructive commands, project scripts, environment-specific commands)

### Step 5: Verify Changes

If managed by chezmoi:
```bash
chezmoi diff
```

### Step 6: Safety Checklist

Verify before committing:
- [ ] Changes affect only `.claude/` related files
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

## Additional Resources

### Reference Files

For detailed patterns and examples, consult:
- **`references/duplicate-patterns.md`** - Comprehensive subsumption rules and common patterns
- **`examples/before-after.md`** - Concrete before/after examples of permission consolidation
