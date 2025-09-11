local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
return function(colors)
	return merge_if(
		{
			BlinkCmpMenu = { 'SubFloatBg' },
			BlinkCmpMenuBorder = { 'SubFloatBorder', { fg = colors.theme.main } },
			BlinkCmpDoc = { 'MainFloatBg' },
			BlinkCmpDocBorder = { 'MainFloatBorder' },
			BlinkCmpScrollBarThumb = { bg = colors.fg.separator },
			BlinkCmpScrollBarGutter = { 'SubFloatBg' },
		},
		G.borderless(),
		{
			BlinkCmpMenuBorder = { 'SubFloatBorder' },
			BlinkCmpDocBorder = { fg = colors.bg.main_float, bg = colors.bg.main_float },
		}
	)
end
