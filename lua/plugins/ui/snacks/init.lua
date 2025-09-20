local M = {}

-- Disable animate by default
vim.g.snacks_animate = false

M.opts = {
  animate = {
    duration = 15,
    easing = 'outInQuad',
    fps = 60,
  },
  indent = {
    enabled = true,
  },
  scroll = {
    enabled = false,
    filter = function(buf)
      return vim.g.snacks_scroll ~= false
        and vim.b[buf].snacks_scroll ~= false
        and vim.bo[buf].buftype ~= 'terminal'
        and vim.bo[buf].filetype ~= 'blink-cmp-menu'
    end,
  },
  styles = require('plugins.ui.snacks.styles'),
  input = { enabled = true },
  statuscolumn = {
    left = { 'mark', 'sign' },
    right = { 'fold', 'git' },
    git_hl = true,
  },
  toggle = { enabled = true },
  scope = { enabled = true },
  words = { enabled = true },
  image = {},
}

return M
