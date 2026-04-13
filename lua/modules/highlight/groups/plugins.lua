--- Define all native Vim syntax highlight groups.
---@param p ColorsPalette palette colors
---@return table<string, table> group definitions
return function(p)
    local color_utils = require('modules.colors.utils')
    return {
        RenderMarkdownBullet = { fg = p.orange },
        RenderMarkdownCode = { bg = p.bg_dark },
        RenderMarkdownDash = { fg = p.orange },
        RenderMarkdownTableHead = { fg = p.red },
        RenderMarkdownTableRow = { fg = p.orange },
        RenderMarkdownCodeInline = '@markup.raw.markdown_inline',
        -- H1 to H6
        RenderMarkdownH1Bg = { bg = color_utils.blend(p.red, 0.1, p.bg) },
        ['@markup.heading.1.markdown'] = { fg = p.red, bold = true },
        RenderMarkdownH2Bg = { bg = color_utils.blend(p.orange, 0.1, p.bg) },
        ['@markup.heading.2.markdown'] = { fg = p.orange, bold = true },
        RenderMarkdownH3Bg = { bg = color_utils.blend(p.yellow, 0.1, p.bg) },
        ['@markup.heading.3.markdown'] = { fg = p.yellow, bold = true },
        RenderMarkdownH4Bg = { bg = color_utils.blend(p.green, 0.1, p.bg) },
        ['@markup.heading.4.markdown'] = { fg = p.green, bold = true },
        RenderMarkdownH5Bg = { bg = color_utils.blend(p.blue, 0.1, p.bg) },
        ['@markup.heading.5.markdown'] = { fg = p.blue, bold = true },
        RenderMarkdownH6Bg = { bg = color_utils.blend(p.purple, 0.1, p.bg) },
        ['@markup.heading.6.markdown'] = { fg = p.purple, bold = true },
    }
end
