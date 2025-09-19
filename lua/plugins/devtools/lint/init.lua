local debounce = require('utils.funcs').debounce

local M = {}

local linters_by_ft = {
  markdown = { 'markdownlint' },
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
}

M.keys = {
  {
    '<leader>ll',
    function()
      require('lint').try_lint()
    end,
    desc = '[l]int',
  },
}

M.config = function()
  local lint = require('lint')

  lint.linters_by_ft = linters_by_ft

  local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = lint_augroup,
    callback = function()
      if vim.bo.modifiable then
        lint.try_lint()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    group = lint_augroup,
    callback = debounce(500, function()
      if G.config.lint_when_text_changed and vim.bo.modifiable then
        lint.try_lint()
      end
    end),
  })
end

return M
