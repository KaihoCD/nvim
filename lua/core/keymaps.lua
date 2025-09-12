local map = require('utils.funcs').map

local function map_nav(dir)
	return function()
		local cfg = vim.api.nvim_win_get_config(0)
		if cfg.relative == '' or cfg.relative == 'win' then
			return vim.cmd.wincmd(dir)
		end
	end
end

map('n', '<Esc>', '<CMD>nohlsearch<CR>', { desc = 'Clear highlights' })

map('n', '<A-Left>', '2<C-w><', { desc = 'Decrease width' })
map('n', '<A-Right>', '2<C-w>>', { desc = 'Increase width' })
map('n', '<A-Down>', '2<C-w>+', { desc = 'Increase height' })
map('n', '<A-Up>', '2<C-w>-', { desc = 'Decrease height' })

map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-c>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map({ 'n', 't' }, '<C-h>', map_nav('h'), { desc = 'Move focus left' })
map({ 'n', 't' }, '<C-l>', map_nav('l'), { desc = 'Move focus right' })
map({ 'n', 't' }, '<C-j>', map_nav('j'), { desc = 'Move focus down' })
map({ 'n', 't' }, '<C-k>', map_nav('k'), { desc = 'Move focus up' })

-- stylua: ignore start
map('n', '<leader><tab>C', '<cmd>tabonly<cr>', { desc = '[C]lose Other Tabs' })
map('n', '<leader><tab><tab>', '<cmd>tabnew %<cr>', { desc = 'New Tab(<tab>) with cur buf' })
map('n', '<leader><tab>n', '<cmd>tabnew<cr>', { desc = '[n]ew Tab' })
map('n', '<leader><tab>l', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>c', '<cmd>tabclose<cr>', { desc = '[c]lose Tab' })
map('n', '<leader><tab>h', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
-- stylua: ignore end

-- native behavior enhancement
map('n', '<C-d>', '<C-d>zz', { desc = 'Page down and center cursor' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Page up and center cursor' })
map('n', '{', '{zz', { desc = 'Jump to previous paragraph' })
map('n', '}', '}zz', { desc = 'Jump to next paragraph' })
map('n', 'n', 'nzzzv', { desc = 'Next search match, center & unfold' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search match, center & unfold' })
map('v', '<', '<gv', { desc = 'Indent left and keep visual selection' })
map('v', '>', '>gv', { desc = 'Indent right and keep visual selection' })
map('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, desc = 'Move down' })
map('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, desc = 'Move up' })

map('n', 'q:', '<nop>')
map('n', 'q/', '<nop>')
map('n', 'q?', '<nop>')
map('n', 'Q', '<nop>')
