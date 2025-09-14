local treesitter = require('plugins.treesitter.treesitter')
return {
	{
		'nvim-treesitter/nvim-treesitter',
		version = false, -- last release is way too old and doesn't work on Windows
		-- event = { 'BufReadPre', 'BufNewFile' },
		event = { 'BufReadPre', 'BufNewFile' },
		build = ':TSUpdate',
		main = 'nvim-treesitter.configs',
		init = treesitter.init,
		opts = treesitter.opts,
	},
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		event = 'VeryLazy',
		config = require('plugins.treesitter.textobjects'),
	},
}
