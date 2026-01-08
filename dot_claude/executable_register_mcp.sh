#!/usr/bin/bash

claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool
claude mcp add playwright -s user -- powershell.exe -NoProfile -Command npx -y @playwright/mcp@latest

# Execute local registration script if it exists
if [ -f "$(dirname "$0")/register_mcp.local.sh" ]; then
    source "$(dirname "$0")/register_mcp.local.sh"
fi
