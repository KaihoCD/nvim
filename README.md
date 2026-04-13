# Neovim Configuration

[中文文档](./README.zh-CN.md) | English

> **Important Notice**: This branch is **no longer actively maintained**. The configuration was developed for Neovim >= 0.10 (primarily tested on 0.11.x). Some configurations may be outdated or incompatible with newer Neovim versions. If you encounter errors or compatibility issues, you will need to resolve them yourself. For a maintained version, please use the [beta-2](https://github.com/KaihoCD/nvim/tree/beta-2) branch (requires Neovim >= 0.12).

Personal Neovim configuration with modular architecture using lazy.nvim.

## Structure

```
├── init.lua              # Entry point
├── lua/
│   ├── core/            # Core Neovim settings
│   ├── hook/            # Pre-plugin hooks
│   │   ├── auto-im/     # Auto input method switching
│   │   ├── autoclose/   # Smart window auto-close
│   │   ├── buffer/      # Per-tab buffer management
│   │   └── highlight/   # Theme-adaptive highlighting
│   ├── modules/         # Custom modules
│   │   ├── colors/      # Color extraction system
│   │   └── highlight/   # Highlight management
│   ├── plugins/         # Plugin configurations
│   │   ├── coding/      # Editing & completion
│   │   ├── devtools/    # LSP, formatting, linting
│   │   ├── editor/      # Editor features
│   │   ├── treesitter/  # Syntax & text objects
│   │   ├── ui/          # Themes & UI components
│   │   └── utils/       # Utility plugins
│   └── utils/           # Helper functions
└── stylua.toml
```

## Custom Modules

| Module                | Description                                       |
| --------------------- | ------------------------------------------------- |
| **modules/colors**    | Extracts colors from any colorscheme              |
| **modules/highlight** | Type-safe highlight group management              |
| **hook/auto-im**      | Auto input method switching (CN/EN context-aware) |
| **hook/autoclose**    | Auto-close auxiliary windows when quitting        |
| **hook/buffer**       | Per-tab buffer lists with smart navigation        |
| **hook/highlight**    | Applies theme-adaptive highlighting to plugins    |

## Plugins

### Coding

- **blink.cmp** - Completion engine
- **mini.pairs**, **mini.ai**, **mini.surround** - Editing utilities
- **ts-comments.nvim** - Smart comments
- **neogen** - Doc generation
- **lazydev.nvim** - Lua development

### DevTools

- **nvim-lspconfig** + **mason.nvim** - LSP management
- **conform.nvim** - Formatting (toggle: `<leader>cf`)
- **nvim-lint** - Linting (toggle: `<leader>cl`)

### Editor

- **snacks.nvim** - File picker, terminal, explorer, notifications
- **gitsigns.nvim** - Git decorations
- **flash.nvim** - Jump navigation
- **which-key.nvim** - Keybind hints
- **todo-comments.nvim** - TODO highlighting
- **guess-indent.nvim** - Indent detection

### UI

- **Themes**: nightfox (default), tokyonight, catppuccin, everforest, ayu
- **heirline.nvim** - Statusline & tabline
- **edgy.nvim** - Sidebar management
- **noice.nvim** - Enhanced UI
- **nvim-origami** - Folding
- **render-markdown.nvim** - Markdown preview
- **nvim-highlight-colors** - Color preview

### Treesitter

- **nvim-treesitter** - Syntax highlighting
- **nvim-treesitter-textobjects** - Text objects

### Utils

- **plenary.nvim**, **nui.nvim** - Lua utilities
- **vim-tmux-navigator** - Tmux/Vim navigation

## License

MIT
