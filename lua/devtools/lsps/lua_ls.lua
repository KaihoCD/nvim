local lua_ls = {
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'Snacks' },
				disable = { 'unused-function' },
			},
			hint = {
				enable = true,
				arrayIndex = 'Enable',
				setType = true,
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
}

return lua_ls
