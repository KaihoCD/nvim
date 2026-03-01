return {
  { 'nvim-lua/plenary.nvim' },
  { 'MunifTanjim/nui.nvim' },
  {
    'folke/snacks.nvim',
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
    },
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    init = function()
      -- 重要：禁用默认映射，使用自定义映射
      vim.g.tmux_navigator_no_mappings = 1

      -- 禁用禁用退出时保存当前窗口（可选）
      vim.g.tmux_navigator_save_on_switch = 2
    end,
    config = function()
      local opts = { noremap = true, silent = true }

      -- 正常模式
      vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', opts)
      vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', opts)
      vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', opts)
      vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', opts)

      -- 终端模式
      vim.keymap.set('t', '<C-h>', '<C-\\><C-n><Cmd>TmuxNavigateLeft<CR>', opts)
      vim.keymap.set('t', '<C-j>', '<C-\\><C-n><Cmd>TmuxNavigateDown<CR>', opts)
      vim.keymap.set('t', '<C-k>', '<C-\\><C-n><Cmd>TmuxNavigateUp<CR>', opts)
      vim.keymap.set('t', '<C-l>', '<C-\\><C-n><Cmd>TmuxNavigateRight<CR>', opts)

      -- 可视化模式也支持
      vim.keymap.set('v', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', opts)
      vim.keymap.set('v', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', opts)
      vim.keymap.set('v', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', opts)
      vim.keymap.set('v', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', opts)
    end,
  },
}
