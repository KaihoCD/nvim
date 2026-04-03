local M = {}

function M.config()
    vim.opt.showtabline = 2
    local heirline = require('heirline')
    local highlights = require('heirline.highlights')
    local clrs = G.State.get('clrs') or {}

    highlights.clear_colors()
    heirline.load_colors(clrs.palette or {})

    heirline.setup({
        statusline = require('plugins.ui.heirline.statusline'),
        tabline = require('plugins.ui.heirline.tabline'),
    })
end

return M
