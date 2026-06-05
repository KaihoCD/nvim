--- Define all native Vim syntax highlight groups.
---@param p modules.colors.ColorsPalette palette colors
---@return table<string, table> group definitions
return function(p)
    return {
        -- Comments
        Comment = { fg = p.fg_low, italic = true },

        -- Constants
        Constant = { fg = p.orange },
        String = { fg = p.green },
        Character = { fg = p.green },
        Number = { fg = p.yellow_bright },
        Float = { fg = p.yellow_bright },
        Boolean = { fg = p.yellow_bright, italic = true },

        -- Identifiers
        Identifier = { fg = p.fg },
        Function = { fg = p.blue },

        -- Statements
        Statement = { fg = p.purple },
        Keyword = { fg = p.purple },
        Conditional = { fg = p.purple },
        Repeat = { fg = p.purple },
        Label = { fg = p.purple },
        Exception = { fg = p.purple },
        ['@keyword'] = { fg = p.red_bright, italic = true },
        ['@keyword.repeat'] = { fg = p.purple },
        ['@keyword.function'] = { fg = p.purple },
        ['@keyword.operator'] = { fg = p.purple },
        ['@keyword.conditional'] = { fg = p.purple },
        ['@constructor'] = { fg = p.purple },
        ['@variable'] = { fg = p.fg_high },

        -- Types
        Type = { fg = p.yellow },
        StorageClass = { fg = p.purple },
        Structure = { fg = p.yellow },
        Typedef = { fg = p.yellow },

        -- Preprocessor
        PreProc = { fg = p.purple },
        Include = { fg = p.purple },
        Define = { fg = p.purple },
        Macro = { fg = p.purple },
        PreCondit = { fg = p.purple },

        -- Operators
        Operator = { fg = p.cyan },

        -- Delimiters
        Delimiter = { fg = p.fg_low },
        ['@constructor.lua'] = { link = 'Delimiter' },

        -- Special
        Special = { fg = p.cyan },
        SpecialChar = { fg = p.cyan },
        Tag = { fg = p.blue },
        Debug = { fg = p.cyan },

        -- Misc
        Underlined = { underline = true },
        Ignore = {},
        Error = { fg = p.red },
        Todo = { fg = p.yellow, bold = true },
    }
end
