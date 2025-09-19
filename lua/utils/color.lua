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

-- Blend two colors
function M.blend(color_1, alpha, color_2)
  alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha
  local bg, fg = rgb(color_2), rgb(color_1)
  local function blendChannel(i)
    return math.floor(math.min(math.max(0, alpha * fg[i] + (1 - alpha) * bg[i]), 255) + 0.5)
  end
  return string.format('#%02x%02x%02x', blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.darken(color, amount, bg)
  return M.blend(color, amount, bg or '#000000')
end

function M.lighten(color, amount, fg)
  return M.blend(color, amount, fg or '#FFFFFF')
end

return M
