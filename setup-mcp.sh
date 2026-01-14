#!/bin/bash

# Setup script for Neovim MCP Server with Claude Code
# This script configures Claude Code to connect to your Neovim instance

echo "=== Neovim MCP Server Setup ==="
echo ""

# Check if Claude Code CLI is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Error: Claude Code CLI not found"
    echo "Please install it first: https://claude.com/claude-code"
    exit 1
fi

echo "✓ Claude Code CLI found"
echo ""

# Get the Neovim socket path
# It will be auto-created when you open Neovim with the MCP plugin
SOCKET_PATH="/tmp/nvim-mcp-$$.sock"

echo "This script will configure Claude Code to connect to Neovim via MCP."
echo ""
echo "Socket path: $SOCKET_PATH"
echo "(Note: Actual socket will use your Neovim PID when running)"
echo ""

# Ask for confirmation
read -p "Do you want to add the Neovim MCP server to Claude Code? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

# Add the MCP server to Claude Code
echo ""
echo "Adding Neovim MCP server to Claude Code..."
echo ""

# Note: The actual socket path will be set by the Neovim plugin
# Users should run :MCPInfo in Neovim to get the correct path
claude mcp add --transport stdio neovim \
  --env NVIM_LISTEN_ADDRESS="/tmp/nvim-mcp.sock" \
  -- npx -y @bigcodegen/mcp-neovim-server

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ MCP server configured successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Open Neovim - the MCP server will start automatically"
    echo "2. Run :MCPSetup in Neovim to see the actual socket path"
    echo "3. Update the MCP config with the correct socket path if needed"
    echo "4. In Claude Code CLI, verify with: claude mcp list"
    echo "5. Use it: open Claude Code and type '/mcp' to connect"
    echo ""
else
    echo ""
    echo "❌ Error configuring MCP server"
    echo "Please check the error message above"
    exit 1
fi
