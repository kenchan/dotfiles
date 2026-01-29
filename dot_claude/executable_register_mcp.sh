#!/usr/bin/bash

claude mcp add gemini-cli -s user -- npx -y gemini-mcp-tool
claude mcp add playwright -s user -- powershell.exe -NoProfile -Command npx -y @playwright/mcp@latest

# GitHub MCP Server (requires gh CLI authentication)
# Required scopes: repo, read:org, read:packages
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    GITHUB_TOKEN=$(gh auth token)
    claude mcp add-json github -s user "{\"type\":\"http\",\"url\":\"https://api.githubcopilot.com/mcp\",\"headers\":{\"Authorization\":\"Bearer ${GITHUB_TOKEN}\"}}"
else
    echo "Warning: gh CLI not found or not authenticated. Skipping GitHub MCP Server."
    echo "Run 'gh auth login -s repo,read:org,read:packages' to authenticate."
fi

# Execute local registration script if it exists
if [ -f "$(dirname "$0")/register_mcp.local.sh" ]; then
    source "$(dirname "$0")/register_mcp.local.sh"
fi
