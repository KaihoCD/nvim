local flash = require('plugins.editor.flash')
local gitsigns = require('plugins.editor.gitsigns')
local snacks = require('plugins.editor.snacks')
local whichkey = require('plugins.editor.whichkey')

return {
  {
    desc = 'Snacks File Picker',
    'folke/snacks.nvim',
    keys = snacks.picker.keys,
    opts = { picker = snacks.picker.opts },
  },
  {
    desc = 'Snacks Terminal',
    'folke/snacks.nvim',
    keys = snacks.terminal.keys,
    opts = {
      terminal = snacks.terminal.opts,
      lazygit = snacks.lazygit.opts,
    },
  },
  {
    desc = 'Snacks File Explorer',
    'folke/snacks.nvim',
    keys = snacks.explorer.keys,
    opts = { explorer = snacks.explorer.opts },
  },
  {
    desc = 'Snacks File Notifier',
    'folke/snacks.nvim',
    keys = snacks.explorer.keys,
    opts = { notifier = snacks.notifier.opts },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = gitsigns.opts,
  },
  {
    'kosayoda/nvim-lightbulb',
    event = 'VeryLazy',
    opts = {
      autocmd = { enabled = true, updatetime = 250 },
      code_lenses = true,
      sign = {
        text = '󱠁',
        lens_text = '',
        hl = 'LightBulbSign',
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = 'VeryLazy',
    keys = {
      -- stylua: ignore start
			{ ']t', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment' },
			{ '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous Todo Comment' },
			{ '<leader>st', function() if Snacks then Snacks.picker['todo_comments']() end end, desc = '[t]odo' },
      -- stylua: ignore end
    },
    opts = {},
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    keys = flash.keys,
    opts = flash.opts,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = whichkey.opts,
  },
  {
    'NMAC427/guess-indent.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
