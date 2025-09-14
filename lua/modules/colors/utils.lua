local notify = require('utils.notify')

local M = {}

function M.get_color_by_hlgroup(hlgroup, attribute)
	local ok, hl_group = pcall(vim.api.nvim_get_hl, 0, { name = hlgroup })

	if not ok then
		notify.warn(
			'Highlight group \'' .. hlgroup .. '\' does not exist or has no ' .. attribute .. ' color.'
		)
		return nil
	end

	if hl_group[attribute] then
		return string.lower(string.format('#%06X', hl_group[attribute]))
	elseif hl_group['link'] then
		return M.get_color_by_hlgroup(hl_group['link'], attribute)
	end
end

function M.gen_color(group_list)
	local result_color = nil

	for _, group in ipairs(group_list) do
		local hlgroup, attribute = group:match('([^:]+):?(.*)')
		attribute = attribute ~= '' and attribute or 'fg'
		result_color = M.get_color_by_hlgroup(hlgroup, attribute) or result_color
	end

	return result_color
end

return M
