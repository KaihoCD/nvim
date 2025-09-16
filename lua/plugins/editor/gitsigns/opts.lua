local border_style = G.status.border_style

return {
	signs = {
		add = { text = '┃' },
		change = { text = '┃' },
		delete = { text = '' },
		topdelete = { text = '' },
		changedelete = { text = '┃' },
		untracked = { text = '┆' },
	},
	signs_staged = {
		add = { text = '┃' },
		change = { text = '┃' },
		delete = { text = '' },
		topdelete = { text = '' },
		changedelete = { text = '┃' },
		untracked = { text = '┆' },
	},
	on_attach = require('plugins.editor.gitsigns.onattach'),
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 500,
	},
	preview_config = {
		border = border_style,
	},
}
