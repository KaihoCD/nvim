local storage = require('state.storage')
local schema_parser = require('state.schema_parser')
local validator = require('state.validator')

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
---@param key string The state key
---@param data any The data to validate
---@param schema table The parsed schema
local function validate_and_notify(key, data, schema)
    local ok, errors, warnings = validator.validate(data, schema)

    if not ok then
        vim.notify(
            string.format('State validation failed for "%s":\n%s', key, table.concat(errors, '\n')),
            vim.log.levels.ERROR
        )
    end

    if warnings and #warnings > 0 then
        vim.notify(
            string.format(
                'State validation warnings for "%s":\n%s',
                key,
                table.concat(warnings, '\n')
            ),
            vim.log.levels.WARN
        )
    end
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
                    validate_and_notify(key, data[key], parsed_schema)
                end
            end
        end
    end

    if changed then
        storage.write()
    end
end

return M
