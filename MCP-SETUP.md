# Neovim MCP Server Setup for Claude Code

This configuration allows Claude Code CLI to interact directly with your Neovim instance through the Model Context Protocol (MCP).

## What This Does

- Neovim starts with an MCP-compatible socket server automatically
- Claude Code can read your buffers, make edits, run commands, and more
- Full bidirectional communication between Claude and your editor

## Quick Start

### Option 1: Automatic Setup (Recommended)

1. **Run the setup script:**
   ```bash
   ~/.config/nvim/setup-mcp.sh
   ```

2. **Restart Neovim** (or run `:Lazy sync` if already open)

3. **Get your socket path:**
   - In Neovim, run `:MCPSetup` or press `<leader>am`
   - This shows setup instructions with your actual socket path

4. **Update Claude Code config** (if needed):
   ```bash
   # Use the socket path from step 3
   claude mcp add --transport stdio neovim \
     --env NVIM_LISTEN_ADDRESS=/tmp/nvim-mcp-XXXXX.sock \
     -- npx -y @bigcodegen/mcp-neovim-server
   ```

### Option 2: Manual Setup

1. **Restart Neovim** to load the MCP plugin

2. **Note your socket path:**
   - Run `:MCPInfo` or press `<leader>ai`
   - Socket path will be copied to clipboard

3. **Configure Claude Code:**
   ```bash
   claude mcp add --transport stdio neovim \
     --env NVIM_LISTEN_ADDRESS=<your-socket-path> \
     -- npx -y @bigcodegen/mcp-neovim-server
   ```

4. **Verify:**
   ```bash
   claude mcp list
   ```

## Usage

Once configured, you can use Claude Code to interact with Neovim:

```bash
# Start Claude Code
claude

# Connect to MCP servers
> /mcp

# Example commands
> "Show me what file is currently open in my editor"
> "Make this change to the file in my Neovim buffer"
> "Search for TODO comments in my open buffers"
> "Add a function called calculateTotal to the current file"
```

## Neovim Commands

| Command | Description |
|---------|-------------|
| `:MCPSetup` | Show detailed setup instructions in a popup |
| `:MCPInfo` | Display current socket path (copies to clipboard) |
| `:MCPStart` | Manually start MCP server socket |

## Keybindings

| Key | Description |
|-----|-------------|
| `<leader>am` | Show MCP setup instructions |
| `<leader>ai` | Show socket info |

## How It Works

1. **Neovim Plugin** (`lua/plugins/mcp-server.lua`):
   - Automatically starts a socket server when Neovim launches
   - Creates a unique socket at `/tmp/nvim-mcp-<pid>.sock`
   - Provides commands and keybindings for easy access

2. **MCP Server** (`@bigcodegen/mcp-neovim-server`):
   - Node.js bridge between Claude Code and Neovim
   - Communicates via Neovim's socket API
   - Translates Claude's requests into Neovim commands

3. **Claude Code CLI**:
   - Connects to the MCP server via stdio transport
   - Can read buffers, execute commands, make edits
   - Full context awareness of your editor state

## Troubleshooting

### "No MCP socket active"
- Run `:MCPStart` in Neovim
- Or restart Neovim to auto-start the socket

### "Cannot connect to Neovim"
- Verify socket path matches in Claude Code config
- Check socket exists: `ls -la /tmp/nvim-mcp-*.sock`
- Make sure Neovim is running

### "MCP server not found in Claude Code"
- Run: `claude mcp list`
- If not listed, add it again with the correct socket path
- Run: `claude mcp get neovim` for details

### Update socket path in Claude Code
```bash
# Remove old config
claude mcp remove neovim

# Add with new socket path (get from :MCPInfo)
claude mcp add --transport stdio neovim \
  --env NVIM_LISTEN_ADDRESS=/tmp/nvim-mcp-XXXXX.sock \
  -- npx -y @bigcodegen/mcp-neovim-server
```

## Advanced Configuration

### Project-Specific MCP Config

Create `.mcp.json` in your project root:
```json
{
  "mcpServers": {
    "neovim": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@bigcodegen/mcp-neovim-server"],
      "env": {
        "NVIM_LISTEN_ADDRESS": "/tmp/nvim-mcp.sock"
      }
    }
  }
}
```

### Multiple Neovim Instances

Each Neovim instance gets a unique socket based on its PID:
- Instance 1: `/tmp/nvim-mcp-12345.sock`
- Instance 2: `/tmp/nvim-mcp-12346.sock`

Configure multiple MCP servers in Claude Code:
```bash
claude mcp add --transport stdio neovim1 \
  --env NVIM_LISTEN_ADDRESS=/tmp/nvim-mcp-12345.sock \
  -- npx -y @bigcodegen/mcp-neovim-server

claude mcp add --transport stdio neovim2 \
  --env NVIM_LISTEN_ADDRESS=/tmp/nvim-mcp-12346.sock \
  -- npx -y @bigcodegen/mcp-neovim-server
```

## Resources

- [MCP Neovim Server](https://github.com/bigcodegen/mcp-neovim-server)
- [Claude Code MCP Docs](https://code.claude.com/docs/en/mcp.md)
- [Model Context Protocol](https://modelcontextprotocol.io)

## What Claude Can Do

Once connected, Claude Code can:
- ✓ Read any open buffer
- ✓ Get cursor position and file info
- ✓ Execute Vim commands
- ✓ Make edits to files
- ✓ Search across buffers
- ✓ Navigate your codebase
- ✓ Run LSP commands (if configured)
