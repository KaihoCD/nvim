local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
---@param borderless boolean
return function(colors, borderless)
	return merge_if(
		{
			-- 容器
			NoiceCmdlinePopup = { 'SubNormalFloat' },
			NoiceCmdlinePopupBorder = { 'SubFloatBorder' },
			NoiceConfirm = { 'SubNormalFloat' },
			NoiceConfirmBorder = { 'SubFloatBorder' },
			NoiceConfirmTitle = { 'SubFloatTitle' },

			-- 图标
			NoiceCmdlineIconLua = { 'SubNormalFloat', { fg = colors.theme.main } },
			NoiceCmdlineIconHelp = { 'SubNormalFloat', { fg = colors.theme.main } },
			NoiceCmdlineIconFilter = { 'SubNormalFloat', { fg = colors.theme.main } },
			NoiceCmdlineIconCmdline = { 'SubNormalFloat', { fg = colors.theme.main } },
			NoiceCmdlineIconInput = { 'SubNormalFloat', { fg = colors.theme.sub } },
			NoiceCmdlineIconSearch = { 'SubNormalFloat', { fg = colors.theme.sub } },
			NoiceCmdlineIconCalculator = { 'SubNormalFloat', { fg = colors.theme.sub } },

			-- 标题
			NoiceCmdlinePopupTitleLua = { 'FloatTitle' },
			NoiceCmdlinePopupTitleHelp = { 'FloatTitle' },
			NoiceCmdlinePopupTitleFilter = { 'FloatTitle' },
			NoiceCmdlinePopupTitleCmdline = { 'FloatTitle' },
			NoiceCmdlinePopupTitleInput = { 'SubFloatTitle' },
			NoiceCmdlinePopupTitleSearch = { 'SubFloatTitle' },
			NoiceCmdlinePopupTitleCalculator = { 'SubFloatTitle' },

			-- 边框
			NoiceCmdlinePopupBorderLua = { 'SubFloatBorder', { fg = colors.theme.main } },
			NoiceCmdlinePopupBorderHelp = { 'SubFloatBorder', { fg = colors.theme.main } },
			NoiceCmdlinePopupBorderFilter = { 'SubFloatBorder', { fg = colors.theme.main } },
			NoiceCmdlinePopupBorderCmdline = { 'SubFloatBorder', { fg = colors.theme.main } },
			NoiceCmdlinePopupBorderInput = { 'SubFloatBorder' },
			NoiceCmdlinePopupBorderSearch = { 'SubFloatBorder' },
			NoiceCmdlinePopupBorderCalculator = { 'SubFloatBorder' },

			-- 确认行
			NoiceFormatConfirm = { 'NormalFloat' },
			NoiceFormatConfirmDefault = { 'FloatTitle' },

			-- 边框
			NoiceSplit = { bg = colors.bg.main },
		},
		borderless,
		{
      -- 边框
			NoiceCmdlinePopupBorderLua = { 'SubFloatBorder' },
			NoiceCmdlinePopupBorderHelp = { 'SubFloatBorder' },
			NoiceCmdlinePopupBorderFilter = { 'SubFloatBorder' },
			NoiceCmdlinePopupBorderCmdline = { 'SubFloatBorder' },
		}
	)
end
