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

  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = 'fallback',
  },

  format_on_save = function()
    if G.config.format_on_save then
      return {}
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
      require('conform').format()
    end,
    desc = '[f]ormat',
  },
}

return M
