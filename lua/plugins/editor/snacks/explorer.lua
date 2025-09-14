local M = {}

M.keys = {
  -- stylua: ignore start
	{ '<leader>e', function() Snacks.explorer() end, desc = 'File [e]xplorer', remap = true },
	{ '<C-e>', function() Snacks.explorer() end, desc = 'File [e]xplorer', remap = true },
	-- stylua: ignore end
}

M.opts = { enabled = true }

return M
