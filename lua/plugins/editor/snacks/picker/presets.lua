local margin_top = G.margin.top
local border_style = G.get_border_style()

local picker_winhl = table.concat({
	'EndOfBuffer:MainFloatBg',
	'Normal:MainFloatBg',
	'NormalNC:MainFloatBg',
	'NormalSB:MainFloatBg',
	'NormalFloat:MainFloatBg',
	'FloatBorder:MainFloatBorder',
	'FloatTitle:MainFloatTitle',
}, ',')

local sidebar_input_winhl = table.concat({
	'Normal:SnacksPickerExplorerNormal',
	'NormalNC:SnacksPickerExplorerNormal',
	'NormalFloat:SnacksPickerExplorerTitle',
	'SnacksPickerPrompt:SnacksPickerExplorerPrompt',
	'FloatBorder:SnacksPickerExplorerBorder',
	'FloatTitle:SnacksPickerExplorerBorder',
}, ',')

local sidebar_list_winhl = table.concat({
	'Normal:SnacksPickerExplorerNormal',
	'NormalNC:SnacksPickerExplorerNormal',
}, ',')

local M = {}

M.default = {
	reverse = false,
	layout = {
		box = 'horizontal',
		backdrop = false,
		width = G.size.float_width,
		height = G.size.float_height,
		border = 'none',
		{
			box = 'vertical',
			{
				win = 'input',
				height = 1,
				border = border_style,
				title = '{title} {live} {flags}',
				title_pos = 'center',
			},
			{
				win = 'list',
				title = ' Results ',
				title_pos = 'center',
				border = border_style,
				wo = {
					winhighlight = picker_winhl,
				},
			},
		},
		{
			win = 'preview',
			title = '{preview:Preview}',
			width = 0.5,
			border = border_style,
			title_pos = 'center',
			wo = {
				winhighlight = picker_winhl,
			},
		},
	},
}

M.vertical = {
	layout = {
		backdrop = false,
		width = G.size.float_width,
		height = G.size.float_height,
		box = 'vertical',
		border = 'none',
		{
			win = 'input',
			title = '{title} {live} {flags}',
			title_pos = 'center',
			height = 1,
			border = border_style,
		},
		{
			win = 'list',
			title = ' Results ',
			title_pos = 'center',
			border = border_style,
			wo = {
				winhighlight = picker_winhl,
			},
		},
		{
			win = 'preview',
			title = '{preview}',
			height = 0.7,
			border = border_style,
			wo = {
				winhighlight = picker_winhl,
			},
		},
	},
}

M.sidebar = {
	preview = 'main',
	layout = {
		backdrop = false,
		width = 40,
		min_width = 40,
		height = 0,
		position = 'left',
		border = 'right',
		box = 'vertical',
		{
			win = 'input',
			height = 1,
			border = G.get_border_style(true),
			title = '{title} {live} {flags}',
			title_pos = 'center',
			wo = {
				winhighlight = sidebar_input_winhl,
			},
		},
		{
			win = 'list',
			border = 'none',
			wo = {
				winhighlight = sidebar_list_winhl,
			},
		},
		{ win = 'preview' },
	},
}

M.select = {
	preview = false,
	layout = {
		backdrop = false,
		row = margin_top,
		width = G.size.float_width / 2,
		height = G.size.float_height / 2,
		min_height = 7,
		box = 'vertical',
		{
			title = '{title}',
			title_pos = 'center',
			win = 'input',
			height = 1,
			border = border_style,
		},
		{
			win = 'list',
			border = border_style,
			wo = {
				winhighlight = picker_winhl,
			},
		},
	},
}

return M
