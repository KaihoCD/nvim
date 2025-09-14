local buf_manager = require('hook.buffer.manager')
local bufdel = require('utils.bufdel')
local map = require('utils.funcs').map

local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Add buffer to tab buffer list
vim.api.nvim_create_autocmd({ 'BufAdd', 'BufEnter', 'TabNewEntered' }, {
	group = augroup('AddingBuf'),
	callback = function(args)
		if not vim.t.bufs then
			vim.t.bufs = {}
		end
		if not buf_manager.is_valid(args.buf) then
			return
		end
		if args.buf ~= buf_manager.current_buf then
			buf_manager.last_buf = buf_manager.is_valid(buf_manager.current_buf)
					and buf_manager.current_buf
				or nil
			buf_manager.current_buf = args.buf
		end
		local bufs = vim.t.bufs
		if not vim.tbl_contains(bufs, args.buf) then
			table.insert(bufs, args.buf)
			vim.t.bufs = bufs
		end
		vim.t.bufs = vim.tbl_filter(buf_manager.is_valid, vim.t.bufs)
	end,
})

-- Remove buffer from all tabs
vim.api.nvim_create_autocmd({ 'BufDelete', 'TermClose' }, {
	group = augroup('RemoveBuf'),
	callback = function(args)
		for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
			local bufs = vim.t[tab].bufs
			if bufs then
				for i, bufnr in ipairs(bufs) do
					if bufnr == args.buf then
						table.remove(bufs, i)
						vim.t[tab].bufs = bufs
						break
					end
				end
			end
		end
		vim.t.bufs = vim.tbl_filter(buf_manager.is_valid, vim.t.bufs)
	end,
})

-- stylua: ignore start
map('n', 'H', function() buf_manager.nav(-vim.v.count1) end, { desc = 'Prev buffer' })
map('n', 'L', function() buf_manager.nav(vim.v.count1) end, { desc = 'Prev buffer' })
map('n', '[b', function() buf_manager.nav(-vim.v.count1) end, { desc = 'Prev buffer' })
map('n', ']b', function() buf_manager.nav(vim.v.count1) end, { desc = 'Prev buffer' })
map('n', '<b', function() buf_manager.move(-vim.v.count1) end, { desc = 'Move buffer tab left' })
map('n', '>b', function() buf_manager.move(vim.v.count1) end, { desc = 'Move buffer tab left' })
map('n', '<leader>bc', function() bufdel(vim.api.nvim_get_current_buf()) end, { desc = '[c]lose current buffer' })
map('n', '<leader>bC', function() buf_manager.close_all(true) end, { desc = '[C]lose other buffers' })
-- stylua: ignore end
