local notify = require('utils.notify')

local VALID_KEYS = {
	'fg',
	'bg',
	'sp',
	'bold',
	'standout',
	'underline',
	'undercurl',
	'underdouble',
	'underdotted',
	'underdashed',
	'strikethrough',
	'italic',
	'reverse',
	'nocombine',
	'default',
	'link',
	'ctermfg',
	'ctermbg',
}
local KEY_SET = {}
for _, k in ipairs(VALID_KEYS) do
	KEY_SET[k] = true
end

local HL = {}
HL.__index = HL

function HL:change(key, value)
	for _, group in ipairs(self.groups) do
		local ok, cur = pcall(vim.api.nvim_get_hl, 0, { name = group })
		if ok and cur then
			local new = {}
			for k, v in pairs(cur) do
				if KEY_SET[k] then
					new[k] = v
				end
			end
			new[key] = value
			vim.api.nvim_set_hl(0, group, new)
		else
			notify.warn('Failed to get highlight group: ' .. group)
		end
	end
	return self
end

function HL:blend(src, overrides)
	local ok, base = pcall(vim.api.nvim_get_hl, 0, { name = src })
	if not ok then
		notify.warn('Failed to get highlight group: ' .. src)
		return self
	end
	local merged = vim.tbl_extend('force', base, overrides or {})
	for _, group in ipairs(self.groups) do
		vim.api.nvim_set_hl(0, group, merged)
	end
	return self
end

local M = {}

---@type HlHelper
function M.hl(...)
	return setmetatable({ groups = { ... } }, HL)
end
return M
