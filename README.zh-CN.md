# Neovim 配置

English | [中文文档](./README.md)

> **重要提示**：此分支**不再积极维护**。配置针对 Neovim >= 0.10 开发（主要在 0.11.x 上测试）。部分配置可能已过时或与新版本 Neovim 不兼容。如遇到错误或兼容性问题，需要自行解决。如需维护版本，请使用 [beta-2](https://github.com/KaihoCD/nvim/tree/beta-2) 分支（需要 Neovim >= 0.12）。

个人 Neovim 配置，采用 lazy.nvim 的模块化架构。

## 目录结构

```
├── init.lua              # 入口文件
├── lua/
│   ├── core/            # 核心 Neovim 设置
│   ├── hook/            # 插件前钩子
│   │   ├── auto-im/     # 自动输入法切换
│   │   ├── autoclose/   # 智能窗口自动关闭
│   │   ├── buffer/      # 每标签页缓冲区管理
│   │   └── highlight/   # 主题自适应高亮
│   ├── modules/         # 自定义模块
│   │   ├── colors/      # 色彩提取系统
│   │   └── highlight/   # 高亮管理
│   ├── plugins/         # 插件配置
│   │   ├── coding/      # 编辑与补全
│   │   ├── devtools/    # LSP、格式化、检查
│   │   ├── editor/      # 编辑器功能
│   │   ├── treesitter/  # 语法与文本对象
│   │   ├── ui/          # 主题与 UI 组件
│   │   └── utils/       # 工具插件
│   └── utils/           # 辅助函数
└── stylua.toml
```

## 自定义模块

| 模块                  | 说明                               |
| --------------------- | ---------------------------------- |
| **modules/colors**    | 从任意配色方案提取颜色             |
| **modules/highlight** | 类型安全的高亮组管理               |
| **hook/auto-im**      | 自动输入法切换（中英文上下文感知） |
| **hook/autoclose**    | 退出时自动关闭辅助窗口             |
| **hook/buffer**       | 每标签页缓冲区列表与智能导航       |
| **hook/highlight**    | 为插件应用主题自适应高亮           |

## 插件

### 编码工具

- **blink.cmp** - 补全引擎
- **mini.pairs**、**mini.ai**、**mini.surround** - 编辑工具
- **ts-comments.nvim** - 智能注释
- **neogen** - 文档生成
- **lazydev.nvim** - Lua 开发

### 开发工具

- **nvim-lspconfig** + **mason.nvim** - LSP 管理
- **conform.nvim** - 格式化（切换：`<leader>cf`）
- **nvim-lint** - 代码检查（切换：`<leader>cl`）

### 编辑器

- **snacks.nvim** - 文件选择器、终端、浏览器、通知
- **gitsigns.nvim** - Git 装饰
- **flash.nvim** - 跳转导航
- **which-key.nvim** - 按键提示
- **todo-comments.nvim** - TODO 高亮
- **guess-indent.nvim** - 缩进检测

### UI

- **主题**：nightfox（默认）、tokyonight、catppuccin、everforest、ayu
- **heirline.nvim** - 状态栏与标签栏
- **edgy.nvim** - 侧边栏管理
- **noice.nvim** - 增强 UI
- **nvim-origami** - 折叠
- **render-markdown.nvim** - Markdown 预览
- **nvim-highlight-colors** - 颜色预览

### Treesitter

- **nvim-treesitter** - 语法高亮
- **nvim-treesitter-textobjects** - 文本对象

### 工具

- **plenary.nvim**、**nui.nvim** - Lua 工具库
- **vim-tmux-navigator** - Tmux/Vim 导航

## 许可证

MIT
