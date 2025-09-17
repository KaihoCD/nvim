local map = require('utils.funcs').map

return function()
	local gitsigns = require('gitsigns')
	local arg = { vim.fn.line('.'), vim.fn.line('v') }

	vim.api.nvim_create_user_command('GitsignsPreviewHunkInline', function()
		local ok, markdown = pcall(require, 'render-markdown')

		if ok then
			markdown.disable()
		end

		gitsigns.preview_hunk_inline()

		if not ok then
			return
		end

		vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
			buffer = vim.api.nvim_get_current_buf(),
			once = true,
			callback = function()
				markdown.enable()
			end,
		})
	end, {})

	-- stylua: ignore start
	-- hunk
	map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
	map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
	map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[r]eset hunk' })
	map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
	map('n', '<leader>hp', '<cmd>GitsignsPreviewHunkInline<cr>', { desc = '[p]review hunk' })
	map('n', '<leader>hb', gitsigns.blame, { desc = '[b]lame' })
  -- stylua: ignore start
	map('v', '<leader>hs', function()gitsigns.stage_hunk(arg) end, { desc = '[s]tage hunk' })
	map('v', '<leader>hr', function() gitsigns.reset_hunk(arg) end,{ desc = '[r]eset hunk' })
	map('n', '[h', function() gitsigns.nav_hunk('prev') end, { desc = 'prev [h]unk' })
	map('n', ']h', function() gitsigns.nav_hunk('next') end, { desc = 'next [h]unk' })
	-- git
	map('n', '<leader>gd', gitsigns.diffthis, { desc = '[d]iff against index' })
	map('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = '[d]iff against commit' })
	-- toggle
	map('n', '<leader>ub', gitsigns.toggle_current_line_blame, { desc = 'git [b]lame line' })
	map('n', '<leader>us', gitsigns.toggle_signs, { desc = 'git [s]ign' })
	map('n', '<leader>uw', gitsigns.toggle_word_diff, { desc = 'git [w]ord diff' })
	-- stylua: ignore end

	if Snacks then
		Snacks.toggle({
			name = 'Git Signs',
			get = function()
				return require('gitsigns.config').config.signcolumn
			end,
			set = function()
				gitsigns.toggle_signs()
			end,
		}):map('<leader>us')
		Snacks.toggle({
			name = 'Git Blame line',
			get = function()
				return require('gitsigns.config').config.current_line_blame
			end,
			set = function()
				gitsigns.toggle_current_line_blame()
			end,
		}):map('<leader>ub')
		Snacks.toggle({
			name = 'Git Word Diff',
			get = function()
				return require('gitsigns.config').config.word_diff
			end,
			set = function()
				gitsigns.toggle_word_diff()
			end,
		}):map('<leader>uw')
	end
end
