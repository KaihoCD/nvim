return {
	{
		'echasnovski/mini.pairs',
		event = 'VeryLazy',
		version = false,
		opts = {},
	},
	{
		'echasnovski/mini.ai',
		event = 'VeryLazy',
		version = false,
		opts = {},
	},
	{
		'echasnovski/mini.surround',
		event = 'VeryLazy',
		version = false,
		opts = {},
	},
	-- Comments
	{
		'folke/ts-comments.nvim',
		event = 'VeryLazy',
		opts = {},
	},

	-- Doc comments
	{
		'danymat/neogen',
		event = 'InsertEnter',
		keys = {
			{
				'gcd',
				function()
					require('neogen').generate()
				end,
				desc = 'Generate Annotations (Neogen)',
			},
		},
		opts = {},
	},
	-- Completion
	{
		'folke/lazydev.nvim',
		ft = 'lua', -- only load on lua files
		cmd = 'LazyDev',
		opts = {
			library = {
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
				{ path = 'snacks.nvim', words = { 'Snacks' } },
				{ path = 'lazy.nvim', words = { 'LazyVim' } },
			},
		},
	},
	{
		'saghen/blink.cmp',
		event = 'InsertEnter',
		version = '1.*',
		dependencies = {
			{ 'xzbdmw/colorful-menu.nvim', 'rafamadriz/friendly-snippets' },
		},
		keys = { ':', '/' }, -- load when into cmdline
		opts = require('plugins.coding.blink').opts,
	},
	-- auto im
	{
		'keaising/im-select.nvim',
		config = function()
			local opts = {}

			if vim.fn.has('mac') == 1 then
				opts = {
					default_im_select = 'com.apple.keylayout.ABC',
					default_command = 'macism',
				}
			elseif vim.fn.has('win32') == 1 then
				opts = {
					default_im_select = '1033',
					default_command = 'im-select.exe',
				}
			elseif vim.fn.has('unix') == 1 then
				local is_wsl = vim.fn.has('wsl') == 1
				if is_wsl then
					opts = {
						default_im_select = '1033',
						default_command = 'im-select.exe',
					}
				else
					opts = {
						default_im_select = 'keyboard-us',
						default_command = 'fcitx5-remote',
					}
				end
			end

			require('im_select').setup(opts)
		end,
	},
}
