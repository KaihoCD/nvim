local M = {}

---@param rule_string string Rule string, e.g. 'boolean', 'enum:a|b', 'pattern:xxx'
---@return table schema
local function parse_rule_string(rule_string)
    if type(rule_string) ~= 'string' then
        return { error = 'Rule must be a string, got: ' .. type(rule_string) }
    end

    -- Enum: enum:a|b|c
    local enum_prefix = 'enum:'
    if vim.startswith(rule_string, enum_prefix) then
        local enum_str = rule_string:sub(#enum_prefix + 1)
        local values = vim.split(enum_str, '|', { plain = true })
        return {
            type = 'string',
            enum = values,
        }
    end

    -- Parttern: pattern:xxx
    local pattern_prefix = 'pattern:'
    if vim.startswith(rule_string, pattern_prefix) then
        local pattern = rule_string:sub(#pattern_prefix + 1)
        return {
            type = 'string',
            pattern = pattern,
        }
    end

    -- Range: range:min-max
    local range_prefix = 'range:'
    if vim.startswith(rule_string, range_prefix) then
        local range_str = rule_string:sub(#range_prefix + 1)
        local min, max = range_str:match('^(%d+)%-(%d+)$')
        if min and max then
            return {
                type = 'number',
                min = tonumber(min),
                max = tonumber(max),
            }
        else
            return { error = 'Invalid range format: ' .. range_str }
        end
    end

    -- Simple type: boolean, string, number, table
    local valid_types = { 'boolean', 'string', 'number', 'table' }
    if vim.tbl_contains(valid_types, rule_string) then
        return { type = rule_string }
    end

    -- Unknown
    return { error = 'Unknown rule type: ' .. rule_string }
end

---@param schema_def table schema
---@return table parsed_schema
local function parse_schema_recursive(schema_def)
    if type(schema_def) ~= 'table' then
        return parse_rule_string(schema_def)
    end

    local parsed = {}

    for key, value in pairs(schema_def) do
        if type(value) == 'string' then
            -- Simple rule string
            parsed[key] = parse_rule_string(value)
        elseif type(value) == 'table' then
            -- Nested object, parse recursively
            parsed[key] = parse_schema_recursive(value)
        else
            parsed[key] = { error = 'Invalid schema value type: ' .. type(value) }
        end
    end

    return parsed
end

---@param schema_config table|nil User-defined schema (2nd parameter of register)
---@return table parsed_schemas Schemas organized by category
function M.parse(schema_config)
    if not schema_config or type(schema_config) ~= 'table' then
        return {}
    end

    local parsed_schemas = {}

    for category, category_schema in pairs(schema_config) do
        parsed_schemas[category] = parse_schema_recursive(category_schema)
    end

    return parsed_schemas
end

---@param defaults table
---@return table inferred_schema
function M.infer_from_defaults(defaults)
    local inferred = {}

    for key, value in pairs(defaults) do
        local value_type = type(value)

        if value_type == 'table' then
            -- 递归推断嵌套表
            inferred[key] = M.infer_from_defaults(value)
        else
            -- 简单类型
            inferred[key] = { type = value_type }
        end
    end

    return inferred
end

return M
