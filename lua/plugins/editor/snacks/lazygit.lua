local border_style = G.setting.border_style

local M = {}

M.opts = {
	configure = true,
	config = {
		gui = {
			border = border_style,
			statusPanelView = 'allBranchesLog',
		},
	},
}

return M
