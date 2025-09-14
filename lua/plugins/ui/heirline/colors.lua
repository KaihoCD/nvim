local utils = require('heirline.utils')
local blend = require('utils.color').blend
local is_hex = require('utils.color').is_hex

local M = {}

---@type table<ThemeName, HeirlineColors>
local colors_cache = {}

local mode_color_map = {
	{ 'normal', 'func' },
	{ 'insert', 'string' },
	{ 'visual', 'statement' },
	{ 'command', 'preproc' },
	{ 'select', 'preproc' },
	{ 'terminal', 'constant' },
	{ 'replace', 'special' },
}

M.diag_color_set = {
	'error',
	'warn',
	'info',
	'hint',
}

---@return HeirlineColors
local function setup_colors()
	local colors = require('modules.colors').get_theme_colors()

	local r = {
		git_add = colors.git.add,
		git_change = colors.git.change,
		git_delete = colors.git.delete,
		fg = colors.fg.sub,
		bg = colors.bg.fix,
		active_fg = colors.fg.main,
		active_bg = colors.bg.main,
		inactive_fg = blend(colors.fg.main, 0.5, colors.bg.main),
		inactive_bg = colors.bg.main_float,
		picker_fg = colors.theme.statement,
		work_dir_fg = colors.fg.sub,
		lsp_fg = colors.theme.func,
		ts_fg = colors.fg.sub,
		record_fg = colors.fg.main,
	}

	for _, level in ipairs(M.diag_color_set) do
		r['diag_' .. level] = colors.diag[level]
		r['diag_' .. level .. '_inactive'] = blend(colors.diag[level], 0.5, r.inactive_bg)
	end

	for _, map in ipairs(mode_color_map) do
		r[map[1]] = colors.theme[map[2]]
		r[map[1] .. '_light'] = blend(colors.theme[map[2]], 0.4, r.bg)
		r[map[1] .. '_lighter'] = blend(colors.theme[map[2]], 0.2, r.bg)
	end

	return r
end

local function get_cache_key(alias_1, alias_2)
	if alias_1 < alias_2 then
		return alias_1 .. '|' .. alias_2
	end
	return alias_2 .. '|' .. alias_1
end

function M.get_colors()
	local r = colors_cache[vim.g.colors_name]

	if r then
		return r
	end

	r = setup_colors()
	colors_cache[vim.g.colors_name] = r

	return r
end

local dynamic_cache = {}
dynamic_cache[vim.g.colors_name] = {}

---@return string
function M.blend(alias_or_color_1, alias_or_color_2)
	local cache_key = get_cache_key(alias_or_color_1, alias_or_color_2)
	local r = dynamic_cache[vim.g.colors_name][cache_key]

	if r then
		return r
	end

	local color_1 = is_hex(alias_or_color_1) and alias_or_color_1
		or colors_cache[vim.g.colors_name][alias_or_color_1]
	local color_2 = is_hex(alias_or_color_2) and alias_or_color_2
		or colors_cache[vim.g.colors_name][alias_or_color_2]

	return blend(color_1, 0.5, color_2)
end

vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('HeirlineReloadColors', { clear = true }),
	callback = function()
		-- init dynamic_cache
		if not dynamic_cache[vim.g.colors_name] then
			dynamic_cache[vim.g.colors_name] = {}
		end
		utils.on_colorscheme(M.get_colors)
	end,
})

return M
