local M = {}

M.opts = {
  notify_no_formatters = true,
  notify_on_error = true,

  formatters_by_ft = {
    javascript = { 'prettierd', 'eslint_d' },
    typescript = { 'prettierd', 'eslint_d' },
    javascriptreact = { 'prettierd', 'eslint_d' },
    typescriptreact = { 'prettierd', 'eslint_d' },
    vue = { 'prettierd', 'eslint_d' },
    css = { 'prettierd' },
    html = { 'prettierd' },
    json = { 'prettierd' },
    yaml = { 'prettierd' },
    markdown = { 'prettierd', 'cbfmt' },
    lua = { 'stylua' },
    zsh = { 'shfmt' },
    bash = { 'shfmt' },
  },

  formatters = require('devtools').get_formatters(),

  format_on_save = function()
    if G.config.format_on_save then
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    else
      return nil
    end
  end,
}

M.keys = {
  {
    mode = { 'n', 'v' },
    '<leader>lf',
    function()
      require('conform').format({
        async = true,
        lsp_format = 'fallback',
        timeout_ms = 500,
      })
    end,
    desc = '[f]ormat',
  },
}

return M
