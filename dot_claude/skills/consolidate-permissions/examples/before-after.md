# Before/After Examples

## Example 1: Full Duplicate Removal

### Before (project settings.local.json)
```json
{
  "permissions": {
    "allow": [
      "Bash(mkdir:*)",
      "Bash(ls:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(find:*)",
      "mcp__GHE__pull_request_read"
    ],
    "deny": []
  }
}
```

### User-level settings.json (allow array)
```json
[
  "Bash(mkdir:*)",
  "Bash(ls:*)",
  "Bash(git:*)",
  "Bash(find:*)",
  "mcp__GHE"
]
```

### After
**File deleted** - All permissions were duplicates.

---

## Example 2: Partial Duplicate Removal

### Before
```json
{
  "permissions": {
    "allow": [
      "Bash(mkdir:*)",
      "Bash(chmod:*)",
      "Bash(docker compose:*)",
      "Bash(rm:*)",
      "Bash(./test.sh:*)"
    ],
    "deny": []
  }
}
```

### After
```json
{
  "permissions": {
    "allow": [
      "Bash(chmod:*)",
      "Bash(docker compose:*)",
      "Bash(rm:*)",
      "Bash(./test.sh:*)"
    ],
    "deny": []
  }
}
```
**Removed**: `mkdir` (duplicate)
**Kept**: `chmod`, `docker compose`, `rm`, `./test.sh` (project-specific)

---

## Example 3: Keep MCP Settings

### Before
```json
{
  "permissions": {
    "allow": [
      "Bash(find:*)"
    ],
    "deny": []
  },
  "enabledMcpjsonServers": [
    "aws-documentation"
  ],
  "enableAllProjectMcpServers": true
}
```

### After
```json
{
  "permissions": {
    "allow": [],
    "deny": []
  },
  "enabledMcpjsonServers": [
    "aws-documentation"
  ],
  "enableAllProjectMcpServers": true
}
```
**File kept** - Has MCP server configuration.

---

## Example 4: Environment-Prefixed Commands

### Before
```json
{
  "permissions": {
    "allow": [
      "Bash(uv run:*)",
      "Bash(python:*)",
      "Bash(GH_HOST=github.example.com gh api:*)",
      "Bash(PLAMO_MOCK_MODE=true uv run pytest:*)"
    ]
  }
}
```

### After
```json
{
  "permissions": {
    "allow": [
      "Bash(GH_HOST=github.example.com gh api:*)",
      "Bash(PLAMO_MOCK_MODE=true uv run pytest:*)"
    ]
  }
}
```
**Removed**: `uv run`, `python` (covered by user-level `uv:*`, `python:*`)
**Kept**: Environment-prefixed commands (project-specific)
