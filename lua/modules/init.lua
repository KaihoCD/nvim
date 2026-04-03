require('modules.state')
require('modules.pack')
require('modules.autoim')

-- Register global state keys and defaults.
G.State.register({
    ['auto_lint'] = false,
    ['format_on_save'] = false,
    ['ui'] = {
        style = 'borderless',
    },
    ['clrs'] = {
        system = 'base16',
        name = 'Neovim Default Dark',
        author = 'Neovim',
        variant = 'dark',
        palette = {
            bg = '#14161b',
            bgAlt = '#2c2e33',
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
            accent = '#6b5300',
        },
        raw = {
            base00 = '#14161b',
            base01 = '#2c2e33',
            base02 = '#4f5258',
            base03 = '#9b9ea4',
            base04 = '#b7bcc4',
            base05 = '#e0e2ea',
            base06 = '#d2d6de',
            base07 = '#eef1f8',
            base08 = '#ff8f9a',
            base09 = '#ffb26b',
            base0A = '#fce094',
            base0B = '#b3f6c0',
            base0C = '#8cf8f7',
            base0D = '#a6dbff',
            base0E = '#d5c5ff',
            base0F = '#6b5300',
        },
    },
})

require('modules.colors').apply()

-- Use Plugins
G.Pack.use('plugins')
