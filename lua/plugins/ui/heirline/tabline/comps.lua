local bufdel = require('utils.bufdel')
local comps = require('plugins.ui.heirline.comps')
local heirline_colors = require('plugins.ui.heirline.colors')
local picker = require('plugins.ui.heirline.tabline.picker')
local utils = require('heirline.utils')

local icons = G.icons.tabline
local buf_icons = G.icons.buf

local blend = heirline_colors.blend
local diag_level_set = heirline_colors.diag_color_set

local BufferIconAndName = {
	init = function(self)
		local bufnr = self.bufnr and self.bufnr or 0
		self.filename = vim.api.nvim_buf_get_name(bufnr)
	end,
	on_click = {
		callback = function(_, minwid, _, button)
			if button == 'm' then -- close on mouse middle click
				vim.schedule(function()
					bufdel(minwid)
				end)
			else
				vim.api.nvim_win_set_buf(0, minwid)
			end
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = 'heirline_tabline_buffer_callback',
	},
	{
		condition = function(self)
			return not self._show_picker
		end,
		comps.get_fileicon(function(self)
			local icon_color = self.icon_color or 'fg'
			if self.is_active then
				return { fg = icon_color }
			end
			return {
				fg = blend(icon_color, 'inactive_bg'),
			}
		end),
	},
	{
		{
			provider = comps.get_unique_filename(10),
			hl = function()
				return { fg = 'inactive_fg', italic = true }
			end,
		},
		comps.get_filename(20),
		hl = function(self)
			local counts = vim.diagnostic.count(self.bufnr)

			local max_level
			for sev, level in ipairs(diag_level_set) do
				if (counts[sev] or 0) > 0 then
					max_level = level
					break
				end
			end

			local diag_color = max_level and { 'diag_' .. max_level, 'diag_' .. max_level .. '_inactive' }
				or {}

			local default = self.is_active and 'active_fg' or 'inactive_fg'
			local color = max_level and diag_color[self.is_active and 1 or 2] or default

			return { fg = color, italic = self.is_active }
		end,
	},
}

local BufferFlag = {
	{
		condition = function(self)
			return not vim.api.nvim_get_option_value('modifiable', { buf = self.bufnr })
				or vim.api.nvim_get_option_value('readonly', { buf = self.bufnr })
		end,
		provider = buf_icons.readonly .. ' ',
		hl = function(self)
			return { fg = self.is_active and 'terminal' or blend('terminal', 'inactive_bg') }
		end,
	},
	{
		condition = function(self)
			return not vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
		end,
		provider = icons.close,
		on_click = {
			callback = function(_, minwid)
				vim.schedule(function()
					bufdel(minwid)
				end)
			end,
			minwid = function(self)
				return self.bufnr
			end,
			name = 'heirline_tabline_close_buffer_callback',
		},
		hl = function(self)
			return {
				fg = self.is_active and 'active_fg' or 'inactive_fg',
			}
		end,
	},
	{
		condition = function(self)
			return vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
		end,
		provider = buf_icons.modified,
		hl = function()
			return { fg = 'insert' }
		end,
	},
}

local M = {}

local edges = icons.separator

M.BufferBlock = utils.surround({ ' ' .. edges[1], edges[2] }, function(self)
	return self.is_active and 'active_bg' or 'inactive_bg'
end, {
	{ provider = ' ' },
	picker.TablinePicker('terminal'),
	BufferIconAndName,
	{ provider = ' ' },
	BufferFlag,
	{ provider = ' ' },
})

M.ExplorerOffset = {
	condition = function(self)
		local win = vim.api.nvim_tabpage_list_wins(0)[1]
		local bufnr = vim.api.nvim_win_get_buf(win)
		self.winid = win

		local filetype = vim.bo[bufnr].filetype
		if filetype == 'snacks_layout_box' then
			self.hl = { bg = 'bg' }
			return true
		end
	end,
	{
		provider = function(self)
			local width = vim.api.nvim_win_get_width(self.winid)
			return string.rep(' ', width)
		end,
	},
	-- Separator
	{
		provider = '│',
		hl = { fg = 'bg' },
	},
}
local Tabpage = {
	provider = function(self)
		local icons_for_tab = icons.tabnr[self.tabnr] or {}
		local icon = self.is_active and (icons_for_tab[2] or icons_for_tab[1] or self.tabnr)
			or (icons_for_tab[1] or self.tabnr)
		return '%' .. self.tabnr .. 'T ' .. icon .. ' %T'
	end,
	hl = function(self)
		return { fg = self.is_active and 'active_fg' or 'inactive_fg' }
	end,
}

local TabpageItem = utils.surround({ edges[1], edges[2] }, function(self)
	return self.is_active and 'active_bg' or 'inactive_bg'
end, Tabpage)

local TabpageClose = {
	provider = '%999X ' .. icons.close .. ' %X',
}

M.TabPages = {
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	utils.make_tablist(TabpageItem),
	TabpageClose,
}

return M
