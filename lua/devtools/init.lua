local lsps = require('devtools.lsps')
local linters = require('devtools.linters')
local formatters = require('devtools.formatters')
local utils = require('devtools.utils')

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
        if linter ~= 'eslint' then
            table.insert(combined, linter)
        end
    end
    return combined
end

-- Get lsps config
function M.get_lsps()
    local configs = {}

    for name, lsp_configs in pairs(lsps) do
        configs[name] = utils.select_lsp_config(name, lsp_configs)
    end

    return configs
end

function M.get_formatters()
    return formatters
end

function M.get_linters()
    return linters
end

return M
