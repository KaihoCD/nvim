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
	formatters = {
		eslint_d = {},
	},

	format_on_save = function()
		if vim.g.status.format_on_save then
			return {
				timeout_ms = 500,
				lsp_format = 'fallback',
			}
		else
			return nil
		end
	end,
}

local args = { async = false, lsp_format = 'fallback', timeout_ms = 500 }
M.keys = {
	{
		mode = { 'n', 'v' },
		'<leader>ff',
		function()
			require('conform').format(args)
		end,
		desc = '[f]ormat',
	},
	{
		mode = { 'n', 'v' },
		'<leader>lf',
		function()
			require('conform').format(args)
		end,
		desc = '[f]ormat',
	},
}

return M
