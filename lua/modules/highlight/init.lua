local mount_hl_set = require('modules.highlight.mounts')
local notify = require('utils.notify')

local hl = require('modules.highlight.utils').hl

local function apply_highlights(batch)
	local colors = require('modules.colors').get_theme_colors()

	for _, get_group in ipairs(batch) do
		for group, value in pairs(get_group(colors)) do
			local hl_obj = hl(group)
			if type(value[1]) == 'string' then
				-- group = { 'group', { fg=xxx, bg=xxx } }
				hl_obj:blend(value[1], value[2] and value[2] or {})
			elseif type(value) == 'table' then
				-- group = { fg=xxx, bg=xxx }
				for k, v in pairs(value) do
					hl_obj:change(k, v)
				end
			else
				notify.warn('Invalid highlight value for group: ' .. group)
			end
		end
	end
end

vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('SetupHighlights', { clear = true }),
	callback = function()
		apply_highlights(mount_hl_set)
	end,
})
