local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
return function(colors)
	return merge_if(
		{
			-- 容器
			NoiceCmdlinePopup = { 'MainFloatBg' },
			NoiceCmdlinePopupBorder = { 'MainFloatBorder' },
			NoiceConfirm = { 'MainFloatBg' },
			NoiceConfirmBorder = { 'MainFloatBorder' },
			NoiceConfirmTitle = { 'MainFloatTitle' },

			-- 图标
			NoiceCmdlineIconLua = { 'MainFloatBorder' },
			NoiceCmdlineIconHelp = { 'MainFloatBorder' },
			NoiceCmdlineIconFilter = { 'MainFloatBorder' },
			NoiceCmdlineIconCmdline = { 'MainFloatBorder' },
			NoiceCmdlineIconInput = { 'SubFloatBorder' },
			NoiceCmdlineIconSearch = { 'SubFloatBorder' },
			NoiceCmdlineIconCalculator = { 'SubFloatBorder' },

			-- 标题
			NoiceCmdlinePopupTitleLua = { 'MainFloatTitle' },
			NoiceCmdlinePopupTitleHelp = { 'MainFloatTitle' },
			NoiceCmdlinePopupTitleFilter = { 'MainFloatTitle' },
			NoiceCmdlinePopupTitleCmdline = { 'MainFloatTitle' },
			NoiceCmdlinePopupTitleInput = { 'SubFloatTitle' },
			NoiceCmdlinePopupTitleSearch = { 'SubFloatTitle' },
			NoiceCmdlinePopupTitleCalculator = { 'SubFloatTitle' },

			-- 边框
			NoiceCmdlinePopupBorderLua = { 'MainFloatBorder' },
			NoiceCmdlinePopupBorderHelp = { 'MainFloatBorder' },
			NoiceCmdlinePopupBorderFilter = { 'MainFloatBorder' },
			NoiceCmdlinePopupBorderCmdline = { 'MainFloatBorder' },
			NoiceCmdlinePopupBorderInput = { 'SubFloatBorder' },
			NoiceCmdlinePopupBorderSearch = { 'SubFloatBorder' },
			NoiceCmdlinePopupBorderCalculator = { 'SubFloatBorder' },

			-- 确认行
			NoiceFormatConfirm = { 'MainFloatBg' },
			NoiceFormatConfirmDefault = { 'MainFloatTitle' },
		},
		G.borderless(),
		{
			-- 边框
			NoiceCmdlinePopupBorderLua = {},
			NoiceCmdlinePopupBorderHelp = {},
			NoiceCmdlinePopupBorderFilter = {},
			NoiceCmdlinePopupBorderCmdline = {},
			NoiceCmdlinePopupBorderInput = {},
			NoiceCmdlinePopupBorderSearch = {},
			NoiceCmdlinePopupBorderCalculator = {},
		}
	)
end
