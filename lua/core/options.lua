-- Global state
vim.g.status = {
	format_on_save = true, ---@type boolean
  ui_style = 'borderless', ---@type UiType
  icon_type = 'nerdfont', ---@type IconType
	-- ui_style = 'border', ---@type UiType
	-- icon_type = 'termicons', ---@type IconType
	border_style = 'single', ---@type BorderType
}

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.colors_name = 'default' -- Default theme name
vim.o.background = 'dark' -- Default colors theme

-- UI
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.signcolumn = 'yes'
vim.opt.list = true
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.laststatus = 3
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Text render
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = '┆ '
vim.opt.breakindentopt = { list = -1 }
vim.opt.listchars = { trail = '·', tab = '→ ', nbsp = '␣' }
vim.opt.fillchars = { eob = ' ' }

-- Edit behavior
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.shiftround = true
vim.opt.virtualedit = 'block'
vim.opt.undofile = true
vim.opt.clipboard = 'unnamedplus'

-- Window management and scrlling
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = 'screen'
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8

-- File handling
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.confirm = true

-- Search behavior
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.inccommand = 'nosplit'

-- Interaction and UX
vim.opt.jumpoptions = 'view'
vim.opt.completeopt = 'noselect'
vim.opt.wildmenu = false
vim.opt.smoothscroll = true
vim.opt.shortmess:append({ W = true, c = true, C = true })
