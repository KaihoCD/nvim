local edgy = require('plugins.ui.edgy')
local heirline = require('plugins.ui.heirline')
local markdown = require('plugins.ui.markdown')
local noice = require('plugins.ui.noice')
local snacks = require('plugins.ui.snacks')

return {
	-- Load theme plugins
	require('plugins.ui.themes'),
	-- icons
	require('plugins.ui.icons'),
	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		opts = snacks.opts,
	},
	{
		'rebelot/heirline.nvim',
		event = 'VeryLazy',
		config = heirline.config,
	},
	{
		'folke/edgy.nvim',
		event = 'VeryLazy',
		opts = edgy.opts,
	},
	{
		'folke/noice.nvim',
		priority = 500,
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
			virtual_symbol = '',
		},
	},
}
