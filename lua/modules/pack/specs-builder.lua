---@class PluginUserSpec
---@field src string
---@field name? string
---@field event? string|string[]
---@field ft? string|string[]
---@field version? string
---@field opts? table
---@field config? fun(opts?: table)
---@field deps? PluginUserSpec[]

---@class PluginSpec
---@field src string
---@field name string
---@field version? string
---@field event? string[]
---@field ft? string[]
---@field opts table
---@field config? fun(opts?: table)
---@field deps string[]
---@field loaded boolean

---@alias PluginSpecMap table<string, PluginSpec>

---@alias PluginSpecEntryList string[]

local M = {}

---@param value any
---@return table|nil
local function to_list(value)
    if value == nil then
        return nil
    end
    if type(value) ~= 'table' then
        return { value }
    end
    if vim.islist(value) then
        return value
    end
    return { value }
end

---@param input PluginUserSpec[]
---@return PluginUserSpec[], PluginSpecEntryList
local function scan_specs(input)
    local flat = {}
    local entry_list = {}

    local function walk(items, is_dep)
        local list = to_list(items) or {}
        for _, item in ipairs(list) do
            if type(item) == 'table' and item.src then
                if not is_dep then
                    table.insert(entry_list, item.src)
                end
                table.insert(flat, item)
                if item.deps then
                    walk(item.deps, true)
                end
            elseif type(item) == 'table' and vim.islist(item) then
                walk(item, is_dep)
            else
                error('Invalid plugin spec entry')
            end
        end
    end

    walk(input, false)
    return flat, entry_list
end

---@param flat PluginUserSpec[]
---@return table<string, PluginUserSpec[]>
local function collect_by_src(flat)
    local map = {}
    for _, spec in ipairs(flat) do
        map[spec.src] = map[spec.src] or {}
        table.insert(map[spec.src], spec)
    end
    return map
end

---@param user_specs PluginUserSpec[]
---@return PluginSpec
local function merge_specs(user_specs)
    local merged = {
        src = user_specs[1].src,
        name = nil,
        version = nil,
        event = nil,
        ft = nil,
        opts = {},
        config = nil,
        deps = {},
        loaded = false,
    }
    local seen_deps = {}
    for _, spec in ipairs(user_specs) do
        if spec.name then
            merged.name = spec.name
        end
        if spec.version then
            merged.version = spec.version
        end
        if spec.opts and vim.tbl_deep_extend then
            merged.opts = vim.tbl_deep_extend('force', merged.opts, spec.opts)
        end
        if spec.config then
            merged.config = spec.config
        end
        for _, e in ipairs(to_list(spec.event) or {}) do
            merged.event = merged.event or {}
            if not vim.tbl_contains(merged.event, e) then
                table.insert(merged.event, e)
            end
        end
        for _, f in ipairs(to_list(spec.ft) or {}) do
            merged.ft = merged.ft or {}
            if not vim.tbl_contains(merged.ft, f) then
                table.insert(merged.ft, f)
            end
        end
        for _, dep in ipairs(spec.deps or {}) do
            if not seen_deps[dep.src] then
                seen_deps[dep.src] = true
                table.insert(merged.deps, dep.src)
            end
        end
    end
    return merged
end

---@param spec PluginSpec
---@return PluginSpec
local function normalize(spec)
    if not spec.name then
        spec.name = spec.src:match('.*/(.*)') or spec.src
    end
    if spec.event then
        spec.event = to_list(spec.event)
    end
    if spec.ft then
        spec.ft = to_list(spec.ft)
    end
    spec.opts = spec.opts or {}
    spec.deps = spec.deps or {}
    return spec
end

---@param user_specs PluginUserSpec[]
---@return PluginSpecMap, PluginSpecEntryList
function M.build(user_specs)
    local flat, entry_list = scan_specs(user_specs)
    local grouped = collect_by_src(flat)
    local specs_map = {}
    for src, group in pairs(grouped) do
        local merged = merge_specs(group)
        local normalized = normalize(merged)
        specs_map[src] = normalized
    end
    return specs_map, entry_list
end

return M
