_G.G = {}

G.layout = {
	margin = {
		top = 10,
		right = 2,
		bottom = 2,
	},
	size = {
		float_width = 0.8,
		float_height = 0.8,
		split_left = 35,
		split_right = 0.3,
		split_bottom = 0.35,
	},
}

local is_borderless = vim.g.status.ui_style == 'borderless'
local is_termicons = vim.g.status.icon_type == 'termicons'
G.status = {
	ui_style = vim.g.status.ui_style,
	icon_type = vim.g.status.icon_type,
	border_style = vim.g.status.border_style,
	blink_menu_border = is_borderless and 'none' or vim.g.status.border_style,
	lsp_border_style = is_borderless and 'solid' or vim.g.status.border_style,
	whichkey_title_pos = is_borderless and 'center' or 'left',
	icon_suffix = is_termicons and '' or ' ',
}

G.icons = {
	tabline = {
		close = '',
		ellipsis = '…',
    -- stylua: ignore start
		tabnr = {
			{ '󰎥', '󰼏' }, { '󰎨', '󰼐' },
			{ '󰎫', '󰼑' }, { '󰎲', '󰼒' },
			{ '󰎯', '󰼓' }, { '󰎴', '󰼔' },
			{ '󰎷', '󰼕' }, { '󰎺', '󰼖' },
			{ '󰎽', '󰼗' }, { '󰿫', '󰿪' },
		},
		-- stylua: ignore end
		separator = { '', '' },
	},
	statusline = {
		nvim = '',
		git = '',
		home = '',
		lsp = '󰄹',
		ts = '󱏒',
		ruler = '󰉪',
		record = '󰻃',
		separator = { '', '', '', '', '', '' },
	},
	buf = {
		modified = '',
		readonly = '󰌾',
	},
	files = {
		dir = vim.g.status.icon_type == 'nerdfont' and '󰉋' or '톀',
		dir_open = vim.g.status.icon_type == 'nerdfont' and '󰝰 ' or '톁',
		file = vim.g.status.icon_type == 'nerdfont' and '󰈤' or '큪',
		lua = vim.g.status.icon_type == 'nerdfont' and '' or '킺',
	},
	markdown = {
		header = { '󰎥  ', '󰼐  ', '󰎫  ', '󰼒  ', '󰎯  ', '󰼔  ' },
		checkbox = {
			checked = '   ',
			unchecked = '   ',
			todo = '   ',
			important = '   ',
			question = '   ',
		},
	},
}

G.ui = {
	fillchars = {
		foldopen = '',
		foldclose = '',
	},
	tree = {
		vertical = '│ ',
		middle = '│ ',
		last = '└╴',
	},
}

G.symbols = {
	diag = {
		error = '',
		warn = '',
		info = '',
		hint = '',
	},
	levels = {
		error = '',
		warn = '',
		info = '',
		debug = '',
		trace = '󰴽',
	},
}

G.kind_icons = {
	Copilot = '',

	String = '',
	Number = '',
	Boolean = '',
	Array = '󰅨',
	Object = '󱃖',
	Package = '󰏖',
	Null = '󰟢',
	Unknown = '',
	Identifier = '',

	-- keys from lspkind
	Text = '󰉿',
	Method = '󰡱',
	Function = '󰡱',
	Constructor = '',

	Field = '',
	Variable = '',
	Property = '󰜢',

	Class = '󰙅',
	Interface = '',
	Struct = '󱡠',
	Namespace = '󰦮',
	Module = '',

	Unit = '󰑭',
	Value = '󱀍',
	Enum = '',
	EnumMember = '',

	Keyword = '󰌆',
	Constant = '󰐀',

	Snippet = '󱄽',
	Color = '󰏘',
	File = '󰈙',
	Reference = '󰬲',
	Folder = '󰝰',
	Event = '',
	Operator = '',
	TypeParameter = '󰬛',
}
