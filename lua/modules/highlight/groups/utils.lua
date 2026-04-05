local M = {}

--- Resolve a color value that may be a mode array.
--- @param val string | string[]
--- @param ui_type 'borderless' | 'bordered'
--- @return string
local function resolve(val, ui_type)
    if type(val) == 'table' then
        return ui_type == 'borderless' and val[1] or val[2]
    end
    return val
end

--- Resolve all color values in a group definition table.
--- @param groups table<string, table>
--- @return table<string, table>
function M.resolve_groups_by_ui_type(groups)
    local resolved = {}
    local ui_type = G.State.get('ui').type

    for group, def in pairs(groups) do
        local r = {}
        for k, v in pairs(def) do
            if k == 'bold' or k == 'italic' or k == 'underline' then
                r[k] = v
            else
                r[k] = resolve(v, ui_type)
            end
        end
        resolved[group] = r
    end
    return resolved
end

return M
