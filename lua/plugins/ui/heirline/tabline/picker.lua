local picker_labels = {}
local M = {}

---Tabline Picker component
---@param color string lable的颜色
M.TablinePicker = function(color)
	return {
		condition = function(self)
			return self._show_picker
		end,
		init = function(self)
			-- Use pre-assigned label if available
			local label = picker_labels[self.bufnr]
			if label then
				self.label = label
				self._picker_labels[label] = self.bufnr
			else
				self.label = ''
			end
		end,
		provider = function(self)
			return self.label .. ' '
		end,
		hl = function()
			return { fg = color, bold = true }
		end,
	}
end

-- Buffer picker function with callback
local alphabet = 'abcdefghijklmnopqrstuvwxyz'
function M.buffer_picker(callback)
	local tabline = require('heirline').tabline
	local buflist = tabline._buflist[1]
	if not buflist then
		return
	end

	-- 重置状态
	picker_labels = {}
	buflist._picker_labels = {}
	buflist._show_picker = true

	-- 优化点1：获取缓冲区时增加排序（最近使用优先）
	local buffers = {}
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if vim.api.nvim_buf_is_valid(buf.bufnr) then
			table.insert(buffers, {
				bufnr = buf.bufnr,
				name = buf.name,
				lastused = buf.lastused,
			})
		end
	end

	-- 按最后使用时间降序排序（最近使用的在前）
	table.sort(buffers, function(a, b)
		return a.lastused > b.lastused
	end)

	local used_labels = {}
	local label_pool = {} -- 预生成可用标签池
	for c in alphabet:gmatch('.') do
		table.insert(label_pool, c)
	end

	-- 优先分配文件名首字母
	for _, buf in ipairs(buffers) do
		local bufname = vim.fn.fnamemodify(buf.name, ':t')
		local label

		-- 检查首字母是否可用
		if bufname ~= '' then
			local first_char = bufname:sub(1, 1):lower()
			if first_char:match('[a-z0-9]') and not used_labels[first_char] then
				label = first_char
			end
		end

		-- 次选：遍历文件名中的其他字符
		if not label and bufname ~= '' then
			for i = 2, #bufname do
				local char = bufname:sub(i, i):lower()
				if char:match('[a-z0-9]') and not used_labels[char] then
					label = char
					break
				end
			end
		end

		-- 最后：从标签池取用备用字母
		if not label and #label_pool > 0 then
			label = table.remove(label_pool, 1)
		end

		if label then
			used_labels[label] = true
			picker_labels[buf.bufnr] = label
		end
	end

	vim.cmd.redrawtabline()
	local char = vim.fn.getcharstr()
	local bufnr = buflist._picker_labels[char]
	if bufnr then
		callback(bufnr)
	end

	-- 清理状态
	buflist._show_picker = false
	picker_labels = {}
	vim.cmd.redrawtabline()
end

return M
