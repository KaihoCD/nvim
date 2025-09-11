local merge_if = require('utils.funcs').merge_if

local M = {}
_G.G = M

M.borderless = function()
	return vim.g.status.ui_type == 'borderless'
end

M.termicons = function()
	return vim.g.status.icon_type == 'termicons'
end

---@param force_use? boolean 是否总是使用设置的border_style
---@return BorderType
M.get_border_style = function(force_use)
	if not M.borderless() then
		return vim.g.status.border_style
	end
	if force_use then
		return vim.g.status.border_style
	end
	return 'solid'
end

M.margin = {
	top = 10,
	right = 2,
	bottom = 2,
}

M.size = {
	float_width = 0.8,
	float_height = 0.8,
	split_right = 0.3,
	split_bottom = 0.35,
}

M.tabline_icons = {
	close = '✘',
	ellipsis = '…',
	tabnr = {
		{ '󰎥', '󰼏' },
		{ '󰎨', '󰼐' },
		{ '󰎫', '󰼑' },
		{ '󰎲', '󰼒' },
		{ '󰎯', '󰼓' },
		{ '󰎴', '󰼔' },
		{ '󰎷', '󰼕' },
		{ '󰎺', '󰼖' },
		{ '󰎽', '󰼗' },
		{ '󰿫', '󰿪' },
	},
	separator = { '', '' },
}

M.statusline_icons = {
	nvim = '',
	git = '',
	home = '',
	lsp = '󰘾',
	ts = '󱏒',
	record = '󰻃',
	separator = { '', '', '', '', '', '' },
}

M.fillchars = {
	foldopen = '',
	foldclose = '',
}

M.diag = {
	error = '',
	warn = '',
	info = '',
	hint = '',
}

M.levels = {
	error = '',
	warn = '',
	info = '',
	debug = '',
	trace = '󰴽',
}

M.tree = {
	vertical = '│ ',
	middle = '│ ',
	last = '└╴',
}

M.files = merge_if(
	{
		dir = '󰉋 ',
		dir_open = '󰝰 ',
		file = ' ',
	},
	M.termicons(),
	{
		dir = '톀',
		dir_open = '톁',
		file = '큪',
	}
)

M.other = merge_if(
	{
		codeaction = '󱠁',
		palette = '',
		lua = '',
	},
	M.termicons(),
	{
		lua = '킺',
	}
)

M.buf = {
	modified = '󰝒',
	readonly = '󰈡',
}

M.md = {
	header = { '󰎥  ', '󰼐  ', '󰎫  ', '󰼒  ', '󰎯  ', '󰼔  ' },
	checkbos = {
		checked = '   ',
		unchecked = '   ',
		todo = '   ',
		important = '   ',
		question = '   ',
	},
}

M.kind_icons = {
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
