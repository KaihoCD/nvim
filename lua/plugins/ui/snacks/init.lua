local M = {}

local presets = require('plugins.ui.snacks.presets')

M.opts = {
    indent = { enabled = true },
    input = { enabled = true },
    statuscolumn = {
        left = { 'mark', 'sign' },
        right = { 'fold', 'git' },
        folds = {
            open = false,
            git_hl = false,
        },
    },
    win = {
        backdrop = false,
        wo = { winhighlight = presets.deep_winhl },
    },
    styles = {
        lazygit = {
            backdrop = false,
            title = '  lazygit ',
            title_pos = 'center',
            border = presets.border_style,
        },
        input = {
            row = 10,
            wo = { winhighlight = presets.float_winhl },
        },
    },
    lazygit = {
        theme = {
            activeBorderColor = { fg = 'Normal', bold = true },
            inactiveBorderColor = { fg = 'WinSeparator' },
        },
    },
    picker = {
        layouts = {
            default = presets.layouts.defautl,
            vertical = presets.layouts.vertical,
            select = presets.layouts.select,
            sidebar = presets.layouts.defautl,
            vscode = presets.layouts.select,
        },
        sources = {
            lines = { layout = { preset = 'vertical' } },
            icons = { layout = { preset = 'select' } },
            search_history = { layout = { preset = 'select' } },
            command_history = { layout = { preset = 'select' } },
        },
    },
}

return M
