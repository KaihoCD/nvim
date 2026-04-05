--- Define all Neovim UI highlight groups.
--- Color values can be a string (shared by both modes) or an array:
---@param p table<string, string> palette colors
---@return table<string, table> group definitions
return function(p)
    --- { borderless_value, bordered_value }
    local map = {
        -- Editor basics
        Normal = { bg = p.bg, fg = p.fg },
        NormalNC = { bg = p.bg, fg = p.fg },
        EndOfBuffer = { bg = nil, fg = p.bg },
        LineNr = { bg = nil, fg = p.comment },
        CursorLineNr = { bg = nil, fg = p.yellowAlt },
        SignColumn = { bg = p.bg, fg = p.fgMute },
        FoldColumn = { bg = p.bg, fg = p.comment },
        WinSeparator = { bg = p.bg, fg = p.fgMute },
        Directory = { fg = p.blue },
        StatusLine = { bg = p.bgAlt, fg = p.fg },
        StatusLineNC = { bg = p.bgAlt, fg = p.fgMute },

        -- Interaction states
        Visual = { bg = p.bgSel },
        VisualNOS = { bg = p.bgSel },
        Search = { bg = p.yellow, fg = p.bg },
        IncSearch = { bg = p.orange, fg = p.bg },
        CurSearch = { bg = p.orange, fg = p.bg },
        MatchParen = { bg = p.bgSel, fg = p.fgMax },
        ColorColumn = { bg = p.bgAlt },
        CursorLine = { bg = p.bgAlt },
        CursorColumn = { bg = p.bgAlt },

        -- Messages
        Question = { fg = p.blue },
        MoreMsg = { fg = p.green },
        WarningMsg = { fg = p.orange },
        ErrorMsg = { fg = p.red },
        Title = { fg = p.fgMax, bold = true },

        -- Floats and menus
        NormalFloat = {
            bg = { p.bgAlt, p.bg },
            fg = p.fg,
        },
        FloatBorder = {
            bg = { p.bgAlt, p.bg },
            fg = { p.bgAlt, p.blue },
        },
        FloatTitle = {
            bg = { p.blue, p.bg },
            fg = { p.bg, p.blue },
            bold = true,
        },
        Pmenu = {
            bg = { p.bgAlt, p.bg },
            fg = p.fg,
        },
        PmenuSel = { bg = p.bgSel, fg = p.fgMax },
        PmenuSbar = { bg = p.bgAlt },
        PmenuThumb = { bg = p.fg },
    }

    return require('modules.highlight.groups.utils').resolve_groups_by_ui_type(map)
end
