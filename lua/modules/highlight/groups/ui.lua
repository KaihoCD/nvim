--- Define all Neovim UI highlight groups.
--- Color values can be a string (shared by both modes) or an array:
---@param p ColorsPalette palette colors
---@return table<string, table> group definitions
return function(p)
    local color_utils = require('modules.colors.utils')

    --- { borderless_value, bordered_value }
    local map = {
        -- Editor basics
        Normal = { bg = p.bg, fg = p.fg },
        NormalNC = { bg = p.bg, fg = p.fg },
        EndOfBuffer = { bg = nil, fg = p.bg },
        LineNr = { bg = nil, fg = p.fg_ghost },
        CursorLineNr = { bg = nil, fg = p.orange },
        SignColumn = { bg = p.bg, fg = p.fg_low },
        FoldColumn = { bg = p.bg, fg = p.blue },
        Folded = { bg = p.bg_line, fg = p.blue },
        WinSeparator = { bg = p.bg, fg = p.fg_ghost },
        Directory = { fg = p.blue },
        StatusLine = { bg = p.bg_sub, fg = p.fg },
        StatusLineNC = { bg = p.bg_sub, fg = p.fg_low },
        NonText = { fg = p.fg_ghost },
        DiffAdd = { bg = color_utils.blend(p.green, 0.15, p.bg), fg = nil },
        DiffChange = { bg = color_utils.blend(p.yellow, 0.15, p.bg), fg = nil },
        DiffDelete = { bg = color_utils.blend(p.red, 0.15, p.bg), fg = nil },

        -- Interaction states
        Visual = { bg = p.bg_sub },
        VisualNOS = { bg = p.bg_sub },
        Search = { bg = p.yellow, fg = p.bg },
        IncSearch = { bg = p.orange, fg = p.bg },
        CurSearch = { bg = p.orange, fg = p.bg },
        MatchParen = { bg = p.bg_sub, fg = p.fg_max },

        -- Messages
        Question = { fg = p.blue },
        MoreMsg = { fg = p.green },
        WarningMsg = { fg = p.orange },
        ErrorMsg = { fg = p.red },
        Title = { fg = p.fg_max, bold = true },

        -- Floats
        NormalFloat = {
            bg = { p.bg_dark, p.bg },
        },
        FloatBorder = {
            bg = { p.bg_dark, p.bg },
            fg = { p.bg_dark, p.fg_low },
        },
        FloatTitle = {
            bg = p.yellow_bright,
            fg = p.bg,
        },
        -- Extra
        SubFloatTitle = {
            bg = p.blue,
            fg = p.bg,
        },
        LightFloat = {
            bg = { p.bg_sub, nil },
            fg = p.fg_high,
        },
        LightFloatBorder = {
            bg = { p.bg_sub, p.bg },
            fg = { p.bg_sub, p.fg_low },
        },
        LighterFloat = {
            bg = { p.bg_line, nil },
            fg = p.fg_high,
        },
        LighterFloatBorder = {
            bg = { p.bg_line, p.bg },
            fg = { p.bg_line, p.fg_low },
        },

        -- Menus
        Pmenu = {
            bg = { p.bg_dark, p.bg },
            fg = p.fg,
        },
        PmenuSel = {
            bg = { p.bg_dark, p.bg },
            fg = p.fg_max,
        },
        PmenuThumb = { bg = p.fg_ghost },
    }

    return require('modules.highlight.groups.utils').resolve_groups_by_ui_type(map)
end
