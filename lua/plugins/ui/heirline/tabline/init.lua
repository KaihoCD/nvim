local bufdel = require('utils.bufdel')
local comps = require('plugins.ui.heirline.tabline.comps')
local picker = require('plugins.ui.heirline.tabline.picker')
local utils = require('heirline.utils')
local map = require('utils.funcs').map

-- keymaps
map('n', '<leader>bb', function()
  return picker.buffer_picker(function(bufnr)
    vim.api.nvim_win_set_buf(0, bufnr)
  end)
end, { desc = 'Pick: Select [b]uffer' })
map('n', '<leader>bd', function()
  return picker.buffer_picker(function(bufnr)
    bufdel(bufnr)
  end)
end, { desc = 'Pick: [d]elete buffer' })
map('n', '<leader>bs', function()
  return picker.buffer_picker(function(bufnr)
    vim.cmd.split()
    vim.api.nvim_win_set_buf(0, bufnr)
  end)
end, { desc = 'Pick: Horizontal [s]plit buffer' })
map('n', '<leader>bv', function()
  return picker.buffer_picker(function(bufnr)
    vim.cmd.vsplit()
    vim.api.nvim_win_set_buf(0, bufnr)
  end)
end, { desc = 'Pick: [v]ertical split buffer' })

return {
  comps.ExplorerOffset,
  utils.make_buflist(
    {
      comps.BufferBlock,
      hl = function(self)
        return {
          fg = self.is_active and 'active_fg' or 'inactive_fg',
          bg = 'bg',
        }
      end,
    },
    -- iterator
    { provider = '  ' },
    { provider = '  ' },
    function()
      return vim.t.bufs
    end,
    false
  ),
  { provider = '%=' },
  comps.TabPages,
  hl = function()
    return { bg = 'bg' }
  end,
}
