local M = {}

local function rgb(color)
    color = string.lower(color)
    return {
        tonumber(color:sub(2, 3), 16),
        tonumber(color:sub(4, 5), 16),
        tonumber(color:sub(6, 7), 16),
    }
end

function M.is_hex(s)
    if type(s) ~= 'string' then
        return false
    end

    return s:match('^#%x%x%x$') -- #RGB
        or s:match('^#%x%x%x%x%x%x$') -- #RRGGBB
        or s:match('^#%x%x%x%x%x%x%x%x$') -- #RRGGBBAA
            and true
        or false
end

-- Determine if the contrast between the two colors is sufficient.
function M.get_contrast_ratio(color_1, color_2, threshold)
    threshold = threshold or 4.5

    local function safe_rgb(hex)
        hex = hex:gsub('#', ''):lower()
        if #hex == 3 then
            hex = hex:gsub('(.)', '%1%1')
        end
        hex = '#' .. hex
        local ok, result = pcall(rgb, hex)
        if not ok then
            return { 0, 0, 0 }
        end
        if type(result) == 'table' then
            return { result[1] or 0, result[2] or 0, result[3] or 0 }
        end
        local r, g, b = result, select(2, result), select(3, result)
        return { r or 0, g or 0, b or 0 }
    end

    local c1 = safe_rgb(color_1)
    local c2 = safe_rgb(color_2)

    local function to_linear(v)
        v = v / 255
        return v <= 0.03928 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4
    end

    local l1 = 0.2126 * to_linear(c1[1]) + 0.7152 * to_linear(c1[2]) + 0.0722 * to_linear(c1[3])
    local l2 = 0.2126 * to_linear(c2[1]) + 0.7152 * to_linear(c2[2]) + 0.0722 * to_linear(c2[3])

    local ratio = (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05)

    return ratio, ratio >= threshold
end

--- Blend foreground color over background with given alpha
---@param color_1 string  -- foreground color (#RRGGBB)
---@param alpha   number  -- blend ratio (0.0-1.0) or hex string (00-FF)
---@param color_2 string  -- background color (#RRGGBB)
---@return string         -- blended color (#RRGGBB)
function M.blend(color_1, alpha, color_2)
    alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha
    local bg, fg = rgb(color_2), rgb(color_1)
    local function blendChannel(i)
        return math.floor(math.min(math.max(0, alpha * fg[i] + (1 - alpha) * bg[i]), 255) + 0.5)
    end
    return string.format('#%02x%02x%02x', blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.darken(color, amount, bg)
    return M.blend(color, 1 - amount, bg or '#000000')
end

function M.lighten(color, amount, fg)
    return M.blend(color, 1 - amount, fg or '#FFFFFF')
end

--- Build a semantic color palette from a base24 theme using the color map
---@param base24 modules.colors.Base24 -- base24 theme with raw.base00-base17
---@param map table    -- color mapping table: { baseXX = 'semantic_name', ... }
---@return modules.colors.ColorsPalette
function M.build_palette(base24, map)
    local palette = { name = base24.name }

    for key, value in pairs(base24) do
        local palette_name = map[key]
        if palette_name then
            palette[map[key]] = value
        end
    end

    return palette
end

return M
