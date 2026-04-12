local M = {}

---Format error message in a consistent, clean style
---@param field_path string The field path (e.g., "lsp_configs.vtsls")
---@param error_type string The error type (e.g., "Invalid enum value")
---@param expected string? Expected value description
---@param got string? Actual value received
---@return string formatted_error The formatted error message
local function format_error(field_path, error_type, expected, got)
    local lines = {
        string.format('Field: "%s"', field_path),
        string.format('Error: %s', error_type),
    }

    if expected then
        table.insert(lines, string.format('- Expected: %s', expected))
    end

    if got then
        table.insert(lines, string.format('- But Got: %s', got))
    end

    -- Add blank line before fix instruction
    table.insert(lines, '')
    table.insert(lines, 'Please Fix at "state.json"')

    return table.concat(lines, '\n')
end

---Validate if a single value conforms to the schema
---@param value any Value to validate
---@param schema table Schema definition
---@param path string Field path (for error messages)
---@return boolean ok
---@return string? error
local function validate_value(value, schema, path)
    -- Check if schema has errors
    if schema.error then
        return false, path .. ': Schema error - ' .. schema.error
    end

    local value_type = type(value)
    local expected_type = schema.type

    -- If schema has no explicit type but has nested field definitions, infer as table
    if not expected_type then
        local has_nested_fields = false
        for key, _ in pairs(schema) do
            if
                key ~= 'type'
                and key ~= 'enum'
                and key ~= 'pattern'
                and key ~= 'min'
                and key ~= 'max'
                and key ~= 'required'
                and key ~= 'error'
            then
                has_nested_fields = true
                break
            end
        end
        if has_nested_fields then
            expected_type = 'table'
        end
    end

    -- Type check
    if expected_type and value_type ~= expected_type then
        return false, format_error(path, 'Type mismatch', expected_type, value_type)
    end

    -- Enum value check
    if schema.enum then
        if not vim.tbl_contains(schema.enum, value) then
            -- Format enum values with quotes and join with |
            local quoted_enums = vim.tbl_map(function(v)
                return string.format('"%s"', v)
            end, schema.enum)

            return false,
                format_error(
                    path,
                    'Invalid enum value',
                    table.concat(quoted_enums, '|'),
                    string.format('"%s"', tostring(value))
                )
        end
    end

    -- Pattern check
    if schema.pattern then
        if value_type ~= 'string' then
            return false, path .. ' must be string for pattern matching'
        end

        -- Try Lua pattern first
        local matched = value:match(schema.pattern) ~= nil

        if not matched then
            -- Try as vim regex (uses Vim regex syntax, not PCRE)
            -- In Vim regex: use \{n\} for repetition, not {n}
            local ok, regex = pcall(vim.regex, schema.pattern)
            if ok and regex then
                local match_pos = regex:match_str(value)
                -- match_str returns the position (0-indexed) if matched, nil otherwise
                if match_pos ~= nil then
                    matched = true
                end
            end
        end

        if not matched then
            return false,
                format_error(path, 'Pattern mismatch', schema.pattern, string.format('"%s"', value))
        end
    end

    -- Number range check
    if schema.min or schema.max then
        if value_type ~= 'number' then
            return false, path .. ' must be number for range check'
        end

        -- Build range description
        local range_desc
        if schema.min and schema.max then
            range_desc = string.format('>= %d and <= %d', schema.min, schema.max)
        elseif schema.min then
            range_desc = string.format('>= %d', schema.min)
        else
            range_desc = string.format('<= %d', schema.max)
        end

        -- Check if value is in range
        if (schema.min and value < schema.min) or (schema.max and value > schema.max) then
            return false, format_error(path, 'Out of range', range_desc, tostring(value))
        end
    end

    -- 5. Recursively validate nested tables
    if value_type == 'table' and expected_type == 'table' then
        -- Check if there are schemas for subfields
        local has_field_schemas = false
        local wildcard_schema = nil

        for key, sub_schema in pairs(schema) do
            if
                key ~= 'type'
                and key ~= 'enum'
                and key ~= 'pattern'
                and key ~= 'min'
                and key ~= 'max'
            then
                if key == '*' then
                    wildcard_schema = sub_schema
                else
                    has_field_schemas = true
                end
            end
        end

        if has_field_schemas or wildcard_schema then
            -- Validate each subfield
            for key, sub_value in pairs(value) do
                local sub_schema = schema[key] or wildcard_schema

                if sub_schema then
                    local ok, err = validate_value(sub_value, sub_schema, path .. '.' .. key)
                    if not ok then
                        return false, err
                    end
                else
                    -- New field, warn but don't block
                    vim.notify(
                        string.format('New field: %s.%s (%s)', path, key, type(sub_value)),
                        vim.log.levels.WARN
                    )
                end
            end

            -- Check for missing fields (optional, currently only warns)
            for key, sub_schema in pairs(schema) do
                if
                    key ~= 'type'
                    and key ~= 'enum'
                    and key ~= 'pattern'
                    and key ~= 'min'
                    and key ~= 'max'
                    and key ~= '*'
                then
                    if value[key] == nil then
                        if sub_schema.required then
                            return false,
                                format_error(path .. '.' .. key, 'Required field missing', nil, nil)
                        else
                            vim.notify(
                                string.format('Missing field: %s.%s', path, key),
                                vim.log.levels.WARN
                            )
                        end
                    end
                end
            end
        end
    end

    return true
end

---Validate if a single data object conforms to the schema
---@param data any Data to validate
---@param schema table Schema definition
---@return boolean success Whether validation passed
---@return string[] errors Error list
---@return string[] warnings Warning list
function M.validate(data, schema)
    local errors = {}
    local warnings = {}

    -- If data is a table and schema is also a table, perform field validation
    if type(data) == 'table' and type(schema) == 'table' then
        -- Validate each field in data
        for field, value in pairs(data) do
            local field_schema = schema[field] or schema['*']

            if field_schema then
                local ok, err = validate_value(value, field_schema, field)
                if not ok then
                    table.insert(errors, err)
                end
            else
                -- New field warning (doesn't block validation)
                table.insert(
                    warnings,
                    string.format('No schema for field: %s (%s)', field, type(value))
                )
            end
        end

        -- Check for missing required fields
        for field, field_schema in pairs(schema) do
            if field ~= '*' and data[field] == nil then
                if field_schema.required then
                    table.insert(errors, format_error(field, 'Required field missing', nil, nil))
                else
                    -- Warn when optional fields are missing
                    table.insert(warnings, string.format('Optional field missing: %s', field))
                end
            end
        end
    else
        -- Data itself is a simple value
        local ok, err = validate_value(data, schema, 'value')
        if not ok then
            table.insert(errors, err)
        end
    end

    return #errors == 0, errors, warnings
end

return M
