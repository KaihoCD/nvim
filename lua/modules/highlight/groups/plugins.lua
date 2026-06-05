--- Define all native Vim syntax highlight groups.
---@param p modules.colors.ColorsPalette palette colors
---@return table<string, table> group definitions
return function(p)
    local blend = require('modules.colors.utils').blend
    return {
        -- [[ Render-Markdown ]]
        RenderMarkdownBullet = { fg = p.orange },
        RenderMarkdownCode = { bg = p.bg_dark },
        RenderMarkdownDash = { fg = p.orange },
        RenderMarkdownTableHead = { fg = p.red },
        RenderMarkdownTableRow = { fg = p.orange },
        RenderMarkdownCodeInline = '@markup.raw.markdown_inline',
        -- H1 to H6
        RenderMarkdownH1Bg = { bg = blend(p.red, 0.1, p.bg) },
        ['@markup.heading.1.markdown'] = { fg = p.red, bold = true },
        RenderMarkdownH2Bg = { bg = blend(p.orange, 0.1, p.bg) },
        ['@markup.heading.2.markdown'] = { fg = p.orange, bold = true },
        RenderMarkdownH3Bg = { bg = blend(p.yellow, 0.1, p.bg) },
        ['@markup.heading.3.markdown'] = { fg = p.yellow, bold = true },
        RenderMarkdownH4Bg = { bg = blend(p.green, 0.1, p.bg) },
        ['@markup.heading.4.markdown'] = { fg = p.green, bold = true },
        RenderMarkdownH5Bg = { bg = blend(p.blue, 0.1, p.bg) },
        ['@markup.heading.5.markdown'] = { fg = p.blue, bold = true },
        RenderMarkdownH6Bg = { bg = blend(p.purple, 0.1, p.bg) },
        ['@markup.heading.6.markdown'] = { fg = p.purple, bold = true },

        -- [[ GitSigns ]]
        GitSignsAddInline = { fg = nil, underline = true },
        GitSignsAddLnInline = { fg = nil, underline = true },
        GitSignsChangeInline = { fg = nil, underline = true },
        GitSignsDeleteInline = { fg = nil, underline = true },
        GitSignsChangeLnInline = { fg = nil, underline = true },
        GitSignsDeleteLnInline = { fg = nil, underline = true },
        GitSignsDeleteVirtLnInLine = { fg = nil, underline = true },
        GitSignsVirtLnum = { bg = nil, fg = nil },
        GitSignsStagedAddLn = { fg = nil, underline = true },
        GitSignsStagedChangeLn = { fg = nil, underline = true },
        GitSignsStagedUntrackedLn = { fg = nil, underline = true },
        GitSignsStagedChangedeleteLn = { fg = nil, underline = true },
    }
end
