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
        bg = '#14161b',
        bgAlt = '#1b1e24',
        bgSel = '#4f5258',
        comment = '#9b9ea4',
        fgMute = '#b7bcc4',
        fg = '#e0e2ea',
        fgAlt = '#d2d6de',
        fgMax = '#eef1f8',
        red = '#ff8f9a',
        orange = '#ffb26b',
        yellow = '#fce094',
        green = '#b3f6c0',
        cyan = '#8cf8f7',
        blue = '#a6dbff',
        purple = '#d5c5ff',
        accent = '#8cf8f7',
        bgDark = '#101216',
        bgDeep = '#0b0d10',
        redAlt = '#590008',
        yellowAlt = '#ffe9ad',
        greenAlt = '#caf8d3',
        cyanAlt = '#b5ffff',
        blueAlt = '#c2e7ff',
        purpleAlt = '#e5dbff',
    },
})

require('modules.colors')

-- Use Plugins
G.Pack.use('plugins')
