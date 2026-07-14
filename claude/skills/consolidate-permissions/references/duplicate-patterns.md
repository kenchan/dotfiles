# Duplicate Detection Patterns

## Subsumption Rules

### Bash Command Wildcards

When user-level has `Bash(command:*)`, the following project-level entries are duplicates:

| User-level | Project-level (duplicate) |
|------------|---------------------------|
| `Bash(git:*)` | `Bash(git add:*)`, `Bash(git commit:*)`, `Bash(git push:*)`, `Bash(git checkout:*)` |
| `Bash(gh:*)` | `Bash(gh pr list:*)`, `Bash(gh api:*)`, `Bash(gh auth:*)` |
| `Bash(chezmoi:*)` | `Bash(chezmoi apply:*)`, `Bash(chezmoi diff:*)` |
| `Bash(npm:*)` | `Bash(npm install:*)`, `Bash(npm run:*)` |
| `Bash(npx:*)` | `Bash(npx astro:*)`, `Bash(npx zenn-cli:*)` |
| `Bash(uv:*)` | `Bash(uv run:*)`, `Bash(uv sync:*)`, `Bash(uv venv:*)`, `Bash(uv pip install:*)` |
| `Bash(pip:*)` | `Bash(pip install:*)` |
| `Bash(python:*)` | `Bash(python -m pytest:*)` |
| `Bash(mise:*)` | `Bash(mise exec:*)`, `Bash(mise activate:*)` |

### MCP Server Wildcards

When user-level has `mcp__server`, all individual tools are duplicates:

| User-level | Project-level (duplicate) |
|------------|---------------------------|
| `mcp__GHE` | `mcp__GHE__search_code`, `mcp__GHE__get_file_contents`, `mcp__GHE__pull_request_read`, `mcp__GHE__list_pull_requests`, `mcp__GHE__create_issue` |
| `mcp__terraform` | `mcp__terraform__get_latest_provider_version`, `mcp__terraform__search_providers`, `mcp__terraform__get_provider_details`, `mcp__terraform__resolveProviderDocID`, `mcp__terraform__getProviderDocs` |
| `mcp__playwright` | `mcp__playwright__browser_navigate`, `mcp__playwright__browser_click` |

## Common User-Level Permissions

These are typically safe to add to user-level:

### File Operations
- `Bash(ls:*)`, `Bash(cat:*)`, `Bash(find:*)`, `Bash(fd:*)`, `Bash(rg:*)`, `Bash(grep:*)`, `Bash(awk:*)`, `Bash(sed:*)`, `Bash(bat:*)`

### Development Tools
- `Bash(git:*)`, `Bash(gh:*)`, `Bash(python:*)`, `Bash(ruby:*)`, `Bash(node:*)`
- `Bash(npm:*)`, `Bash(npx:*)`, `Bash(pnpm:*)`, `Bash(uv:*)`, `Bash(uvx:*)`, `Bash(pip:*)`
- `Bash(go:*)`, `Bash(cargo:*)`

### Utilities
- `Bash(jq:*)`, `Bash(mkdir:*)`, `Bash(sqlite3:*)`, `Bash(chezmoi:*)`, `Bash(mise:*)`

## Project-Specific Permissions (Keep in Project)

### Destructive Commands
- `Bash(rm:*)`, `Bash(mv:*)`, `Bash(chmod:*)`, `Bash(chown:*)`

### Environment-Prefixed Commands
- `Bash(GH_HOST=... :*)` - GitHub Enterprise specific
- `Bash(PLAMO_MOCK_MODE=... :*)` - Test environment specific
- `Bash(export ... :*)` - Environment variable exports

### Project Scripts
- `Bash(./script.sh:*)` - Local scripts
- `Bash(bin/command:*)` - Project bin commands
- `Bash(bundle exec:*)` - Ruby bundler commands

### Sudo Commands
- `Bash(sudo:*)` - Always project-specific

### Project-Specific MCP
- `mcp__textlint__*` - Linting tools
- `mcp__cloudflare-docs__*` - Service-specific docs
- `mcp__sqlite3-vec__*` - Custom MCP servers
