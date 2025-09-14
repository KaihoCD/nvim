local border_style = G.status.border_style

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
