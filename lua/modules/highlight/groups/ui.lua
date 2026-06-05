--- Define all Neovim UI highlight groups.
--- Color values can be a string (shared by both modes) or an array:
---@param p modules.colors.ColorsPalette palette colors
---@return table<string, table> group definitions
return function(p)
    local blend = require('modules.colors.utils').blend

    --- { borderless_value, bordered_value }
    local map = {
        -- Core editor
        Normal = { bg = p.bg, fg = p.fg },
        NormalNC = { bg = p.bg, fg = p.fg },
        EndOfBuffer = { bg = nil, fg = p.bg },
        NonText = { bg = nil, fg = p.fg_ghost },
        Directory = { bg = nil, fg = p.blue },

        -- Gutter and window chrome
        LineNr = { bg = nil, fg = p.fg_ghost },
        CursorLine = { bg = p.bg_sub, fg = nil },
        CursorLineNr = { bg = nil, fg = p.orange },
        SignColumn = { bg = p.bg, fg = p.fg_low },
        FoldColumn = { bg = p.bg, fg = p.blue },
        Folded = { bg = p.bg_line, fg = p.blue },
        WinSeparator = { bg = p.bg, fg = p.fg_ghost },
        StatusLine = { bg = p.bg_sub, fg = p.fg },
        StatusLineNC = { bg = p.bg_sub, fg = p.fg_low },

        -- Diff
        DiffAdd = { bg = blend(p.green, 0.2, p.bg), fg = nil },
        DiffDelete = { bg = blend(p.red, 0.2, p.bg), fg = nil },
        DiffChange = { bg = blend(p.yellow, 0.2, p.bg), fg = nil },
        DiffText = { bg = blend(p.yellow, 0.2, p.bg), fg = nil, underline = true },

        -- Search and selection
        Visual = { bg = blend(p.blue, 0.15, p.bg) },
        VisualNOS = { bg = blend(p.blue, 0.15, p.bg) },
        Search = { bg = p.yellow, fg = p.bg },
        IncSearch = { bg = p.orange, fg = p.bg },
        CurSearch = { bg = p.orange, fg = p.bg },
        MatchParen = { bg = p.bg_sub, fg = p.fg_max },

        -- Messages and prompts
        MsgArea = { bg = p.bg },
        MsgSeparator = { bg = p.bg, fg = p.fg_ghost },
        Question = { fg = p.blue },
        MoreMsg = { fg = p.green },
        WarningMsg = { fg = p.orange },
        ErrorMsg = { fg = p.red },
        Title = { fg = p.fg_max, bold = true },

        -- Floating windows
        NormalFloat = {
            bg = { p.bg_dark, nil },
        },
        FloatBorder = {
            bg = { p.bg_dark, nil },
            fg = { p.bg_dark, p.fg_low },
        },
        FloatTitle = {
            bg = p.yellow_bright,
            fg = p.bg,
        },

        -- Float variants
        SubFloatTitle = {
            bg = p.blue,
            fg = p.bg,
        },
        LightFloat = {
            bg = { p.bg_sub, nil },
            fg = p.fg_high,
        },
        LightFloatBorder = {
            bg = { p.bg_sub, nil },
            fg = { p.bg_sub, p.fg_low },
        },
        LighterFloat = {
            bg = { p.bg_line, nil },
            fg = p.fg_high,
        },
        LighterFloatBorder = {
            bg = { p.bg_line, 'NONE' },
            fg = { p.bg_line, p.fg_low },
        },

        -- Popup menu
        Pmenu = {
            bg = { p.bg_dark, nil },
            fg = p.fg,
        },
        PmenuSel = {
            bg = { p.bg_dark, nil },
            fg = p.fg_max,
        },
        PmenuThumb = { bg = p.fg_ghost },
    }

    return require('modules.highlight.groups.utils').resolve_groups_by_ui_type(map)
end
