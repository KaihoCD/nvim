return {
  -- stylua: ignore start
	{ '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
	{ '<leader>nh', function() require('noice').cmd('history') end, desc = 'Noice [h]istory' },
	{ '<leader>na', function() require('noice').cmd('all') end, desc = 'Noice [a]ll' },
	{ '<leader>nd', function() require('noice').cmd('dismiss') end, desc = 'Noice [d]ismiss All' },
	{ '<leader>np', function() require('noice').cmd('pick') end, desc = 'Noice [p]icker' },
	{ '<leader>nl', function() require('noice').cmd('last') end, desc = 'Noice [l]ast Message' },
	{ '<leader>nu', '<cmd>messages<cr>', desc = 'Noice [u]ser Message' },
	-- stylua: ignore end
}
