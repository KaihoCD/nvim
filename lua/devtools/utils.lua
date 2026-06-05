local M = {}

local DEFAULT_VARIANT = 'default'

---@alias devtools.LspConfigBuilder fun(default_lsp_config: vim.lsp.Config): vim.lsp.Config

---@param default_lsp_config vim.lsp.Config
---@param variant_builders? table<string, devtools.LspConfigBuilder>
---@return table<string, vim.lsp.Config>
function M.build_lsp_configs(default_lsp_config, variant_builders)
    local lsp_configs = {
        [DEFAULT_VARIANT] = vim.deepcopy(default_lsp_config),
    }

    for variant, builder in pairs(variant_builders or {}) do
        if variant ~= DEFAULT_VARIANT and type(builder) == 'function' then
            lsp_configs[variant] = builder(vim.deepcopy(default_lsp_config))
        end
    end

    return lsp_configs
end

---@param name string
---@param lsp_configs vim.lsp.Config|table<string, vim.lsp.Config>
---@return vim.lsp.Config
function M.select_lsp_config(name, lsp_configs)
    local lsp_config_type = G.State.get('lsp_configs') or {}
    local variant = lsp_config_type[name]

    if type(lsp_configs) == 'table' and type(lsp_configs.default) == 'table' then
        return vim.deepcopy(lsp_configs[variant] or lsp_configs[DEFAULT_VARIANT])
    end

    return vim.deepcopy(lsp_configs)
end

return M
