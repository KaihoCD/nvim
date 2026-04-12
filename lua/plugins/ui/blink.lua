local M = {}

local border_style = G.State.get('ui').style

local function get_color_item(ctx)
    if ctx.item.source_name ~= 'LSP' then
        return nil
    end

    return require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
end

local winhl_menu = table.concat({
    'Normal:Pmenu',
    'FloatNormal:FloatNormal',
    'Pmenu:FloatNormal',
    'FloatBorder:FloatBorder',
    'CursorLine:Visual',
}, ',')

local winhl_doc = table.concat({
    'Normal:LightFloat',
    'FloatBorder:LightFloatBorder',
    'BlinkCmpDocSeparator:LineNr',
}, ',')

local winhl_signature = table.concat({
    'Normal:LightFloat',
    'FloatBorder:LightFloatBorder',
}, ',')

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
    appearance = {
        nerd_font_variant = 'mono',
        kind_icons = G.icons.kind_icons,
    },
    completion = {
        menu = {
            border = border_style,
            draw = {
                columns = { { 'kind_icon' }, { 'label', 'source_name', gap = 2 } },
                components = {
                    label = {
                        text = function(ctx)
                            return require('colorful-menu').blink_components_text(ctx)
                        end,
                        highlight = function(ctx)
                            return require('colorful-menu').blink_components_highlight(ctx)
                        end,
                    },
                    -- [[ https://github.com/brenoprata10/nvim-highlight-colors#blinkcmp-integration ]]
                    kind_icon = {
                        text = function(ctx)
                            local color_item = get_color_item(ctx)
                            local icon = color_item and color_item.abbr ~= '' and color_item.abbr
                                or ctx.kind_icon
                            return icon .. ctx.icon_gap
                        end,
                        highlight = function(ctx)
                            local color_item = get_color_item(ctx)
                            return color_item and color_item.abbr_hl_group
                                or 'BlinkCmpKind' .. ctx.kind
                        end,
                    },
                },
            },
            winhighlight = winhl_menu,
        },
        documentation = {
            window = {
                border = border_style,
                winhighlight = winhl_doc,
            },
        },
    },
    signature = {
        window = {
            border = border_style,
            winhighlight = winhl_signature,
        },
    },
}

return M
