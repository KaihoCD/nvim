local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
---@param borderless boolean
return function(colors, borderless)
	return merge_if(
		{
			BlinkCmpMenu = { 'NormalFloat' },
			BlinkCmpMenuBorder = { 'FloatBorder' },
			BlinkCmpDoc = { 'NormalFloat' },
			BlinkCmpDocBorder = { 'FloatBorder' },
			BlinkCmpScrollBarThumb = { bg = colors.fg.separator },
			BlinkCmpScrollBarGutter = { 'FloatBorder' },
			BlinkCmpKind = { 'NormalFloat' },
			BlinkCmpMenuSelection = { 'Visual' },
		},
		borderless,
		{
			BlinkCmpDoc = { 'SubNormalFloat' },
			BlinkCmpDocBorder = { 'SubFloatBorder' },
			BlinkCmpDocSeparator = { 'SubNormalFloat' },
		}
	)
end
