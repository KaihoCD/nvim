local M = {}

function M.config()
    vim.opt.showtabline = 2
    require('heirline').setup({
        statusline = require('plugins.ui.heirline.statusline'),
        tabline = require('plugins.ui.heirline.tabline'),
    })
end

return M
