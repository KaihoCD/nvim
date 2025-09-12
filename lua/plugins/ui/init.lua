local edgy = require('plugins.ui.edgy')
local heirline = require('plugins.ui.heirline')
local markdown = require('plugins.ui.markdown')
local noice = require('plugins.ui.noice')
local snacks = require('plugins.ui.snacks')

local use_or = require('utils.funcs').use_or

return {
	-- Load theme plugins
	require('plugins.ui.themes'),
	-- icons
	use_or(
		{
			'nvim-tree/nvim-web-devicons',
			event = 'VeryLazy',
			opts = {},
		},
		G.termicons(),
		{
			'mskelton/termicons.nvim', -- Need font "termicons"
			event = 'VeryLazy',
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			build = false,
			opts = {},
		}
	),
	{
		'rebelot/heirline.nvim',
		event = 'VeryLazy',
		config = heirline.config,
	},
	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		opts = snacks.opts,
	},
	{
		'folke/edgy.nvim',
		event = 'VeryLazy',
		opts = edgy.opts,
	},
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		dependencies = {
			'MunifTanjim/nui.nvim',
		},
		keys = noice.keys,
		opts = noice.opts,
		config = noice.config,
	},
	-- folding
	{
		'chrisgrieser/nvim-origami',
		event = 'VeryLazy',
		opts = {
			foldtext = {
				lineCount = {
					template = ' 󰘕 %d lines ',
					hlgroup = 'Function',
				},
			},
			autoFold = { enabled = false },
			foldKeymaps = { setup = false },
		},
	},
	-- markdown
	{
		'MeanderingProgrammer/render-markdown.nvim',
		event = 'VeryLazy',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
		opts = markdown.opts,
	},
	{
		'brenoprata10/nvim-highlight-colors',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			render = 'virtual',
			virtual_symbol = G.other.palette,
		},
	},
}
