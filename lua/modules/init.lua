require('modules.state')
require('modules.pack')
require('modules.autoim')

-- Register global state keys and defaults.
G.State.register({
    ['auto_lint'] = false,
    ['format_on_save'] = false,
    ---@type Colorscheme
    ['theme_name'] = 'tokyonight-storm',
    ['colors'] = {
        name = 'TokyoNight Moon',
        blue = '#82aaff',
        purple = '#c099ff',
        cyan = '#86e1fc',
        brightYellow = '#ffc777',
        red = '#ff757f',
        brightGreen = '#c3e88d',
        foreground = '#c8d3f5',
        brightRed = '#ff757f',
        brightBlue = '#82aaff',
        selection = '#2d3f76',
        cursor = '#c8d3f5',
        brightPurple = '#c099ff',
        brightWhite = '#c8d3f5',
        green = '#c3e88d',
        yellow = '#ffc777',
        black = '#1b1d2b',
        white = '#828bb8',
        brightCyan = '#86e1fc',
        brightBlack = '#444a73',
        background = '#222436',
    },
})

-- Use Plugins
G.Pack.use('plugins')
