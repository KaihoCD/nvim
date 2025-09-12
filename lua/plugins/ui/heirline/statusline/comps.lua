local comps = require('plugins.ui.heirline.comps')
local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

local icons = G.statusline_icons

local M = {}

M.Vimode = {
	flexible = 5,
	{
		provider = function()
			return ' ' .. icons.nvim .. ' ' .. comps.get_vimode().str .. ' '
		end,
	},
	{ provider = '' },
}

M.BufferName = {
	{ provider = ' ' },
	comps.get_fileicon(),
	comps.get_filename(),
	{ provider = ' ' },
	{
		{
			condition = function()
				return vim.bo.modified
			end,
			provider = G.buf.modified .. ' ',
			hl = function()
				return { fg = 'insert', italic = false }
			end,
		},
		{
			condition = function()
				return not vim.bo.modifiable or vim.bo.readonly
			end,
			provider = G.buf.readonly .. ' ',
			hl = function()
				return { fg = 'terminal', italic = false }
			end,
		},
	},
}

M.Git = {
	condition = conditions.is_git_repo,
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0
			or self.status_dict.removed ~= 0
			or self.status_dict.changed ~= 0
	end,
	flexible = 4,
	{
		{
			provider = ' ' .. icons.git .. ' ',
		},
		{
			provider = function(self)
				return self.status_dict.head
			end,
		},
		{
			condition = function(self)
				return self.has_changes
			end,
			provider = '[',
		},
		{
			provider = function(self)
				local count = self.status_dict.added or 0
				return count > 0 and ('+' .. count)
			end,
			hl = function()
				return { fg = 'git_add' }
			end,
		},
		{
			provider = function(self)
				local count = self.status_dict.removed or 0
				return count > 0 and ('-' .. count)
			end,
			hl = function()
				return { fg = 'git_delete' }
			end,
		},
		{
			provider = function(self)
				local count = self.status_dict.changed or 0
				return count > 0 and ('~' .. count)
			end,
			hl = function()
				return { fg = 'git_change' }
			end,
		},
		{
			condition = function(self)
				return self.has_changes
			end,
			provider = ']',
		},
		{ provider = ' ' },
	},
	{
		provider = function(self)
			return ' ' .. icons.git .. self.status_dict.head
		end,
	},
}

M.Diagnostics = {
	condition = conditions.has_diagnostics,
	static = {
		error_icon = G.diag.error .. ' ',
		warn_icon = G.diag.warn .. ' ',
		info_icon = G.diag.info .. ' ',
		hint_icon = G.diag.hint .. ' ',
	},
	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	end,
	update = { 'DiagnosticChanged', 'BufEnter' },
	{
		provider = function(self)
			return self.errors > 0 and (' ' .. self.error_icon .. self.errors)
		end,
		hl = function()
			return { fg = 'diag_error' }
		end,
	},
	{
		provider = function(self)
			return self.warnings > 0 and (' ' .. self.warn_icon .. self.warnings)
		end,
		hl = function()
			return { fg = 'diag_warn' }
		end,
	},
	{
		provider = function(self)
			return self.info > 0 and (' ' .. self.info_icon .. self.info)
		end,
		hl = function()
			return { fg = 'diag_info' }
		end,
	},
	{
		provider = function(self)
			return self.hints > 0 and (' ' .. self.hint_icon .. self.hints)
		end,
		hl = function()
			return { fg = 'diag_hint' }
		end,
	},
}

M.WorkDir = {
	flexible = 1,
	{
		provider = function()
			local cwd = vim.fn.getcwd()
			cwd = vim.fn.fnamemodify(cwd, ':~')
			local path_separator = package.config:sub(1, 1)
			return cwd:gsub('~', icons.home .. ' '):gsub(path_separator, ' ')
		end,
	},
	{
		provider = '',
	},
}

M.BufferDir = {
	provider = function()
		local buf_path = vim.api.nvim_buf_get_name(0)
		if buf_path == '' then
			return ''
		end

		local root = vim.fn.getcwd()
		root = vim.fn.fnamemodify(root, ':~')
		local buf_dir = vim.fn.fnamemodify(buf_path, ':~')
		local relative = buf_dir:gsub('^' .. vim.pesc(root), '')
		local path_separator = package.config:sub(1, 1)
		return relative:gsub(path_separator, ' ')
	end,
}

M.Lsp = {
	condition = conditions.lsp_attached,
	update = { 'LspAttach', 'LspDetach' },
	{ provider = ' ' .. icons.lsp .. ' ', hl = { italic = false } },
	{
		provider = function()
			local names = {}
			for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
				table.insert(names, server.name)
			end
			return table.concat(names, ' ')
		end,
	},
	{ provider = ' ' },
}

M.Ts = {
	condition = function()
		local has_treesitter, _ = pcall(require, 'nvim-treesitter')
		if not has_treesitter then
			return false
		end
		local parsers = require('nvim-treesitter.parsers').get_parser_configs()
		if not parsers then
			return false
		end
		local ts = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
		if ts then
			return ts
		end
		return false
	end,
	flexible = 3,
	{
		{ provider = ' ' .. icons.ts .. ' ', hl = { italic = false } },
		{
			provider = function()
				return require('nvim-treesitter.parsers').get_buf_lang(vim.api.nvim_get_current_buf())
			end,
		},
		{ provider = ' ' },
	},
	{
		provider = '',
	},
}

M.Record = {
	condition = function()
		return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
	end,
	{ provider = ' ' .. icons.record .. ' ', hl = { italic = false } },
	utils.surround({ '⌜', '⌟ ' }, nil, {
		provider = function()
			return vim.fn.reg_recording()
		end,
	}),
}

M.Ruler = {
	flexible = 2,
	{ provider = ' 󰉨 %P ' },
}

return M
