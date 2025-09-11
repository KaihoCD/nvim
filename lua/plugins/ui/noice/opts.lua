local border_style = G.get_border_style()

local confirm_view_opts = {
	border = { style = border_style },
	position = { row = G.margin.top, col = '50%' },
	win_options = {
		winhighlight = {
			FloatBorder = 'NoiceConfirmBorder',
			FloatTitle = 'NoiceConfirmTitle',
		},
	},
	format = {
		{ '{confirm}', before = '\n' },
	},
}

local popup_views_opts = {
	border = { style = border_style },
	position = { row = G.margin.top, col = '50%' },
}

return {
	-- 不使用Noice接管lsp服务
	lsp = {
		progress = { enabled = false },
		signature = { enabled = false },
		hover = { enabled = false },
	},
	cmdline = {
		view = 'cmdline_popup',
		format = {
			cmdline = {
				pattern = '^:',
				icon = '',
				lang = 'vim',
				title = ' Command Line ',
			},
			search_down = {
				kind = 'search',
				pattern = '^/',
				icon = ' ',
				lang = 'regex',
			},
			search_up = {
				kind = 'search',
				pattern = '^%?',
				icon = ' ',
				lang = 'regex',
			},
			filter = { pattern = '^:%s*!', icon = '', lang = 'bash' },
			help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
			lua = {
				pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s+', '^:%s*=%s+' },
				icon = G.other.lua,
				lang = 'lua',
			},
		},
	},
	views = {
		split = { scrollbar = false },
		confirm = confirm_view_opts,
		cmdline_popup = popup_views_opts,
		cmdline_input = popup_views_opts,
	},
	commands = {
		last = {
			view = 'split',
		},
	},
	routes = {
		{
			filter = {
				event = 'msg_show',
				any = {
					{ find = '%d+L, %d+B' },
					{ find = '; after #%d+' },
					{ find = '; before #%d+' },
					{ find = '%d fewer lines' },
					{ find = '%d more lines' },
				},
			},
		},
	},
	format = {
		details = {
			'{level} ',
			'{date} ',
			'{title} ',
			'{message}',
		},
	},
	presets = {
		long_message_to_split = true,
	},
}
