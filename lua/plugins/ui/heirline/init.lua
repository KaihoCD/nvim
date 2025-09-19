return {
  config = function()
    local heirline = require('heirline')
    -- always show tabline
    vim.opt.showtabline = 2

    -- load colors
    heirline.load_colors(require('plugins.ui.heirline.colors').get_colors())

    -- setup heirline
    heirline.setup({
      statusline = require('plugins.ui.heirline.statusline'),
      tabline = require('plugins.ui.heirline.tabline'),
    })
  end,
}
