local border_style = G.status.border_style
local size = G.layout.size
local margin = G.layout.margin

local float_winhl = table.concat({
	'EndOfBuffer:MainNormalFloat',
	'NormalFloat:NormalFloat',
	'FloatTitle:MainFloatTitle',
	'FloatBorder:MainFloatBorder',
}, ',')

return {
	input = {
		border = border_style,
		row = margin.top,
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
		width = size.float_width,
		height = 0.3,
		wo = {
			winhighlight = float_winhl,
		},
	},
	terminal = {
		title = '  Terminal ',
		title_pos = 'center',
		backdrop = false,
		width = size.float_width,
		height = size.float_height,
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
		border = border_style,
		col = 40,
		wo = { wrap = true },
	},
	blame_line = { border = border_style },
	scratch = { border = border_style },
	snacks_image = { border = border_style },
}
