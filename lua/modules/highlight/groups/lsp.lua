--- Define all LSP highlight groups.
--- Directly defines colors (no linking) so LSP can enhance native/treesitter highlights.
---@param p table<string, string> palette colors
---@return table<string, table> group definitions
return function(p)
    return {
        -- Diagnostics
        DiagnosticError = { fg = p.red },
        DiagnosticWarn = { fg = p.orange },
        DiagnosticInfo = { fg = p.blue },
        DiagnosticHint = { fg = p.cyan },
        DiagnosticOk = { fg = p.green },

        -- Virtual Text
        DiagnosticVirtualTextError = { fg = p.red, bg = p.bgAlt },
        DiagnosticVirtualTextWarn = { fg = p.orange, bg = p.bgAlt },
        DiagnosticVirtualTextInfo = { fg = p.blue, bg = p.bgAlt },
        DiagnosticVirtualTextHint = { fg = p.cyan, bg = p.bgAlt },
        DiagnosticVirtualTextOk = { fg = p.green, bg = p.bgAlt },

        -- Underlines
        DiagnosticUnderlineError = { underline = true, sp = p.red },
        DiagnosticUnderlineWarn = { underline = true, sp = p.orange },
        DiagnosticUnderlineInfo = { underline = true, sp = p.blue },
        DiagnosticUnderlineHint = { underline = true, sp = p.cyan },
        DiagnosticUnderlineOk = { underline = true, sp = p.green },

        -- Semantic Tokens (direct colors, not links)
        ['@lsp.type.variable'] = { fg = p.fg },
        ['@lsp.type.parameter'] = { fg = p.orange },
        ['@lsp.type.property'] = { fg = p.cyanAlt },
        ['@lsp.type.function'] = { fg = p.blue },
        ['@lsp.type.method'] = { fg = p.blue },
        ['@lsp.type.namespace'] = { fg = p.cyan },
        ['@lsp.type.class'] = { fg = p.yellow },
        ['@lsp.type.struct'] = { fg = p.yellow },
        ['@lsp.type.type'] = { fg = p.yellow },
        ['@lsp.type.typeParameter'] = { fg = p.cyan },
        ['@lsp.type.enumMember'] = { fg = p.purple },
        ['@lsp.type.keyword'] = { fg = p.purple },

        -- LSP Modifiers (higher priority: 126-127)
        ['@lsp.mod.global'] = { fg = p.red },
        ['@lsp.mod.readonly'] = { italic = true },
        ['@lsp.mod.defaultLibrary'] = { fg = p.orange },

        ['@lsp.typemod.function.defaultLibrary'] = { fg = p.cyan },
        ['@lsp.typemod.variable.readonly'] = { italic = true },
        ['@lsp.typemod.variable.defaultLibrary'] = { fg = p.cyan },
    }
end
