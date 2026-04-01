local M = {}

function M.config()
    vim.opt.showtabline = 2
    local heirline = require('heirline')
    local highlights = require('heirline.highlights')

    highlights.clear_colors()
    heirline.load_colors(G.State.get('colors'))

    heirline.setup({
        statusline = require('plugins.ui.heirline.statusline'),
        tabline = require('plugins.ui.heirline.tabline'),
    })
end

return M
