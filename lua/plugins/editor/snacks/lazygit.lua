local M = {}

M.opts = {
	configure = true,
	config = {
		gui = {
			border = G.get_border_style(true),
			statusPanelView = 'allBranchesLog',
		},
	},
}

return M
