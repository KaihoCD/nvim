local setup_onattach = require('plugins.devtools.lsp.onattach')

local diag_icons = G.symbols.diag
local size = G.layout.size
local border_style = G.status.border_style

local SEVERITY = {
	ERROR = vim.diagnostic.severity.ERROR,
	WARN = vim.diagnostic.severity.WARN,
	INFO = vim.diagnostic.severity.INFO,
	HINT = vim.diagnostic.severity.HINT,
}

local function setup_diagbostic()
	vim.diagnostic.config({
		update_in_insert = true,
		severity_sort = true,
		virtual_text = {
			spacing = 2,
			source = 'if_many',
			format = function(diag)
				local diagnostic_message = {
					[SEVERITY.ERROR] = diag.message,
					[SEVERITY.WARN] = diag.message,
					[SEVERITY.INFO] = diag.message,
					[SEVERITY.HINT] = diag.message,
				}
				return diagnostic_message[diag.severity]
			end,
		},
		signs = {
			text = {
				[SEVERITY.ERROR] = diag_icons.error,
				[SEVERITY.WARN] = diag_icons.warn,
				[SEVERITY.INFO] = diag_icons.info,
				[SEVERITY.HINT] = diag_icons.hint,
			},
		},
		float = {
			border = border_style,
			source = 'if_many',
		},
	})
end

return function()
	local devtools = require('devtools')

	require('mason').setup({
		ui = {
			width = size.float_width,
			height = size.float_height,
		},
	})

	-- check update of lsp servers
	require('mason-tool-installer').setup({
		ensure_installed = devtools.get_installed(),
	})

	local extra_capabilities = {
		require('blink.cmp').get_lsp_capabilities(),
	}

	-- attach lsp
	for lsp_name, lsp_config in pairs(devtools.get_lsps()) do
		lsp_config.capabilities =
			vim.tbl_deep_extend('force', {}, extra_capabilities, lsp_config.capabilities or {})
		require('lspconfig')[lsp_name].setup(lsp_config)
	end

	setup_diagbostic()
	setup_onattach()
end
