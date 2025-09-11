return {
	-- library used by other plugins
	{ 'nvim-lua/plenary.nvim', lazy = true },
	{
		'folke/snacks.nvim',
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
		},
	},
}
