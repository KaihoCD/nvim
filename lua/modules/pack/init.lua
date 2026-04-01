local module_scan = require('modules.pack.module-scan')
local specs_builder = require('modules.pack.specs-builder')
local queue_builder = require('modules.pack.queue-builder')
local notify = require('utils.notify')

---@class PackManager
---@field use fun(name: string)

local M = {}
local module_cache = {}

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

    local pack_specs = {}
    for _, src in ipairs(srcs) do
        local spec = specs_map[src]
        if spec and not spec.loaded then
            table.insert(pack_specs, {
                src = spec.src,
                name = spec.name,
                version = spec.version,
            })
        end
    end

    if #pack_specs == 0 then
        return
    end

    vim.pack.add(pack_specs, {
        confirm = false,
        load = function(data)
            local plug_spec = data.spec or {}
            local spec = specs_map[plug_spec.src]

            if not spec or spec.loaded then
                return
            end

            if plug_spec.name then
                spec.name = plug_spec.name
            end

            setup_plugin(spec)
            spec.loaded = true
        end,
    })
end

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

---@param name string
function M.use(name)
    local user_specs = module_scan.scan(name)
    local specs_map, entry_list = specs_builder.build(user_specs)
    local queue = queue_builder.build(specs_map, entry_list)
    setup_triggers(specs_map, queue)
end

G.Pack = M

return M
