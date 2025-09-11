local merge_if = require('utils.funcs').merge_if
local blend = require('utils.color').blend

---@param colors ThemeColors
return function(colors)
	local type_map = {
		Error = colors.diag.error,
		Warn = colors.diag.warn,
		Info = colors.diag.info,
		Debug = colors.fg.nontext,
		Trace = colors.theme.statement,
	}

	local function make_hl(color)
		return merge_if(
			{
				normal = { 'MainFloatBg' },
				title = { 'MainFloatTitle', { fg = color } },
				border = {
					fg = blend(color, 0.5, colors.bg.main_float),
					bg = colors.bg.main,
				},
			},
			G.borderless(),
			{
				title = { 'MainFloatTitle', { bg = color } },
				border = {
					fg = blend(color, 0.5, colors.bg.main_float),
					bg = colors.bg.main_float,
				},
			}
		)
	end

	local map = {}

	for type, color in pairs(type_map) do
		local hl = make_hl(color)

		map['SnacksNotifier' .. type] = hl.normal
		map['SnacksNotifierIcon' .. type] = hl.title
		map['SnacksNotifierTitle' .. type] = hl.title
		map['SnacksNotifierBorder' .. type] = hl.border
		map['SnacksNotifierFooter' .. type] = hl.border
	end

	-- Override error group font color
	map['SnacksNotifierError'] = { 'MainFloatBg', { fg = colors.diag.error } }

	return map
end
