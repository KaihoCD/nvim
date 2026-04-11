local notify = require('utils.notify')

local M = {}

---@diagnostic disable: undefined-global
local function path_to_module(path)
    local config_root = vim.fn.stdpath('config') and vim.fn.stdpath('config') .. '/lua/' or ''

    local module_path = path:gsub('^' .. (vim.pesc(config_root) or config_root), '')

    module_path = module_path:gsub('/init%.lua$', '')
    module_path = module_path:gsub('%.lua$', '')
    module_path = module_path:gsub('/', '.')

    return module_path
end

local function resolve_module_name(module_name)
    if module_name and module_name ~= '' then
        return module_name
    end

    local caller = debug.getinfo(3, 'S')
    local source = caller and caller.source or ''

    if source:sub(1, 1) == '@' then
        return path_to_module(source:sub(2))
    end
    error('Unable to resolve caller module path')
end

---Scans the specified root module for plugin specifications.
---@param name string - The root module name to scan for plugin specifications.
---@return table[] - A list of plugin specifications found in the scanned modules.
function M.scan(name)
    local root_module = resolve_module_name(name)
    local plugin_root = (vim and vim.fn and vim.fn.stdpath and vim.fn.stdpath('config'))
            and vim.fn.stdpath('config') .. '/lua/' .. root_module:gsub('%%.', '/')
        or ''
    local modules, specs = {}, {}

    if vim and vim.fs and vim.fs.dir then
        for _name, kind in vim.fs.dir(plugin_root) do
            if kind == 'directory' then
                table.insert(modules, _name)
            end
        end
    end

    table.sort(modules)

    for _, module_name in ipairs(modules) do
        local ok, mod = pcall(require, root_module .. '.' .. module_name)
        if ok and type(mod) == 'table' then
            if vim and vim.list_extend then
                vim.list_extend(specs, mod)
            else
                for _, v in ipairs(mod) do
                    table.insert(specs, v)
                end
            end
        else
            local err_msg = mod or 'unknown error'
            notify.warn('Failed to require module: ' .. root_module .. '.' .. module_name)
            notify.warn('\nError: ' .. err_msg)
        end
    end

    return specs
end

return M
