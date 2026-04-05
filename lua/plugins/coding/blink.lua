local M = {
    utils = {},
    state = {},
}

function M.utils.get_color_item(ctx)
    if ctx.item.source_name ~= 'LSP' then
        return nil
    end

    return require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
end

function M.utils.cmdline_sources()
    local cmd_type = vim.fn.getcmdtype()

    if cmd_type == '/' or cmd_type == '?' then
        return { 'buffer' }
    end

    if cmd_type == ':' or cmd_type == '@' then
        return { 'cmdline' }
    end

    return {}
end

function M.utils.get_border()
    if not M.state.ui then
        M.state.ui = G.State.get('ui')
    end

    local ui = M.state.ui

    if ui.type == 'borderless' then
        return 'none'
    else
        return ui.style
    end
end

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
    keymap = {
        preset = 'super-tab',
        -- override the 'super-tab' preset
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<C-k>'] = { 'snippet_backward', 'fallback' },
        ['<C-j>'] = { 'snippet_forward', 'fallback' },
    },
    appearance = {
        nerd_font_variant = 'mono',
        kind_icons = G.icons.kind_icons,
    },
    completion = {
        list = {
            selection = { preselect = true, auto_insert = false },
        },
        documentation = {
            window = { border = M.utils.get_border() },
            auto_show = true,
            auto_show_delay_ms = 200,
        },
        menu = {
            border = M.utils.get_border(),
            auto_show = true,
            draw = {
                columns = { { 'kind_icon' }, { 'label', gap = 1 } },
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
                            local color_item = M.utils.get_color_item(ctx)
                            local icon = color_item and color_item.abbr ~= '' and color_item.abbr
                                or ctx.kind_icon
                            return icon .. ctx.icon_gap
                        end,
                        highlight = function(ctx)
                            local color_item = M.utils.get_color_item(ctx)
                            return color_item and color_item.abbr_hl_group
                                or 'BlinkCmpKind' .. ctx.kind
                        end,
                    },
                },
            },
        },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        providers = {
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },
    fuzzy = { implementation = 'lua' },
    signature = { window = { border = M.utils.get_border() } },
    cmdline = {
        sources = M.utils.cmdline_sources,
        keymap = {
            preset = 'super-tab',
        },
        completion = {
            menu = {
                auto_show = true,
            },
        },
    },
}

return M
