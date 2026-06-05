local storage = require('state.storage')
local schema_parser = require('state.schema-parser')
local validator = require('state.validator')
local Notify = require('utils.notify')
local notify = Notify.new({ title = 'State' })

local M = {}

---@type table<string, table>
local schema_registry = {}

---Merge default values into existing data recursively.
---Only sets fields that are nil in the existing data.
---@param existing table<string, any>
---@param defaults table<string, any>
---@return boolean changed
local function merge_defaults(existing, defaults)
    local changed = false
    for key, value in pairs(defaults) do
        if existing[key] == nil then
            existing[key] = vim.deepcopy(value)
            changed = true
        elseif type(existing[key]) == 'table' and type(value) == 'table' then
            if merge_defaults(existing[key], value) then
                changed = true
            end
        end
    end
    return changed
end

---Validate data against schema and show notifications.
---@param data any The data to validate
---@param schema table The parsed schema
local function validate_and_notify(data, schema)
    local ok, errors, warnings = validator.validate(data, schema)

    if not ok then
        -- Display each error separately (already formatted by validator)
        for _, error_msg in ipairs(errors) do
            vim.schedule(function()
                notify.error(error_msg)
            end)
        end
    end

    if warnings and #warnings > 0 then
        -- Display warnings
        for _, warning_msg in ipairs(warnings) do
            vim.schedule(function()
                notify.warn(warning_msg)
            end)
        end
    end
end

---Reload state from file and validate all data.
---@return boolean success True if reload succeeded
local function reload_from_file()
    -- Read state.json file
    local state_file = storage.get_file_path()
    local fd = io.open(state_file, 'r')
    if not fd then
        notify.error('Failed to open state.json for reading')
        return false
    end

    local content = fd:read('*a')
    fd:close()

    -- Parse JSON
    local ok, data = pcall(vim.json.decode, content)
    if not ok then
        notify.error(string.format('Failed to parse state.json:\n%s', data))
        return false
    end

    if type(data) ~= 'table' then
        notify.error('Invalid state.json: must be a JSON object')
        return false
    end

    -- Validate all keys against their schemas
    local all_errors = {}
    for key, value in pairs(data) do
        local schema = schema_registry[key]
        if schema then
            local valid, errors = validator.validate(value, schema)
            if not valid then
                table.insert(all_errors, string.format('Key "%s":', key))
                for _, err in ipairs(errors) do
                    table.insert(all_errors, '  ' .. err)
                end
            end
        end
    end

    -- If validation failed, don't apply changes
    if #all_errors > 0 then
        notify.error(
            string.format(
                'State validation failed. Changes not applied:\n%s',
                table.concat(all_errors, '\n')
            )
        )
        return false
    end

    -- Validation passed, reload data from disk
    storage.invalidate_cache()
    storage.get_data() -- This will re-read from disk

    notify.info('State reloaded successfully')

    -- Trigger StateUpdated event
    vim.api.nvim_exec_autocmds('User', {
        pattern = 'StateUpdated',
        data = { data = storage.get_data() },
    })

    return true
end

---Get a value from state.
---@param key string The state key
---@return any The value, or nil if not found
function M.get(key)
    local data = storage.get_data()
    return data[key]
end

---Set a value in state.
---@param key string The state key
---@param value any The value to set
function M.set(key, value)
    local data = storage.get_data()
    data[key] = value
    storage.write()

    -- Trigger StateUpdated event
    vim.api.nvim_exec_autocmds('User', {
        pattern = 'StateUpdated',
        data = { data = storage.get_data() },
    })
end

---Register default values and optional validation schema.
---@param defaults table<string, any> Default values to merge into state
---@param schemas? table<string, any> Optional validation schema definitions
function M.register(defaults, schemas)
    local data = storage.get_data()
    local changed = false

    -- Parse and store schemas if provided
    if schemas then
        for key, schema_def in pairs(schemas) do
            local parsed_schema = schema_parser.parse(schema_def)
            schema_registry[key] = parsed_schema
        end
    end

    -- Merge defaults into existing data
    for key, value in pairs(defaults) do
        if data[key] == nil then
            data[key] = vim.deepcopy(value)
            changed = true
        elseif type(data[key]) == 'table' and type(value) == 'table' then
            if merge_defaults(data[key], value) then
                changed = true
            end
        end
    end

    -- Validate final data (from disk + defaults) against schema
    if schemas then
        for key, _ in pairs(schemas) do
            if data[key] then
                local parsed_schema = schema_registry[key]
                if parsed_schema then
                    validate_and_notify(data[key], parsed_schema)
                end
            end
        end
    end

    if changed then
        storage.write()
    end
end

---Setup file watcher for state.json.
---Automatically reloads state when the file is saved.
function M.watch_file()
    local state_file = storage.get_file_path()

    vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = state_file,
        callback = function()
            reload_from_file()
        end,
        desc = 'Auto-reload state when state.json is saved',
    })

    require('utils').map('n', '<leader>se', function()
        vim.cmd.edit(storage.get_file_path())
    end, { desc = '[s]tate [e]dit' })
end

return M
