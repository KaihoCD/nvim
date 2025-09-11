local M = {}

local function resize(dim_type, amount)
	return function(win)
		local dim_value = win:dim(dim_type)
		if dim_value ~= win.width then
			win:resize(dim_type)
		end
		win:resize(dim_type, amount)
	end
end

local function ensure_pos_table(opts, pos)
	if type(opts[pos]) ~= 'table' then
		opts[pos] = {}
	end
	return opts[pos]
end

M.opts = {
	exit_when_last = true,
	animate = { enabled = false },
	icons = {
		closed = ' ' .. G.fillchars.foldclose,
		open = ' ' .. G.fillchars.foldopen,
	},
	wo = {
		winbar = false,
		winfixwidth = true,
		winfixheight = true,
	},
	options = {
		left = { size = 35 },
		bottom = { size = G.size.split_bottom },
		right = { size = G.size.split_right },
	},
	bottom = {
		{ ft = 'qf' },
		{ ft = 'Trouble' },
		{
			ft = 'noice',
			filter = function(_, win)
				local cfg = vim.api.nvim_win_get_config(win)
				return cfg.relative == ''
			end,
		},
		{
			ft = 'help',
			filter = function(buf)
				return vim.bo[buf].buftype == 'help'
			end,
		},
	},
	left = {
		{
			ft = 'snacks_layout_box',
			filter = function(_, win)
				local cfg = vim.api.nvim_win_get_config(win)
				return cfg.relative == ''
			end,
		},
	},
	keys = {
		['<C-M-l>'] = resize('width', 2),
		['<C-M-h>'] = resize('width', -2),
		['<C-M-j>'] = resize('height', 2),
		['<C-M-k>'] = resize('height', -2),
	},
}

local directions = { 'bottom', 'right' }

-- trouble 窗口配置
for _, pos in ipairs(directions) do
	local t = ensure_pos_table(M.opts, pos)
	table.insert(t, {
		ft = 'trouble',
		filter = function(_, win)
			local w = vim.w[win]
			return w.trouble
				and w.trouble.position == pos
				and w.trouble.type == 'split'
				and w.trouble.relative == 'editor'
				and not w.trouble_preview
		end,
	})
end

-- snacks terminal 窗口配置
for _, pos in ipairs(directions) do
	local t = ensure_pos_table(M.opts, pos)
	table.insert(t, {
		ft = 'snacks_terminal',
		filter = function(_, win)
			local w = vim.w[win]
			return w.snacks_win
				and w.snacks_win.position == pos
				and w.snacks_win.relative == 'editor'
				and not w.trouble_preview
		end,
	})
end

return M
