---@class Base24
---@field name   string
---@field base00 string
---@field base01 string
---@field base02 string
---@field base03 string
---@field base04 string
---@field base05 string
---@field base06 string
---@field base07 string
---@field base08 string
---@field base09 string
---@field base10 string
---@field base11 string
---@field base0A string
---@field base0B string
---@field base0C string
---@field base0D string
---@field base0E string
---@field base0F string
---@field base12 string
---@field base13 string
---@field base14 string
---@field base15 string
---@field base16 string
---@field base17 string

---@class ColorsPalette
---@field name          string Theme name
---@field bg            string Core background
---@field bg_sub        string Secondary background (statusline/sidebar)
---@field bg_line       string Line/block background (selection)
---@field fg_ghost      string Dimmest text (comments)
---@field fg_low        string Dim text (linenumbers/dividers)
---@field fg            string Primary text (standard code)
---@field fg_high       string Bright text (selected item/title)
---@field fg_max        string Brightest text (search highlight)
---@field red           string Variables/errors
---@field orange        string Numbers/constants
---@field yellow        string Types/warnings
---@field green         string Strings/Git additions
---@field cyan          string Operators/regex
---@field blue          string Functions/properties
---@field purple        string Keywords
---@field brown         string Special markers
---@field bg_dark       string Darker background (popup menu)
---@field red_bright    string Accent background (error block)
---@field orange_bright string Bright orange
---@field yellow_bright string Bright yellow (warning icons)
---@field green_bright  string Bright green (success markers)
---@field cyan_bright   string Bright cyan (info icons)
---@field blue_bright   string Bright blue (Git branch/folds)
---@field purple_bright string Bright purple (key logic)

-- stylua: ignore start
local map = {
    bg            = 'base00', -- Core background
    bg_sub        = 'base01', -- Secondary background (statusline/sidebar)
    bg_line       = 'base02', -- Line/block background (selection)
    fg_ghost      = 'base03', -- Dimmest text (comments)
    fg_low        = 'base04', -- Dim text (linenumbers/dividers)
    fg            = 'base05', -- Primary text (standard code)
    fg_high       = 'base06', -- Bright text (selected item/title)
    fg_max        = 'base07', -- Brightest text (search highlight)
    red           = 'base08', -- Variables/errors
    orange        = 'base09', -- Numbers/constants
    yellow        = 'base0A', -- Types/warnings
    green         = 'base0B', -- Strings/Git additions
    cyan          = 'base0C', -- Operators/regex
    blue          = 'base0D', -- Functions/properties
    purple        = 'base0E', -- Keywords
    brown         = 'base0F', -- Special markers
    bg_dark       = 'base10', -- Darker background (popup menu)
    red_bright    = 'base11', -- Accent background (error block)
    orange_bright = 'base12', -- Bright orange
    yellow_bright = 'base13', -- Bright yellow (warning icons)
    green_bright  = 'base14', -- Bright green (success markers)
    cyan_bright   = 'base15', -- Bright cyan (info icons)
    blue_bright   = 'base16', -- Bright blue (Git branch/folds)
    purple_bright = 'base17', -- Bright purple (key logic)
    --
    base00 = 'bg',            -- Core background
    base01 = 'bg_sub',        -- Secondary background (statusline/sidebar)
    base02 = 'bg_line',       -- Line/block background (selection)
    base03 = 'fg_ghost',      -- Dimmest text (comments)
    base04 = 'fg_low',        -- Dim text (linenumbers/dividers)
    base05 = 'fg',            -- Primary text (standard code)
    base06 = 'fg_high',       -- Bright text (selected item/title)
    base07 = 'fg_max',        -- Brightest text (search highlight)
    base08 = 'red',           -- Variables/errors
    base09 = 'orange',        -- Numbers/constants
    base0A = 'yellow',        -- Types/warnings
    base0B = 'green',         -- Strings/Git additions
    base0C = 'cyan',          -- Operators/regex
    base0D = 'blue',          -- Functions/properties
    base0E = 'purple',        -- Keywords
    base0F = 'brown',         -- Special markers
    base10 = 'bg_dark',       -- Darker background (popup menu)
    base11 = 'red_bright',    -- Accent background (error block)
    base12 = 'orange_bright', -- Bright orange
    base13 = 'yellow_bright', -- Bright yellow (warning icons)
    base14 = 'green_bright',  -- Bright green (success markers)
    base15 = 'cyan_bright',   -- Bright cyan (info icons)
    base16 = 'blue_bright',   -- Bright blue (Git branch/folds)
    base17 = 'purple_bright', -- Bright purple (key logic)
}
-- stylua: ignore end

return map
