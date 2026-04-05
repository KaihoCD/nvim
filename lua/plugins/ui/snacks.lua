local M = {}

local border_style = G.State.get('ui').style

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
    },
    picker = {
        layouts = {
            default = {
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
                            border = border_style,
                        },
                        {
                            win = 'list',
                            title = ' Results ',
                            title_pos = 'center',
                            border = border_style,
                        },
                    },
                    {
                        win = 'preview',
                        title = '{preview:Preview}',
                        width = 0.5,
                        title_pos = 'center',
                        border = border_style,
                    },
                },
            },
        },
    },
}

return M
