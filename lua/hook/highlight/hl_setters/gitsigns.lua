local merge_if = require('utils.funcs').merge_if

---@param colors ThemeColors
---@param borderless boolean
return function(colors, borderless)
	return {
		GitSignsAddPreview = { bg = 'green' },
		GitSignsDeletePreview = { bg = 'red' },
	}
end
