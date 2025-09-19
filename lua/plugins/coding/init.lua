return {
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    version = false,
    opts = {},
  },
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    version = false,
    opts = {},
  },
  {
    'echasnovski/mini.surround',
    event = 'VeryLazy',
    version = false,
    opts = {},
  },
  -- Comments
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  -- Doc comments
  {
    'danymat/neogen',
    event = 'InsertEnter',
    keys = {
      {
        'gcd',
        function()
          require('neogen').generate()
        end,
        desc = 'Generate Annotations (Neogen)',
      },
    },
    opts = {},
  },
  -- Completion
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'lazy.nvim', words = { 'LazyVim' } },
      },
    },
  },
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = {
      { 'xzbdmw/colorful-menu.nvim', 'rafamadriz/friendly-snippets' },
    },
    keys = { ':', '/' }, -- load when into cmdline
    opts = require('plugins.coding.blink').opts,
  },
}
