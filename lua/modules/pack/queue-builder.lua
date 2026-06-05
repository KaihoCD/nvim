local M = {}

---@param specs_map modules.pack.PluginSpecMap
---@return modules.pack.DepGraph
local function build_graph(specs_map)
    local graph = {}
    for src, spec in pairs(specs_map) do
        graph[src] = spec.deps or {}
    end
    return graph
end

---@param graph modules.pack.DepGraph
local function validate_deps(graph)
    for src, deps in pairs(graph) do
        for _, dep_src in ipairs(deps) do
            if not graph[dep_src] then
                error('Missing dependency: ' .. dep_src .. ' for ' .. src)
            end
        end
    end
end

---@param graph modules.pack.DepGraph
local function validate_no_cycle(graph)
    local visiting = {}
    local visited = {}

    local function dfs(src)
        if visiting[src] then
            error('Cycle detected: ' .. src)
        end
        if visited[src] then
            return
        end

        visiting[src] = true
        for _, dep_src in ipairs(graph[src]) do
            dfs(dep_src)
        end
        visiting[src] = nil
        visited[src] = true
    end

    for src in pairs(graph) do
        dfs(src)
    end
end

---@param spec modules.pack.PluginSpec
---@return string, string[]
local function classify(spec)
    if spec.event then
        return 'event', spec.event
    end
    if spec.ft then
        return 'ft', spec.ft
    end
    return 'startup', { '__startup__' }
end

---@param specs_map modules.pack.PluginSpecMap
---@param entry_list modules.pack.PluginSpecEntryList
---@return string[]
local function ordered_sources(specs_map, entry_list)
    local ordered = {}
    local seen = {}

    for _, src in ipairs(entry_list) do
        if not specs_map[src] then
            error('Entry plugin not found in specs map: ' .. src)
        end
        if not seen[src] then
            seen[src] = true
            table.insert(ordered, src)
        end
    end

    return ordered
end

---@param graph modules.pack.DepGraph
---@param src string
---@param cache table<string, string[]>
---@param visiting modules.pack.SeenSet
---@return string[]
local function resolve_for(graph, src, cache, visiting)
    if cache[src] then
        return cache[src]
    end
    if visiting[src] then
        error('Cycle detected: ' .. src)
    end

    visiting[src] = true
    local resolved = {}
    local seen_local = {}

    for _, dep_src in ipairs(graph[src]) do
        local dep_order = resolve_for(graph, dep_src, cache, visiting)
        for _, dep in ipairs(dep_order) do
            if not seen_local[dep] then
                seen_local[dep] = true
                table.insert(resolved, dep)
            end
        end
    end

    table.insert(resolved, src)
    visiting[src] = nil
    cache[src] = resolved
    return resolved
end

---@param queue modules.pack.PackQueue
---@param kind "event"|"ft"
---@param key string
---@param seen_by_key table<string, modules.pack.SeenSet>
---@return string[], modules.pack.SeenSet
local function ensure_keyed_bucket_state(queue, kind, key, seen_by_key)
    queue[kind][key] = queue[kind][key] or {}
    seen_by_key[key] = seen_by_key[key] or {}
    return queue[kind][key], seen_by_key[key]
end

---@param bucket string[]
---@param seen modules.pack.SeenSet
---@param items string[]
local function append_unique(bucket, seen, items)
    for _, src in ipairs(items) do
        if not seen[src] then
            seen[src] = true
            table.insert(bucket, src)
        end
    end
end

---Builds a plugin loading queue based on the provided specifications and entry list.
---@param specs_map modules.pack.PluginSpecMap
---@param entry_list modules.pack.PluginSpecEntryList
---@return modules.pack.PackQueue
function M.build(specs_map, entry_list)
    if type(entry_list) ~= 'table' then
        error('queue-builder.build expects entry_list (modules.pack.PluginSpecEntryList)')
    end

    local graph = build_graph(specs_map)
    validate_deps(graph)
    validate_no_cycle(graph)

    local queue = { startup = {}, event = {}, ft = {} }
    local startup_seen = {}
    local event_seen = {}
    local ft_seen = {}
    local resolved_cache = {}
    local visiting = {}

    for _, src in ipairs(ordered_sources(specs_map, entry_list)) do
        local spec = specs_map[src]
        local kind, keys = classify(spec)
        local ordered = resolve_for(graph, src, resolved_cache, visiting)

        for _, key in ipairs(keys) do
            if kind == 'startup' then
                append_unique(queue.startup, startup_seen, ordered)
            elseif kind == 'event' then
                local bucket, seen = ensure_keyed_bucket_state(queue, 'event', key, event_seen)
                append_unique(bucket, seen, ordered)
            else
                local bucket, seen = ensure_keyed_bucket_state(queue, 'ft', key, ft_seen)
                append_unique(bucket, seen, ordered)
            end
        end
    end

    return queue
end

return M
