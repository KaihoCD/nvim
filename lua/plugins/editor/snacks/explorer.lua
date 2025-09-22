local M = {}

M.keys = {
  {
    '<leader>e',
    function()
      Snacks.explorer()
    end,
    desc = 'File [e]xplorer',
    remap = true,
  },
}

M.opts = { enabled = true }

return M
