local icon_suffix = G.status.icon_suffix
local tabline_icons = G.icons.tabline
local files_icon = G.icons.files

local vimode = {
	['n'] = { 'NORMAL', 'normal' },
	['no'] = { 'OP', 'normal' },
	['nov'] = { 'OP', 'normal' },
	['noV'] = { 'OP', 'normal' },
	['no'] = { 'OP', 'normal' },
	['niI'] = { 'NORMAL', 'normal' },
	['niR'] = { 'NORMAL', 'normal' },
	['niV'] = { 'NORMAL', 'normal' },
	['i'] = { 'INSERT', 'insert' },
	['ic'] = { 'INSERT', 'insert' },
	['ix'] = { 'INSERT', 'insert' },
	['t'] = { 'TERM', 'terminal' },
	['nt'] = { 'N-TERM', 'normal' },
	['v'] = { 'VISUAL', 'visual' },
	['vs'] = { 'V-CHAR', 'visual' },
	['V'] = { 'V-LINES', 'visual' },
	['Vs'] = { 'V-LINES', 'visual' },
	[''] = { 'V-BLOCK', 'visual' },
	['s'] = { 'V-BLOCK', 'visual' },
	['R'] = { 'REPLACE', 'replace' },
	['Rc'] = { 'REPLACE', 'replace' },
	['Rx'] = { 'REPLACE', 'replace' },
	['Rv'] = { 'V-REPLACE', 'replace' },
	['s'] = { 'SELECT', 'visual' },
	['S'] = { 'S-LINE', 'visual' },
	[''] = { 'S-BLOCK', 'visual' },
	['c'] = { 'COMMAND', 'command' },
	['cv'] = { 'COMMAND', 'command' },
	['ce'] = { 'COMMAND', 'command' },
	['r'] = { 'PROMPT', 'terminal' },
	['rm'] = { 'MORE', 'terminal' },
	['r?'] = { 'CONFIRM', 'terminal' },
	['!'] = { 'SHELL', 'terminal' },
	['null'] = { 'null', 'terminal' },
}

local M = {}

---get current mode metas
---@return {str: string, color: string}
function M.get_vimode()
	local cur_vimode = vimode[vim.fn.mode(1)]
	return {
		str = cur_vimode[1],
		color = cur_vimode[2],
	}
end

function M.get_fileicon(cb)
	return {
		init = function(self)
			self.cur_filename = self.filename or vim.api.nvim_buf_get_name(0)
			local filename = vim.fn.fnamemodify(self.cur_filename, ':t')
			local extension = vim.fn.fnamemodify(self.cur_filename, ':e')
			self.icon, self.icon_color =
				require('nvim-web-devicons').get_icon_color(filename, extension, { default = false })
			if not self.icon then
				self.icon = files_icon.file
			end
		end,
		provider = function(self)
			return self.icon .. icon_suffix
		end,
		hl = function(self)
			if cb then
				return cb(self)
			end
			return { fg = self.icon_color, italic = false }
		end,
	}
end

---@param max_length integer | nil
function M.get_filename(max_length)
	return {
		init = function(self)
			self.cur_filename = self.filename or vim.api.nvim_buf_get_name(0)
		end,
		provider = function(self)
			local filename = vim.fn.fnamemodify(self.cur_filename, ':t')

			if filename == '' then
				return 'NONE'
			end

			if max_length and max_length > 0 and #filename > max_length then
				filename = filename:sub(1, max_length - 1) .. tabline_icons.ellipsis
			end
			return filename
		end,
	}
end

local function _get_bufs()
	return vim.tbl_filter(function(bufnr)
		return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
	end, vim.api.nvim_list_bufs())
end

---@param max_length integer | nil
function M.get_unique_filename(max_length)
	local function path_parts(bufnr)
		local path = vim.api.nvim_buf_get_name(bufnr)
		if path == '' then
			return {}
		end
		return vim.split(vim.fn.fnamemodify(path, ':h'), '/')
	end
	return function(self)
		local bufnr = self.bufnr
		local name = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
		local unique_path_str = ''
		local current = path_parts(bufnr)
		local has_duplicate = false
		for _, value in ipairs(_get_bufs()) do
			if value ~= bufnr and name == vim.fs.basename(vim.api.nvim_buf_get_name(value)) then
				has_duplicate = true
				local other = path_parts(value)
				for i = #current, 1, -1 do
					if current[i] ~= other[i] then
						unique_path_str = current[i] .. '/'
						break
					end
				end
				if unique_path_str ~= '' then
					break
				end
			end
		end
		if not has_duplicate then
			return ''
		end

		if max_length and max_length > 0 and #unique_path_str > max_length then
			unique_path_str = unique_path_str:sub(1, max_length - 2) .. tabline_icons.ellipsis .. '/'
		end
		return unique_path_str
	end
end

return M
