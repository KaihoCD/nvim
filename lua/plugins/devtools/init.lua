local format = require('plugins.devtools.format')
local lint = require('plugins.devtools.lint')
local lsp = require('plugins.devtools.lsp')

vim.schedule(function()
	if not Snacks then
		return
	end
	Snacks.toggle({
		name = 'Format on Save',
		get = function()
			return G.config.format_on_save
		end,
		set = function()
			G.config.format_on_save = not G.config.format_on_save
		end,
	}):map('<leader>cf')
end)

return {
	{
		'neovim/nvim-lspconfig',
		event = 'VeryLazy',
		dependencies = {
			'mason-org/mason.nvim',
			'mason-org/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			'saghen/blink.cmp',
		},
		config = lsp.config,
	},
	{
		'stevearc/conform.nvim',
		event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
		cmd = { 'ConformInfo' },
		keys = format.keys,
		opts = format.opts,
	},
	{
		'mfussenegger/nvim-lint',
		event = 'VeryLazy',
		opts = lint.opts,
		config = lint.config,
	},
}
