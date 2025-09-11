local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
return function(colors)
	local fix_bg = G.borderless() and colors.bg.fix or colors.bg.main

	return merge_if(
		{
			SnacksPickerExplorerNormal = { fg = colors.fg.sub, bg = fix_bg },
			SnacksPickerExplorerBorder = { fg = colors.theme.sub, bg = fix_bg },
			SnacksPickerExplorerTitle = { fg = colors.theme.sub, bg = fix_bg },
			SnacksPickerExplorerPrompt = { fg = colors.theme.main, bg = fix_bg },
			-- snacks input
			SnacksInputNormal = { 'SubFloatBg' },
			SnacksInputBorder = { 'SubFloatBorder' },
			SnacksInputTitle = { 'SubFloatTitle' },
			-- picker box
			SnacksPickerBoxBorder = { bg = colors.bg.main, fg = colors.fg.separator },
			-- picker input
			SnacksPickerInput = { 'SubFloatBg' },
			SnacksPickerInputBorder = { 'SubFloatBorder' },
			SnacksPickerInputTitle = { 'SubFloatTitle' },
		},
		G.borderless(),
		{
			-- picker box
			SnacksPickerBoxBorder = { bg = colors.bg.fix, fg = colors.bg.fix },
		}
	)
end
