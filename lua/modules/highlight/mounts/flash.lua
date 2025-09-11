---@param colors ThemeColors
return function(colors)
	return {
		FlashLabel = {
			fg = colors.theme.sub,
			sp = colors.theme.sub,
			bg = colors.bg.main,
			underline = true,
		},
		FlashMatch = {
			fg = colors.theme.main,
			sp = colors.theme.main,
			bg = colors.bg.main,
			underline = true,
		},
		FlashCurrent = {
			fg = colors.theme.main,
			sp = colors.theme.main,
			bg = colors.bg.main,
			underline = true,
		},
		FlashBackdrop = { fg = colors.fg.nontext },
	}
end
