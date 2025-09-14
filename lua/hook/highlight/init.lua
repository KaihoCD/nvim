local notify = require('utils.notify')
local hl = require('modules.highlight').hl
local hl_setters = require('hook.highlight.hl_setters')

local function apply_highlights(batch)
	local colors = require('modules.colors').get_theme_colors()
	local borderless = G.status.ui_style == 'borderless'

	for _, hl_setter in ipairs(batch) do
		for group, value in pairs(hl_setter(colors, borderless)) do
			local hl_obj = hl(group)
			if type(value[1]) == 'string' then
				-- group = { 'group', { fg=xxx, bg=xxx } }
				hl_obj:blend(value[1], value[2] and value[2] or {})
			elseif type(value) == 'table' then
				-- group = { fg=xxx, bg=xxx }
				for k, v in pairs(value) do
					hl_obj:change(k, v)
				end
				hl_obj:change('link', nil)
			else
				notify.warn('Invalid highlight value for group: ' .. group)
			end
		end
	end
end

vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('SetupHighlights', { clear = true }),
	callback = function()
		apply_highlights(hl_setters)
	end,
})
