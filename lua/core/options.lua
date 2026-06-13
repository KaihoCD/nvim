-- Leader Settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- UI settings
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 0
vim.g.netrw_keepdir = 0
vim.g.netrw_preview = 0
vim.g.netrw_sort_sequence = [[[\/]$,*]]
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.fillchars = { msgsep = '─', eob = ' ' }
vim.opt.mouse = 'a'
vim.opt.laststatus = 3
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.cmdheight = 0

-- Wrapping & indentation
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = '┆ '
vim.opt.breakindentopt = { list = -1 }
vim.opt.list = true
vim.opt.listchars = { trail = '·', tab = '→ ', nbsp = '␣' }
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Editing
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.virtualedit = 'block'
vim.opt.undofile = true
vim.opt.clipboard = 'unnamedplus'

-- Windows & splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = 'screen'
vim.opt.smoothscroll = true

-- Files & buffers
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.confirm = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'nosplit'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'

-- UX & performance
vim.opt.jumpoptions = 'stack,view'
vim.opt.completeopt = 'noselect'
vim.opt.wildmenu = false
vim.opt.updatetime = 500
vim.opt.timeoutlen = 500
vim.opt.shortmess:append({ W = true, c = true, C = true })
