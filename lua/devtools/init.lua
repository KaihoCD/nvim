local lsps = {
  ['html'] = {},
  ['cssls'] = {},
  ['emmet_ls'] = {},
  ['marksman'] = {},
  ['ts_ls'] = require('devtools.lsps.ts_ls'),
  ['jsonls'] = require('devtools.lsps.jsonls'),
  ['lua_ls'] = require('devtools.lsps.lua_ls'),
}
local formatters = {
  ['prettierd'] = function()
    return {
      prepend_args = {
        '--tab-width',
        G.config.indent_size,
      },
    }
  end,
  ['stylua'] = function()
    return {
      prepend_args = {
        '--indent-width',
        G.config.indent_size,
      },
    }
  end,
  ['shfmt'] = {},
  ['cbfmt'] = {},
}
local linters = {
  ['eslint_d'] = {},
  ['markdownlint'] = {},
}

local M = {}

-- get ensure installed list
function M.get_installed()
  local combined = {}
  for lsp in pairs(lsps) do
    table.insert(combined, lsp)
  end
  for formatter in pairs(formatters) do
    table.insert(combined, formatter)
  end
  for linter in pairs(linters) do
    table.insert(combined, linter)
  end
  return combined
end

-- Get lsps config
function M.get_lsps()
  return lsps
end

function M.get_formatters()
  return formatters
end

return M
