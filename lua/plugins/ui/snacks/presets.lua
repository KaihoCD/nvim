local M = {}

M.border_style = G.State.get('ui').style

M.input_winhl = table.concat({
    'NonText:LintNr',
    'NormalFloat:LightFloat',
    'FloatBorder:LightFloatBorder',
    'Special:Function',
}, ',')

M.deep_winhl = table.concat({
    'NormalFloat:DeepFloat',
    'FloatBorder:DeepFloatBorder',
    'FloatTitle:SubFloatTitle',
    'DiagnosticInfo:SubFloatTitle',
}, ',')

M.float_winhl = table.concat({
    'NormalFloat:LightFloat',
    'FloatBorder:LightFloatBorder',
    'FloatTitle:FloatTitle',
    'DiagnosticInfo:FloatTitle',
    'DiagnosticHint:Function',
}, ',')

local N = {}
M.layouts = N

N.defautl = {
    reverse = false,
    layout = {
        box = 'horizontal',
        backdrop = false,
        width = 0.8,
        height = 0.8,
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
                title = ' Results ',
                title_pos = 'center',
                border = M.border_style,
                wo = { winhighlight = M.deep_winhl },
            },
        },
        {
            win = 'preview',
            title = 'Preview: {preview}',
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
        width = 0.8,
        height = 0.8,
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
            title = 'Preview: {preview}',
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
        width = 0.4,
        height = 0.4,
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
