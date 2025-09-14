local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
---@param borderless boolean
return function(colors, borderless)
	local main_bg = colors.bg.main
	local main_float_bg = colors.bg.main_float
	local sub_float_bg = colors.bg.sub_float
	local main_color = colors.theme.main
	local sub_color = colors.theme.sub

	return merge_if(
		{
			CursorLine = { 'Visual' },
			CursorLineNr = { bg = main_bg },
			WinSeparator = { fg = colors.fg.separator },
      -- Dynamic hl
			NormalFloat = { bg = main_bg },
			FloatTitle = { bg = main_bg, fg = main_color },
			FloatBorder = { bg = main_bg, fg = main_color },
			SubNormalFloat = { bg = main_bg },
			SubFloatTitle = { bg = main_bg, fg = sub_color },
			SubFloatBorder = { bg = main_bg, fg = sub_color },
		},
		borderless,
		{
			NormalFloat = { bg = main_float_bg },
			FloatBorder = { bg = main_float_bg, fg = main_float_bg },
			FloatTitle = { bg = main_color, fg = main_float_bg },
			SubNormalFloat = { bg = sub_float_bg },
			SubFloatBorder = { bg = sub_float_bg, fg = sub_float_bg },
			SubFloatTitle = { bg = sub_color, fg = sub_float_bg },
		}
	)
end
