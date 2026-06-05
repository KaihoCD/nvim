---@class state.Storage
---@field get_data fun(): table<string, any>
---@field write fun()
---@field invalidate_cache fun()

local M = {}

local state_path = vim.fn.stdpath('config') .. '/state.json'

---@type table<string, any> | nil
local cache = nil

---@type fun()[]
local queue = {}

local scheduled = false
local write_pending = false

-- File IO

---Ensure the state directory exists.
local function ensure_dir()
    vim.fn.mkdir(vim.fn.stdpath('state'), 'p')
end

---Read persisted state from disk.
---@return table<string,any>
local function read_file()
    local fd = io.open(state_path, 'r')
    if not fd then
        return {}
    end

    local content = fd:read('*a')
    fd:close()

    local ok, data = pcall(vim.json.decode, content)

    if ok and type(data) == 'table' then
        return data
    end

    return {}
end

---Write state to disk.
---@param data table<string, any>
local function write_file(data)
    ensure_dir()

    local fd = io.open(state_path, 'w')
    if not fd then
        return
    end

    local encoded = vim.json.encode(data, { indent = '  ' })
    fd:write(encoded)
    fd:write('\n')
    fd:close()
end

-- Cache Management

---Load state once into memory.
local function ensure_cache()
    if cache == nil then
        cache = read_file()
    end
end

---Return the in-memory store, creating it if needed.
---@return table<string, any>
local function get_data()
    ensure_cache()

    if cache == nil then
        cache = {}
    end

    return cache
end

---Invalidate the cache (for testing purposes).
local function invalidate_cache()
    cache = nil
end

-- Write Queue

---Run all queued tasks.
local function run_queue()
    scheduled = false

    while #queue > 0 do
        local task = table.remove(queue, 1)
        task()
    end
end

---Queue work onto the scheduled write loop.
---@param task fun()
local function push(task)
    table.insert(queue, task)

    if not scheduled then
        scheduled = true
        vim.schedule(run_queue)
    end
end

---Schedule a write to disk.
local function schedule_write()
    if write_pending then
        return
    end

    write_pending = true

    push(function()
        write_file(cache or {})
        write_pending = false
    end)
end

M.get_data = get_data
M.write = schedule_write
M.invalidate_cache = invalidate_cache
M.get_file_path = function()
    return state_path
end

return M
