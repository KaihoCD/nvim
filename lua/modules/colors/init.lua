local theme_colors_cache = {} ---@type table<string, ThemeColors>

local darken = require('utils.color').darken
local blend = require('utils.color').blend
local get_contrast_ratio = require('utils.color').get_contrast_ratio
local pipe = require('utils.funcs').pipe
local COLORMAP = require('modules.colors.colormap')

local function cache_theme_colors(colors)
	theme_colors_cache[vim.g.colors_name or 'default'] = colors
end

local function gen_base_colors()
	local colors = {}

	for key, group_list in pairs(COLORMAP) do
		colors[key] = require('modules.colors.utils').gen_color(group_list)
	end

	local _, contrast_ok = get_contrast_ratio(colors.bg, colors.sub_bg, 1.1)
	if not contrast_ok then
		local alpha = vim.o.background == 'dark' and 0.9 or 0.95
		colors.sub_bg = darken(colors.sub_bg, alpha)
	end

	return colors
end

---@param colors BaseColors
---@return ThemeColors
local function build_theme_colors(colors)
	local fix_bg = blend(colors.bg, 0.5, colors.sub_bg)

	---@type ThemeColors
	local r = {
		fg = {
			main = colors.fg,
			sub = colors.sub_fg,
			separator = blend(colors.comment, 0.5, colors.bg),
			nontext = colors.nontext_fg,
		},
		bg = {
			fix = fix_bg,
			main = colors.bg,
			main_float = colors.sub_bg,
			sub_float = blend(fix_bg, 0.5, colors.sub_bg),
		},
		theme = {
			main = colors.func,
			sub = colors.constant,
			comment = colors.comment,
			type = colors.type,
			func = colors.func,
			preproc = colors.preproc,
			special = colors.special,
			statement = colors.statement,
			constant = colors.constant,
			string = colors.string,
		},
		git = {
			add = colors.git_add,
			change = colors.git_change,
			delete = colors.git_delete,
		},
		diag = {
			error = colors.diag_error,
			warn = colors.diag_warn,
			info = colors.diag_info,
			hint = colors.diag_hint,
		},
	}

	return r
end

local M = {}

M.gen_theme_colors = pipe({
	gen_base_colors,
	build_theme_colors,
	cache_theme_colors,
})

function M.get_theme_colors()
	local colors = theme_colors_cache[vim.g.colors_name]

	if not colors then
		M.gen_theme_colors()
		colors = theme_colors_cache[vim.g.colors_name]
	end

	return colors
end

return M
