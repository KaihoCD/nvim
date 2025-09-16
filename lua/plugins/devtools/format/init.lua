local M = {}

M.opts = {
	notify_no_formatters = true,
	notify_on_error = true,

	formatters_by_ft = {
		javascript = { 'prettierd', 'eslint_d' },
		typescript = { 'prettierd', 'eslint_d' },
		javascriptreact = { 'prettierd', 'eslint_d' },
		typescriptreact = { 'prettierd', 'eslint_d' },
		css = { 'prettierd' },
		html = { 'prettierd' },
		json = { 'prettierd' },
		yaml = { 'prettierd' },
		vue = { 'prettierd', 'eslint_d' },
		markdown = { 'prettierd', 'cbfmt' },
		lua = { 'stylua' },
		zsh = { 'shfmt' },
		bash = { 'shfmt' },
	},

	format_on_save = function()
		if vim.g.format_on_save then
			return {
				timeout_ms = 500,
				lsp_format = 'fallback',
			}
		else
			return nil
		end
	end,
}

M.keys = {
	{
		'<leader>lf',
		function()
			require('conform').format({ async = true, lsp_format = 'fallback' })
		end,
		desc = '[f]ormat file',
	},
}

return M
