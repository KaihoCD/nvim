local border_style = G.setting.border_style
local title_pos = G.context.whichkey_title_pos
local margin = G.layout.margin

local M = {}

M.opts = {
	preset = 'helix',
	show_help = false,
	win = {
		col = -margin.right,
		row = -margin.bottom,
		border = border_style,
		padding = { 0, 2 },
		title_pos = title_pos,
	},
	icons = {
		keys = {
			BS = '←',
			Space = '󰄼',
			Tab = '⇥',
		},
	},
	spec = {
		{ '<leader>b', group = '[b]uffer', icon = '󰈔' },
		{ '<leader>c', group = '[c]onfig', icon = '' },
		{ '<leader>f', group = '[f]ind', icon = '󰱼' },
		{ '<leader>l', group = '[l]sp', icon = '󰿘', mode = { 'n', 'v' } },
		{ '<leader>s', group = '[s]earch', icon = '', mode = { 'n', 'v' } },
		{ '<leader>g', group = '[g]it', icon = '', mode = { 'n', 'v' } },
		{ '<leader>h', group = '[h]unk', icon = '' },
		{ '<leader>u', group = '[u]i', icon = '󰙵' },
		{ '<leader>n', group = '[n]oice', icon = '󰍩' },
		{ '<leader>x', group = '[x]/trouble', icon = '' },
		{ '<leader>t', group = '[t]ranslate', icon = '󰊿', mode = { 'n', 'v' } },
		{ '<leader>w', group = '[w]inbar', icon = '' },
		{ '<leader><tab>', group = '[<Tab>]Tab', icon = '' },
	},
}

return M
