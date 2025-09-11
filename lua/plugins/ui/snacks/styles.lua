local float_winhl = table.concat({
	'NormalFloat:SubFloatBg',
	'FloatBorder:SubFloatBorder',
	'FloatTitle:SubFloatTitle',
	'EndOfBuffer:SubFloatBg',
}, ',')

local border_style = G.get_border_style()

return {
	input = {
		border = border_style,
		row = G.margin.top,
	},
	lazygit = {
		backdrop = false,
		title = '  lazygit ',
		title_pos = 'center',
		border = border_style,
		wo = {
			winhighlight = float_winhl,
		},
	},
	help = {
		backdrop = false,
		position = 'float',
		title = '  Keymaps Help ',
		title_pos = 'center',
		border = border_style,
		row = -2,
		width = G.size.float_width,
		height = 0.3,
		wo = {
			winhighlight = float_winhl,
		},
	},
	terminal = {
		title = '  Terminal ',
		title_pos = 'center',
		backdrop = false,
		width = G.size.float_width,
		height = G.size.float_height,
		border = border_style,
		wo = {
			winhighlight = float_winhl,
		},
	},
	notification = {
		border = border_style,
		wo = {
			wrap = true,
			winhighlight = float_winhl,
		},
	},
	notification_history = {
		border = G.get_border_style(true),
		col = 40,
		wo = { wrap = true },
	},
	blame_line = { border = G.border_style },
	scratch = { border = G.border_style },
	snacks_image = { border = G.border_style },
}
