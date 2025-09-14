local size = G.layout.size
local fillchars = G.ui.fillchars

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

local M = {}

M.opts = {
	exit_when_last = true,
	animate = { enabled = false },
	icons = {
		closed = ' ' .. fillchars.foldclose,
		open = ' ' .. fillchars.foldopen,
	},
	wo = {
		winbar = false,
		winfixwidth = true,
		winfixheight = true,
	},
	options = {
		left = { size = size.split_left },
		bottom = { size = size.split_bottom },
		right = { size = size.split_right },
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
		['<A-Left>'] = resize('width', 2),
		['<A-Right>'] = resize('width', -2),
		['<A-Up>'] = resize('height', 2),
		['<A-Down>'] = resize('height', -2),
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
