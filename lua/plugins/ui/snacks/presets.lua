local M = {}

M.border_style = G.State.get('ui').style

M.input_winhl = table.concat({
    'NonText:LintNr',
    'NormalFloat:LighterFloat',
    'FloatBorder:LighterFloatBorder',
    'Special:Function',
    'DiagnosticHint:Function',
    'DiagnosticInfo:FloatTitle',
}, ',')

M.deep_winhl = table.concat({
    'FloatTitle:SubFloatTitle',
}, ',')

M.float_winhl = table.concat({
    'NormalFloat:LightFloat',
    'FloatBorder:LightFloatBorder',
    'FloatTitle:FloatTitle',
}, ',')

local N = {}
M.layouts = N

N.defautl = {
    reverse = false,
    layout = {
        box = 'horizontal',
        backdrop = false,
        width = 0.9,
        height = 0.8,
        min_width = 100,
        border = 'none',
        {
            box = 'vertical',
            {
                win = 'input',
                height = 1,
                title = '{title} {live} {flags}',
                title_pos = 'center',
                border = M.border_style,
                wo = { winhighlight = M.input_winhl },
            },
            {
                win = 'list',
                title = 'Results',
                title_pos = 'center',
                border = M.border_style,
                wo = { winhighlight = M.deep_winhl },
            },
        },
        {
            win = 'preview',
            title = '{preview}',
            width = 0.5,
            title_pos = 'center',
            border = M.border_style,
            wo = { winhighlight = M.deep_winhl },
        },
    },
}

N.vertical = {
    layout = {
        backdrop = false,
        box = 'vertical',
        border = 'none',
        width = 0.9,
        height = 0.8,
        min_width = 100,
        {
            win = 'input',
            title = '{title} {live} {flags}',
            title_pos = 'center',
            height = 1,
            border = M.border_style,
        },
        {
            win = 'list',
            title = ' Results ',
            title_pos = 'center',
            border = M.border_style,
            wo = { winhighlight = M.deep_winhl },
        },
        {
            win = 'preview',
            title = '{preview}',
            height = 0.5,
            border = M.border_style,
            wo = { winhighlight = M.deep_winhl },
        },
    },
}

N.select = {
    preview = false,
    layout = {
        backdrop = false,
        row = 10,
        width = 100,
        height = 0.5,
        box = 'vertical',
        {
            title = '{title}',
            title_pos = 'center',
            win = 'input',
            height = 1,
            border = M.border_style,
        },
        {
            win = 'list',
            border = M.border_style,
            wo = {
                winhighlight = M.deep_winhl,
            },
        },
    },
}

return M
