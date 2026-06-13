# Neovim Configuration

[中文文档](./README.zh-CN.md) | English

Personal Neovim configuration built with Lua for modern development.

## Core Architecture

| Directory   | Description                                     |
| ----------- | ----------------------------------------------- |
| `core/`     | Core configs: options, keymaps, autocmds        |
| `modules/`  | Custom modules (see details below)              |
| `plugins/`  | Plugin configuration files                      |
| `state/`    | Global state management with persistent storage |
| `utils/`    | Utility function library                        |
| `devtools/` | Development tools config (LSP, Formatter)       |

## Custom Modules

| Module        | Function                 | Description                                                                      |
| ------------- | ------------------------ | -------------------------------------------------------------------------------- |
| **pack**      | Package manager          | Lightweight plugin manager with lazy loading (startup/filetype/event-based)      |
| **autoim**    | Auto input method switch | Automatically switch input methods between insert/normal modes for CN/EN editing |
| **colors**    | Theme management         | Integrate external `clrs` tool for dynamic color scheme loading                  |
| **highlight** | Highlight group manager  | Unified management of custom highlight groups (native, LSP, UI, plugins)         |

## Plugin List

### Editing Enhancement

| Plugin                | Function                                  |
| --------------------- | ----------------------------------------- |
| **blink.cmp**         | Fast completion engine                    |
| **copilot.lua**       | GitHub Copilot AI assistance              |
| **mini.pairs**        | Auto bracket pairing                      |
| **mini.surround**     | Quick surround editing (brackets, quotes) |
| **mini.ai**           | Enhanced text objects                     |
| **nvim-ts-autotag**   | HTML/JSX tag auto-closing                 |
| **friendly-snippets** | Code snippet collection                   |

### Development Tools

| Plugin                        | Function                                 |
| ----------------------------- | ---------------------------------------- |
| **nvim-lspconfig**            | LSP client configuration                 |
| **mason.nvim**                | LSP/DAP/Linter/Formatter package manager |
| **mason-lspconfig.nvim**      | Bridge between Mason and LSP             |
| **mason-tool-installer.nvim** | Auto-install Mason tools                 |
| **conform.nvim**              | Async code formatting                    |
| **lazydev.nvim**              | Neovim Lua development enhancement       |
| **gitsigns.nvim**             | Git status display and operations        |
| **todo-comments.nvim**        | TODO comment highlighting and search     |

### Syntax & Parsing

| Plugin               | Function                            |
| -------------------- | ----------------------------------- |
| **nvim-treesitter**  | Syntax parsing and highlighting     |
| **ts-comments.nvim** | Smart commenting (Treesitter-based) |
| **nvim-origami**     | Code folding optimization           |

### UI Enhancement

| Plugin                    | Function                                              |
| ------------------------- | ----------------------------------------------------- |
| **heirline.nvim**         | Highly customizable statusline/tabline                |
| **snacks.nvim**           | UI component collection (notifications, inputs, etc.) |
| **render-markdown.nvim**  | Markdown live preview                                 |
| **nvim-highlight-colors** | Color code visualization                              |
| **colorful-menu.nvim**    | Colorful completion menu                              |
| **nvim-web-devicons**     | File type icons                                       |
| **guess-indent.nvim**     | Auto-detect indentation                               |

### File Management

| Plugin       | Function                  |
| ------------ | ------------------------- |
| **oil.nvim** | Buffer-like file explorer |

### AI Tools

| Plugin            | Function                          |
| ----------------- | --------------------------------- |
| **opencode.nvim** | OpenCode AI assistant integration |

## Dependencies

| Dependency                   | Required    | Description                            |
| ---------------------------- | ----------- | -------------------------------------- |
| Neovim >= 0.12               | ✓           | Editor itself                          |
| Git                          | ✓           | Plugin download                        |
| Nerd Font                    | Recommended | Icon display                           |
| ripgrep                      | Optional    | Search functionality                   |
| `clrs`                       | Optional    | Theme management tool (colors module)  |
| `im-select` / `fcitx-remote` | Optional    | Input method switching (autoim module) |

## Customization

| Path                            | Purpose                    |
| ------------------------------- | -------------------------- |
| `lua/core/options.lua`          | Editor options             |
| `lua/core/keymaps.lua`          | Keybindings                |
| `lua/plugins/`                  | Add/modify plugin configs  |
| `lua/devtools/lsps.lua`         | LSP server configuration   |
| `lua/devtools/formatters.lua`   | Formatter configuration    |
| `lua/modules/autoim/config.lua` | Input method switch config |

## Why Beta-2 is discontinued

- **Snacks became too heavy.** The picker pulled in an entire UI component library.
  Most features went unused, and searches would freeze on larger projects. Tight
  coupling made it impossible to replace the picker alone.

- **heirline's git component had performance issues.** The statusline itself worked
  well, but the git branch detection mechanism suffered from performance problems and
  compatibility quirks in certain buffer types.

- **UI state management added little real value.** The state and package management
  frameworks are sound in design. What proved unnecessary was the UI type layer
  maintaining borderless/bordered theming — it was never toggled in daily use and
  only added maintenance overhead.

- **The borderless UI type was dropped.** It never achieved a satisfying visual
  result despite significant effort. Given the maintenance cost and unresolved
  aesthetic gaps, it was removed.

- **Some operations fit commands better than keymaps.** Not a rejection of hotkeys,
  but custom commands (`:LspConfig`, `:Format`) proved more discoverable and easier
  to recall in certain cases, without requiring additional keymap maintenance.

The configuration had already been moving toward a lighter setup. These were the
remaining rough edges.

What Beta-2 got right: a vim-pack-based plugin loading mechanism, adapting to native
buffer operations without bufferline, a practical utility library, and a deeper
understanding that **configuration should serve the workflow, not constrain it.**

## License

MIT
