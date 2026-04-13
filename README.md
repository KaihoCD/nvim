# Neovim 配置

个人 Neovim 配置，基于 Lua 构建的现代化开发环境。

## 核心架构

| 目录        | 说明                             |
| ----------- | -------------------------------- |
| `core/`     | 核心配置：选项、快捷键、自动命令 |
| `modules/`  | 自定义功能模块（见下方详细说明） |
| `plugins/`  | 插件配置文件                     |
| `state/`    | 全局状态管理系统｜持久化存储     |
| `utils/`    | 工具函数库                       |
| `devtools/` | 开发工具配置（LSP、Formatter）   |

## 自定义模块

| 模块          | 功能           | 说明                                                       |
| ------------- | -------------- | ---------------------------------------------------------- |
| **pack**      | 包管理器       | 轻量级插件管理系统，支持懒加载（启动时/文件类型/事件触发） |
| **autoim**    | 输入法自动切换 | 在插入/正常模式间自动切换输入法，提升中英文混合编辑体验    |
| **colors**    | 主题管理       | 集成外部 `clrs` 工具，动态加载和管理配色方案               |
| **highlight** | 高亮组管理     | 统一管理自定义高亮组（原生、LSP、UI、插件）                |

## 插件清单

### 编辑增强

| 插件                  | 功能                         |
| --------------------- | ---------------------------- |
| **blink.cmp**         | 快速补全引擎                 |
| **copilot.lua**       | GitHub Copilot AI 辅助编码   |
| **mini.pairs**        | 自动括号配对                 |
| **mini.surround**     | 快速包围编辑（括号、引号等） |
| **mini.ai**           | 增强文本对象                 |
| **nvim-ts-autotag**   | HTML/JSX 标签自动闭合        |
| **friendly-snippets** | 代码片段集合                 |

### 开发工具

| 插件                          | 功能                              |
| ----------------------------- | --------------------------------- |
| **nvim-lspconfig**            | LSP 客户端配置                    |
| **mason.nvim**                | LSP/DAP/Linter/Formatter 包管理器 |
| **mason-lspconfig.nvim**      | Mason 与 LSP 的桥接               |
| **mason-tool-installer.nvim** | 自动安装 Mason 工具               |
| **conform.nvim**              | 异步代码格式化                    |
| **lazydev.nvim**              | Neovim Lua 开发增强               |
| **gitsigns.nvim**             | Git 状态显示与操作                |
| **todo-comments.nvim**        | TODO 注释高亮与搜索               |

### 语法与解析

| 插件                 | 功能                        |
| -------------------- | --------------------------- |
| **nvim-treesitter**  | 语法解析与高亮              |
| **ts-comments.nvim** | 智能注释（基于 Treesitter） |
| **nvim-origami**     | 代码折叠优化                |

### UI 增强

| 插件                      | 功能                          |
| ------------------------- | ----------------------------- |
| **heirline.nvim**         | 高度可定制的状态栏/标签页     |
| **snacks.nvim**           | UI 组件集合（通知、输入框等） |
| **render-markdown.nvim**  | Markdown 实时预览             |
| **nvim-highlight-colors** | 颜色代码可视化                |
| **colorful-menu.nvim**    | 彩色补全菜单                  |
| **nvim-web-devicons**     | 文件类型图标                  |
| **guess-indent.nvim**     | 自动检测缩进                  |

### 文件管理

| 插件         | 功能                     |
| ------------ | ------------------------ |
| **oil.nvim** | 类似 buffer 的文件浏览器 |

### AI 工具

| 插件              | 功能                 |
| ----------------- | -------------------- |
| **opencode.nvim** | OpenCode AI 助手集成 |

## 快速开始

### 安装

```bash
# 1. 备份现有配置
mv ~/.config/nvim ~/.config/nvim.bak

# 2. 克隆此配置
git clone <your-repo-url> ~/.config/nvim

# 3. 启动 Neovim（插件将自动安装）
nvim
```

### 依赖

| 依赖                         | 必需 | 说明                        |
| ---------------------------- | ---- | --------------------------- |
| Neovim >= 0.12               | ✓    | 编辑器本体                  |
| Git                          | ✓    | 插件下载                    |
| Nerd Font                    | 推荐 | 图标显示                    |
| ripgrep                      | 可选 | 搜索功能                    |
| `clrs`                       | 可选 | 主题管理工具（colors 模块） |
| `im-select` / `fcitx-remote` | 可选 | 输入法切换（autoim 模块）   |

## 自定义配置

| 路径                            | 用途              |
| ------------------------------- | ----------------- |
| `lua/core/options.lua`          | 编辑器选项        |
| `lua/core/keymaps.lua`          | 快捷键映射        |
| `lua/plugins/`                  | 添加/修改插件配置 |
| `lua/devtools/lsps.lua`         | LSP 服务器配置    |
| `lua/devtools/formatters.lua`   | 格式化工具配置    |
| `lua/modules/autoim/config.lua` | 输入法切换配置    |

## License

MIT
