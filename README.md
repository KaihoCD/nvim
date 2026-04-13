# Neovim Configuration

[中文文档](./README.zh-CN.md) | English

Personal Neovim configuration built with Lua for modern development.

## Core Architecture

| Directory   | Description                                   |
| ----------- | --------------------------------------------- |
| `core/`     | Core configs: options, keymaps, autocmds      |
| `modules/`  | Custom modules (see details below)            |
| `plugins/`  | Plugin configuration files                    |
| `state/`    | Global state management with persistent storage |
| `utils/`    | Utility function library                      |
| `devtools/` | Development tools config (LSP, Formatter)     |

## Custom Modules

| Module        | Function                   | Description                                                                        |
| ------------- | -------------------------- | ---------------------------------------------------------------------------------- |
| **pack**      | Package manager            | Lightweight plugin manager with lazy loading (startup/filetype/event-based)       |
| **autoim**    | Auto input method switch   | Automatically switch input methods between insert/normal modes for CN/EN editing  |
| **colors**    | Theme management           | Integrate external `clrs` tool for dynamic color scheme loading                   |
| **highlight** | Highlight group manager    | Unified management of custom highlight groups (native, LSP, UI, plugins)          |

## Plugin List

### Editing Enhancement

| Plugin                | Function                                |
| --------------------- | --------------------------------------- |
| **blink.cmp**         | Fast completion engine                  |
| **copilot.lua**       | GitHub Copilot AI assistance            |
| **mini.pairs**        | Auto bracket pairing                    |
| **mini.surround**     | Quick surround editing (brackets, quotes) |
| **mini.ai**           | Enhanced text objects                   |
| **nvim-ts-autotag**   | HTML/JSX tag auto-closing               |
| **friendly-snippets** | Code snippet collection                 |

### Development Tools

| Plugin                        | Function                                      |
| ----------------------------- | --------------------------------------------- |
| **nvim-lspconfig**            | LSP client configuration                      |
| **mason.nvim**                | LSP/DAP/Linter/Formatter package manager      |
| **mason-lspconfig.nvim**      | Bridge between Mason and LSP                  |
| **mason-tool-installer.nvim** | Auto-install Mason tools                      |
| **conform.nvim**              | Async code formatting                         |
| **lazydev.nvim**              | Neovim Lua development enhancement            |
| **gitsigns.nvim**             | Git status display and operations             |
| **todo-comments.nvim**        | TODO comment highlighting and search          |

### Syntax & Parsing

| Plugin              | Function                           |
| ------------------- | ---------------------------------- |
| **nvim-treesitter** | Syntax parsing and highlighting    |
| **ts-comments.nvim** | Smart commenting (Treesitter-based) |
| **nvim-origami**    | Code folding optimization          |

### UI Enhancement

| Plugin                      | Function                           |
| --------------------------- | ---------------------------------- |
| **heirline.nvim**           | Highly customizable statusline/tabline |
| **snacks.nvim**             | UI component collection (notifications, inputs, etc.) |
| **render-markdown.nvim**    | Markdown live preview              |
| **nvim-highlight-colors**   | Color code visualization           |
| **colorful-menu.nvim**      | Colorful completion menu           |
| **nvim-web-devicons**       | File type icons                    |
| **guess-indent.nvim**       | Auto-detect indentation            |

### File Management

| Plugin      | Function                     |
| ----------- | ---------------------------- |
| **oil.nvim** | Buffer-like file explorer    |

### AI Tools

| Plugin            | Function                       |
| ----------------- | ------------------------------ |
| **opencode.nvim** | OpenCode AI assistant integration |

## Quick Start

### Installation

```bash
# Backup existing configuration
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this configuration
git clone <your-repo-url> ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

### Dependencies

| Dependency      | Required | Description                            |
| --------------- | -------- | -------------------------------------- |
| Neovim >= 0.10  | ✓        | Editor itself                          |
| Git             | ✓        | Plugin download                        |
| Nerd Font       | Recommended | Icon display                        |
| ripgrep         | Optional | Search functionality                   |
| `clrs`          | Optional | Theme management tool (colors module) |
| `im-select` / `fcitx-remote` | Optional | Input method switching (autoim module) |

## Customization

| Path                              | Purpose                        |
| --------------------------------- | ------------------------------ |
| `lua/core/options.lua`            | Editor options                 |
| `lua/core/keymaps.lua`            | Keybindings                    |
| `lua/plugins/`                    | Add/modify plugin configs      |
| `lua/devtools/lsps.lua`           | LSP server configuration       |
| `lua/devtools/formatters.lua`     | Formatter configuration        |
| `lua/modules/autoim/config.lua`   | Input method switch config     |

## Features

### Dynamic Path Rendering

The tabline intelligently adapts path display based on available space:

**Configuration** (`lua/plugins/ui/heirline/tabline.lua`):
```lua
M.truncate_config = {
    max_length = 30,    -- Maximum length before truncation
    keep_prefix = 15,   -- Characters to keep at start
    keep_suffix = 10,   -- Characters to keep at end
}
```

**Example**:
- Original: `@reolink-web+bff-business@2.0.24-beta.53_@reolink+web.fe.http-client@1.9.2_axios@1.8.4__e4bda360cd87d5177aca9c72bd8de5d4`
- Truncated: `@reolink-web+bf…72bd8de5d4`

## License

MIT
