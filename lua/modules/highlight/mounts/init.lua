local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
local function change_native_hlgroup(colors)
	return merge_if(
		{
			Title = { bg = nil },
			WinSeparator = { fg = colors.fg.separator },
			CursorLine = { bg = colors.bg.main },
			NormalFloat = { bg = colors.bg.main },
			FloatTitle = { bg = colors.bg.main, fg = colors.theme.main },
			FloatBorder = { bg = colors.bg.main, fg = colors.theme.main },
			-- Helper HlGroup
			MainBg = { bg = colors.bg.main },
			MainFloatBg = { bg = colors.bg.main },
			MainFloatTitle = { bg = colors.bg.main, fg = colors.theme.main },
			MainFloatBorder = { bg = colors.bg.main, fg = colors.theme.main },
			SubFloatBg = { bg = colors.bg.main },
			SubFloatTitle = { bg = colors.bg.main, fg = colors.theme.sub },
			SubFloatBorder = { bg = colors.bg.main, fg = colors.theme.sub },
		},
		G.borderless(),
		{
			NormalFloat = { bg = colors.bg.main_float },
			FloatBorder = { bg = colors.bg.main_float, fg = colors.theme.main },
			FloatTitle = { bg = colors.theme.main, fg = colors.bg.main_float },
			MainFloatBg = { bg = colors.bg.main_float },
			MainFloatBorder = { bg = colors.bg.main_float },
			MainFloatTitle = { bg = colors.theme.main, fg = colors.bg.main_float },
			SubFloatBg = { bg = colors.bg.sub_float },
			SubFloatBorder = { bg = colors.bg.sub_float },
			SubFloatTitle = { bg = colors.theme.sub, fg = colors.bg.sub_float },
		}
	)
end

return {
	change_native_hlgroup,
	require('modules.highlight.mounts.snacks_picker'),
	require('modules.highlight.mounts.snacks_notifier'),
	require('modules.highlight.mounts.whichkey'),
	require('modules.highlight.mounts.noice'),
	require('modules.highlight.mounts.flash'),
	require('modules.highlight.mounts.blink'),
	require('modules.highlight.mounts.edgy'),
}
