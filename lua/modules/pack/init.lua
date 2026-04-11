local module_scan = require('modules.pack.module-scan')
local specs_builder = require('modules.pack.specs-builder')
local queue_builder = require('modules.pack.queue-builder')
local notify = require('utils.notify')

---@class PackManager
---@field use fun(name: string)

local M = {}
local module_cache = {}

---Synchronizes the plugins specified in the specs_map with the local plugin directory.
---@param specs_map PluginSpecMap - A map of plugin specifications keyed by their source identifiers.
local function sync_plugins(specs_map)
    local pack_specs = {}
    local need_install = false

    local base_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/'

    for _, spec in pairs(specs_map) do
        local path = base_path .. spec.name

        if not need_install and not vim.uv.fs_stat(path) then
            need_install = true
        end

        table.insert(pack_specs, {
            name = spec.name,
            src = spec.src,
            version = spec.version,
        })
    end

    if not need_install or #pack_specs == 0 then
        return
    end

    vim.pack.add(pack_specs, {
        confirm = false,
        load = function()
            --[[ nop function ]]
        end,
    })
end

---@param name string
---@return string[]
local function guess_modules(name)
    local stripped = name:gsub('%.nvim$', '')
    return stripped == name and { name } or { name, stripped }
end

---@param spec PluginSpec
local function setup_plugin(spec)
    vim.cmd.packadd(spec.name)

    if spec.config then
        spec.config(spec.opts or {})
        return
    end

    local plugin_name = spec.name
    for _, mod_name in ipairs(guess_modules(plugin_name)) do
        if module_cache[mod_name] ~= nil then
            if module_cache[mod_name] then
                module_cache[mod_name].setup(spec.opts or {})
            end
            return
        end

        local ok, mod = pcall(require, mod_name)
        if ok and type(mod) == 'table' and type(mod.setup) == 'function' then
            module_cache[mod_name] = mod
            mod.setup(spec.opts or {})
            return
        end
        module_cache[mod_name] = false
    end

    notify.warn('Failed to setup plugin: ')
    for _, mod_name in ipairs(guess_modules(plugin_name)) do
        notify.warn(' - ' .. mod_name)
    end
end

---@param specs_map PluginSpecMap
---@param srcs string[]
local function load_plugins(specs_map, srcs)
    if #srcs == 0 then
        return
    end

    for _, src in ipairs(srcs) do
        local spec = specs_map[src]
        if not spec or spec.loaded then
            goto continue
        end

        setup_plugin(spec)
        spec.loaded = true

        ::continue::
    end
end

---Sets up triggers for loading plugins based on the provided specs_map and queue.
---@param specs_map PluginSpecMap
---@param queue PackQueue
local function setup_triggers(specs_map, queue)
    if #queue.startup > 0 then
        load_plugins(specs_map, queue.startup)
    end

    local current_ft = vim.bo.filetype
    for ft, srcs in pairs(queue.ft) do
        if ft == current_ft then
            load_plugins(specs_map, srcs)
        else
            vim.api.nvim_create_autocmd('FileType', {
                pattern = ft,
                once = true,
                callback = function()
                    load_plugins(specs_map, srcs)
                end,
            })
        end
    end

    for event, srcs in pairs(queue.event) do
        vim.api.nvim_create_autocmd(event, {
            once = true,
            callback = function()
                load_plugins(specs_map, srcs)
            end,
        })
    end
end

---@param name? string
function M.setup(name)
    local user_specs = module_scan.scan(name or 'plugins')
    local specs_map, entry_list = specs_builder.build(user_specs)
    local queue = queue_builder.build(specs_map, entry_list)
    sync_plugins(specs_map)
    setup_triggers(specs_map, queue)
end

return M
