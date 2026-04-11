local blink = require('plugins.ui.blink')

return {
    {
        src = 'https://github.com/rebelot/heirline.nvim',
        event = 'UiEnter',
        deps = {
            {
                src = 'https://github.com/nvim-treesitter/nvim-treesitter',
            },
        },
        config = require('plugins.ui.heirline').config,
    },
    {
        src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
        event = 'VimEnter',
        deps = {
            { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
        },
        opts = require('plugins.ui.markdown').opts,
    },
    {
        src = 'https://github.com/brenoprata10/nvim-highlight-colors',
        event = 'VimEnter',
        opts = {
            render = 'virtual',
            virtual_symbol = '',
            enable_named_colors = false,
            virtual_symbol_position = 'eol',
        },
    },
    {
        src = 'https://github.com/saghen/blink.cmp',
        deps = {
            { src = 'https://github.com/xzbdmw/colorful-menu.nvim' },
            { src = 'https://github.com/brenoprata10/nvim-highlight-colors' },
        },
        opts = blink.opts,
    },
    {
        src = 'https://github.com/folke/snacks.nvim',
        event = 'VimEnter',
        opts = require('plugins.ui.snacks').opts,
    },
}
